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
ULSTU	DB	"UL'YANOVSKIJ GOSUDARSTVENNYJ TEKHNICHESKIJ UNIVERSITET",0
DEPT	DB	"Kafedra vychislitel'noj tekhniki",0
MOP	DB	"Mashinno-orientirovannoe programmirovanie",0
LABR	DB	"Laboratornaya rabota N 1",0
Choc	DB	"Calculate?", 0
REQ1    DB      "Zamedlit' vremya raboty v taktah(-), uskorit' vremya raboty v taktah (+),", 0
NEWLINE DB " ", 0
;------------- ���� ��६���� ------------------------------------------------------------------
REQ2	DB	"vychislit' funkciyu (f), vyjti(ESC)?", 0
;-------------------------------------------------------------------------------------------------
X DB "Xn = ",0FFh
TACTS   DB	"�६� ࠡ��� � ⠪��: ",0
N DB "N = ",0FFh
XNUM  DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Y DB "Y = ",0FFh
YNUM  DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
	; ���樠������ ᥣ���⭮�� ॣ����
	MOV	AX,	@DATA
	MOV	DS,	AX
	; ���樠������ ����প�
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H
	PUTLS	REQ	; ����� �����
	; ���� �����
	LEA	DX,	BUF
	CALL	GETS	
@@L:	; 横���᪨� ����� ����७�� �뢮�� ���⠢��
	; �뢮� ���⠢��
	; ��������� ������� ������ �����
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; ࠧ����⥫쭠� ���
	PUTL	EMPTYS
	PUTLSC	MINIS	; ��ࢠ� 
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  �  
	PUTL	EMPTYS
	PUTLSC	DEPT	;   ��᫥���騥 
	PUTL	EMPTYS
	PUTLSC	MOP	;    ��ப�  
	PUTL	EMPTYS
	PUTLSC	LABR	;     ���⠢��
	PUTL	EMPTYS
	; �ਢ���⢨�
	PUTLSC	SNAME   ; ��� ��㤥��
	PUTL	EMPTYS
	; ࠧ����⥫쭠� ���
	PUTL	SLINE
	; ��������� ������� ��������� ����� 
	DURAT    	; ������ ����祭���� �६���
	; �८�ࠧ������ �᫠ ⨪�� � ��ப� � �뢮�
	LEA	DI,	TI
	CALL	UTOA10	
	PUTL	TACTS
	PUTL	TI      ; �뢮� �᫠ ⠪⮢
	; ��ࠡ�⪠ �������
	PUTL	REQ1
;------�뢮� ᢮�� ��ப � ����⢨ﬨ -------------------
	PUTL	REQ2
;--------------------------------------------------------
	CALL	GETCH
	CMP	AL,	'-'    ; 㤫������ ����প�?
	JNE	CMINUS
	INC	PAUSE+2        ; �������� 65536 ���
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; 㪮�稢��� ����প�?
	JNE	CEXIT
	CMP	WORD PTR PAUSE+2, 0		
	JE	BACK
	DEC	PAUSE+2        ; 㡠���� 65536 ���
BACK:	JMP	@@L
CEXIT:	CMP	AL,	'f'
	JNE	CFUNC
	JMP func
CFUNC: CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
	JNE	BACK
	CALL	GETCH
	JMP	@@L
	; ��室 �� �ணࠬ��
func:
	PUTL N
	CALL GETCH
	SUB AL, 30h ;�������� ����樨 ���
	mov cl, AL  ;���-�� ᤢ����
	ror ebx, cl ;ᤢ�� ���  �㦭� ���
	PUTL NEWLINE
	PUTL X
	CALL GETCH
	PUTL NEWLINE
	SUB AL, 30h ;������ ���祭��
	add bl, AL	;�ਡ������� ���祭��
	mov al, 32h ;����� ebx
	sub al, cl  ;����祬 ���祭�� ��� �����饭�� �᫠ �� ��室��� ������
	mov cl, al	;��६�頥� ���祭�� � cl
	ror ebx, cl ;ᤢ����� � ��砫쭮� ���ﭨ�
	JMP CHOICE
CHOICE:
	mov ax, bx
	call OutBin
	PUTL Choc
	CALL GETCH
	CMP	al, 'y'
	JNE func

@@E:	EXIT	
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	EXTRN   OutBin: NEAR
	END	BEGIN


;keyb ru
;mount c C:\asm
;c:
;keyrus /scan=88