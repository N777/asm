.MODEL SMALL ; ������ �����
	.STACK 200h  ; ������ �⥪�
	LOCALS ; ����襭�� �������� ��६����� (@@���)
	; ������� ������
	.DATA  ; ��砫� ᥣ���� ������
; char *txt[]= {"������ �.�.",  "��� \"�����\"",
;                        "����騩 �ணࠬ����", NULL};
TXT	DW  S1, S2, S3, 0
str1 DB	255 DUP(" "), 0
S1	DB  255 DUP(" "), 0
S2	DB  '��� "�����"', 0
S3	DB  '����騩 �ணࠬ����',0
	.CODE
BEGIN:	; ���樠������ ᥣ���⭮�� ॣ���� DS
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

END BEGIN