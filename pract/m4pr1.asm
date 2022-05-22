MODEL	small	
STACK	256	
.data
	a dw 0
	b dw 0
.code
start:
		mov ax, @data
		mov ds, ax
		mov cx, 100	
	cycl_1:
		mov a, cx
		mov cx, 50	
	cycl_2:
		mov b, cx
		mov cx, 25	
	cycl_3:
		loop cycl_3
		mov cx, b	
		loop cycl_2
		mov cx, a
		loop cycl_1

	mov ax, 4c00h
	int 21h
end start
END	Start