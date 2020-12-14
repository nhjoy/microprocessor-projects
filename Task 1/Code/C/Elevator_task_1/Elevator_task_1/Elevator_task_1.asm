/*
 * Elevator_task_1.asm
 *
 *  Created: 12/8/2020 11:25:29 PM
 *   Author: nhjoy
 */ 

 .include "M32DEF.INC"
 	.ORG 0

;initialize
		LDI		R16, HIGH (RAMEND)	; Load SPH
		OUT		SPH, R16
		LDI		R16, LOW (RAMEND)	; Load SPL
		OUT		SPL, R16

		CBI		DDRB, 0
		LDI		R16, 0xFF
		OUT		DDRC, R16 ; set PORTC as OUTPUT

		LDI		R16, 0x01
		OUT		PORTC, R16

MAIN:
		LDI		R17,	0x01

SW1:	SBIS	PINB,	0; skip next if PB bit is HIGH
		RJMP	SW2
		LDI		R16, 0b00000001
		CALL	COMPARE
		RJMP	SW1

SW2:
		SBIS	PINB,	1 ; skip next if PB bit is HIGH
		RJMP	SW3
		LDI		R16, 0b00000010
		CALL	COMPARE
		RJMP	SW1

SW3:
		SBIS	PINB,	2 ; skip next if PB bit is HIGH
		RJMP	SW4
		LDI		R16, 0b00000011
		CALL	COMPARE
		RJMP	SW1

SW4:
		SBIS	PINB,	3 ; skip next if PB bit is HIGH
		RJMP	SW5
		LDI		R16, 0b00000100
		CALL	COMPARE
		RJMP	SW1
SW5:
		SBIS	PINB,	4 ; skip next if PB bit is HIGH
		RJMP	SW1
`		LDI		R16, 0b00000101
		CALL	COMPARE
		RJMP	SW1

;Compare subroutine
COMPARE:

 CP		R16, R17
 BRSH SAME_HI

 MOV	R20, R17 ; LESS
 CALL LESS

SAME_HI:
 BRNE HI

 MOV R17, R16; EQUAL
 OUT	PORTC, R17
 RET

HI:
	MOV R20, R16 ; MORE
	SUB	R20, R17
L2:
	INC	R17
	CALL DELAY_500ms
	OUT	PORTC, R17
	DEC R20
	BRNE L2
	MOV R17, R16

	RET
; HIGH

LESS:
	MOV R21, R20
	LDI R22, 0x00
	L1:
		DEC	R20	
		RJMP CHECK1
		BRNE L1
CHECK1:
		CP	R20,R22
		BRSH CHECKING1
CHECKING1:
		BRNE HI1

		OUT	PORTC, R21
		MOV R17, R16
		RET

HI1:
	DEC R21
	CALL DELAY_500ms
	OUT	PORTC, R21
	RJMP L1

;DELAY SUBROUTINE
DELAY_500ms:

		LDI		R30, 32
L5:		LDI		R29, 50
L6:		LDI		R28, 150
L7:
		NOP
		NOP
		DEC		R28
		BRNE	L7

		DEC		R29
		BRNE	L6

		DEC		R30
		BRNE	L5
		RET
