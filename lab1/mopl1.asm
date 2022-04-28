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
IN_X DB "Введите X: (где N это позиция бита, а An его значение)", 0
IN_Y DB "Введите Y: (где N это позиция бита, а An его значение)", 0
ULSTU	DB	"UL'YANOVSKIJ GOSUDARSTVENNYJ TEKHNICHESKIJ UNIVERSITET",0
DEPT	DB	"Kafedra vychislitel'noj tekhniki",0
MOP	DB	"Mashinno-orientirovannoe programmirovanie",0
LABR	DB	"Laboratornaya rabota N 1",0
Choc	DB	"Done?", 0
REQ1    DB      "Zamedlit' vremya raboty v taktah(-), uskorit' vremya raboty v taktah (+),", 0
NEWLINE DB " ", 0
;------------- Новые переменные ------------------------------------------------------------------
REQ2	DB	"vychislit' funkciyu (f), vyjti(ESC)?", 0
;-------------------------------------------------------------------------------------------------
X DB "An = ",0FFh
O_1 DB "1", 0FFh
O_0 DB "0", 0FFh

TACTS   DB	"Время работы в тактах: ",0
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
	; Выход из программы

xn_input:
	mov ebx, XNUM
	xor cx, cx
	mov si, 0 
	and ebx, 11110b
	shr bl, 1 ;нужные биты оставляем остальные зануляем
l1:
	shr bl, 1; побитово заносим в cf x 
	jc xn_1; если равен 1, то прыгаем
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
	;получили f в dl
	pushad
	PUTL F
	popad
	pushad
	mov ah,02h
	add dl, 30h
	int 21h
	PUTL NEWLINE
	popad
	cmp dl, 1 ; начинаем считать z
	je f_1
	mov eax, XNUM
	mov ebx, 8h
	div ebx
	mov ebx, YNUM
	add ebx, eax
	jmp z

f_1:
	mov ebx, XNUM
	imul eax,ebx, 2h ; результат умножения лежит в eax
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
	ror ebx, cl ; 4, чтобы закинуть бит в cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 6
	ror ebx, cl ; 7, чтобы подвести к нужному биту
	shr ebx, 1 ; закинуть его в cf и занулить
	call byte_from_cf
	rol ebx, 1
	and dl, dh
	mov al, dl ; переношу результат в al чтобы расширить до dword
	CBW 
	cwde
	add ebx, eax
	sub ch, cl
	mov cl, ch
	ror ebx, cl
	;z9 |= z11
	mov ch, 20h
	mov cl, 11
	ror ebx, cl ; 11, чтобы закинуть бит в cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 8
	ror ebx, cl ; 9, чтобы подвести к нужному биту
	shr ebx, 1 ; закинуть его в cf и занулить
	call byte_from_cf
	rol ebx, 1
	or dl, dh
	mov al, dl ; переношу результат в al чтобы расширить до dword
	CBW 
	cwde
	add ebx, eax
	sub ch, cl
	mov cl, ch
	ror ebx, cl
	; z15 = _z17
	mov ch, 20h
	mov cl, 17
	ror ebx, cl ; 17+1, чтобы закинуть бит в cf
	call byte_from_cf
	mov dh, dl
	sub ch, cl
	mov cl, ch
	ror ebx, cl

	mov ch, 20h
	mov cl, 15
	ror ebx, cl ; 15, чтобы подвести к нужному биту
	shr ebx, 1 ; закинуть его в cf и занулить
	call byte_from_cf
	rol ebx, 1
	not dh
	and dh, 00000001b
	mov al, dh ; переношу результат в al чтобы расширить до dword
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
;Введенное число будет находиться в ax
	push ebx
	push ecx
    mov ah,01h
    int 21h ; в al - первый символ
    sub al,30h  ; теперь первая цифра
    mov ah,0  ; расширение до слова
    mov bx,10
    mov cx,ax ; в cx - первая цифра
Lp:  mov ah,01h
    int 21h ;   в al следующий символ
    cmp al,0dh  ; сравнение с символом Enter
    je Ed         ; конец ввода
    sub al,30h   ; в al - следующая цифра
    cbw             ; расширение до слова
    xchg ax,cx   ; теперь в ax - предыдущее число, в cx - следующая
    mul bx          ; ax*10
    add cx,ax      ; cx=ax*10+cx
    jmp Lp     ; продолжение ввода
Ed :
	mov ax, cx
    pop ecx
	pop ebx
	ret
InputInt endp


byte_from_cf proc ; заносит бит из cf в dl
	jc byte_1
	mov dl, 0b
	ret
byte_1:
	mov dl, 1b
	ret
byte_from_cf endp



input proc ; ввод ebx по битово
	xor ebx, ebx
func:
	call OutBin
	PUTL N
	CALL InputInt
	mov cl, al  ;кол-во сдвигов
	ror ebx, cl ;сдвиг под  нужный бит
	pusha ;сохраняю cl
	PUTL NEWLINE
	;PUTL X
	popa
	;CALL GETCH
	;SUB AL, 30h ;запись значения
	add bl, 1	;прибавление значения
	mov al, 20h ;длина ebx
	sub al, cl  ;получем значение для возвращения числа на исходную позицию
	mov cl, al	;перемещаем значение в cl
	ror ebx, cl ;сдвигаем в начальное состояние
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

	
OutBin proc ; процедура вывода ebx по битово
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