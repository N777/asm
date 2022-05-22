MODEL	small	
STACK	256	
.data
var db 0
N1 db 1
N2 db 2
N3 db 3
Nk db 4

.code
start:
mov ax, @data
mov ds, ax
xor ax, ax
mov ah, 1h
int 21h
sub al, 30h
mov var, al
cmp al, N1
je act1
cmp al, N2
je act2
cmp al, N3
je act3
cmp al, Nk
je actk
jmp exit
act1:
jmp exit
act2:
jmp exit
act3:
jmp exit
actk:

jmp exit

exit:
mov ax, 4C00h
int 21h
end start