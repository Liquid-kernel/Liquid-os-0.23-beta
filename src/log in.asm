Login_in_main:
	mov	bh,0
	mov	bl,0
	mov	ah,07h
	mov	esi,Log_in_Gui
	call	PutStr

	call Login_input
    call FindOption
	ret

Login_input:
	push	esi
	call	WaitInput
	pop	esi
	cmp	al,08h	; 退格的处理
	je	.BackSpace
	cmp	al,0dh	; 换行的处理
	je	.Enter
	mov	ah,07h
	call	Cons_PutChar
	mov	[Log_in_Console.CmdLine+esi],al
	inc	esi
	jmp	Login_input
.BackSpace:
	cmp	byte[Log_in_Console.CmdCurXsize],21
	je	UserInput
	sub	byte[Log_in_Console.CmdCurXsize],2
	mov	ah,07h
	mov	al,20h
	call	Cons_PutChar
	dec	esi
	mov	byte[Log_in_Console.CmdLine+esi],0
	jmp Login_input	
.Enter:
	call	Cons_NewLine
	mov	byte[Log_in_Console.CmdCurXsize],0		; 执行程序时Xsize必须为0
	call	FindCommand
	call	Cons_NewLine
	mov	bh,[Log_in_Console.CmdCurYsize]
	mov	bl,0
	mov	si,LinePut
	mov	ah,07h
	call	PutStr
	mov	byte[Log_in_Console.CmdCurXsize],21
	call	CleanCmdLineTemp
	mov	esi,0
	jmp	Login_input

FindOption:
	mov	esi,0
	mov	cx,1
.LoopFind1:
	mov	ah,[Log_in_Console.CmdLine+esi]
	mov	al,[one_Com+esi]
	cmp	al,ah
	jne	.LoopFind2r
	inc	esi
	loop	.LoopFind1
	jmp	boot_32_bit
.LoopFind2r:
	mov	esi,0
	mov	cx,1
.LoopFind2:
	mov	ah,[Log_in_Console.CmdLine+esi]
	mov	al,[two_Com+esi]
	cmp	al,ah
	jne	.LoopFind3r
	inc	esi
	loop	.LoopFind2
	jmp	boot_16_bit
.LoopFind3r:
	mov	esi,0
	mov	cx,1
.LoopFind3:
	mov	ah,[Log_in_Console.CmdLine+esi]
	mov	al,[three_Com+esi]
	cmp	al,ah
	jne	.LoopFind4r
	inc	esi
	loop	.LoopFind3
	jmp	safe_mode
.LoopFind4r:
	mov	esi,0
	mov	cx,1
.LoopFind4:
	mov	ah,[Log_in_Console.CmdLine+esi]
	mov	al,[four_Com+esi]
	cmp	al,ah
	jne	.NotFind
	inc	esi
	loop	.LoopFind4
	jmp	login_reboot
.NotFind:
	mov	esi,0
.PutLoop:
	mov	si,Log_in_error
	mov	ah,07h
	call	Cons_PutStr
	ret

boot_16_bit:
	call clear
	ret

boot_32_bit:
	call clear
	ret

safe_mode:
	call clear
	ret

login_reboot:
	call clear
	ret

Log_in_Console:
	.CmdLine					times	128	db	0	; 输入的命令行
	.CmdCurYsize				db	10
	.CmdCurXsize				db	18

Log_in_LinePut					db	'Select option:',0 

one_Com	     	    	db  '1'
two_Com	     		    db  '2'
three_Com	     		db  '3'
four_Com	     		db  '4'
Log_in_error            db	'input again!',0

Log_in_Gui:
    db  '+-----------------------------------------+                                  ',0dh,0ah
	db  '|                                         |   __    _             _     __   ',0dh,0ah
    db  '|      welcome to Liquid-os v0.23!        |  | |   (_)___ ___  __(_)___| |   ',0dh,0ah
	db  '|                                         |  | |   | | __  | | | | | __  |   ',0dh,0ah
	db  '|  1.Boot Liquid-os(32-bit) from floppy   |  | |___| | |_| | |_| | | |_| |   ',0dh,0ah
	db  '|  2.Boot Liquid-os(16-bit) from floppy   |  |_____|_|\___ |\____|_|\____|   ',0dh,0ah
	db  '|  3.Safe mode(32-bit)                    |              |_|                 ',0dh,0ah
	db  '|  4.Reboot                               |           ___  ___               ',0dh,0ah
	db  '|                                         |          / _ \/ __|              ',0dh,0ah
	db  '|  Select option:                         |         | (_) \__ \              ',0dh,0ah
	db  '|  enter for Default                      |          \___/|___/              ',0dh,0ah
	db  '|                                         |                                  ',0dh,0ah
	db  '|  Copyright (c) 2021-2023 Liquid-OS      |                                  ',0dh,0ah
    db  '+-----------------------------------------+                                  ',0dh,0