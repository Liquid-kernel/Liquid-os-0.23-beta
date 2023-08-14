;command.asm
;Copyright (C) liquid 2021-2023
;Liquid-os-0.22

WelcomeMessage:
	db  '+-----------------------------------------------------------------------------+',0dh,0ah
	db	'|Welcome to Liquid-OS kernel v0.23!                                           |',0dh,0ah
    db	'|Copyright (C) Liquid-OS 2021-2023                                            |',0dh,0ah 
    db	'|build version: liquid-kernel-v0.23                                           |',0dh,0ah
	db  '+-----------------------------------------------------------------------------+',0dh,0ah
	db  '     _     _             _     _          _                        _           ',0dh,0ah
	db  '    | |   (_)           (_)   | |        | |                      | |          ',0dh,0ah
	db  '    | |    _  __ _ _   _ _  __| | ______ | | _____ _ __ _ __   ___| |          ',0dh,0ah
	db  '    | |   | |/ _  | | | | |/ _  ||______|| |/ / _ \ |__| |_ \ / _ \ |          ',0dh,0ah
	db  '    | |___| | (_| | |_| | | (_| |        |   <  __/ |  | | | |  __/ |          ',0dh,0ah
	db  '    \_____/_|\__, |\__,_|_|\__,_|        |_|\_\___|_|  |_| |_|\___|_|          ',0dh,0ah
	db  '                | |                                                            ',0dh,0ah
	db  '                |_|                                                            ',0dh,0

    ;db  '    __    _             _     __                 ',0dh,0ah
    ;db  '   / /   (_)___ ___  __(_)___/ /     ____  _____ ',0dh,0ah
    ;db  '  / /   / / __ `/ / / / / __  /_____/ __ \/ ___/ ',0dh,0ah
	;db  ' / /___/ / /_/ / /_/ / / /_/ /_____/ /_/ (__  )  ',0dh,0ah
	;db  '/_____/_/\__, /\__,_/_/\__,_/      \____/____/   ',0dh,0ah
    ;db  '           /_/                                   ',0dh,0


LinePut					db	'[User@Liquid-Kernel]$',0 
rootLinePut			    db	'[User@Liquid-Kernel]#',0 ;root
Console:
	.CmdLine					times	128	db	0	; 输入的命令行
	.CmdCurYsize				db	14  
	.CmdCurXsize				db	21
	
BadCom					db	'Command not found',0
UnameCom				db	'uname'
ClsCom					db	'clear'
EchoCom					db	'echo'
dateCom					db  'date'
shutdownCom             db  'shutdown'
rebootCom               db  'reboot'
FreeCom					db	'free'
MemoryAMFPut			db	'All:000000KB  Malloc:000000KB  Free:000000KB',0
lsCom					db	'ls'
lsput       			db	'List Files',0
CatCom					db	'cat'
helpCom					db	'help'
NotFindPut				db	'File not find.',0
rootCom				    db  'root'
bcCom                   db  'bc'
cpuinfoCom				db  'cpuinfo'
desktopCom				db  'desktop'
timeCom					db  'time'
GobangCom	     		db  'gobang'
edxdata 				dd 0
Version:
    db	'Liquid-Kernel-v0.22',0dh,0ah
	db  'Built on Windows 10,Windows 11 and Ubuntu Linux with vscode,edimg and nasm.',0dh,0ah
	db  'QQ E-mail:2804966657@qq.com',0dh,0
	
helpmsg:
	db  '[uname  ]  The version of the System.',0dh,0ah
	db  '[ls     ]  List files of the System.',0dh,0ah
	db  '[echo   ]  Print the words.' ,0dh,0ah
	db  '[free   ]  The ram of the computer.',0dh,0ah
	db  '[clear  ]  Clear the screen.',0dh,0ah
	db  '[cat    ]  Open the files.',0dh,0ah
	db  '[cpuinfo]  The version of the CPU.',0dh,0ah
	db  '[root   ]  Superuer permissions.',0dh,0ah
	db  '[date   ]  Print the date.',0dh,0ah
	db  '[time   ]  Print the time.',0dh,0