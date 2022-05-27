TITLE MineSweeper
     .486
        .model flat,stdcall
        option casemap:none   
; 说明程序中用到的库、函数原型和常量
includelib      msvcrt.lib
include MineSweeper.inc

printf          PROTO C :ptr sbyte, :VARARG
; 数据区
.data
szMsg            byte    "第%ld行文本不同", 0dh, 0ah,0
szMsg2           byte    "%s", 0ah, 0
szMsg_A           byte    "文件A载入完成", 0ah, 0
button db 'button',0
button1 db '*',0
szMsg_B         byte    "文件B载入完成", 0ah, 0
szMsg_OK           byte    "比对完毕，两文件完全一致", 0ah, 0
opMsg         byte  10000 dup(0)
temMsg       byte  100 dup(0)
 res           dword 1
 diffNum    dword 0
 sum1 dword 0
 _line dword 0
; 代码区
.code



start:
        invoke GetModuleHandle,NULL			;获得并保存本程序的句柄
        mov hInstance,eax
	    invoke WinMain,hInstance,0,0,SW_SHOWDEFAULT
		invoke ExitProcess,eax				;退出程序，返回eax值


WinMain proc hInst:DWORD, hPrevInst:DWORD, CmdLine:DWORD, CmdShow:DWORD
        LOCAL wc:WNDCLASSEX						;窗口类
        LOCAL msg:MSG							;消息
		LOCAL hWnd:HWND							;对话框句柄
		
        mov wc.cbSize,sizeof WNDCLASSEX			;WNDCLASSEX的大小
        mov wc.style,CS_BYTEALIGNWINDOW or CS_BYTEALIGNWINDOW ;窗口风格 or CS_HREDRAW or CS_VREDRAW 
        mov wc.lpfnWndProc,OFFSET MineSweeper		;窗口消息处理函数地址
        mov wc.cbClsExtra,0						;在窗口类结构后的附加字节数，共享内存
        mov wc.cbWndExtra,DLGWINDOWEXTRA		;在窗口实例后的附加字节数(！注意点)
        mov eax,hInst
        mov wc.hInstance,eax					;窗口所属程序句柄
        mov wc.hbrBackground,COLOR_BTNFACE+1	;背景画刷句柄
        mov wc.lpszMenuName,NULL				;菜单名称指针
        mov wc.lpszClassName,OFFSET DialogName	;类名称指针
        invoke LoadIcon,hInst,addr IconName		;加载Icon
        mov wc.hIcon,eax						;图标句柄
        invoke LoadCursor,NULL,IDC_ARROW
        mov wc.hCursor,eax						;光标句柄
        mov wc.hIconSm,0						;窗口小图标句柄
        
        invoke RegisterClassEx,addr wc			;注册窗口类
        invoke CreateDialogParam,hInst,addr DialogName,0,addr MineSweeper,0	;调用对话框窗口
        mov   hWnd,eax							;保存对话框句柄
        invoke ShowWindow,hWnd,CmdShow			;最后一个参数可设置为SW_SHOWNORMAL
        invoke UpdateWindow,hWnd				;更新窗口
StartLoop:										;消息循环
		invoke GetMessage,addr msg,0,0,0		;获取消息
		cmp eax,0
		je ExitLoop
		invoke TranslateMessage,addr msg		;转换键盘消息
		invoke DispatchMessage,addr msg			;分发消息
		jmp StartLoop
ExitLoop:										;结束消息循环
		mov eax,msg.wParam 
      ret
WinMain endp

MineSweeper proc hWin:DWORD,uMsg:UINT,aParam:DWORD,bParam:DWORD
        LOCAL pt :POINT 
		

   .if uMsg == WM_INITDIALOG
	                invoke CreateMap,hWin                       ;创建地图

       

    .elseif uMsg == WM_CHAR		
 	                    mov eax,aParam
                        .if (eax>=ID_ADDA) && (eax<=ID_Implement)
                            invoke MineSweeper,hWin,WM_COMMAND,eax,0
                        .endif
    .elseif uMsg == WM_COMMAND
          mov eax,aParam
                        .if eax == ID_ADDA	
                            invoke GetDlgItem,hWin,eax
                            invoke SetWindowText,eax,addr szMsg_A
                            invoke LoadFile,hWin,ID_ADDA
                            invoke SendMessage,hEdit,WM_SETTEXT,0,addr szMsg_A
                        .elseif eax == ID_ADDB
                            invoke LoadFile,hWin,ID_ADDB
                            invoke SendMessage,hEdit,WM_SETTEXT,0,addr szMsg_B
                        .elseif eax == ID_Implement
                            
                            invoke CreateFile, ADDR FilePathA,  GENERIC_READ,  0,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,  0                         ;未使用
                            mov hFileA,eax
                            invoke CreateFile, ADDR FilePathB,  GENERIC_READ,  0,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,  0                         ;未使用
                            mov hFileB,eax
                            invoke Compare


                            .if diffNum == 0
                               ; invoke MessageBox,hWnd,offset SameContent,offset szBoxTitle,MB_OK+MB_ICONQUESTION
                                           ;反之输出不同的行号
                                 invoke SendMessage,hEdit,WM_SETTEXT,0,addr szMsg_OK
                            .else
                                 invoke SendMessage,hEdit,WM_SETTEXT,0,addr opMsg
                             .endif

                          mov _line,0
                          mov diffNum,0
                          invoke RtlZeroMemory,addr opMsg,sizeof opMsg

                        .endif

    .elseif uMsg == WM_CLOSE
                        invoke EndDialog,hWin,NULL                        
                        invoke PostQuitMessage,0						;有主窗口程序时添加
    .else
         invoke DefWindowProc,hWin,uMsg,aParam,bParam
   
    .endif
        xor eax,eax				       
        ret
MineSweeper endp 


CreateMap proc hWin:DWORD

    local x:dword
    local y:dword
    local tx:dword
    local ty:dword
    mov x,0
    mov y,0

    L1:
        mov ebx,20
        mov eax,x
        mul ebx
        mov tx,eax
        mov eax,y
        mul ebx
        mov ty,eax
        
        ;地图整体偏移
        add tx,16
        add ty,50
        invoke CreateWindowEx,NULL,offset button,offset button1,\
        WS_CHILD or WS_VISIBLE,tx,ty,20,20,\ 
        hWin,1,hInstance,NULL  ;1表示该按钮的句柄是1
        inc x
        mov eax,x
        cmp eax ,MapCol
        jz L2
        jmp L1
    L2:
        mov x,0
        inc y
        mov eax,y
        cmp eax ,MapRow
        jz L3
        jmp L1
    L3:
    ret


CreateMap endp



;搭了个壳





















;-------------------------------------------------------------------------
_ReadLine proc uses ebx,hFile:HANDLE,buffer:ptr byte
    ;指向实际读取字节数的指针
    local lpNum:dword
    ;用于保存读入数据的一个缓冲区
    local _str:byte
    ;ebx=buffer[0]
    mov ebx,buffer
    .while TRUE
        ;读入一个1个字符到_str中
        invoke ReadFile,hFile,addr _str,1,addr lpNum,NULL
        ;如果指针为空，退出循环
        .break .if !lpNum
        ;或者遇到换行号，退出循环
        .break .if _str==10
 
        ;将读入的字符赋给buffer
        mov al,_str
        mov [ebx],al
        ;ebx=buffer[i+1]
        inc ebx
    .endw
    ;最后一位赋0表示结束
    mov al,0
    mov [ebx],al
    ;调用strlen，结果存到eax中，返回eax
    invoke lstrlen,buffer
    ret
_ReadLine endp



Compare proc
    L1:
    inc _line
    ;初始化buffer，并读入一行数据
    invoke  RtlZeroMemory,addr szBuffer1,sizeof szBuffer1
    invoke _ReadLine,hFileA,offset szBuffer1
    ;返回值为buffer长度
    mov p1,eax
    invoke  RtlZeroMemory,addr szBuffer2,sizeof szBuffer2
    invoke _ReadLine,hFileB,offset szBuffer2
    mov p2,eax

    
L2:
    ;如果长度为0，则表示已读到文件结束
    cmp p1,0
    ;不等于0，则跳转L3继续比较p2
    jne L3
    ;比较p2长度，如果也为0，表示文件1和2都已读完，结束循环
    cmp p2,0
    je L5
    ;若p2不等于0，则表示buffer1为空，buffer2不为空，两者一定不等，记录行号
    invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    ;diffNum+1
    inc diffNum
    ;继续循环
    jmp L1
L3:
    ;比较p2，若不为空则表示p1，p2都不为空，调用strcmp比较
    cmp p2,0
    jne L4
    ;若p2为空，则表示buffer1不为空，buffer2为空，两者一定不等，记录行号
    invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    inc diffNum
    jmp L1
L4:
    ;调用strcmp比较
    invoke lstrcmp,offset szBuffer1,offset szBuffer2
    cmp eax,0
    ;若两者相同，继续循环
    je L1
    ;反之记录行号
       invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    inc diffNum
    jmp L1

L5:
    ;循环结束，关闭句柄
    invoke CloseHandle,hFileA
    invoke CloseHandle,hFileB
    invoke printf,addr szMsg2,addr opMsg

    ret
Compare endp



LoadFile proc hWin:DWORD,uMsg:UINT
    LOCAL File :OPENFILENAME
    	                    mov File.lStructSize,sizeof OPENFILENAME
						    mov eax,hWin
							mov File.hwndOwner,eax
							mov File.hInstance,0
							mov File.lpstrFilter,OFFSET FileFilter
							mov File.lpstrCustomFilter,0
							mov File.nMaxCustFilter ,0
							mov File.nFilterIndex,0
                            .if (uMsg==ID_ADDA)
							    mov File.lpstrFile,OFFSET FilePathA
                            .elseif (uMsg==ID_ADDB)                          
							    mov File.lpstrFile,OFFSET FilePathB
                            .endif
							mov File.nMaxFile,MAX_PATH
							mov File.lpstrFileTitle,0
							mov File.nMaxFileTitle,0
							mov File.lpstrInitialDir,0
							mov File.lpstrTitle,0
							mov File.Flags,0
							mov File.nFileOffset,0
							mov File.nFileExtension,0
							mov File.lpstrDefExt,OFFSET FileFilter
							mov File.lCustData,0
							mov File.lpfnHook,0
							mov File.lpTemplateName,0	
	                        invoke GetOpenFileName,addr File

        ret
LoadFile endp



                ret
end             start






