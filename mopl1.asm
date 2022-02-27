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
IN_X DB "������ X: (��� N �� ������ ���, � An ��� ���祭��)", 0
IN_Y DB "������ Y: (��� N �� ������ ���, � An ��� ���祭��)", 0
ULSTU	DB	"UL'YANOVSKIJ GOSUDARSTVENNYJ TEKHNICHESKIJ UNIVERSITET",0
DEPT	DB	"Kafedra vychislitel'noj tekhniki",0
MOP	DB	"Mashinno-orientirovannoe programmirovanie",0
LABR	DB	"Laboratornaya rabota N 1",0
Choc	DB	"Done?", 0
REQ1    DB      "Zamedlit' vremya raboty v taktah(-), uskorit' vremya raboty v taktah (+),", 0
NEWLINE DB " ", 0
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
	PUTL IN_Y
	call input
	mov YNUM, ebx
	PUTL IN_X
	call input
	mov XNUM, ebx
	jmp xn_input
	
CFUNC: CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
	JNE	BACK
	CALL	GETCH
	JMP	@@L
	; ��室 �� �ணࠬ��

xn_input:
	mov ebx, XNUM
	xor cx, cx
	mov si, 0 
	and ebx, 11110b
	shr bl, 1 ;�㦭� ���� ��⠢�塞 ��⠫�� ����塞
l1:
	shr bl, 1; ����⮢� ����ᨬ � cf x 
	jc xn_1; �᫨ ࠢ�� 1, � ��룠��
	mov Xn[si], 0b
	jmp l2
xn_1:
	mov Xn[si], 1b
l2:
	inc si
	cmp si, 4
	jl l1
	jmp calc
	
calc:
	pushad
	PUTL FSTR
	popad
	xor dl, dl
	xor ebx, ebx


	PUTL X
	mov ah,02h
	mov dl, Xn[0]
	add dl, 30h
	int 21h
	PUTL NEWLINE
	PUTL X
	mov ah,02h
	mov dl, Xn[1]
	add dl, 30h
	int 21h
	PUTL NEWLINE
	PUTL X
	mov ah,02h
	mov dl, Xn[2]
	add dl, 30h
	int 21h
	PUTL NEWLINE
	PUTL X
	mov ah,02h
	mov dl, Xn[3]
	add dl, 30h
	int 21h
	PUTL NEWLINE
	


	mov bh, Xn[0] ;x_1 x_2 x3
	not bh
	and bh, 00000001b
	mov bl, Xn[1]
	not bl
	and bl, 00000001b
	and bh, bl
	mov bl, Xn[2]
	and bh, bl
	mov dl, bh
	mov bh, Xn[0] ;x1 x3
	mov bl, Xn[2]
	and bh, bl
	or dl, bh ; x_1 x_2 x3 | x1 x3 
	mov bh, Xn[1]
	mov bl, Xn[2]
	not bl
	and bl, 00000001b
	and bh, bl
	or dl, bh ;  | x2 x_3
	mov bh, Xn[1] ;x2 x4 
	mov bl, Xn[3]
	and bh, bl
	or dl, bh ;| x2 x4
	mov bh, Xn[0];  x1 x_3 x_4
	mov bl, Xn[2]
	not bl
	and bl, 00000001b
	and bh, bl
	mov bl, Xn[3]
	not bl
	and bl, 00000001b
	and bh, bl
	or dl, bh ; |x1 x_3 x_4
	;����稫� f � dl
	pushad
	PUTL F
	popad
	pushad
	mov ah,02h
	add dl, 30h
	int 21h
	PUTL NEWLINE
	popad
	cmp dl, 1 ; ��稭��� ����� z
	je f_1
	mov eax, XNUM
	mov ebx, 8h
	div ebx
	mov ebx, YNUM
	add ebx, eax
	jmp z

f_1:
	mov ebx, XNUM
	imul eax,ebx, 2h ; १���� 㬭������ ����� � eax
	mov ebx, YNUM
	sub eax, ebx
	mov ebx, eax
	jmp z
	
z:
	PUTL ZSTR
	PUTL ZS
	call OutBin
	;z7& = z4
	mov ch, 20h
	mov cl, 4
	ror ebx, cl ; 4, �⮡� �������� ��� � cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 6
	ror ebx, cl ; 7, �⮡� ������� � �㦭��� ����
	shr ebx, 1 ; �������� ��� � cf � ���㫨��
	call byte_from_cf
	rol ebx, 1
	and dl, dh
	mov al, dl ; ��७��� १���� � al �⮡� ������ �� dword
	CBW 
	cwde
	add ebx, eax
	sub ch, cl
	mov cl, ch
	ror ebx, cl
	;z9 |= z11
	mov ch, 20h
	mov cl, 11
	ror ebx, cl ; 11, �⮡� �������� ��� � cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 8
	ror ebx, cl ; 9, �⮡� ������� � �㦭��� ����
	shr ebx, 1 ; �������� ��� � cf � ���㫨��
	call byte_from_cf
	rol ebx, 1
	or dl, dh
	mov al, dl ; ��७��� १���� � al �⮡� ������ �� dword
	CBW 
	cwde
	add ebx, eax
	sub ch, cl
	mov cl, ch
	ror ebx, cl
	; z15 = _z17
	mov ch, 20h
	mov cl, 17
	ror ebx, cl ; 17+1, �⮡� �������� ��� � cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 15
	ror ebx, cl ; 15, �⮡� ������� � �㦭��� ����
	shr ebx, 1 ; �������� ��� � cf � ���㫨��
	call byte_from_cf
	rol ebx, 1
	not dh
	and dh, 00000001b
	mov al, dh ; ��७��� १���� � al �⮡� ������ �� dword
	CBW 
	cwde
	add ebx, eax
	sub ch, cl
	mov cl, ch
	ror ebx, cl
	
	PUTL ZS
	call OutBin
	jmp @@e


InputInt proc 
;��������� �᫮ �㤥� ��室����� � ax
	push ebx
	push ecx
    mov ah,01h
    int 21h ; � al - ���� ᨬ���
    sub al,30h  ; ⥯��� ��ࢠ� ���
    mov ah,0  ; ���७�� �� ᫮��
    mov bx,10
    mov cx,ax ; � cx - ��ࢠ� ���
Lp:  mov ah,01h
    int 21h ;   � al ᫥���騩 ᨬ���
    cmp al,0dh  ; �ࠢ����� � ᨬ����� Enter
    je Ed         ; ����� �����
    sub al,30h   ; � al - ᫥����� ���
    cbw             ; ���७�� �� ᫮��
    xchg ax,cx   ; ⥯��� � ax - �।��饥 �᫮, � cx - ᫥�����
    mul bx          ; ax*10
    add cx,ax      ; cx=ax*10+cx
    jmp Lp     ; �த������� �����
Ed :
	mov ax, cx
    pop ecx
	pop ebx
	ret
InputInt endp


byte_from_cf proc ; ������ ��� �� cf � dl
	jc byte_1
	mov dl, 0b
	ret
byte_1:
	mov dl, 1b
	ret
byte_from_cf endp



input proc ; ���� ebx �� ��⮢�
	xor ebx, ebx
func:
	call OutBin
	PUTL N
	CALL InputInt
	mov cl, al  ;���-�� ᤢ����
	ror ebx, cl ;ᤢ�� ���  �㦭� ���
	pusha ;��࠭�� cl
	PUTL NEWLINE
	;PUTL X
	popa
	;CALL GETCH
	;SUB AL, 30h ;������ ���祭��
	add bl, 1	;�ਡ������� ���祭��
	mov al, 20h ;����� ebx
	sub al, cl  ;����祬 ���祭�� ��� �����饭�� �᫠ �� ��室��� ������
	mov cl, al	;��६�頥� ���祭�� � cl
	ror ebx, cl ;ᤢ����� � ��砫쭮� ���ﭨ�
	;PUTL NEWLINE
	JMP CHOICE
CHOICE:
	call OutBin
	PUTL Choc
	CALL GETCH
	CMP	al, 'y'
	JNE func
	ret
input endp

	
OutBin proc ; ��楤�� �뢮�� ebx �� ��⮢�
	xor cx, cx
	rol ebx, 12
	mov cx, 20
Print_ebx:
	rol ebx, 1
	jc Print_ebx_1
	mov ah,02h
	mov dl,'0'
	int 21h
	loopw Print_ebx
	jmp P_END
Print_ebx_1:
	mov ah,02h
	mov dl,'1'
	int 21h
	loopw Print_ebx
	jmp P_END
P_END:
	PUTL NEWLINE
	ret
OutBin endp

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