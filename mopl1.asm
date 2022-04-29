;***************************************************************************************************
; MOPL1.ASM - �祡�� �ਬ�� ��� �믮������ 
; ������୮� ࠡ��� N1 �� ��設��-�ਥ��஢������ �ணࠬ��஢����
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       �ᯮ������� ������樨 ����⠭� � ����ᮢ
        INCLUDE MOPL1.INC	
        INCLUDE MOPL1.MAC

; ������樨 ������
        .DATA    
SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"Fimiliya I.O.: ",0FFh
MINIS	DB	"MINISTERSTVO OBRAZOVANIYA ROSSIJSKOJ FEDERACII",0
TXT	DW  S1, S2, S3, 0
str1 DB	255 DUP(" "), 0
S1	DB  255 DUP(" "), 0
S2	DB  '��� "�����"', 0
S3	DB  '����騩 �ணࠬ����',0
;------------- ���� ��६���� ------------------------------------------------------------------
REQ2	DB	"vychislit' funkciyu (f), vyjti(ESC)?", 0
;-------------------------------------------------------------------------------------------------
X DB "An = ",0FFh
O_1 DB "1", 0FFh
O_0 DB "0", 0FFh

TACTS   DB	"�६� ࠡ��� � ⠪��: ",0
N DB "N = ",0FFh
F DB "F = ",0FFh
FSTR DB "F6 = !x1!x2x3|x1!x3|x2x3|x2x4|x1!x3!x4",0
ZSTR DB "Z = F6?X*2-Y: X/8+Y ;z7& = z4; z9 |= z11; z15 = _z17",0
ZS DB "Z = ",0FFh
XNUM  DD ?
Xn DB 0,0,0,0
Y DB "Y = ",0FFh
YNUM  DD ?
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; ����襥 � ���襥 ᫮�� ����প� �� �뢮�� ��ப�
TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; ��ப� �뢮�� �᫠ ⠪⮢
                                          ; ����� ��� ࠧ����⥫��� "`"

;========================= �ணࠬ�� =========================
        .CODE
; ����� ���������� ��ப� LINE �� ����樨 POS ᮤ�ন�� CNT ��ꥪ⮢,
; ����㥬�� ���ᮬ ADR �� �ਭ� ���� �뢮�� WFLD
BEGIN	LABEL	NEAR
	MOV  AX,  @DATA ; @DATA ���९���� �� ᥣ�����
	MOV  DS,  AX
	; s = txt; 
	call InputInt
	LEA  SI,  TXT  ; SI ? 㪠��⥫� ���ᨢ� ���ᮢ ��ப
	;  ���� �� ����⨫�� �㫥��� 㪠��⥫�, 
	;  �뢮���� ��ப� ⥪��
@@L:	; while(*s != NULL) {
	CMP  WORD PTR [SI],  0
	JE  @@R
	; puts(*s);
	MOV  DI,  [SI]
	CALL  PUTS
	; s++;}
	ADD  SI,  2
	JMP  SHORT  @@L
@@R:	; return(0);
	MOV  AH,  4Ch
	MOV  AL,  0
	INT  21h
; ����� �뢮�� ᨬ���� �� �࠭ 
PUTC	MACRO  CHAR
IFNB	<CHAR>
	MOV  DL,  CHAR
ENDIF
	MOV  AH,  2
	INT  21h
	ENDM
; ��楤�� �뢮�� ��ப�, ����㥬�� DI
PUTS	PROC  NEAR
	PUSH  DX
	; ���� ��ᨬ���쭮�� �뢮�� ��ப�
	; for(;(_DL = *_DI) != ?\0?; _DI++)
@@L:	MOV  DL,   [DI]
	CMP  DL,  0
	JE  @@E
	; putc(_DL);
	PUTC
	INC  DI
	JMP  SHORT @@L
@@E:	PUTC  13     ; ���室
	PUTC  10     ;  �� ����� ��ப�
@@R:	POP  DX
	RET
PUTS	ENDP 

InputInt proc
enterch:
        mov     cx, 50
        mov     bx, offset str1
ech:
        mov     ah, 01h
        int     21h 
        cmp al,13
        jle quit
        mov     byte ptr [bx],al
        inc     bx
        loop    ech
quit:
        mov cx, 255
 
m1:
        addr1 dw offset S1
        addr2 dw offset str1
        mov bx,addr2
        mov al,[bx]
        mov bx,addr1
        mov [bx],al

        inc addr1
        inc addr2

        loop m1
        ret
InputInt endp

@@E:	EXIT	
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN




;keyb ru
;mount c C:\asm
;c:
;keyrus /scan=88