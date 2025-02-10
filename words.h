#include <stdbool.h>
#include <stdint.h>

/// @brief Checks if the word is in the 13k wordset
/// @param word pointer to 5 character array
bool isValidWord(char* word);

/// @brief Generates a word from the 2k wordset
/// @return pointer to 5 character array
char* generateSecret(void);
