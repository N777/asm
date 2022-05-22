.MODEL SMALL 
.STACK 200h  
.386
.DATA
message	db	'Введите шестандцатиричное число: $'
ineer  	db	'Ошибка ввода числа$'
	.CODE
BEGIN1:			
	mov	ax, @DATA				
	mov	ds, ax	
M4:		
	mov	ah, 9
	mov	dx, offset message
	int	21h
	xor dx, dx
	xor	ax, ax
	mov di, 4		
	mov	ah, 1	
M0:		
	int	21h
	cmp al, 10
	je M2	
	cmp al, '0'
	jl M3
	cmp al, '9'
	jg M5
	sub	al, 30h	
	jmp  M1	
M5:
	cmp al, 'A'
	jl M3	
	cmp al,'F'
	jg M6		
	sub	al, 37h		
	jmp M1
M6:	
	cmp al, 'a'
	jl M3	
	cmp al,'f'
	jg M3		
	sub	al, 57h		
	jmp M1	
M1:							
	shl	dx, 4
	add dl, al
	dec di
	jnz M0		; переход по флагу z = 0	
	
M3:
	mov	ah, 9
	mov	dx, offset ineer
	int	21h
	jmp M4
		
M2:							
	mov	ax, 4c00h		
	int	21h	

						
			
END BEGIN1			

