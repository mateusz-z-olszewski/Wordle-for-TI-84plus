include "./ti83plus.inc"

; assembly library for the system calls
; calling convention: all arguments on the stack left to right. Return in de/hl
; meaning: first argument is pushed first and is at highest address on the stack

GLOBAL _puts
GLOBAL _clearScreen
GLOBAL _awaitUserInput
GLOBAL _getKeyboardInput
GLOBAL _getKeyboardScanCode
GLOBAL _printNumber
GLOBAL _drawGreenOutline
GLOBAL _drawYellowOutline
GLOBAL _printU8
GLOBAL _clearSquare
GLOBAL _drawChar
GLOBAL _convertCSC
GLOBAL _printText ; todo

._puts:
	; load #1 arg
    ld hl, 2
    add hl, sp
    ld hl, (hl)
	
    rst rBR_CALL
    dw  _PutS
    ret

._clearScreen
	rst	rBR_CALL
	dw	_ClrLCDFull
	rst	rBR_CALL
	dw	_HomeUp
	ret

._awaitUserInput
	rst rBR_CALL
	dw _getkey	
	ret

._getKeyboardInput
	rst rBR_CALL
	dw _getkey	
	ld h, 0
	ld l, a
	ret
	
._getKeyboardScanCode
	; ei ; enable interrupts and halt to save energy
	; halt
	rst rBR_CALL
	dw _GetCSC
	cp a, 0
	jp Z, _getKeyboardScanCode
	ld h, 0
	ld l, a
	ret

._printNumber
	; load #1 arg: u16
    ld hl, 2
    add hl, sp
    ld hl, (hl)
    
	rst rBR_CALL
	dw _DispHL
	ret

._printU8
	; load #1 arg: u8
    ld hl, 2
    add hl, sp
    ld hl, (hl)
	ld h, 0
    
	rst rBR_CALL
	dw _DispHL
	ret

.setMarginsHLDE
	; invertRect/ClearRect arguments:
	; H = upper left corner pixel row
	; L = upper left corner pixel column
	; D = lower right corner pixel row
	; E = lower right corner pixel column

	; load #1 arg: u8
	ld hl, 6
    add hl, sp
    ld hl, (hl)
	ld a, l
	call mulA9
	ld d, a ; e now stores unoffset NW corner Y coord.

	; load #2 arg: u8
    ld hl, 4
    add hl, sp
    ld hl, (hl)
	ld a, l
	call mulA9
	ld e, a ; e now stores unoffset NW corner X coord.

	ld hl, (OUTLINE_OFFSETS)
	add hl, de 
	ld de, hl ; de now stores the coordinates of the SE corner
	ld hl, (OUTLINE_SIZES)
	add hl, de

	ret

._clearSquare
	call setMarginsHLDE

	rst rBR_CALL
	dw _ClearRect

	ret

._drawGreenOutline ;(u8 y, u8 x)
	call setMarginsHLDE

	rst rBR_CALL
	dw _InvertRect

	ret

._drawYellowOutline ;(u8 y, u8 x)
	call setMarginsHLDE

	; note: yellow outline is just two inverted rectangles, 
	; one smaller than the other, on top of each other

	push hl
	push de

	; larger rect
	rst rBR_CALL
	dw _InvertRect

	ld bc, 0xfeff
	pop hl
	add hl, bc
	ld de, hl
	ld bc, 0x0101
	pop hl
	add hl, bc

	; smaller rect	
	rst rBR_CALL
	dw _InvertRect
	
	ret 


._drawChar
	; load offsets
	ld bc, (OFFSETS)

	; load arg #1: u8 y -> a
	ld hl, 6
    add hl, sp
    ld hl, (hl)
	ld a, l

	; set Y variable: 1. a = d is first argument
	call mulA9      ; 2. a = 9d
	add a, b        ; 3. a = 9d + yoffset	
	ld (penRow), a

	; load arg #2: u8
	ld hl, 4
    add hl, sp
    ld hl, (hl)
	ld a, l

	; set X variable: 1. a = d is first argument
	call mulA9      ; 2. a = 9d
	add a, c       ; 3. a = 9d +xoffset	
	ld (penCol), a

	; load arg #3: char
	ld hl, 2
    add hl, sp
    ld hl, (hl)
	ld a, l
	;DEBUG ld (vputmapBuffer), hl

	; reset flags
	res fracDrawLFont, (iy+fontFlags)
	res textWrite, (iy+sGrFlags)

	rst rBR_CALL
	dw _VPutMap

	ret

; multiplies the accumulator by 9
; modifies: a / trashes: none
.mulA9
	push de
	ld d, a
	add a, a ; a = 2a
	add a, a ; a = 4a
	add a, a ; a = 8a
	add a, d ; a = 9a
	pop de
	ret

; CONSTANTS
MarginTop equ 6
MarginLeft equ 6
.OFFSETS
	db MarginTop, 4 + MarginLeft
.OUTLINE_OFFSETS ; offset from NW screen corner to SE outline corner
	db 5 + MarginTop, 11 + MarginLeft
.OUTLINE_SIZES
	db -8, -9

.vputmapBuffer
	db 'X', 0

._convertCSC
	; load #1 arg: u8
    ld hl, 2
    add hl, sp
    ld hl, (hl)
	ld a, l

	ld hl, _CHARTABLE
	add hl, a
	ld hl, (hl)
	ld h, 0

	ret

._printText
	ret


; the lookup table for key input. for keys that have letters on them, returns the 
; letter's ASCII code regardless of shift/alpha. For some keys, returns the 
; QUITCODE; example: quit, delete, clear.
._CHARTABLE
	defs 9
	defb 253 	; #09 - enter -> delete
	defs 1
	defb 'W'    ; #11
	defb 'R'    ; #12
	defb 'M'    ; #13
	defb 'H'    ; #14
	defb 255    ; #15 - clear -> quit
	defs 3
	defb 'V'    ; #19
	defb 'Q'    ; #20
	defb 'L'    ; #21
	defb 'G'    ; #22
	defs 3
	defb 'Z'    ; #26
	defb 'U'    ; #27
	defb 'P'    ; #28
	defb 'K'    ; #29
	defb 'F'    ; #30
	defb 'C'    ; #31
	defs 2
	defb 'Y'    ; #34
	defb 'T'    ; #35
	defb 'O'    ; #36
	defb 'J'    ; #37
	defb 'E'    ; #38
	defb 'B'    ; #39
	defs 2
	defb 'X'    ; #42
	defb 'S'    ; #43
	defb 'N'    ; #44
	defb 'I'    ; #45
	defb 'D'    ; #46
	defb 'A'    ; #47
	defs 7
	defb 255      ; #55 - mode -> quit
	defb 254      ; #56 - del -> delete
	defs 8
