%define bckgd 0x2000

; Desc: Clears screen
; Args:
;	ah - attr
_screen_clear:
	pusha			; Store GPRs to stack

	mov	cx, 2000
	xor	di, di

	rep	stosw		; Wipe VGA 

	popa			; Restore GPRs from stack
	ret

; Desc: Prints a single char at x, y
; Args:
;	bx - x
;	di - y
;	al - char
;	ah - attr
_screen_print_at:
	call	cords_to_vga_offset

	mov	[es:di], ax	; Write char to VGA

	ret

; Desc: Prints a str at x, y
; Args:
;	bx - x
;	di - y
;	si - str ptr
;	ah - attr
_screen_print_str_at:
	call	cords_to_vga_offset
	
	.loop:
	lodsb			; Load str char to al and move to the next one
	test	al, al		; Check if str end
	jz	.done

	mov	[es:di], ax	; Write char to VGA
	add	di, 2		; Next char

	jmp	.loop
	.done:
	ret

; Desc: Converts x and y to VGA offset
; Args:
;	bx - x
;	di - y
; Ret:
;	di - offset
cords_to_vga_offset:	
	; VGA offset calculation
	; di = ((y * 80) + x) * 2
	mul	di, 80		; y * 80
	add	di, bx		; y + x
	shl	di, 1		; y * 2 (2 bytes per VGA char)

	ret
