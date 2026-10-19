%define vga_addr	0xb800	; VGA addr

bits 16
org 0x7c00			; Bootloader load addr

_main:
	; VGA buffer segment setup
	mov	ax, vga_addr
	mov	es, ax

	xor	ah, ah
	call	_screen_clear
	call	_game_main_menu

	.halt:			; Halt loop
	hlt
	jmp	.halt

%include "./utils/screen.asm"
%include "./game/main_menu.asm"
%include "./utils/keyboard.asm"

times 510 - ($ - $$) db 0	; Padding to 512 bytes
dw 0xaa55			; Bootloader magic bytes

; Snake struct bss

; Type: Array
; Desc: Snakes tail x cord
; Vals: [(x, y)..]
snake_cords	resb 4000	; Reserve mem for snake
