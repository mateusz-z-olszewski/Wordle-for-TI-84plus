# Words
Wordle clone for TI-84+

## Build
Compile project with `make`. This results in a `wordle.8xp` file that can be passed to the calculator to be executed.

## Editor
Recommended editor is Visual Studio Code with WSL Remote, C/C++, and Z80 assembly extensions.

## Tests
There exist some unit tests that allow for checking of parts of the code. They can be compiled using `make tests` and are also made into `.8xp` files executable on the calculator.

## Current version's features
- [X] GUI
- [X] Word checking (yellow/green)
- [ ] Word validation
- [ ] Synced secret generation
- [ ] Advanced UI (ingame text messages)