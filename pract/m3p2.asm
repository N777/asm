MODEL	small	
STACK	256	
.data
arr_labels dw m1, m2, m3, mk
len dw 4 ; длина массива меток!
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
mov si, 0
cmp al, N1
je m1 ; arr_labels[si]
inc si
cmp si, len
jg exit
cmp al, N2
je m2
inc si
cmp si, len
jg exit
cmp al, N3
je m3
inc si
cmp si, len
jg exit

cmp al, Nk
je mk
jmp exit

m1:

jmp exit
m2:

jmp exit
m3:

jmp exit

mk:

jmp exit


exit:
mov ax, 4C00h
int 21h
end start