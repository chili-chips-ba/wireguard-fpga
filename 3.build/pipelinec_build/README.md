# Encryption and Decryption using PipelineC

In this segement we will present the design behind the implemented *chacha20poly1305* encryptor and decryptor

## Encryption

<p align="center">
    <img width="700" src="./doc/Encryption.png">
</p>

## Decryption

<p align="center">
    <img width="700" src="./doc/chacha20poly1305_decrypt.png">
</p>

The design scheme for the decryptor can be seen above. Unlike the *encryption* we now have both *ciphertext* and the *authentication tag* as inputs to our module. The inputs first go inside the *strip_auth_tag* block, since both *ciphertext* and *authentication tag* come in one after the other in one stream, we have to separate them, and them pass them on to the next blocks. 

In the table below we showcase the  
| 128b AXIS bus |128b bus | 1b bus | 256b bus |
|:--:|:--:|:--:|:--:|
|input ciphertext + auth_tag | auth_tag | verify_bit | poly1305_key |
| ciphertext | calculated_tag | is_verified | |
| auth_data | |||
| plaintext |