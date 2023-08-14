Gobang_main_Input:
	push	esi
	call	WaitInput
	pop	esi
	cmp	al,08h	; 退格的处理
	je	.BackSpace
	cmp	al,0dh	; 换行的处理
	je	.Enter
	mov	ah,07h
	call	Cons_PutChar
	mov	[Console.CmdLine+esi],al
	inc	esi
	jmp	Gobang_main_Input
.BackSpace:
	cmp	byte[Console.CmdCurXsize],21
	je	Gobang_main_Input
	sub	byte[Console.CmdCurXsize],2
	mov	ah,07h
	mov	al,20h
	call	Cons_PutChar
	dec	esi
	mov	byte[Console.CmdLine+esi],0
	jmp	Gobang_main_Input
.Enter:
	call	Cons_NewLine
	mov	byte[Console.CmdCurXsize],0		; 执行程序时Xsize必须为0
	call	FindCommand
	call	Cons_NewLine
	mov	bh,[Console.CmdCurYsize]
	mov	bl,0
	mov	si,Gobang_LinePut
	mov	ah,07h
	call	PutStr
	mov	byte[Console.CmdCurXsize],21
	call	CleanCmdLineTemp
	mov	esi,0
	jmp Gobang_main_Input

Gobang_Console:
	.CmdLine					times	128	db	0	; 输入的命令行
	.CmdCurYsize				db	1
	.CmdCurXsize				db	1

Gobang_LinePut					db	'>',0 



Gobang_Gui:
	db  '+-----------------------------------------------------------------------------+',0dh,0ah
	db  '|                                                                             |',0dh,0ah
    db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah
	db  '|                                                                             |',0dh,0ah    
	db  '|                                                                             |',0dh,0ah    
	db  '|                                                                             |',0dh,0ah    
	db  '|                                                                             |',0dh,0ah   
    db  '+-----------------------------------------------------------------------------+',0dh,0
