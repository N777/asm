data segment para public 'data'
    countItems  equ 9           ;количество эл-в в массиве
    temp    dw  0               ;для сортировки сделал..и не использую
    array db 9 dup(?)           ;массив(9 эл-в)
    enter_mas   db  'vvedi massiv:$'
    output_mas  db  'massiv:$'
data ends
 
stacks segment stack 
    db  32  dup (?)
stacks ends
 
code segment para public 'code'
    main    proc
        assume cs:code, ds:data, ss:stacks
        
        mov ax,data     
        mov ds,ax       
        
        ;для вывода
        mov ah,9
        mov dx,offset enter_mas
        int 21h
        
        ;enter
        mov ah,2h
        mov dl,0dh
        int 21h
        mov ah,2h
        mov dl,0ah
        int 21h
        ;endenter
                
        xor ax,ax   ;чистим ax
        
        mov cx,10
        mov si,0
        
        jmp enter_text
        
    enter_text:
        mov ah,1h
        int 21h
        
        sub al,30h
        mov array[si],al
        inc si
        
        cmp si,countItems
        jle enter_text
 
        ;doubleEnter
        mov ah,2h
        mov dl,0dh
        int 21h
        mov ah,2h
        mov dl,0ah
        int 21h
        mov ah,2h
        mov dl,0ah
        int 21h
        ;endenter
        
        mov cx,10
        mov si,0
        mov ah,09h
        lea dx,output_mas
        int 21h
 
        ;enter
        mov ah,2h
        mov dl,0dh
        int 21h
        mov ah,2h
        mov dl,0ah
        int 21h
        ;endenter
        
        mov si,0
        mov cx,10
    
    output_array:
        mov ah,02h
        mov dl,array[si]
        add dl,30h
        int 21h
        inc si
        loop output_array
    
        mov cx,10
    
    sort_array_ext:
        mov si,0
        sort_array_int:
            mov dl,array[si]
            cmp dl,array[si+1]
            ja rotate_items
            inc si
            cmp si,countItems
            jle sort_array_int
            jmp _else
            
        rotate_items:
            mov ah,array[si]
            mov bh,array[si+1]
            mov array[si],bh
            mov array[si+2],ah
        ;jmp sort_array
            inc si
            jmp _else
        _else:
        inc temp
    cmp temp,countItems
    jle sort_array_ext
        
    end_program:
            
        mov si,0
        mov cx,10
    
    output_array2:
        mov ah,02h
        mov dl,array[si]
        add dl,30h
        int 21h
        inc si
        loop output_array2
    
        ;завершение программы
        mov ax,4c00h
        int 21h
    main endp
code ends
end main