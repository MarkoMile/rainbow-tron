	CALL PREPARE_BORDER_BITMAP_POINTER
	CALL INIT_PLAYERS
	CALL DRAW_BORDER_ATTRIBUTE_BLOCKS
	CALL DRAW_BORDER_PIXLES
	CALL SET_BORDER_COLOR
MAIN_LOOP:
	LD   A,(WINNING_PLAYER)			; load winning player into A
	AND  %00000011			; check if winning player is 1, 2, or 3
	JP   NZ,END_GAME			; if YES (somebody has won), jump to ??end game label??
	CALL MOVE_PLAYERS
	LD   A,(INPUT_LOOP_COUNTER)
	LD   B,A
READ_INPUT:
	HALT
	CALL READ_INPUT_PLAYER2			; READ INPUT FOR PLAYER2 (I,J,K,L) --> Bits of A meaning: 0(I):UP,1(L):RIGHT,2(K):DOWN,3(J):LEFT
	BIT  0,A
	CALL Z,PLAYER2_CHANGEDIR_UP
	BIT  2,A
	CALL Z,PLAYER2_CHANGEDIR_DOWN
	BIT  3,A
	CALL Z,PLAYER2_CHANGEDIR_LEFT
	BIT  1,A
	CALL Z,PLAYER2_CHANGEDIR_RIGHT
	LD   A,$FF
	CALL READ_INPUT_PLAYER1			; READ INPUT FOR PLAYER1 (W,A,S,D) --> Bits of A meaning: 0(A):LEFT,1(S):DOWN,2(D):RIGHT,3(W):UP
	BIT  3,A
	CALL Z,PLAYER1_CHANGEDIR_UP
	BIT  1,A
	CALL Z,PLAYER1_CHANGEDIR_DOWN
	BIT  0,A
	CALL Z,PLAYER1_CHANGEDIR_LEFT
	BIT  2,A
	CALL Z,PLAYER1_CHANGEDIR_RIGHT
	DEC  B
	JP   NZ,READ_INPUT
	JR   MAIN_LOOP
PREPARE_BORDER_BITMAP_POINTER:			; i actually have no clue why this exists
	PUSH HL
	LD   HL,$8445			; hard coded border bitmap location ???
	LD   (BORDER_BITMAP_POINTER),HL
	POP  HL
	RET 
INIT_PLAYERS:
	PUSH AF
	PUSH DE
	PUSH HL
	LD   HL,(PLAYER1_STARTING_POS)			; load player1 starting pos into HL
	LD   A,%01101000			; load color "bright cyan" into A
	LD   (HL),A			; set attribute block of p1 starting pos to "bright cyan"
	LD   (PLAYER1_POS),HL			; set PLAYER1_POS to p1 starting pos
	LD   HL,(PLAYER2_STARTING_POS)			; load player2 starting pos into HL
	LD   A,%01010000			; load "bright red" into A
	LD   (HL),A			; set attribute block of p2 starting pos to "bright red"
	LD   (PLAYER2_POS),HL			; set PLAYER2_POS to p2 starting pos
	POP  HL
	POP  DE
	POP  AF
	RET 
READ_INPUT_PLAYER2:
	PUSH BC
	PUSH DE
	LD   BC,$BFFE			; load bc with row port address (H, J, K, L, ret)
	IN   A,(C)			; read input from port
	OR   $01			; set bit 1 of A, this is used later when checking if I is pressed
	LD   BC,$DFFE			; load bc with row port address (Y, U, I, O, P)
	IN   D,(C)			; read input from port
	BIT  2,D			; check bit 2 (I)
	JR   NZ,SKIP_RESET_INPUT_P2			; if (I) is pressed skip resetting bit 0 of A
	RES  0,A
SKIP_RESET_INPUT_P2:			; if (I) is not pressed, reset bit 0 of A
	POP  DE
	POP  BC
	RET 
READ_INPUT_PLAYER1:
	PUSH BC
	PUSH DE
	LD   BC,$FDFE			; load bc with row port address (A, S, D, F, G)
	IN   A,(C)			; read input from port
	OR   %00001000			; set bit 3 of A, this is used later when checking if W is pressed
	LD   BC,$FBFE			; load bc with row port address (Q, W, E, R, T)
	IN   D,(C)			; read input from port
	BIT  1,D			; check bit 1 (W)
	JR   NZ,SKIP_RESET_INPUT_P1			; if (W) is pressed skip resetting bit 3 of A
	RES  3,A			; if (W) is not pressed, reset bit 3 of A
SKIP_RESET_INPUT_P1:
	POP  DE
	POP  BC
	RET 
PLAYER1_CHANGEDIR_RIGHT:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER1_MOVEDIR
	LD   BC,3
	LD   A,2
	CP   (HL)
	JR   Z,P1_SKIP_CHANGEDIR_RIGHT
	LD   (PLAYER1_MOVEDIR),BC
P1_SKIP_CHANGEDIR_RIGHT:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER1_CHANGEDIR_UP:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER1_MOVEDIR
	LD   BC,1
	LD   A,0
	CP   (HL)
	JR   Z,P1_SKIP_CHANGEDIR_UP
	LD   (PLAYER1_MOVEDIR),BC
P1_SKIP_CHANGEDIR_UP:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER1_CHANGEDIR_DOWN:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER1_MOVEDIR
	LD   BC,0
	LD   A,1
	CP   (HL)
	JR   Z,P1_SKIP_CHANGEDIR_DOWN
	LD   (PLAYER1_MOVEDIR),BC
P1_SKIP_CHANGEDIR_DOWN:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER1_CHANGEDIR_LEFT:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER1_MOVEDIR
	LD   BC,2
	LD   A,3
	CP   (HL)
	JR   Z,P1_SKIP_CHANGEDIR_LEFT
	LD   (PLAYER1_MOVEDIR),BC
P1_SKIP_CHANGEDIR_LEFT:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER2_CHANGEDIR_RIGHT:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER2_MOVEDIR
	LD   BC,3
	LD   A,2
	CP   (HL)
	JR   Z,P2_SKIP_CHANGEDIR_RIGHT
	LD   (PLAYER2_MOVEDIR),BC
P2_SKIP_CHANGEDIR_RIGHT:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER2_CHANGEDIR_UP:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER2_MOVEDIR			; load current player2_movedir into HL
	LD   BC,1			; load new movedir into BC (UP)
	LD   A,0			; load movedir down into A (0)
	CP   (HL)			; check if player2_movedir is 0 (down)
	JR   Z,P2_SKIP_CHANGEDIR_UP			; if player2_movedir is down, he can't start moving up - so skip changing direction
	LD   (PLAYER2_MOVEDIR),BC			; change player2 movedir to 1 (up)
P2_SKIP_CHANGEDIR_UP:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER2_CHANGEDIR_DOWN:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER2_MOVEDIR
	LD   BC,0
	LD   A,1
	CP   (HL)
	JR   Z,P2_SKIP_CHANGEDIR_DOWN
	LD   (PLAYER2_MOVEDIR),BC
P2_SKIP_CHANGEDIR_DOWN:
	POP  HL
	POP  AF
	POP  BC
	RET 
PLAYER2_CHANGEDIR_LEFT:
	PUSH BC
	PUSH AF
	PUSH HL
	LD   HL,PLAYER2_MOVEDIR
	LD   BC,2
	LD   A,3
	CP   (HL)
	JR   Z,P2_SKIP_CHANGEDIR_LEFT
	LD   (PLAYER2_MOVEDIR),BC
P2_SKIP_CHANGEDIR_LEFT:
	POP  HL
	POP  AF
	POP  BC
	RET 
	db $04
	db $C9
MOVE_PLAYER2_UP:			; move player2 up
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$FFE0			; load increment value into BC for moving up
	LD   HL,(PLAYER2_POS)			; load player2 pos (current attribute block address) into HL
	ADD  HL,BC			; add increment value to player2 pos (go up 1 screen block)
	LD   A,(HL)			; next screen block address into A
	LD   HL,(PLAYER2_POS)			; load player2 pos (current attribute block address) into HL
	CP   %01000111			; check if next position of player2 is in wall
	CALL NZ,PLAYER1_WINS			; if YES, end game with player1 wins
	LD   BC,$FFE0			; load increment value into BC for moving up
	LD   (HL),%01110000			; load color "bright yellow" into HL -> previous player2 pos
	ADD  HL,BC			; calculate new player2 pos
	LD   (HL),%01010000			; load color "bright red" into HL -> new player2 pos
	LD   (PLAYER2_POS),HL			; store new player2 pos into memory
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER2_DOWN:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$0020
	LD   HL,(PLAYER2_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER2_POS)
	CP   %01000111
	CALL NZ,PLAYER1_WINS
	LD   BC,$0020
	LD   (HL),%01110000
	ADD  HL,BC
	LD   (HL),%01010000
	LD   (PLAYER2_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER2_LEFT:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$FFFF
	LD   HL,(PLAYER2_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER2_POS)
	CP   %01000111
	CALL NZ,PLAYER1_WINS
	LD   BC,$FFFF
	LD   (HL),%01110000
	ADD  HL,BC
	LD   (HL),%01010000
	LD   (PLAYER2_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER2_RIGHT:			; move player2 right
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,1			; load increment value into BC (1)
	LD   HL,(PLAYER2_POS)			; load player2 pos (current attribute block address) into HL
	ADD  HL,BC			; add increment value to player2 pos (go right 1 screen block address)
	LD   A,(HL)			; next screen block address into A
	LD   HL,(PLAYER2_POS)			; load player2 pos (current attribute block address) into HL
	CP   %01000111			; check if next position of player2 is in wall
	CALL NZ,PLAYER1_WINS			; if YES, end game with player1 wins
	LD   BC,1			; load increment value into BC (1)
	LD   (HL),%01110000			; load color "bright yellow" into HL -> previous player2 pos
	ADD  HL,BC			; calculate new player2 pos
	LD   (HL),%01010000			; load color "bright red" into HL -> new player2 pos
	LD   (PLAYER2_POS),HL			; store new player2 pos into memory
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER1_UP:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$FFE0
	LD   HL,(PLAYER1_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER1_POS)
	CP   $47
	CALL NZ,PLAYER2_WINS
	LD   BC,$FFE0
	LD   (HL),$68
	ADD  HL,BC
	LD   (HL),$48
	LD   (PLAYER1_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER1_DOWN:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$0020
	LD   HL,(PLAYER1_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER1_POS)
	CP   %01000111
	CALL NZ,PLAYER2_WINS
	LD   BC,$0020
	LD   (HL),$68
	ADD  HL,BC
	LD   (HL),$48
	LD   (PLAYER1_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER1_LEFT:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$FFFF
	LD   HL,(PLAYER1_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER1_POS)
	CP   $47
	CALL NZ,PLAYER2_WINS
	LD   BC,$FFFF
	LD   (HL),$68
	ADD  HL,BC
	LD   (HL),$48
	LD   (PLAYER1_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYER1_RIGHT:
	PUSH AF
	PUSH BC
	PUSH HL
	PUSH DE
	LD   BC,$0001
	LD   HL,(PLAYER1_POS)
	ADD  HL,BC
	LD   A,(HL)
	LD   HL,(PLAYER1_POS)
	CP   $47
	CALL NZ,PLAYER2_WINS
	LD   BC,$0001
	LD   (HL),$68
	ADD  HL,BC
	LD   (HL),$48
	LD   (PLAYER1_POS),HL
	POP  DE
	POP  HL
	POP  BC
	POP  AF
	RET 
MOVE_PLAYERS:			; move players depending on direction of movement
	PUSH AF
	PUSH BC
	PUSH HL
	LD   A,(PLAYER2_MOVEDIR)
	CP   $00
	CALL Z,MOVE_PLAYER2_DOWN
	LD   A,(PLAYER2_MOVEDIR)
	CP   $01
	CALL Z,MOVE_PLAYER2_UP
	LD   A,(PLAYER2_MOVEDIR)
	CP   $02
	CALL Z,MOVE_PLAYER2_LEFT
	LD   A,(PLAYER2_MOVEDIR)
	CP   $03
	CALL Z,MOVE_PLAYER2_RIGHT
	LD   A,(PLAYER1_MOVEDIR)
	CP   $00
	CALL Z,MOVE_PLAYER1_DOWN
	LD   A,(PLAYER1_MOVEDIR)
	CP   $01
	CALL Z,MOVE_PLAYER1_UP
	LD   A,(PLAYER1_MOVEDIR)
	CP   $02
	CALL Z,MOVE_PLAYER1_LEFT
	LD   A,(PLAYER1_MOVEDIR)
	CP   $03
	CALL Z,MOVE_PLAYER1_RIGHT
	POP  HL
	POP  BC
	POP  AF
	RET 
DRAW_BORDER_ATTRIBUTE_BLOCKS:
	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL
	LD   HL,$5800			; load first attribute block into HL
	LD   DE,(BORDER_BITMAP_POINTER)			; load border bitmap pointer into DE ;; i have no idea why this doesn't just load the border bitmap
	INC  DE			; move 2 memory locations because for some reason i don't have a label for the border bitmap
	INC  DE
	LD   C,96			; attribute blocks counter : total_screen_attributes_area/8=96
	DEC  C
	DEC  C
DRAW_BORDER_LOOP:
	LD   A,(DE)			; load current border bitmap byte
	LD   B,8			; counter to 8 [size of byte]
COLOR_BLOCKS:
	LD   (HL),%01000111			; color value in HL into "bright white" this colors the playable area
	SLA  A			; shift current border bitmap byte left ; if carry then draw border color
	JR   NC,SKIP_BORDER_COLOR			; don't color block to border color if carry flag isn't set
	LD   (HL),%00000111			; color value in HL into "white" this colors the border
SKIP_BORDER_COLOR:
	INC  HL			; move pointer to next attribute block
	DEC  B			; decrease counter
	JR   NZ,COLOR_BLOCKS
	DEC  C			; decrease attribute blocks counter
	JR   Z,BREAK_DRAW_BORDER_LOOP			; break loop if counter hits zero
	INC  DE			; increment DE to next border bitmap byte
	JR   DRAW_BORDER_LOOP
BREAK_DRAW_BORDER_LOOP:
	POP  HL
	POP  DE
	POP  BC
	POP  AF
	RET 
DRAW_BORDER_PIXLES:			; procedure to draw the border pixels around the playable window
	PUSH HL
	PUSH BC
	PUSH DE
	LD   HL,$4000			; load first pixel row into HL (HL is pointer to pixel row)
	LD   BC,$001F			; constant for jumping to right border
	LD   D,$C0			; row counter for drawing border [equal to height of screen in pixels]
DRAW_SIDE_BORDERS:
	LD   (HL),%10000000			; write left border pixel line
	ADD  HL,BC			; add constant to jump to right border pixel line
	LD   (HL),%00000001			; write right border pixel line
	INC  HL			; increment pixel row pointer
	DEC  D			; decrease row counter
	JR   NZ,DRAW_SIDE_BORDERS			; if row counter is not 0, repeat loop
	LD   HL,$57C0			; prepare pixel row pointer
	LD   D,$20			; column counter for drawing border [equal to width of screen in blocks]
DRAW_BOTTOM_BORDER:
	DEC  HL			; move back pixel row pointer (goes right to left)
	LD   (HL),$FF			; write bottom border pixel line
	DEC  D			; decrease column counter
	JR   NZ,DRAW_BOTTOM_BORDER			; if column counter is not 0, repeat loop
	LD   HL,$4000			; prepare pixel row pointer
	LD   D,$20			; column counter for drawing border [equal to width of screen in blocks]
DRAW_TOP_BORDER:
	LD   (HL),$FF			; write top border pixel line
	INC  HL			; move forward pixel row pointer (goes left to right)
	DEC  D			; decrease column counter
	JR   NZ,DRAW_TOP_BORDER			; if column counter is not 0, repeat loop
	POP  DE
	POP  BC
	POP  HL
	RET 
SET_BORDER_COLOR:
	LD   A,%00000000			; load color "black" into A
	CALL function_229B			; call routine from ROM to change border color
	RET 
DRAW_CHAR_PROCEDURE:			; routine to draw character - first calculates pixel position from B (row) and C (column)
	PUSH AF
	PUSH BC
	PUSH HL
	LD   A,B			; A = character_row [expected value for B is 20]
	AND  %00011000			; extract top bits from B
	OR   $40			; add base adress 0x4000 of first pixel to A
	LD   H,A
	LD   A,B			; A = character_row [expected value for B is 20]
	AND  %00000111			; A = (character_row & 0b111) (lower 3 bits = pixel row within section)
	RRCA
	RRCA			; Rotate right 3 times to divide by 8. This shifts the bits to correctly align the pixel row
	RRCA
	OR   C			; Add C to result, moving right by C columns
	LD   L,A
	LD   B,$08			; B now becomes counter for drawing pixel rows
DRAW_CHAR:
	LD   A,(DE)			; fetch pixel line from DE
	LD   (HL),A			; write pixels for letters
	INC  DE			; DE goes to next row of bitmap
	INC  H			; HL pixel row pointer goes to next row
	DJNZ DRAW_CHAR			; decrease B and repeat loop if B is not zero
	POP  HL
	POP  BC
	POP  AF
	RET 
PLAYER2_WINS:
	PUSH BC
	LD   BC,2			; write 2 (winning player) into BC
	LD   (WINNING_PLAYER),BC			; store winning player to memory
	POP  BC
	CALL DRAW_PLAYER2_WINS
	RET 
PLAYER1_WINS:
	PUSH BC
	LD   BC,1			; write 1 (winning player) into BC
	LD   (WINNING_PLAYER),BC			; store winning player to memory
	POP  BC
	CALL DRAW_PLAYER1_WINS
	RET 
END_GAME:			; end game label -- i have no idea why this isn't just a function call
	CALL RESET_VARS_PROCEDURE
	RET 
RESET_VARS_PROCEDURE:			; this function is likely supposed to be used for looping the game after it finishes
	LD   BC,$582C			; load player1 starting pos into BC
	LD   (PLAYER1_POS),BC			; change player1 pos to player1 starting pos
	LD   (PLAYER1_STARTING_POS),BC
	LD   BC,$5A0B			; load player2 starting post into BC
	LD   (PLAYER1_POS),BC			; change player2 post to player1 starting pos -- NOTE: this might be an error
	LD   (PLAYER2_STARTING_POS),BC
	LD   BC,$0000
	LD   (PLAYER1_MOVEDIR),BC			; set player1 movedir to 0 (down)
	LD   (WINNING_PLAYER),BC			; set winning player to 0
	LD   BC,$0001
	LD   (PLAYER2_MOVEDIR),BC			; set player2 movedir to 1 (up)
	RET 
DRAW_PLAYER1_WINS:
	PUSH BC
	LD   B,$14			; drawing in the 20th row
	LD   C,$01			; character counter
	LD   DE,CHAR_P			; loading address into DE [character 1]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_L			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_A			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_Y			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_E			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_R			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_1			; loading address into DE [number 1 character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_BLANK			; loading address into DE [blank character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_W			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_I			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_N			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_S			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	POP  BC
	RET 
DRAW_PLAYER2_WINS:			; draw player2 wins
	PUSH BC
	LD   B,$14
	LD   C,$01
	LD   DE,CHAR_P			; loading address into DE [character 1]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_L			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_A			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_Y			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_E			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_R			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_2			; loading address into DE [number 2 character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_BLANK			; loading address into DE [blank character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_W			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_I			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_N			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	INC  C
	LD   DE,CHAR_S			; loading address into DE [next character]
	CALL DRAW_CHAR_PROCEDURE
	POP  BC
	RET 
INPUT_LOOP_COUNTER:			; i am not really sure if this is the correct label name
	db $08
PLAYER1_POS:
	db $0B
	db $5A
PLAYER2_POS:
	db $0B
	db $58
PLAYER1_STARTING_POS:
	db $2C
	db $58
PLAYER2_STARTING_POS:
	db $0B
	db $5A
PLAYER1_MOVEDIR:
	db $00
	db $00
PLAYER2_MOVEDIR:
	db $01
	db $00
WINNING_PLAYER:
	db 0
BORDER_BITMAP_POINTER:			; i have no clue why this exists
	db $00
	db $84
	db $00 
	db $58 
BORDER_BITMAP:
	db %11111111,%11111111,%11111111,%11111111 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %10000000,%00000000,%00000000,%00000001 
	db %11111111,%11111111,%11111111,%11111111 
	db %00000000,%00000000,%00000000,%00000000 
	db %00000000,%00000000,%00000000,%00000000 
CHAR_P:
	db %00000000
	db %01111100
	db %00000010
	db %01000010
	db %01111100
	db %01000000
	db %01000000
	db %00000000
CHAR_L:
	db %00000000
	db %01000000
	db %01000000
	db %01000000
	db %01000000
	db %01000000
	db %01111111
	db %00000000
CHAR_A:
	db %00000000
	db %00111100
	db %01000010
	db %01000010
	db %01011010
	db %01000010
	db %01000010
	db %00000000
CHAR_Y:
	db %00000000
	db %10000010
	db %10000010
	db %01111100
	db %00000000
	db %00010000
	db %00010000
	db %00000000
CHAR_E:
	db %00000000
	db %01111110
	db %01000000
	db %01000000
	db %01011110
	db %01000000
	db %01111110
	db %00000000
CHAR_R:
	db %00000000
	db %01111100
	db %01000010
	db %01000010
	db %01011100
	db %01011000
	db %01001110
	db %00000000
CHAR_1:
	db %00000000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00010000
	db %00000000
CHAR_2:
	db %00000000
	db %01111100
	db %00000010
	db %00001110
	db %00111000
	db %01100000
	db %01111110
	db %00000000
CHAR_W:
	db %00000000
	db %01000001
	db %01000001
	db %01000001
	db %01101011
	db %00101010
	db %00111110
	db %00000000
CHAR_I:
	db %00000000
	db %01111100
	db %00000000
	db %00010000
	db %00010000
	db %00010000
	db %01111100
	db %00000000
CHAR_N:
	db %00000000
	db %01000010
	db %01010010
	db %01011010
	db %01001110
	db %01000110
	db %01000010
	db %00000000
CHAR_S:
	db %00000000
	db %00111110
	db %00000000
	db %01000000
	db %00111100
	db %00000010
	db %01111100
	db %00000000
CHAR_D:
	db %00000000
	db %01011000
	db %01000100
	db %01000010
	db %01000010
	db %01000100
	db %01111000
	db %00000000
CHAR_BLANK:
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db %00000000
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
