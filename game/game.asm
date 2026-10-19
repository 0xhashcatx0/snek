%include "./game/snake.asm"
%include "./utils/sleep.asm"

_game:

	mov	ax, bckgd
	call	_screen_clear

	call	_snake_spawn

	.game_loop:
	
	call	_keyboard_get_key
	call	_snake_update

	mov	ax, 100
	call	_sleep

	jmp	.game_loop

	ret	
