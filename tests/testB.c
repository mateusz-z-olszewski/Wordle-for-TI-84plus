#include "../gui.h"
#include "../words.h"

void test1(void){
    clearScreen();

    drawChar(0, 0, 'X');
    drawChar(5, 4, 'X');

    drawGreenOutline(5, 0);
    drawChar(5, 0, ' ');

    drawChar(2, 2, 'G');
    drawGreenOutline(2, 2);

    drawYellowOutline(0, 4);

    drawChar(2, 4, 'Y');
    drawYellowOutline(2, 4);

    awaitUserInput();
}

int main(void){
    test1();
}