; Desc: Waits ax amount of time
; Args:
;	ax - Time (ms)
_sleep:
	pusha			; Store GPRs to stack 

	; ms to us	
	mov	bx, 1000
	mul	bx

	mov	cx, dx		; High word
	mov	dx, ax		; Low word
	mov	ah, 0x86	; Delay for a microsecond interval
	int	0x15

	popa			; Restore GPRs from stack
	ret
