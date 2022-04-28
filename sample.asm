.MODEL SMALL ; Модель памяти
	.STACK 200h  ; Размер стека
	LOCALS ; Разрешение локальных переменных (@@имя)
	; Объявление данных
	.DATA  ; Начало сегмента данных
; char *txt[]= {"Иванов И.И.",  "ОАО \"ПАРУС\"",
;                        "Ведущий программист", NULL};
TXT	DW  S1, S2, S3, 0
S1	DB  'Иванов И.И.', 0
S2	DB  'ОАО "ПАРУС"', 0
S3	DB  'Ведущий программист',0
	.CODE
BEGIN:	; инициализация сегментного регистра DS
	MOV  AX,  @DATA ; @DATA закреплено за сегментным
	MOV  DS,  AX
	; s = txt; 
	mov dx, offset S1  ;запись строки в переменную name1
	mov ah,0ah
	int 21h
	LEA  SI,  TXT  ; SI ? указатель массива адресов строк
	;  ПОКА не встретился нулевой указатель, 
	;  выводить строки текста
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
; Макрос вывода символа на экран 
PUTC	MACRO  CHAR
IFNB	<CHAR>
	MOV  DL,  CHAR
ENDIF
	MOV  AH,  2
	INT  21h
	ENDM
; Процедура вывода строки, адресуемой DI
PUTS	PROC  NEAR
	PUSH  DX
	; Цикл посимвольного вывода строки
	; for(;(_DL = *_DI) != ?\0?; _DI++)
@@L:	MOV  DL,   [DI]
	CMP  DL,  0
	JE  @@E
	; putc(_DL);
	PUTC
	INC  DI
	JMP  SHORT @@L
@@E:	PUTC  13     ; Переход
	PUTC  10     ;  на новую строку
@@R:	POP  DX
	RET
PUTS	ENDP 
END	BEGIN
 
