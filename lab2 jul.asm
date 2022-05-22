.MODEL SMALL
	.STACK 200h 
	.386
	LOCALS
	.DATA  

S1	DB  255, 255 DUP(0), 0
S2	DB  255, 255 DUP(0), 0
s_eq DB "Равны$", 0
s_neq DB "Нарушение равенства в слове $"
counter db 1



	.CODE
BEGIN:	
	MOV  AX,  @DATA 
	MOV  DS,  AX
	MOV  ES,  AX
	; s = txt;

	; puts(*s);
	lea  DI,  S1
	call InputInt

	lea  DI,  S2
	call InputInt


	mov cx, 255
	lea DI, S1
	lea SI, S2
	REPE cmpsb
	JE  equal 
	mov cx, di
	lea DI, S1
find_wrong:
	
	MOV  DL,   [DI]

	cmp dl, ' '
	jne next_s
	inc counter
next_s:
	INC  DI
	loop find_wrong
	MOV	AH,	09h             ;Номер функции 09h
  	MOV	DX,	offset s_neq   ;Адрес строки записываем в DX
  	INT	21h
	mov  dl, counter
	add  DL, 30h
	MOV  AH,  2
	INT  21h


	jmp EXIT
equal:
	MOV	AH,	09h             ;Номер функции 09h
  	MOV	DX,	offset s_eq   ;Адрес строки записываем в DX
  	INT	21h
	jmp EXIT


EXIT:
	MOV  AH,  4Ch
	MOV  AL,  0
	INT  21h


PUTC	MACRO  CHAR
IFNB	<CHAR>
	MOV  DL,  CHAR
ENDIF
	MOV  AH,  2
	INT  21h
	ENDM

PUTS	PROC  NEAR
	PUSH  DX

	; for(;(_DL = *_DI) != ?\0?; _DI++)
@@L:	MOV  DL,   [DI]
	CMP  DL,  0
	JE  @@E
	; putc(_DL);
	PUTC
	INC  DI
	JMP  SHORT @@L
@@E:	PUTC  13     
	PUTC  10    
@@R:	POP  DX
	RET
PUTS	ENDP 

InputInt proc near
enterch:
        mov     cx, 254
        mov     bx, offset DI
ech:
        mov     ah, 01h
        int     21h 
        cmp 	al,13
        jle 	@@quit
		cmp		al, " "
		jne		not_del_dup
		cmp		al, byte ptr [bx-1]
		je		next
not_del_dup:
        mov     byte ptr [bx],al
        inc     bx
next:
        loop    ech
@@quit:
		mov     byte ptr [bx],0
        ret
InputInt endp

END BEGIN
