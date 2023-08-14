jmp short start    

db	0x90
	db	"liquidos"
	dw	512
	db	1
	dw	1
	db	2
	dw	224
	dw	2880
	db	0xf0
	dw	9
	dw	18
	dw	2
	dd	0
	dd	2880
	db	0,0,0x29
	dd	0xffffffff
	db	"liquid-os  "
	db	"FAT16   "
	
app_lba_start equ 64      ;声明主程序所在的扇区

SECTION mbr align=16 vstart=0x7c00
;---------------------------------------------------
;硬盘读取例程。负责将扇区加载到指定的段地址程序。并注册状态。
;@params:
;AX :保存扇区号低16位。
;DX :保存扇区号高12位和读取状态   
;BX :保存需要加载的扇区段地址位置。最大不超过65536个扇区

;使用方式：远程调用
;寄存器影响：无影响
;注意事项：硬盘的一个扇区加载程序跟内存可用扇区数没有关系。这是硬盘管理程序做的事。
read_hard_disk_0:             ;从主硬盘中读取数据
    push ax 
    push bx 
    push cx
    push dx
    push si 
    push ds
    
    mov cx,ax
    xor ax,ax
    mov ds,ax   ;重新设置内存段地址  
    mov si,direct_disk_service

    mov word [ds:si+0x08],cx   ;设置需要读取的扇区号低16位
    mov word [ds:si+0x0a],dx   ;设置需要读取的扇区号高12位
    mov word [ds:si+0x06],bx   ;设置需要加载到的内存段位置


    ;加载设置程序并跳转。
    xor dx,dx
    mov ah,0x42
    mov dl,0x80   ;读取硬盘，drive number,一般0x80是c盘
    mov si,direct_disk_service
    int 0x13
    test ax,0xff_00   ;ah为0表示读取成功。
        jz .exit
    call show_error_message
    cli 
    hlt 
    .exit:
        pop ds
        pop si
        pop dx
        pop cx 
        pop bx
        pop ax
        retf   ;过程调用完可以直接返回了。

;--------------------------------------------------
;设置一个加载启动项。用于int 13H的扩展硬盘读取。
direct_disk_service:
struct_length    dw 0x0010    ;可以为0x10或0x18,定义这个struct 结构的长度,这里是
load_sector_number    dw 0x01    ;定义需要读取的扇区数
target_memory_address    dw 0x0000  ;设置需要读取到的内存位置offset
target_memory_segment    dw 0x0000  ;设置内存位置段ds
start_sector_lba         dd 0x0001  ;设置读取的起始LBA48扇区号，低32位
long_mode_linear_address    dd 0x0000  ;设置读取的起始LBA48扇区号，高12位

;--------------------------------------------------------------------------
start:
    ;设置堆栈段和栈指针
    mov ax,0
    mov ss,ax          ;指明了堆栈从内存位置0开始。
    mov sp,0x7c00      ;堆栈向下拓展

    ;计算用户程序所在的逻辑地址
    mov ax,[cs:phy_base]
    mov dx,[cs:phy_base+0x02]
    mov bx,16
    div bx   ;32位无符号除法。得到段地址

    mov ds,ax
    mov es,ax
    mov bx,ax    ;设置需要加载的段地址
    ;读取程序
    xor dx,dx
    mov ax,app_lba_start      ;设置用户程序起始扇区号

    push cs
    call read_hard_disk_0       ;过程调用完成后，用户程序的第一个扇区被加载到了内存开始的地方

    push ax 
    push bx 
    push dx 

    ;以下判断整个程序有多大
    mov dx,[ds:2]
    mov ax,[ds:0]             ;取得程序头部文件，计算有多少个字节。

    mov bx,512             ;每个扇区有512个字节
    div bx                 ;此时商在ax中，就是扇区数。
    cmp dx,0               ;如果没有余数，则说明刚好除尽。
        jnz .continue_1                 ;如果是不相等，则ax不需要减一。如果相等，则需要减一
    dec ax                 ;自减指令。

.continue_1:
    mov cx,ax 
    pop dx
    pop bx 
    pop ax 

    cmp cx,0               ;如果ax为0则说明扇区数已经读完了。
        jz .access_new_procedure
    ;如果没有读取完，则需要继续读取扇区数。
               ;循环读取，直到读完整个用户程序。
.continue_read_left_sectors:
        add bx,0x20    ;指向下一个内存段位置
        inc ax         ;指向硬盘下一个扇区
        xor dx,dx
        push cs
        call read_hard_disk_0
        loop .continue_read_left_sectors              ;循环读取，直到读完整个用户程序。

.access_new_procedure:
    jmp 0x8004


show_error_message:
    push ax 
    push ds 
    mov ax,0xb800
    mov ds,ax 
    ret

;----------------------------------------------
phy_base dd 0x008000              ;用户程序加载的内存位置
bootstrap_code_end:
times 440-($-$$) db 0
disk_serial_number db 0xff,0x0d,0x0a,0x50
resrved db 0x00,0x00

PARTION_1:
.active_partion_flag db 0x80   ;active or 0x73 非活动分区
.start_head db 0x01            ;
.start_sector db 0x01 
.start_cylinder db 0x00 
.file_system_id db 0x0b        ;0x0b表示FAT32,0x04表示FAT16,0x07表示NTFS。 
.end_head db 0xfe 
.end_sector db 0xff 
.end_cylinder db 0x7b
.first_sector db 0x3f,0x00,0x00,0x00 
.total_sectors db 0x3d,0xa8,0xda,0x00 

PARTION_2:
.active_partion_flag db 0x00   ;active or 0x73 非活动分区
.start_head db 0x73            ;
.start_sector db 0x20 
.start_cylinder db 0x61 
.file_system_id db 0x6e 
.end_head db 121 
.end_sector db 0x20 
.end_cylinder db 0x6b
.first_sector db 0x65,0x79,0x20,0x74 
.total_sectors db 0x00,0x00,0x00,0x00 

PARTION_3:
.active_partion_flag db 0x00   ;active or 0x73 非活动分区
.start_head db 0x73            ;
.start_sector db 0x20 
.start_cylinder db 0x61 
.file_system_id db 0x6e 
.end_head db 121 
.end_sector db 0x20 
.end_cylinder db 0x6b
.first_sector db 0x65,0x79,0x20,0x74 
.total_sectors db 0x00,0x00,0x00,0x00 

PARTION_4:
.active_partion_flag db 0x00   ;active or 0x73 非活动分区
.start_head db 0x73            ;
.start_sector db 0x20 
.start_cylinder db 0x61 
.file_system_id db 0x6e 
.end_head db 121 
.end_sector db 0x20 
.end_cylinder db 0x6b
.first_sector db 0x65,0x79,0x20,0x74 
.total_sectors db 0x00,0x00,0x00,0x00 

db 0x55,0xaa