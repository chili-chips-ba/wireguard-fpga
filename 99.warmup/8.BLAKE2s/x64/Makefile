# Project folder structure
INC_DIR = inc
SRC_DIR = src
OUT_DIR = buildOutput
TEST_DIR = test

# Compiler and flags
CC = gcc
CFLAGS = -Wall -I$(INC_DIR) -std=c99

# Source files
SRCS = $(SRC_DIR)/blake2s.c

# Output binary
TARGET_BIN = $(OUT_DIR)/blake2s

# Test files
TEST_SRC = $(TEST_DIR)/test_blake2s.c
TEST_BIN  = $(OUT_DIR)/test_blake2s

# Create build output directory	
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Compile tests
$(TEST_BIN): $(TEST_SRC) $(SRCS)
	$(CC) $(CFLAGS) -o $@ $^ -lcunit

# Run tests
test: $(OUT_DIR) $(TEST_BIN)
	./$(TEST_BIN)

# Run main and tests
all: clean test

# Clean rule
clean:
	rm -rf $(OUT_DIR)

.PHONY: all clean