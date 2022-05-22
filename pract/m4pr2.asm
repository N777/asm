MODEL	small	
STACK	256	
.data
	a db 0
	b db 0
.code
start:
	mov ax, @data
	mov ds, ax
	MOV	AH, 02h
	MOV	DI, 10
while:
	CMP	DI, 0
	JE	after
	MOV	DL, "*"
	INT	21h
	DEC	DI
	JMP	while
after:
	mov ax, 4c00h
	int 21h
end start