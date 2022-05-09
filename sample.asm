.MODEL SMALL ; ?????? ?????
	.STACK 200h  ; ?????? ???
	.386
	LOCALS ; ??????? ???????? ???????? (@@???)
	; ???????? ??????
	.DATA  ; ???? ????? ??????
; char *txt[]= {"?????? ?.?.",  "??? \"?????\"",
;                        "????? ???????", NULL};
TXT	DW  S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, 0
S1	DB  255, 255 DUP(0), 0
S2	DB  255, 255 DUP(0), 0
S3	DB  255, 255 DUP(0), 0
S4	DB  255, 255 DUP(" "), 0
S5	DB  255, 255 DUP(" "), 0
S6	DB  255, 255 DUP(" "), 0
S7	DB  255, 255 DUP(" "), 0
S8	DB  255, 255 DUP(" "), 0
S9	DB  255, 255 DUP(" "), 0
S10	DB  255, 255 DUP(" "), 0
S11	DB  255, 255 DUP(" "), 0
S12	DB  255, 255 DUP(" "), 0
S13	DB  255, 255 DUP(" "), 0
S14	DB  255, 255 DUP(" "), 0
S15	DB  255, 255 DUP(" "), 0
S16	DB  255, 255 DUP(" "), 0
S17	DB  255, 255 DUP(" "), 0
S18	DB  255, 255 DUP(" "), 0
S19	DB  255, 255 DUP(" "), 0
S20	DB  255, 255 DUP(" "), 0
S21	DB  255, 255 DUP(" "), 0
temp	DB  255, 255 DUP(" "), 0
i dw 0
j dw 0
len db 0


	.CODE
BEGIN:	; ?????????? ??????? ????? DS
	MOV  AX,  @DATA ; @DATA ???????? ?? ??????
	MOV  DS,  AX
	MOV  ES,  AX
	; s = txt; 
	LEA  SI,  TXT  ; SI ? ????? ????? ???? ???
	;  ???? ?? ??????? ????? ?????, 
	;  ?????? ???? ???
@@L:	; while(*s != NULL) {
	CMP  WORD PTR [SI],  0
	JE  begin_cycle
	; puts(*s);
	MOV  DI,  [SI]
	call InputInt
	;CALL  PUTS
	; s++;}
	ADD  SI,  2
	JMP  SHORT  @@L


begin_cycle:
	MOV  DL,  13
	MOV  AH,  2
	INT  21h
	mov cx, 255
	mov bx, word ptr [len]
R:	
	mov j, 0
	xor si, si
	LEA  SI,  TXT ; ???? ??
	CMP bx, i
	;CMP  WORD PTR [SI + i],  0
	JE  EXIT

IN_R:
	mov ah, byte ptr i
	cmp ah, byte ptr j
	je IN_END
	xor ax, ax
	xor di, di
	LEA  DI,  TXT ; ??? ??
	cmp bx, j
	JE  PRINT
	;CMP  WORD PTR [DI + j],  0
	
 	
	add di, i
	mov SI, [DI]
	sub DI, i
	add DI, j
	mov  DI, [DI]
	REPE cmpsb 
	JNZ IN_END

check_num:
	;MOV  AX,  @DATA
	;MOV  DS,  AX
	xor ax, ax
	mov al, byte ptr i
	cmp al, byte ptr j
	jg IN_EXIT
IN_END:
	ADD  j,  2
	JMP  SHORT  IN_R

PRINT:
	LEA  SI,  TXT
	ADD  SI, i 
	MOV  DI,  [SI]
	call PRINT_NUM
	CALL  PUTS

IN_EXIT:
	ADD  i,  2
	JMP  SHORT  R



EXIT:
	MOV  AH,  4Ch;gg
	MOV  AL,  0
	INT  21h



PRINT_NUM PROC near

	MOV  DL, byte ptr i 
	add  DL, 30h
	MOV  AH,  2
	INT  21h

PRINT_NUM endp


; ????? ???? ????? ?? ??? 
PUTC	MACRO  CHAR
IFNB	<CHAR>
	MOV  DL,  CHAR
ENDIF
	MOV  AH,  2
	INT  21h
	ENDM
; ????? ???? ????, ??????? DI
PUTS	PROC  NEAR
	PUSH  DX
	; ???? ????????? ???? ????
	; for(;(_DL = *_DI) != ?\0?; _DI++)
@@L:	MOV  DL,   [DI]
	CMP  DL,  0
	JE  @@E
	; putc(_DL);
	PUTC
	INC  DI
	JMP  SHORT @@L
@@E:	PUTC  13     ; ????
	PUTC  10     ;  ?? ????? ????
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
		cmp		al, "!"
		je		begin_cycle
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
		inc len
		inc len
		mov     byte ptr [bx],0
        ret
InputInt endp

END BEGIN