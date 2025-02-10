#include "../gui.h"
#include "../words.h"

#define ASSERT_TRUE(expr) if(!(expr)) failed++;

int failed;

void word5LettersTest(){
    char* word = generateSecret();
    ASSERT_TRUE(
        word[0] != 0 && 
        word[1] != 0 && 
        word[2] != 0 && 
        word[3] != 0 && 
        word[4] != 0
    );
}

int main(void){
    failed = 0;

    word5LettersTest();

    return failed;
}