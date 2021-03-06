#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

	; add your code here
	jmp     st1 
	nop
	dw      0000
	dw      0000
	dw      0000
	dw      0000

	db     1012 dup(0)
		 
	
TABLE_D db 1h,2h,3h,4h,5h,6h,7h,8h,9h,0Fh,0h
TABLE_K db  0EDh, 0EBh,0E7h,0DDh,0DBh,0D7h,0BDh,0BBh,0B7h,7Dh,7Bh	 
		 
;main program
          
st1:
    cli 
	; intialize ds, es,ss to start of RAM
	mov       ax,0200h
	mov       ds,ax
	mov       es,ax
	mov       ss,ax
	mov       sp,0FFFEH

	;intialising 8255-1 port A, upper port C as input, port B, lower port C as output 
	mov     al,10011000b
	out	86h,al

	;intialising 8255-2 port A, upper port C as output, port B, lower port C as input
	mov     al,10000011b
	out	96h,al

	;intialising  8253 - counter 0 in mode 3 count 5; counter 1 in mode 3 count 500 
	mov al,00010111b
	out 0a6h,al
	mov al,01110111b
	out 0a6h,al
	mov al,05h
	out 0a0h,al 
	mov al,00h
	out 0a2h,al
	mov al,05h
	out 0a2h,al


	;checking for record switch
chk1:
	in al, 94h
    and al,08h
   	jz chk1
y10:
	;making record led high
	mov al,01000000b
	out 94h,al

	mov di,00h
	mov cx,6000d
	;checking EOC
eoc:
	in al,94h
	and al,01h
	jz eoc 

	;making oe high
	mov al,01010000b
	out 94h,al

	;transfering data
	in al, 80h
	mov [di],al
	inc di

	;making oe low
	mov al,01000000b
	out 94h,al
trns1:
	in al,94h
	and al,01h
	cmp al,01h
	je trns1
	loop eoc

	;making record led low
	mov al, 00b
	out 94h,al
	               
	mov bx, 01h

	;checking for replay switch
chk2:
	in al, 94h
	and al,00000100b
	jz chk2

	;making replay led high
	mov al,00100000b
	out 94h,al

	mov cx,6000d
	mov di,00h
c : 
    mov cx,bx
d : 
	in al,94h
    and al,02h
    cmp al,00h
    je d
e:  
	in al,94h
    and al,02h
    cmp al,02h
    je e
    loop d
    inc di
    pop cx
    loop c

	;making replay led LOW
	mov al,00000000b
	out 94h,al               

