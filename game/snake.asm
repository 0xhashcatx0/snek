%define snake_start_x 39
%define snake_start_y 12
%define snake_char 0x2f4f

; Type:	Struct
; Fields:
;	0 - x
;	1 - y
;	2 - snake_dir
snake:
	; Type: Enum
	; Desc: Dir the snake moves
	; Vals:
	;	1 - Up 
	;	2 - Down
	;	3 - Left
	;	4 - Righ
	snake_dir		db 0	; Snake not moving
	
	; Type: int
	; Desc: Snakes len
	; Vals: 1-2000
	snake_len	dw 15		; No tail
	
; Desc: Snake spawner
_snake_spawn:
	pusha				; Store GPRs to stack

	; Snake head init
	mov	byte [snake_cords], snake_start_x
	mov	byte [snake_cords + 1], snake_start_y

	mov	bx, snake_start_x
	mov	di, snake_start_y
	mov	ax, snake_char		; ah = 0x0f, al = 'O' 
	call	_screen_print_at

	popa				; Restore GPRs from stack
	ret

; Desc: Snake updater
_snake_update:
	pusha				; Store GPRs to stack

	call	tail_update

	; Key code handler
	cmp	ah, 0x48		; Check if up arrow
	je	.up_arrow

	cmp	ah, 0x50		; Check if down arrow
	je	.down_arrow

	cmp	ah, 0x4b		; Check if left arrow
	je	.left_arrow

	cmp	ah, 0x4d		; Check if right arrow
	je	.right_arrow

	jmp	.snake_dir_done		; Fallback
	
	; Dir updater
	.up_arrow:
	cmp	[snake_dir], 2		; Check if not going down
	je	.snake_dir_done

	mov	[snake_dir], 1		; Set dir to up
	jmp	.snake_dir_done

	.down_arrow:
	cmp	[snake_dir], 1		; Check if not going up
	je	.snake_dir_done

	mov	[snake_dir], 2		; Set dir to down
	jmp	.snake_dir_done

	.left_arrow:
	cmp	[snake_dir], 4		; Check if not going right
	je	.snake_dir_done

	mov	[snake_dir], 3		; Set dir to left
	jmp	.snake_dir_done

	.right_arrow:
	cmp	[snake_dir], 3		; Check if not going left
	je	.snake_dir_done

	mov	[snake_dir], 4		; Set dir to right
	jmp	.snake_dir_done

	.snake_dir_done:
	
	; Dir handler
	cmp	[snake_dir], 1		; Check if dir up
	je	.move_up

	cmp	[snake_dir], 2		; Check if dir down
	je	.move_down

	cmp	[snake_dir], 3		; Check if dir left
	je	.move_left

	cmp	[snake_dir], 4		; Check if dir right
	je	.move_right

	jmp	.cords_done		; Fallback

	; Cords updater
	.move_up:
	cmp	[snake_cords + 1], 0	; Check if on top border
	jne	.skip_up_wrap

	add	[snake_cords + 1], 25	; Wrap

	.skip_up_wrap:

	sub	[snake_cords + 1], 1	; Move up
	jmp	.cords_done

	.move_down:
	cmp	[snake_cords + 1], 24	; Check if bot border
	jne	.skip_down_wrap

	sub	[snake_cords + 1], 25	; Wrap

	.skip_down_wrap:

	add	[snake_cords + 1], 1	; Move down
	jmp	.cords_done
	
	.move_left:
	cmp	[snake_cords], 0	; Check if left border
	jne	.skip_left_wrap

	add	[snake_cords], 80	; Wrap

	.skip_left_wrap:

	sub	[snake_cords], 1	; Move left
	jmp	.cords_done
	
	.move_right:
	cmp	[snake_cords], 79	; Check if right border
	jne	.skip_right_wrap

	sub	[snake_cords], 80	; Wrap

	.skip_right_wrap:

	add	[snake_cords], 1	; Move right
	jmp	.cords_done

	.cords_done:

	call	renderer

	popa				; Restore GPRs from stack
	ret

; Desc: Tail updater 
tail_update:
	pusha					; Store GPRs to stack
	
	mov	si, [snake_len]
	dec	si

	; Clear last snake segment
	movzx	bx, byte [snake_cords + si]	; Get last segments x cord
	movzx	di, byte [snake_cords + si + 1]	; Get last segments y cord
	mov	ax, bckgd			; ah = 0x20, al = 0x00
	call	_screen_print_at

	; Shift snake
	mov	si, [snake_len]
	dec	si
	shl	si, 1				; * 2 (2 bytes per cord)
	.shift_loop:
	
	mov	ax, [snake_cords + si - 2]	; Get next snake segment
	mov	[snake_cords + si], ax		; Overwrite current segment

	sub	si, 2				; Move to next cord
	jnz	.shift_loop

	popa					; Restore GPRs from stack
	ret

; Desc: Renders the snake
; Args:
;	bx - x
;	di - y
;	ax - char
renderer:
	movzx	bx, byte [snake_cords]
	movzx	di, byte [snake_cords + 1]
	mov	ax, snake_char	; ah = 0x0f, al = 'O' 
	call	_screen_print_at

	ret
