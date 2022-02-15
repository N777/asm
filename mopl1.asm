;***************************************************************************************************
; MOPL1.ASM - учебный пример для выполнения 
; лабораторной работы N1 по машинно-ориентированному программированию
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       Используются декларации констант и макросов
        INCLUDE MOPL1.INC	
        INCLUDE MOPL1.MAC

; Декларации данных
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
;------------- Новые переменные ------------------------------------------------------------------
REQ2	DB	"vychislit' funkciyu (f), vyjti(ESC)?", 0
;-------------------------------------------------------------------------------------------------
X DB "Xn = ",0FFh
O_1 DB "1", 0FFh
O_0 DB "0", 0FFh
TACTS   DB	"Время работы в тактах: ",0
N DB "N = ",0FFh
XNUM  DD ?
Xn DB 0,0,0,0
Y DB "Y = ",0FFh
YNUM  DW ?
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; младшее и старшее слова задержки при выводе строки
TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; строка вывода числа тактов
                                          ; запас для разделительных "`"

;========================= Программа =========================
        .CODE
; Макрос заполнения строки LINE от позиции POS содержимым CNT объектов,
; адресуемых адресом ADR при ширине поля вывода WFLD
BEGIN	LABEL	NEAR
	; инициализация сегментного регистра
	MOV	AX,	@DATA
	MOV	DS,	AX
	; инициализация задержки
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H
	PUTLS	REQ	; запрос имени
	; ввод имени
	LEA	DX,	BUF
	CALL	GETS	
@@L:	; циклический процесс повторения вывода заставки
	; вывод заставки
	; ИЗМЕРЕНИЕ ВРЕМЕНИ НАЧАТЬ ЗДЕСЬ
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; разделительная черта
	PUTL	EMPTYS
	PUTLSC	MINIS	; первая 
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  и  
	PUTL	EMPTYS
	PUTLSC	DEPT	;   последующие 
	PUTL	EMPTYS
	PUTLSC	MOP	;    строки  
	PUTL	EMPTYS
	PUTLSC	LABR	;     заставки
	PUTL	EMPTYS
	; приветствие
	PUTLSC	SNAME   ; ФИО студента
	PUTL	EMPTYS
	; разделительная черта
	PUTL	SLINE
	; ИЗМЕРЕНИЕ ВРЕМЕНИ ЗАКОНЧИТЬ ЗДЕСЬ 
	DURAT    	; подсчет затраченного времени
	; Преобразование числа тиков в строку и вывод
	LEA	DI,	TI
	CALL	UTOA10	
	PUTL	TACTS
	PUTL	TI      ; вывод числа тактов
	; обработка команды
	PUTL	REQ1
;------Вывод своих строк с действиями -------------------
	PUTL	REQ2
;--------------------------------------------------------
	CALL	GETCH
	CMP	AL,	'-'    ; удлиннять задержку?
	JNE	CMINUS
	INC	PAUSE+2        ; добавить 65536 мкс
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; укорачивать задержку?
	JNE	CEXIT
	CMP	WORD PTR PAUSE+2, 0		
	JE	BACK
	DEC	PAUSE+2        ; убавить 65536 мкс
BACK:	JMP	@@L
CEXIT:	CMP	AL,	'f'
	JNE	CFUNC
	xor ebx, ebx
	call func
	mov XNUM, ebx
	mov cx, 4h
	jmp xn_input
	
CFUNC: CMP	AL,	CHESC
	JE	@@E
	TEST	AL,	AL
	JNE	BACK
	CALL	GETCH
	JMP	@@L
	; Выход из программы

xn_input:
	xor cx, cx
	mov cx, 4h 
	and ebx, 11110b
l1:
	shl bl, 1
	jc xn_1
	loopw l1
	jmp calc
xn_1:
	mov cx, si
	mov Xn[si], 1b
	loopw l1
	jmp calc
	
calc:
	jmp @@e


input proc ; ввод ebx по битово
func:
	call OutBin
	PUTL N
	CALL GETCH
	SUB AL, 30h ;введение позиции бита
	mov cl, AL  ;кол-во сдвигов
	ror ebx, cl ;сдвиг под  нужный бит
	pusha ;сохраняю cl
	PUTL NEWLINE
	PUTL X
	popa
	CALL GETCH
	SUB AL, 30h ;запись значения
	add bl, AL	;прибавление значения
	mov al, 20h ;длина ebx
	sub al, cl  ;получем значение для возвращения числа на исходную позицию
	mov cl, al	;перемещаем значение в cl
	ror ebx, cl ;сдвигаем в начальное состояние
	PUTL NEWLINE
	JMP CHOICE
CHOICE:
	call OutBin
	PUTL Choc
	CALL GETCH
	CMP	al, 'y'
	JNE func
	ret
input endp

	
OutBin proc ; процедура вывода ebx по битово
	xor cx, cx
	mov cx, 20h
Print_ebx:
	rol ebx, 1
	jc Print_ebx_1
	mov ah,02h
	mov dl,'0'
	int 21h
	loopw Print_ebx
	PUTL NEWLINE
	ret

Print_ebx_1:
	mov ah,02h
	mov dl,'1'
	int 21h
	loopw Print_ebx
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