# Encryption and Decryption using PipelineC

In this segement we will present the design behind the implemented *chacha20poly1305* encryptor and decryptor



# Encryption

<p align="center">
    <img width="700" src="./doc/Encryption.png">
</p>



## chacha20

The `chacha20` module implements the core **ChaCha20 stream cipher** logic for encryption, decryption, and key-stream generation in the context of the larger ChaCha20-Poly1305 construction.

This block performs two main responsibilities in sequence:

1.  **Poly1305 Key Generation:** It first generates a 32-byte (256-bit) one-time Poly1305 key by running the ChaCha20 block function with the initial counter set to 0 and the input plaintext/ciphertext data set to zero. This key is immediately streamed out via `chacha20_poly_key`.
2.  **Data Processing (Encrypt/Decrypt):** After key generation, it switches state to process the main data stream. It takes 128-bit (16-byte) blocks of input data (`chacha20_axis_in`), applies the ChaCha20 block function to generate the keystream for each 64-byte block, and XORs the keystream with the input data to produce the output data (`chacha20_axis_out`).

### Internal Architecture

This module utilizes a **Finite State Machine (FSM)** (`chacha20_fsm`) to manage the two states (POLY\_KEY generation and PLAINTEXT/CIPHERTEXT processing). It controls data flow in and out of a highly parallelized ChaCha20 core.

* **Pipelined Core:** It instantiates the `chacha20_loop_body` function as a **Global Valid-Ready Pipeline (`chacha20_pipeline`)**. This core executes the 20-round ChaCha20 block function (`chacha20_block`), which is fully unrolled into 10 pairs of step functions (`chacha20_block_step`) to maximize throughput for hardware synthesis.
* **Data Width Conversion:** The module uses helper functions (`axis128_to_axis512` and `axis512_to_axis128`) to convert the input and output streams between the 128-bit AXI stream interface (for external I/O) and the 512-bit (64-byte) block size required by the ChaCha20 core.

### Inputs and Outputs

| Port Name | Direction | Data Type | Description |
| :--- | :--- | :--- | :--- |
| `chacha20_key` | Input (CSR) | `uint8_t[32]` | The 256-bit secret key. |
| `chacha20_nonce` | Input (CSR) | `uint8_t[12]` | The 96-bit nonce/IV. |
| `chacha20_axis_in` | Input (Stream) | `stream(axis128_t)` | The input plaintext (for encryption) or ciphertext (for decryption). |
| `chacha20_poly_key` | Output (Stream) | `stream(poly1305_key_uint_t)` | The 256-bit key derived from the first ChaCha20 block output (counter 0). |
| `chacha20_axis_out` | Output (Stream) | `stream(axis128_t)` | The resulting ciphertext or plaintext stream. |



## prep_auth_data

The `prep_auth_data` module is a critical stream-processing component responsible for assembling and formatting the input data stream required by the Poly1305 authenticator.

It correctly concatenates the three components that Poly1305 must authenticate, ensuring each block is zero-padded to a 16-byte boundary as specified in RFC 8439 for ChaCha20-Poly1305.

### Poly1305 Data Format

The module outputs a single AXI stream in the following fixed sequence:

$$\text{Authenticated Stream} = \text{AAD}^* || \text{Ciphertext}^* || \text{Lengths}$$

Where:
* **$\text{AAD}^*$**: Additional Authenticated Data (AAD), padded with zeros to the next 16-byte boundary.
* **$\text{Ciphertext}^*$**: The Ciphertext stream, padded with zeros to the next 16-byte boundary.
* **$\text{Lengths}$**: A fixed 16-byte block containing two 64-bit little-endian integers: the actual AAD length, followed by the actual Ciphertext length.



### Inputs and Outputs

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `aad` | Input | `uint8_t[AAD_MAX_LEN]` | The AAD block (read once, not streamed). |
| `aad_len` | Input | `uint8_t` | The length of the AAD block. |
| `prep_auth_data_axis_in` | Input | `stream(axis128_t)` | Input AXI stream carrying the Ciphertext. |
| `prep_auth_data_axis_in_ready` | Output | `uint1_t` | Indicates readiness to consume Ciphertext. |
| `prep_auth_data_axis_out` | Output | `stream(axis128_t)` | Output AXI stream carrying the Poly1305 authenticated data. |
| `prep_auth_data_axis_out_ready` | Input | `uint1_t` | Readiness signal from the Poly1305 core. |

### Finite State Machine (FSM) Description

The FSM uses a static `counter` to track remaining AAD bytes or accumulated Ciphertext bytes.

#### 1. `IDLE` State

* **Entry Condition:** Reset or completion of the last authentication sequence (`LENGTHS` state finish).
* **Transition:** Waits for the first valid word of the incoming Ciphertext stream (`axis_in.valid`).
* **Next State:**
    * If `aad_len > 0`: Transition to `AAD_STATE`.
    * If `aad_len == 0`: Transition to `CIPHERTEXT` (bypassing AAD).

#### 2. `AAD_STATE`

* **Function:** Streams out the AAD data, followed by necessary zero-padding to complete the current 16-byte block (if `counter` drops below 16).
* **Data Handling:** Reads from the internal `aad_reg`.
* **TLAST:** The output `tlast` is **not** asserted, as the ciphertext follows.
* **Counter:** Decremented by 16 bytes upon a successful transfer.
* **Next State:** Transitions to `CIPHERTEXT` once all AAD (and its padding) has been streamed out (`counter \le 16` and transfer completes).

#### 3. `CIPHERTEXT` State

* **Function:** Streams the incoming Ciphertext data directly to the output.
* **Padding:** Overrides any bytes in the output data to $\mathbf{0}$ where the input `tkeep` is $\mathbf{0}$ (this enforces the required zero-padding for the final block).
* **TLAST:** Output `tlast` is **de-asserted** (`tlast=0`), even if the input `axis_in.data.tlast` is high, because the `LENGTHS` block must follow.
* **Counter:** The static `counter` is incremented by the number of bytes indicated by the *input* stream's `tkeep` (the true ciphertext length).
* **Next State:** Transitions to `LENGTHS` upon seeing the `tlast` signal from the input Ciphertext stream.

#### 4. `LENGTHS` State

* **Function:** Outputs the final 16-byte block containing the lengths.
* **Data Handling:**
    * Bytes 0-7: AAD length (`aad_len`) as a 64-bit little-endian integer.
    * Bytes 8-15: Ciphertext length (`counter`) as a 64-bit little-endian integer.
* **TLAST:** Output `tlast` is **asserted** (`tlast=1`) to signal the end of the entire authenticated data stream.
* **Next State:** Transitions back to `IDLE` upon a successful transfer of the `LENGTHS` block.


## poly1305_mac

The `poly1305_mac` module is the core computational unit responsible for calculating the 16-byte Poly1305 authentication tag (MAC). It operates as a Finite State Machine (FSM) that orchestrates the data flow, key clamping, iterative accumulation, and final reduction, utilizing a high-performance, dedicated pipeline for the core arithmetic operation.

### Architecture and Pipelining

The module is designed around the iterative structure of Poly1305, where the 320-bit accumulator $\mathbf{a}$ feeds back into the pipeline for the next calculation:

$$\mathbf{a_{i+1}} = \text{poly1305\_mac\_loop\_body}(\mathbf{m_i}, \mathbf{r}, \mathbf{a_i})$$

This inner loop is implemented as a high-performance hardware pipeline (`poly1305_pipeline`) to achieve a high operating frequency. The FSM manages the handshaking and sequential feeding of data blocks into this pipeline.



### Inputs and Outputs

The module manages two input streams (Key and Data) and one output stream (Authentication Tag).

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `poly1305_mac_key` | Input | `stream(poly1305_key_uint_t)` (256 bits) | The 32-byte key stream ($\mathbf{r} || \mathbf{s}$). Read once per MAC sequence. |
| `poly1305_mac_key_ready` | Output | `uint1_t` | Ready signal for the key input stream. |
| `poly1305_mac_data_in` | Input | `stream(axis128_t)` | 16-byte wide AXI stream of authenticated data blocks ($\mathbf{m_i}$). |
| `poly1305_mac_data_in_ready` | Output | `uint1_t` | Ready signal for the data input stream. |
| `poly1305_mac_auth_tag` | Output | `stream(poly1305_auth_tag_uint_t)` (128 bits) | The final 16-byte authentication tag output. |
| `poly1305_mac_auth_tag_ready` | Input | `uint1_t` | Handshake signal from the consumer indicating readiness to accept the tag. |

### Finite State Machine (FSM)

The FSM controls the sequence of operations, ensuring correct pipeline synchronization and key handling.

| State | FSM Action | Pipeline Interaction | Next State Conditions |
| :--- | :--- | :--- | :--- |
| **KEY\_SETUP** | Initializes the accumulator $\mathbf{a}$ to $\mathbf{0}$ and waits for the 32-byte key ($\mathbf{r} || \mathbf{s}$). Upon key receipt, it performs **clamping** on the $\mathbf{r}$ component (zeroing specific bits as per the Poly1305 specification). | Idle. | Key received and processed. $\rightarrow \text{DATA\_LOOP}$ |
| **DATA\_LOOP** | Asserts `poly1305_mac_data_in_ready` and consumes the next 16-byte block ($\mathbf{m_i}$). Checks for the end-of-stream signal (`tlast`). | Sends the current state $(\mathbf{m_i}, \mathbf{r}, \mathbf{a})$ to the pipeline and asserts `to_pipeline_valid`. | Data block read successfully. $\rightarrow \text{PIPELINE\_WAIT}$ |
| **PIPELINE\_WAIT** | Waits for the pipeline to finish computation, signaled by `poly1305\_pipeline\_out\_valid`. This ensures the iterative dependency is respected. | Receives the new accumulator value ($\mathbf{a_{i+1}}$) and stores it in the static $\mathbf{a}$ register. | Pipeline output is valid. $\rightarrow \text{DATA\_LOOP}$ (if more blocks) or $\rightarrow \text{FINALIZE\_START}$ (if last block was processed). |
| **FINALIZE\_START** | Initiates the final calculation, which is the addition of the clamped key component $\mathbf{s}$: $$\mathbf{t} = ((\mathbf{a} \bmod 2^{130} - 5) \bmod 2^{128}) + \mathbf{s}$$ This step results in the final 16-byte MAC. | Idle. Uses the final value of $\mathbf{a}$. | Final calculation complete (occurs over a single cycle). $\rightarrow \text{OUTPUT\_TAG}$ |
| **OUTPUT\_TAG** | Asserts `auth_tag_valid` and outputs the final tag (`poly1305_mac_auth_tag`). | Idle. | Consumer asserts `auth_tag_ready`. $\rightarrow \text{KEY\_SETUP}$ (Ready for a new MAC sequence). |


## append_auth_tag

The `append_auth_tag` module is responsible for the final stage of the ChaCha20-Poly1305 dencryption process. Its sole function is to stream the received Ciphertext data from the core, and upon completion, append the 16-byte Poly1305 Authentication Tag (MAC) as the final AXI word.

This ensures the combined stream is correctly structured for the consumer as the Ciphertext followed by the MAC. The module manages the critical `tlast` signal to accurately mark the end of the entire authenticated message.



### Inputs and Outputs

The module manages two input streams and one output stream.

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `append_auth_tag_axis_in` | Input | `stream(axis128_t)` | Input AXI stream carrying the Ciphertext. |
| `append_auth_tag_axis_in_ready` | Output | `uint1_t` | Ready signal to consume the Ciphertext stream. |
| `append_auth_tag_auth_tag_in` | Input | `stream(poly1305_auth_tag_uint_t)` | 16-byte Authentication Tag output from the Poly1305 core. |
| `append_auth_tag_auth_tag_in_ready` | Output | `uint1_t` | Ready signal to consume the Auth Tag. |
| `append_auth_tag_axis_out` | Output | `stream(axis128_t)` | Output AXI stream: Ciphertext followed by the 16-byte Tag. |
| `append_auth_tag_axis_out_ready` | Input | `uint1_t` | Ready signal from the consumer. |

### Finite State Machine (FSM) Description

The module uses a simple two-state FSM to sequence the Ciphertext pass-through and the final tag append.

#### 1. `CIPHERTEXT` State

* **Function:** This is the pass-through state. The module forwards the incoming Ciphertext AXI stream (`append_auth_tag_axis_in`) directly to the output (`append_auth_tag_axis_out`).
* **Ready Signal:** The input ready signal (`append_auth_tag_axis_in_ready`) is directly coupled to the output ready signal (`append_auth_tag_axis_out_ready`) to propagate back-pressure.
* **TLAST Handling (CRITICAL):** The input `tlast` signal from the Ciphertext stream is **suppressed** (`append_auth_tag_axis_out.data.tlast = 0`). This is necessary because the data block is *not* the true end of the transaction; the authentication tag must follow.
* **Transition:** Transitions to the `AUTH_TAG` state when the input `tlast` is observed and the current transfer is valid and accepted by the output consumer.

#### 2. `AUTH_TAG` State

* **Function:** This state inserts the 16-byte authentication tag as the final word of the transaction.
* **Data Mapping:** The 128-bit authentication tag data (`append_auth_tag_auth_tag_in.data`) is mapped directly to the output AXI data payload (`tdata`).
* **TLAST Assertion:** The output `tlast` signal is **asserted** (`append_auth_tag_axis_out.data.tlast = 1`) to signal the definite end of the combined stream.
* **Ready Signal:** The authentication tag input ready signal (`append_auth_tag_auth_tag_in_ready`) is driven by the output ready signal.
* **Transition:** Transitions back to the `CIPHERTEXT` state (or `IDLE` in a complete FSM, although here it is `CIPHERTEXT`) when the tag transfer is valid and accepted by the output consumer. This prepares the module for the next transaction.


# Decryption

<p align="center">
    <img width="700" src="./doc/chacha20poly1305_decrypt.png">
</p>

The design scheme for the decryptor can be seen above. Unlike the *encryption* we now have both *ciphertext* and the *authentication tag* as inputs to our module. The inputs first go inside the *strip_auth_tag* block, since both *ciphertext* and *authentication tag* come in one after the other in one stream, we have to separate them, and then pass them on to the next blocks. From there we pass the *authentication tag* to the *poly1305_verify* block and *ciphertext* is passed to *prep_auth_data* and *chacha20_decrypt*. The *prep_auth_data* block ... (insert what the block does). As a result the block outputs *auth_data* which along with *poly1305_key* goes into the *poly1305_mac* block.

In the table below we showcase the bus size of each signal passed between our decryption blocks:
| 128b AXIS bus |128b bus | 1b bus | 256b bus |
|:--:|:--:|:--:|:--:|
|input ciphertext + auth_tag | auth_tag | verify_bit | poly1305_key |
| ciphertext | calculated_tag | is_verified | |
| auth_data | |||
| plaintext |


## strip_auth_tag

The `strip_auth_tag` module performs the inverse operation of `append_auth_tag`. It takes an AXI stream containing the Ciphertext followed by the 16-byte Poly1305 Authentication Tag (MAC) and separates them into two distinct outputs: the Ciphertext stream and the MAC value.

This module is designed to operate in a decryption and verification pipeline, where the Ciphertext is sent to memory/storage, and the MAC is passed to the Poly1305 verification unit. A key design element is the use of an internal look-ahead buffer to determine the true `tlast` for the Ciphertext stream (i.e., the block *before* the MAC).



### Architecture: The `axis128_early_tlast` Look-Ahead

Since the MAC block is identified by the incoming stream's `tlast` signal, the block immediately preceding it is the *true* last Ciphertext block. To correctly assert `tlast` on the Ciphertext output at the right time, the module uses a custom block called `axis128_early_tlast` to buffer one AXI word.

This buffer allows the module to peek at the *next* incoming block. If the next block has `tlast=1`, the current block being processed is marked as the last Ciphertext block.

## Inputs and Outputs

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `strip_auth_tag_axis_in` | Input | `stream(axis128_t)` | Input AXI stream containing the Ciphertext followed by the Tag. |
| `strip_auth_tag_axis_in_ready` | Output | `uint1_t` | Ready signal to consume the incoming stream. |
| `strip_auth_tag_axis_out` | Output | `stream(axis128_t)` | Output AXI stream containing only the Ciphertext. |
| `strip_auth_tag_axis_out_ready` | Input | `uint1_t` | Ready signal from the Ciphertext consumer. |
| `strip_auth_tag_auth_tag_out` | Output | `stream(poly1305_auth_tag_uint_t)` | Output stream containing the separated 16-byte Authentication Tag. |
| `strip_auth_tag_auth_tag_out_ready` | Input | `uint1_t` | Ready signal from the MAC consumer (Poly1305 verifier). |

### Operational Flow

#### 1. Look-Ahead and Buffer (`axis128_early_tlast`)

The input data passes through the `axis128_early_tlast` function:
* It buffers the most recently received AXI word.
* It determines if the *next* word waiting at the input has `tlast=1`. This signal (`next_axis_out_is_tlast`) is used to correctly terminate the Ciphertext output stream.
* The function ensures back-pressure is correctly applied if the buffer is full.

#### 2. Ciphertext Pass-Through (Default Operation)

* **Data:** By default, the output from the look-ahead buffer (`axis_in`) is passed directly to the Ciphertext output (`strip_auth_tag_axis_out`).
* **TLAST Correction:** The output `tlast` signal on the Ciphertext output is driven by `early_tlast.next_axis_out_is_tlast`. This asserts `tlast` on the block *before* the MAC block.
* **Ready Signal:** The ready signal for the main loop (`ready_for_axis_in`) is normally tied to the Ciphertext output's ready signal (`strip_auth_tag_axis_out_ready`).

#### 3. Auth Tag Extraction (Final Cycle)

* **Condition:** If the buffered input word (`axis_in`) has both `valid=1` and `tlast=1`, the block is the Authentication Tag.
* **Ciphertext Suppression:** The Ciphertext output stream (`strip_auth_tag_axis_out`) is suppressed (`valid = 0`).
* **MAC Output:** The data payload (`axis_in.data.tdata`) is interpreted as the 128-bit MAC using `poly1305_auth_tag_uint_from_bytes()` and driven onto the `strip_auth_tag_auth_tag_out` stream.
* **Ready Signal Update:** The main loop's ready signal is momentarily switched to be driven by the MAC consumer's ready signal (`strip_auth_tag_auth_tag_out_ready`), ensuring the MAC is only consumed when the Poly1305 verifier is ready.



## poly1305_verify_decrypt

The `poly1305_verify_decrypt` module is the final arbiter in the authentication process for ChaCha20-Poly1305. Its sole responsibility is to receive the Authentication Tag provided with the incoming message (`poly1305_verify_auth_tag`) and the tag calculated locally by the `poly1305_mac` module (`poly1305_verify_calc_tag`). It performs a single, atomic 128-bit comparison to determine if the message is authentic, outputting a 1-bit match result.

The verification result is critical: if the tags match (1), the decrypted ciphertext is considered valid; if they do not match (0), the ciphertext must be discarded to prevent padding oracle or related attacks.



### Inputs and Outputs

The module manages two input streams (Tags) and one output stream (Result).

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `poly1305_verify_auth_tag` | Input | `stream(poly1305_auth_tag_uint_t)` | The 16-byte Authentication Tag received from the network (via `strip_auth_tag`). |
| `poly1305_verify_auth_tag_ready` | Output | `uint1_t` | Ready signal for the input received tag stream. |
| `poly1305_verify_calc_tag` | Input | `stream(poly1305_auth_tag_uint_t)` | The 16-byte Tag calculated locally by the `poly1305_mac` module. |
| `poly1305_verify_calc_tag_ready` | Output | `uint1_t` | Ready signal for the input calculated tag stream. |
| `poly1305_verify_tags_match` | Output | `stream(uint1_t)` | 1-bit result: 1 if tags are identical, 0 otherwise. |
| `poly1305_verify_tags_match_ready` | Input | `uint1_t` | Ready signal from the consumer of the verification result. |

### Finite State Machine (FSM) Description

The FSM sequentially consumes the two input tags and then performs the comparison, ensuring correct synchronization between the two independent input streams before generating the output.

| State | FSM Action | Input/Output Handshake | Next State Transition |
| :--- | :--- | :--- | :--- |
| **TAKE\_AUTH\_TAG** | Asserts readiness for the incoming Authentication Tag (`poly1305_verify_auth_tag_ready = 1`). | On valid data transfer, reads and registers the received tag (`auth_tag_reg`). | Successful transfer. $\rightarrow \text{TAKE\_CALC\_TAG}$ |
| **TAKE\_CALC\_TAG** | Asserts readiness for the locally Calculated Tag (`poly1305_verify_calc_tag_ready = 1`). | On valid data transfer, reads and registers the calculated tag (`calc_tag_reg`). | Successful transfer. $\rightarrow \text{COMPARE\_TAGS}$ |
| **COMPARE\_TAGS** | Performs the 128-bit equality check: `tags_match_reg = (auth_tag_reg == calc_tag_reg)`. This operation is combinatorial and completes in a single clock cycle. | No I/O handshake is needed in this state, as it uses internal registers. | Unconditional transition. $\rightarrow \text{OUTPUT\_COMPARE\_RESULT}$ |
| **OUTPUT\_COMPARE\_RESULT** | Outputs the result stored in `tags_match_reg` and asserts the output stream valid signal. | Waits until the consumer asserts `poly1305_verify_tags_match_ready`. | Successful output transfer. $\rightarrow \text{TAKE\_AUTH\_TAG}$ (Reset for next transaction). |




## wait_to_verify

The `wait_to_verify` module is the final gate in the decryption pipeline. In the ChaCha20-Poly1305 scheme, plaintext is generated *before* the authentication tag is calculated and verified. This module synchronizes the plaintext output with the verification result.

It acts as a **synchronous buffer (FIFO)**:
1.  **Buffering:** It immediately buffers the incoming plaintext into a FIFO.
2.  **Waiting:** It waits until the 1-bit verification result (`wait_to_verify_verify_bit`) arrives from the comparator.
3.  **Outputting:** Once the verification result is known, it either allows the buffered plaintext to stream out (if verified) or keeps it permanently buffered (if verification failed, preventing invalid data from leaving the chip).



### Architecture and Components

The module primarily relies on an embedded **Global Stream FIFO** (`verify_fifo`) with a depth of 128 words (2KB of data), large enough to buffer several standard AXI stream packets while the Poly1305 MAC calculation completes.

### Inputs and Outputs

| Port Name | Direction | Type | Description |
| :--- | :--- | :--- | :--- |
| `wait_to_verify_axis_in` | Input | `stream(axis128_t)` | The incoming Plaintext stream (output from the ChaCha20 decryptor). |
| `wait_to_verify_axis_in_ready` | Output | `uint1_t` | Ready signal (derived from FIFO not-full status). |
| `wait_to_verify_verify_bit` | Input | `stream(uint1_t)` | 1-bit result from the `poly1305_verify_decrypt` module. |
| `wait_to_verify_verify_bit_ready` | Output | `uint1_t` | Ready signal for the verification bit input. |
| `wait_to_verify_axis_out` | Output | `stream(axis128_t)` | The outgoing Plaintext stream (released only after verification). |
| `wait_to_verify_axis_out_ready` | Input | `uint1_t` | Ready signal from the plaintext consumer. |
| `wait_to_verify_is_verified_out` | Output | `uint1_t` | Outputs the verification result (`tags_match_reg`) synchronized with the stream output. |

### Finite State Machine (FSM) Description

The FSM controls the read enable of the FIFO and manages the timing of the verification result output.

| State | FSM Action | FIFO Read/Write | Next State Transition |
| :--- | :--- | :--- | :--- |
| **WAIT\_TO\_VERIFY\_BIT** | **Input Side:** Plaintext is continuously written into the FIFO (`verify_fifo`) as long as space is available. **Output Side:** FIFO Read Enable is **de-asserted** (`verify_fifo_out_ready = 0`). Plaintext is buffered. | Asserts readiness for the single-bit verification result (`wait_to_verify_verify_bit_ready = 1`). | Verification bit received (`wait_to_verify_verify_bit.valid = 1`). $\rightarrow \text{OUTPUT\_PLAINTEXT}$ |
| **OUTPUT\_PLAINTEXT** | **Condition:** This state is only entered once the verification bit is received. **Data Release:** FIFO Read Enable is asserted (`verify_fifo_out_ready = wait_to_verify_axis_out_ready`), allowing the plaintext to stream out. | Outputs the static verification result (`tags_match_reg`) via `wait_to_verify_is_verified_out`, synchronized with the plaintext stream valid signal. | When the output stream is valid and accepted (`wait_to_verify_axis_out.valid & wait_to_verify_axis_out_ready`) AND the stream's `tlast` signal is observed. $\rightarrow \text{WAIT\_TO\_VERIFY\_BIT}$ (Reset for next transaction). |

**Security Note:** If the verification result (`tags_match_reg`) is 0 in the `OUTPUT_PLAINTEXT` state, the plaintext stream is still ready to output, but the accompanying signal `wait_to_verify_is_verified_out` will be 0. If the zero does occur the system will drop the output plaintext.