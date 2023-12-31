;command.asm
;Copyright (C) liquid & yijiapin 2021-2023
;Liquid-os-0.22

FindCommand:
; 判断并执行命令
	mov	esi,0
	mov	cx,5
.LoopFind1:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[UnameCom+esi]
	cmp	al,ah
	jne	.LoopFind2r
	inc	esi
	loop	.LoopFind1
	jmp	uname
.LoopFind2r:
	mov	esi,0
	mov	cx,3
.LoopFind2:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[ClsCom+esi]
	cmp	al,ah
	jne	.LoopFind3r
	inc	esi
	loop	.LoopFind2
	jmp	clear
.LoopFind3r:
	mov	esi,0
	mov	cx,4
.LoopFind3:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[EchoCom+esi]
	cmp	al,ah
	jne	.LoopFind4r
	inc	esi
	loop	.LoopFind3
	jmp	echocommand
.LoopFind4r:
	mov	esi,0
	mov	cx,4
.LoopFind4:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[FreeCom+esi]
	cmp	al,ah
	jne	.LoopFind5r
	inc	esi
	loop	.LoopFind4
	jmp	free
.LoopFind5r:
	mov	esi,0
	mov	cx,2
.LoopFind5:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[lsCom+esi]
	cmp	al,ah
	jne	.LoopFind6r
	inc	esi
	loop	.LoopFind5
	jmp	ls
.LoopFind6r:
	mov	esi,0
	mov	cx,3
.LoopFind6:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[CatCom+esi]
	cmp	al,ah
	jne	.LoopFind7r
	inc	esi
	loop	.LoopFind6
	jmp	catcommand
.LoopFind7r:
	mov	esi,0
	mov	cx,4
.LoopFind7:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[rootCom+esi]
	cmp	al,ah
	jne	.LoopFind8r
	inc	esi
	loop	.LoopFind7
	jmp root
.LoopFind8r:
	mov	esi,0
	mov	cx,4
.LoopFind8:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[helpCom+esi]
	cmp	al,ah
	jne	.LoopFind9r
	inc	esi
	loop	.LoopFind8
	jmp	help
.LoopFind9r:
	mov	esi,0
	mov	cx,4
.LoopFind9:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[dateCom+esi]
	cmp	al,ah
	jne	.LoopFind10r
	inc	esi
	loop	.LoopFind9
	jmp	date
.LoopFind10r:
	mov	esi,0
	mov	cx,7
.LoopFind10:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[desktopCom+esi]
	cmp	al,ah
	jne	.LoopFind11r
	inc	esi
	loop	.LoopFind10
	jmp	desktop
.LoopFind11r:
	mov	esi,0
	mov	cx,7
.LoopFind11:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[cpuinfoCom+esi]
	cmp	al,ah
	jne	.LoopFind12r
	inc	esi
	loop	.LoopFind11
	jmp	cpuinfo
.LoopFind12r:
	mov	esi,0
	mov	cx,4
.LoopFind12:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[dateCom+esi]
	cmp	al,ah
	jne	.LoopFind13r
	inc	esi
	loop	.LoopFind12
	jmp	date
.LoopFind13r:
	mov	esi,0
	mov	cx,4
.LoopFind13:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[timeCom+esi]
	cmp	al,ah
	jne	.LoopFind14r
	inc	esi
	loop	.LoopFind13
	jmp	time
.LoopFind14r:
	mov	esi,0
	mov	cx,8
.LoopFind14:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[shutdownCom+esi]
	cmp	al,ah
	jne	.LoopFind15r
	inc	esi
	loop	.LoopFind14
	jmp	shutdown
.LoopFind15r:
	mov	esi,0
	mov	cx,6
.LoopFind15:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[rebootCom+esi]
	cmp	al,ah
	jne	.LoopFind16r
	inc	esi
	loop	.LoopFind15
	jmp	reboot
.LoopFind16r:
	mov	esi,0
	mov	cx,6
.LoopFind16:
	mov	ah,[Console.CmdLine+esi]
	mov	al,[GobangCom+esi]
	cmp	al,ah
	jne	.NotFind
	inc	esi
	loop	.LoopFind15
	jmp	gobang
.NotFind:
	mov	esi,0
.PutLoop:
	mov	si,BadCom
	mov	ah,07h
	call	Cons_PutStr
	ret

;分界线下为命令执行区--------------------------------------------------------------------分界线上为命令判断区

uname:
; uname命令
	call	Cons_NewLine
	mov	si,Version
	mov	ah,07h
	call	Cons_PutStr
	call	Cons_NewLine
	ret

cpuinfo:
	mov eax,0
	cpuid
	push ebx
	shr ebx,24
	mov dl,bl
	pop ebx
	push ebx
	shr ebx,16
	mov dh,bl
	pop ebx
	push ebx
	shr ebx,8
	mov cl,bl
	pop ebx
	mov ch,bl
	shl ecx,16
	and edx,0x0000ffff
	and ecx,0xffff0000
	or edx,ecx
	;mov [edxdata],edx
	mov si,edxdata
	call Cons_PutStr
	ret
	
clear:
; clear命令
	mov	byte[Console.CmdCurYsize],0
	mov	byte[Console.CmdCurXsize],0
	mov	esi,0
	mov	cx,25*80
.MemWriteLoop:
	mov	byte[es:TextVramAddrSegment+esi],' '
	mov	byte[es:TextVramAddrSegment+esi+1],07h
	add	esi,2
	loop	.MemWriteLoop
	ret

help:
	call	Cons_NewLine
	mov	si,helpmsg
	mov	ah,07h
	call	Cons_PutStr
	call	Cons_NewLine
	ret
echocommand:
; echo命令
	mov	esi,5
.PutLoop:
	mov	al,[Console.CmdLine+esi]
	cmp	al,0
	je	.PutOK
	mov	ah,07h
	call	Cons_PutChar
	inc	esi
	jmp	.PutLoop
.PutOK:
	ret

free:
; free命令
	; 输出部分
	mov	esi,MemoryAMFPut
	mov	ah,07h
	call	Cons_PutStr
	call	Cons_NewLine
	; All部分
	mov	eax,[MemoryLargest]
	shr	eax,16
	mov	bx,4
	mul	bx		; (地址>>16)*4=KB制总内存（大约）
	mov	[Temp],dl
	mov	[Temp+1],ah
	mov	[Temp+2],al
	mov	ecx,3
	mov	esi,Temp
	mov	ah,07h
	call	PutHexNumber
	mov	bh,[Console.CmdCurYsize]
	dec	bh
	mov	bl,4
	ret

root:
    mov	esi,rootLinePut
	mov	bh,[Console.CmdCurYsize]
	mov	bl,0
	mov	ah,07h
	call	PutStr
	mov	esi,0
	ret

shutdown:
	ret
reboot:
ret
mov ax,8000h
mov dx,0cfah
out dx,ax
mov ax,0f840h
mov dx,0cf8h
out dx,ax
mov dx,0cfch
in ax,dx
mov ax,0e401h
and ax,0ff80h
add ax,4
mov dx,ax
mov ax,3c00h
out dx,ax

ls:
; ls命令
	mov	esi,lsput
	mov	ah,07h
	call	Cons_PutStr
	call	Cons_NewLine
	call	Cons_NewLine
	
	mov	esi,FileInfoSegment
	mov	ecx,12
.LoopPutFileName:
	mov	al,[es:esi]
	mov	ah,07h
	call	Cons_PutChar
	inc	esi
	loop	.LoopPutFileName
	call	Cons_NewLine
	cmp	byte[es:esi+32-12],0
	je	.PutOK
	mov	ecx,12
	add	esi,32-12
	jmp	.LoopPutFileName
.PutOK:
	ret

catcommand:
; cat命令
	mov	esi,4
	mov	edi,0
.Copy:
	mov	al,[Console.CmdLine+esi]
	cmp	al,0
	je	.OK
	cmp	al,' '
	je	.OK
	mov	[Temp+edi],al
	inc	esi
	inc	edi
	jmp	.Copy
.OK:
	mov	esi,Temp
	mov	dh,20h	; 20h为文件
	call	FileNameCpy
	mov	esi,Temp
	call	FindFileLoop
	cmp	ebx,0
	je	.Notfind
	cmp	edi,0
	je	.Notfind
	mov	ecx,[es:ebx+28]
.PutLoop:
	mov	al,[es:edi]
	mov	ah,07h
	call	Cons_PutChar
	inc	edi
	dec	ecx
	jecxz	.Ret
	jmp	.PutLoop
.Ret:
	ret
.Notfind:
	mov	esi,NotFindPut
	mov	ah,07h
	call	Cons_PutStr
	call	Cons_NewLine
	ret

gobang:
	call clear
	ret

date:
   ;输出年份
   MOV AL,'2'
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,'0'
   CALL Cons_PutChar
   MOV AL,9
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   MOV AL,'-'
   CALL Cons_PutChar
   ;输出月份
   MOV AL,8
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   MOV AL,'-'
   CALL Cons_PutChar
   ;输出日期
   MOV AL,7
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   RET
   
time:
   ;输出小时
   MOV AL,4
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   MOV AL,':'
   CALL Cons_PutChar
   ;输出分钟
   MOV AL,2
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   MOV AL,':'
   CALL Cons_PutChar
   ;输出秒钟
   MOV AL,0
   OUT 70H,AL
   IN AL,71H
   MOV AH,AL
   MOV CX,4
   SHR AH,CL
   AND AL,00001111B
   ADD AL,30H
   ADD AH,30H
   MOV DL,AL
   MOV AL,AH
   MOV AH,00001111B
   CALL Cons_PutChar
   MOV AL,DL
   CALL Cons_PutChar
   ret

%include "desktop.asm"
%include "gobang.asm"