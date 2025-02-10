#include "gui.h"
#include "words.h"

enum {
    GRAY_TILE,
    YELLOW_TILE,
    GREEN_TILE
};

char table[6][5] = {0};
char* secret;
u8 colors[5];
u8 row = 0, col = 0;
char* INCORRECT_WORD_MSG = "No such word!";
char* YOU_WON_MSG = "You won!";
char did_not_guess_msg[] = "The word was XXXXX";

bool checkColors(char* word, char* secret, u8* array){  
    array[0] = array[1] = array[2] = array[3] = array[4] = GRAY_TILE;
    char mem[5]; // stores up to 5 letters from secret which are not immediately matched (green)
    int l = 0;
    // initial check: mark green letters and store all other ones
    for (int i = 0; i < 5; i++) {
        if (word[i] == secret[i]) array[i] = GREEN_TILE;
        else mem[l++] = secret[i];
    }
    if (l == 0) return true; // if every character matched.
    // yellow letter check: attempt to match each stored letter with a not yet matched letter in word.
    for (int m = 0; m < l; m++) {
        for (int i = 0; i < 5; i++) {
            char c = mem[m];
            if (array[i] == GRAY_TILE && word[i] == c) {
                array[i] = YELLOW_TILE;
                break;
            }
        }
    }
    return false;
}

void displayText(char* text){
    printText(57, 3, text);
}

void drawUnderscore(u8 y, u8 x){
    drawChar(y, x, '_');
}

void displayColors(u8* array, u8 row){
    for (int i = 0; i < 5; i++) {
        u8 color = array[i];
        if (color == GREEN_TILE) drawGreenOutline(row, i);
        else if (color == YELLOW_TILE) drawYellowOutline(row, i);
    }
}

void handleDelete(void){
    if (col == 0) return;
    // clear the following underscore if present
    if (col < 5) clearSquare(row, col);
    // draw new underscore 
    col--;
    drawUnderscore(row, col);
}

bool handleEnter(void){
    char* word = table[row];
    bool out = false;
    if (isValidWord(word)) {
        out = checkColors(word, secret, colors);
        displayColors(colors, row);
        row++;
        col = 0;
        if(row < 6) drawUnderscore(row, col);
    } else {
        displayText(INCORRECT_WORD_MSG);
    }
    return out;
}

void handleCharacter(char c){
    if(col == 5) return;
    drawChar(row, col, c);
    table[row][col] = c;
    col++;
    if(col != 5) drawUnderscore(row, col);
}


// program structure
void start(void){
    secret = generateSecret();
    // compute the 'did not guess' message
    const int start = sizeof(did_not_guess_msg) - 6;
    for (int i = 0; i < 5; i++) {
        did_not_guess_msg[start + i] = secret[i];
    }
    // clear screen
    clearScreen();
}


void loop(void){
    bool guessed = false;
    while (row < 6){
        char key = getKeyboardScanCode();
        char ascii = convertCSC(key);
        if (ascii == ESCKEY) return;
        if (ascii == DELKEY) handleDelete();
        else if (ascii == ENTERKEY){ 
            if (col < 5) continue;
            guessed = handleEnter();
            if (guessed) break;
        }
        else handleCharacter(ascii);
    }
    displayText(guessed ? YOU_WON_MSG : did_not_guess_msg);
}

void finish(void){
    awaitUserInput();
    clearScreen();
}

int main(void){
    start();
    loop();
    finish();
    return 0;
}
