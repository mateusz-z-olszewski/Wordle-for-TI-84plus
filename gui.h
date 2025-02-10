typedef unsigned char u8;
typedef unsigned int u16;

#define ENTERKEY -3
#define DELKEY -2
#define ESCKEY -1

/// @brief Clears the screen
void clearScreen(void);

/// @brief Awaits user input (using getKey)
void awaitUserInput(void); 

/// @brief Awaits user input and returns the key pressed
char getKeyboardInput(void); 
/// @brief Awaits user input and returns the keyboard scan code of the key pressed. 
/// Uses more power than GetKey because it does not enter the low power mode.
char getKeyboardScanCode(void); 

/// @brief Prints an unsigned integer.
/// @param i number to be printed
void printNumber(u16 i);

/// @brief Prints an unsigned char.
/// @param i number to be printed
void printU8(u8 i);

/// @brief Displays text from given coordinates.
void printText(u8 y, u8 x, char* text); // not implemented yet


// WORDLE SPECIFIC FUNCTIONS HEADERS

/// @brief Draws a full square representing a correct (green) guess.
///  Does not write over letters which are already present there.
/// @param y coordinate (value 0-5)
/// @param x coordinate (value 0-4)
void drawGreenOutline(u8 y, u8 x);

/// @brief Draws a partial square outline representing a partially correct (yellow) guess.
/// Does not write over letters which are already present there.
/// @param y coordinate (value 0-5)
/// @param x coordinate (value 0-4)
void drawYellowOutline(u8 y, u8 x);

/// @brief Clears a square. 
/// @param y coordinate (value 0-5)
/// @param x coordinate (value 0-4)
void clearSquare(u8 y, u8 x);

/// @brief Draws a letter at specified position.
/// @param y coordinate (value 0-5) 
/// @param x coordinate (value 0-4) 
/// @param c character
void drawChar(u8 y, u8 x, char c);


// OTHER FUNCTIONS

/// @brief Converts a keyboard scan code to: (1.) ASCII character if it is an uppercase letter
/// (2.) Special value if it is `Enter`, `Clear`, `Del` or `Mode[Quit]` (3.) Value 0 otherwise
/// @param csc keyboard scan code as returned from `getCSC`
char convertCSC(char csc);
