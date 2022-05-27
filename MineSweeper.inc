;===================== Start 预定义说明 Start =====================
;--------------------------- 头文件声明 ---------------------------
		include windows.inc
        include user32.inc
        include kernel32.inc
        include comctl32.inc
        include masm32.inc
        include shell32.inc
        include winmm.inc
        include comdlg32.inc


;--------------------------- 引入库声明 ---------------------------
        includelib user32.lib
        includelib comctl32.lib
        includelib masm32.lib
        includelib winmm.lib
        includelib comdlg32.lib
		
;---------------------------- 常量声明 ----------------------------
		ID_NUM0			equ 300
		ID_NUM1			equ 301
		ID_NUM2			equ 302
		ID_NUM3			equ 303
		ID_NUM4			equ 304
		ID_NUM5			equ 305
		ID_NUM6			equ 306
		ID_NUM7			equ 307
		ID_NUM8			equ 308
		ID_NUM9			equ 309
		ID_NEG			equ 310
		ID_POINT		equ 311
		ID_MUL			equ 312
		ID_DIV			equ 313
		ID_SUB			equ 314
		ID_ADD			equ 315
		ID_EQU			equ 316
		ID_PER			equ 317
		ID_DAO			equ 318
		ID_SQRT			equ 319
		ID_MC			equ 320
		ID_MR			equ 321
		ID_MS			equ 322
		ID_MPLUS		equ 323
		ID_M			equ 324
		ID_BACK			equ 325
		ID_CE			equ 326
		ID_C			equ 327
		ID_RESULT		equ 328

		ID_SIN			equ 401
		ID_COS			equ 402
		ID_TAN			equ 403
		ID_MOD			equ 404


		ID_ADDA         equ 1001
		ID_ADDB         equ 1002
		ID_Implement    equ 1003
		ID_TextBox      equ 1004

		ID_COPY			equ 1001
		ID_PASTE		equ 1002
		ID_STANDARD		equ 1003
		ID_SCIENCE		equ 1004
		ID_PACKET		equ 1006
		ID_HELP			equ 1007
		ID_ABOUT		equ 1008
		ID_EXIT			equ 1009
		ID_SELECT		equ	1010
		ID_PLAY			equ	1011
		ID_STOP			equ	1012
		ID_NOTIFYICON	equ 2000
		WM_SHELLNOTIFY	equ WM_USER+1
;---------------------------- 函数声明 ----------------------------
		WinMain PROTO :DWORD, :DWORD, :DWORD,:DWORD		;窗口主程序
        MineSweeper PROTO :DWORD,:DWORD,:DWORD,:DWORD		;消息处理程序
        PackNum PROTO									;数字分组子程序
        UnpackNum PROTO									;数字不分组子程序
        BtnNum PROTO :DWORD								;数字按键消息处理程序
        ShowNum PROTO									;显示数据子程序
        ShowTextM PROTO									;显示存储信息子程序
		Init PROTO										;初始化计算器子程序
        GetResult PROTO									;计算结果子程序
		BtnOperator PROTO								;双目运算符消息处理程序
		BtnEqual PROTO									;等于消息处理程序
		PlayMidiFile PROTO :DWORD, :DWORD
		LoadFile PROTO :DWORD, :UINT
		Compare PROTO
		CreateMap PROTO :DWORD							;地图生成程序


;======================= End 预定义说明 End =======================
;===================== Start 数据段定义 Start =====================
    .data
	
		hInstance		dd	?					;主程序句柄
		hEdit			dd	?					;输出文本框句柄
		hTextM			dd	?					;记忆标签句柄
		hMenu			dd	?					;菜单句柄
		hIcon			dd	?					;Icon句柄
		DialogName		db	"MINESWEEPER",0		;对话框名称
		MenuName		db	"Menu",0			;菜单名称
		IconName		db	"Icon",0			;Icon名称
		TextM			db	'M',0				;M
		Output			db	"0.",0,30 dup(0)	;输出字符串
		IsStart			db	1					;判断是否运算开始
		HasPoint		db	0					;判断是否存在小数点
		HasEqueal		db	0					;判断是否存在等号
		Remember		dq	0.0					;记忆数据
		Number			dq	0.0					;记录临时数据
		Result			dq	0.0					;记录结果
		Operand			dq  0.0					;记录操作数
		IsPacket		db	0					;数字分组
		Operator		db	'.'					;记录运算符
		IsError			db	0					;记录是否出现异常
		Div0			db	"除数不能为零。",0
		FunctionError	db	"函数输入无效。",0
		hGlobal			HANDLE ?				;剪切板内存块句柄
		pGlobal			dd ?					;pointer to allocate memory
		NumLittle		REAL8	1.0E-12
		Num10			REAL8	10.0			;实数10
		Num100			REAL8	100.0			;实数100 
        FileFilter		db	"Mid Files (*.txt)",0,"*.txt",0	;文件名过滤
        MidDeviceID		dd	0
		szMIDISeqr		db	"Sequencer",0
		
		FilePathA		db	128 dup(0)			;文件A名称
		FilePathB		db	128 dup(0)			;文件B名称
		hFileA			dd	?					;文件A句柄
		hFileB		    dd	?					;文件B句柄
		szBuffer1			byte 100 dup(0)
		szBuffer2			byte 100 dup(0)
		 p1 dd ?
		 p2 dd ?
	
		MapRow		dd	10;	地图行数
		MapCol		dd	10;	地图列数
		
		

;======================= End 数据段定义 End =======================        