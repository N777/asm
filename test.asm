STACKSG SEGMENT PARA STACK
    DW 128 DUP(?)
STACKSG ENDS
;---------------------
DATASG SEGMENT PARA
    LAST_ARR = 254
    MAX_LEN = 128
    STRING DB MAX_LEN, MAX_LEN DUP('$')
    SYMBOLS DB 255 DUP(0)
DATASG ENDS
;---------------------
CODESG SEGMENT PARA
    ASSUME DS:DATASG, CS:CODESG, ES:CODESG, SS:STACKSG
START:
    .386
    LEN EQU STRING + 1;длина строки
    BGN_STR EQU STRING + 2;адрес 1 символа


    PUSH DS
    MOV AX, DATASG
    MOV DS, AX
    MOV ES, AX
    XOR AX, AX

    ;-----------------------
    ;ввод строки

    MOV AH, 10
    LEA DX, STRING
    INT 21h
    ;-----------------------
    XOR DX, DX

    MOV DL, 0AH
    MOV AH, 2 ;вывести на экран символ( перевод строки)
    INT 21h

    XOR DX, DX
    XOR AX, AX
    ;--------------------------

    MOV BX, 0
    LEA SI, BGN_STR
    MOV DI, SI
    MOV DX, SI; сохраним для внутренего

OUTER:
    ;PUSH SI
    MOV SI, DI; восстановим значение
    LODSB

    CMP AL, '$'
    JE FIND_MAX
    CMP AL, 0Dh
    JE FIND_MAX

    MOV SI, DX
    ;DEC SI

    MOV AH, AL
    XOR AL, AL
    INNER:
        LODSB

        CMP AL, '$'
        JE NEXT_ITER
        CMP AL, 0Dh
        JE NEXT_ITER


        CMP AH, AL
        JNE INNER
        INC CX ;сколько раз встретили
        JMP INNER

NEXT_ITER:
    INC DI  
    MOV BL, AH; код символа
    CMP SYMBOLS[BX], CL ; CL-сколько раз встретился символ
    JL WRITE 
    JNL GO
WRITE:  
    MOV byte ptr SYMBOLS[BX], CL ; в ячейку кода символа запищем встречаемость
    JMP GO

GO: 
    ;XOR BX, BX
    XOR CX, CX
    JMP OUTER

FIND_MAX:
    XOR BX, BX
    XOR AX, AX
    XOR CX, CX
    XOR SI, SI

    GET_MAX:
        CMP SI, LAST_ARR
        JA SHOW

        CMP SYMBOLS[SI], CL
        JG SAVE_SYMB
        INC SI
        JMP GET_MAX

SAVE_SYMB:
    MOV CL, SYMBOLS[SI]
    INC SI
    JMP GET_MAX



SHOW:
    XOR SI, SI
    SHOW_MAX:
        CMP SI, LAST_ARR
        JA EXIT 

        CMP SYMBOLS[SI], CL
        JE OUTPUT
        INC SI
        JMP SHOW_MAX
OUTPUT:
    MOV AH, 2
    MOV DX, SI
    INT 21h

    MOV DL, 20h
    INT 21h

    XOR DX, DX

    INC SI
    JMP SHOW_MAX
EXIT:
    MOV AX, 4C00h
    INT 21h

CODESG ENDS
END START