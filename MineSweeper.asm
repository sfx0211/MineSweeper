TITLE MineSweeper
     .486
        .model flat,stdcall
        option casemap:none   
; ˵���������õ��Ŀ⡢����ԭ�ͺͳ���
includelib      msvcrt.lib
include MineSweeper.inc

printf          PROTO C :ptr sbyte, :VARARG
; ������
.data
szMsg            byte    "��%ld���ı���ͬ", 0dh, 0ah,0
szMsg2           byte    "%s", 0ah, 0
szMsg_A           byte    "�ļ�A�������", 0ah, 0
button db 'button',0
button1 db '*',0
szMsg_B         byte    "�ļ�B�������", 0ah, 0
szMsg_OK           byte    "�ȶ���ϣ����ļ���ȫһ��", 0ah, 0
opMsg         byte  10000 dup(0)
temMsg       byte  100 dup(0)
 res           dword 1
 diffNum    dword 0
 sum1 dword 0
 _line dword 0
; ������
.code



start:
        invoke GetModuleHandle,NULL			;��ò����汾����ľ��
        mov hInstance,eax
	    invoke WinMain,hInstance,0,0,SW_SHOWDEFAULT
		invoke ExitProcess,eax				;�˳����򣬷���eaxֵ


WinMain proc hInst:DWORD, hPrevInst:DWORD, CmdLine:DWORD, CmdShow:DWORD
        LOCAL wc:WNDCLASSEX						;������
        LOCAL msg:MSG							;��Ϣ
		LOCAL hWnd:HWND							;�Ի�����
		
        mov wc.cbSize,sizeof WNDCLASSEX			;WNDCLASSEX�Ĵ�С
        mov wc.style,CS_BYTEALIGNWINDOW or CS_BYTEALIGNWINDOW ;���ڷ�� or CS_HREDRAW or CS_VREDRAW 
        mov wc.lpfnWndProc,OFFSET MineSweeper		;������Ϣ��������ַ
        mov wc.cbClsExtra,0						;�ڴ�����ṹ��ĸ����ֽ����������ڴ�
        mov wc.cbWndExtra,DLGWINDOWEXTRA		;�ڴ���ʵ����ĸ����ֽ���(��ע���)
        mov eax,hInst
        mov wc.hInstance,eax					;��������������
        mov wc.hbrBackground,COLOR_BTNFACE+1	;������ˢ���
        mov wc.lpszMenuName,NULL				;�˵�����ָ��
        mov wc.lpszClassName,OFFSET DialogName	;������ָ��
        invoke LoadIcon,hInst,addr IconName		;����Icon
        mov wc.hIcon,eax						;ͼ����
        invoke LoadCursor,NULL,IDC_ARROW
        mov wc.hCursor,eax						;�����
        mov wc.hIconSm,0						;����Сͼ����
        
        invoke RegisterClassEx,addr wc			;ע�ᴰ����
        invoke CreateDialogParam,hInst,addr DialogName,0,addr MineSweeper,0	;���öԻ��򴰿�
        mov   hWnd,eax							;����Ի�����
        invoke ShowWindow,hWnd,CmdShow			;���һ������������ΪSW_SHOWNORMAL
        invoke UpdateWindow,hWnd				;���´���
StartLoop:										;��Ϣѭ��
		invoke GetMessage,addr msg,0,0,0		;��ȡ��Ϣ
		cmp eax,0
		je ExitLoop
		invoke TranslateMessage,addr msg		;ת��������Ϣ
		invoke DispatchMessage,addr msg			;�ַ���Ϣ
		jmp StartLoop
ExitLoop:										;������Ϣѭ��
		mov eax,msg.wParam 
      ret
WinMain endp

MineSweeper proc hWin:DWORD,uMsg:UINT,aParam:DWORD,bParam:DWORD
        LOCAL pt :POINT 
		

   .if uMsg == WM_INITDIALOG
	                invoke CreateMap,hWin                       ;������ͼ

       

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
                            
                            invoke CreateFile, ADDR FilePathA,  GENERIC_READ,  0,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,  0                         ;δʹ��
                            mov hFileA,eax
                            invoke CreateFile, ADDR FilePathB,  GENERIC_READ,  0,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,  0                         ;δʹ��
                            mov hFileB,eax
                            invoke Compare


                            .if diffNum == 0
                               ; invoke MessageBox,hWnd,offset SameContent,offset szBoxTitle,MB_OK+MB_ICONQUESTION
                                           ;��֮�����ͬ���к�
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
                        invoke PostQuitMessage,0						;�������ڳ���ʱ���
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
        
        ;��ͼ����ƫ��
        add tx,16
        add ty,50
        invoke CreateWindowEx,NULL,offset button,offset button1,\
        WS_CHILD or WS_VISIBLE,tx,ty,20,20,\ 
        hWin,1,hInstance,NULL  ;1��ʾ�ð�ť�ľ����1
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



;���˸���





















;-------------------------------------------------------------------------
_ReadLine proc uses ebx,hFile:HANDLE,buffer:ptr byte
    ;ָ��ʵ�ʶ�ȡ�ֽ�����ָ��
    local lpNum:dword
    ;���ڱ���������ݵ�һ��������
    local _str:byte
    ;ebx=buffer[0]
    mov ebx,buffer
    .while TRUE
        ;����һ��1���ַ���_str��
        invoke ReadFile,hFile,addr _str,1,addr lpNum,NULL
        ;���ָ��Ϊ�գ��˳�ѭ��
        .break .if !lpNum
        ;�����������кţ��˳�ѭ��
        .break .if _str==10
 
        ;��������ַ�����buffer
        mov al,_str
        mov [ebx],al
        ;ebx=buffer[i+1]
        inc ebx
    .endw
    ;���һλ��0��ʾ����
    mov al,0
    mov [ebx],al
    ;����strlen������浽eax�У�����eax
    invoke lstrlen,buffer
    ret
_ReadLine endp



Compare proc
    L1:
    inc _line
    ;��ʼ��buffer��������һ������
    invoke  RtlZeroMemory,addr szBuffer1,sizeof szBuffer1
    invoke _ReadLine,hFileA,offset szBuffer1
    ;����ֵΪbuffer����
    mov p1,eax
    invoke  RtlZeroMemory,addr szBuffer2,sizeof szBuffer2
    invoke _ReadLine,hFileB,offset szBuffer2
    mov p2,eax

    
L2:
    ;�������Ϊ0�����ʾ�Ѷ����ļ�����
    cmp p1,0
    ;������0������תL3�����Ƚ�p2
    jne L3
    ;�Ƚ�p2���ȣ����ҲΪ0����ʾ�ļ�1��2���Ѷ��꣬����ѭ��
    cmp p2,0
    je L5
    ;��p2������0�����ʾbuffer1Ϊ�գ�buffer2��Ϊ�գ�����һ�����ȣ���¼�к�
    invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    ;diffNum+1
    inc diffNum
    ;����ѭ��
    jmp L1
L3:
    ;�Ƚ�p2������Ϊ�����ʾp1��p2����Ϊ�գ�����strcmp�Ƚ�
    cmp p2,0
    jne L4
    ;��p2Ϊ�գ����ʾbuffer1��Ϊ�գ�buffer2Ϊ�գ�����һ�����ȣ���¼�к�
    invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    inc diffNum
    jmp L1
L4:
    ;����strcmp�Ƚ�
    invoke lstrcmp,offset szBuffer1,offset szBuffer2
    cmp eax,0
    ;��������ͬ������ѭ��
    je L1
    ;��֮��¼�к�
       invoke wsprintf,addr temMsg,addr szMsg,_line
    invoke lstrcat,addr opMsg,addr temMsg
    inc diffNum
    jmp L1

L5:
    ;ѭ���������رվ��
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






