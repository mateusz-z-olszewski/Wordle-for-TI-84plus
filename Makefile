CC = zcc

# Compiler Flags
CFLAGS = +ti83p -subtype=asm -create-app -pragma-define:CRT_ENABLE_STDIO=0


TARGET = wordle
IMPLEMENTATIONS = gui.asm words.c

# Find all testX.c files in the tests/ directory
TESTS := $(wildcard tests/test*.c)
TEST_TARGETS := $(TESTS:.c=.8xp)

default: $(TARGET) tests

$(TARGET):
	$(CC) main.c $(IMPLEMENTATIONS) -o $(TARGET).8xp $(CFLAGS)

%.8xp: %.c
	$(CC) $< $(IMPLEMENTATIONS) -o $@ $(CFLAGS)

tests: $(TEST_TARGETS)

.PHONY: $(TARGET) tests