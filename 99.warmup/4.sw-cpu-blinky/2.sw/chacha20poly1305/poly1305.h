/**
 * @file poly1305.h
 * @brief Simple implementation of Poly1305 MAC algorithm
 */

#ifndef POLY1305_H
#define POLY1305_H

#include <stdint.h>
#include <stddef.h>
/**
 * @brief Compute Poly1305 MAC for a message
 *
 * @param auth_tag Output buffer for the 16-byte authentication tag
 * @param key 32-byte key (r || s)
 * @param message Input message buffer
 * @param message_length Length of the message in bytes
 */
void poly1305_mac(uint8_t *auth_tag, const uint8_t *key, const uint8_t *message, size_t message_lenght);

/**
 * @brief Verify if two Poly1305 tags match
 *
 * @param received_auth_tag Received tag to compare
 * @param calucalted_auth_tag Calculated tag to compare
 * @return 1 if tags match, 0 otherwise
 */
int poly1305_verify(const uint8_t *received_auth_tag, const uint8_t *calucalted_auth_tag);

#endif // POLY1305_H