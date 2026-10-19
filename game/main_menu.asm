%include "./game/game.asm"

main_menu_msg	db "Press any key to start.", 0

; Desc: Game main menu
_game_main_menu:
	; Main menu msg print
	xor	bx, bx
	xor	di, di
	mov	si, main_menu_msg
	mov	ah, 0x0f
	call	_screen_print_str_at

	.game_start_handler_loop:
	hlt	; Wait for interaction

	call	_keyboard_get_key

	; Check if any button was pressed
	test	ah, ah
	jnz	.game_start

	jmp	.game_start_handler_loop

	.game_start:
	call	_game

	ret
