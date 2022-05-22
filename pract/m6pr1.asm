MODEL	small	
STACK	256	
.data	
N=5	
mas	db	5 dup (3 dup (0))
; 1 0 0 2 0 0 3 0 0 4 0 0 5 0 0 
.code		
main:	
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax	
	mov	si,0	
	mov	cx,N
	mov	dl,0	
go:	
	inc	dl
        mov	mas[si],dl	       
			       
	add	si,3	
			
	loop	go

	
	mov	di,0
ex_loop:
	mov	si,2
	
in_loop:
	mov	dl, mas[di][si]
	add dl, byte ptr [si]
	cmp	si,0
	je	end_in
	dec	si
	jmp	in_loop
end_in:	cmp	di,12
	je	show_bn
	add	di,3
	jmp	ex_loop
	
show_bn:mov	cx,15
	mov	ah,02h
show:	
	pop	dx
	add	dl,30h
	int	21h
	mov	dl, ' '
	int	21h
	loop	show
exit:
	mov	ax,4c00h	
	int	21h
end	main