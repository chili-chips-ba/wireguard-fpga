# Makefile for ChaCha20-Poly1305 AEAD implementation

CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c99
LDFLAGS = 
OBJDUMP = objdump  # Use objdump to generate hex files
BUILD_DIR = build_output

SRCS = main.c chacha20.c poly1305.c chacha20poly1305.c string_bare.c
OBJS = $(patsubst %.c, $(BUILD_DIR)/%.o, $(SRCS))
HEX_FILES = $(patsubst %.o, %.hex, $(OBJS))

TARGET = $(BUILD_DIR)/chacha20poly1305_test.exe  # Ensure .exe for Windows

all: $(TARGET) $(HEX_FILES)

# Link the final executable
$(TARGET): $(OBJS)
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET) $(LDFLAGS)

# Compile each .c file into a .o file in build_output/
$(BUILD_DIR)/%.o: %.c
	@if not exist $(BUILD_DIR) mkdir $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Generate .hex file from .o file
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.o
	$(OBJDUMP) -s $< > $@

# Clean build_output directory
clean:
	@if exist $(BUILD_DIR) rmdir /s /q $(BUILD_DIR)

.PHONY: all clean
