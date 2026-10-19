; Desc: Returns last pressed key.
; Ret:
;	al - char
;	ah - code
_keyboard_get_key:
	; Read keyboard code and char (non-blocking)
	mov	ah, 0x01
	int	0x16

	jz	.no_key

	; Read keyboard code and char (blocking)
	mov	ah, 0
	int	0x16

	jmp	.done

	.no_key:
	xor	ax, ax		; Ret 0 if no key

	.done:
	ret
