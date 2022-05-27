;===================== Start Ԥ����˵�� Start =====================
;--------------------------- ͷ�ļ����� ---------------------------
		include windows.inc
        include user32.inc
        include kernel32.inc
        include comctl32.inc
        include masm32.inc
        include shell32.inc
        include winmm.inc
        include comdlg32.inc


;--------------------------- ��������� ---------------------------
        includelib user32.lib
        includelib comctl32.lib
        includelib masm32.lib
        includelib winmm.lib
        includelib comdlg32.lib
		
;---------------------------- �������� ----------------------------
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
;---------------------------- �������� ----------------------------
		WinMain PROTO :DWORD, :DWORD, :DWORD,:DWORD		;����������
        MineSweeper PROTO :DWORD,:DWORD,:DWORD,:DWORD		;��Ϣ��������
        PackNum PROTO									;���ַ����ӳ���
        UnpackNum PROTO									;���ֲ������ӳ���
        BtnNum PROTO :DWORD								;���ְ�����Ϣ��������
        ShowNum PROTO									;��ʾ�����ӳ���
        ShowTextM PROTO									;��ʾ�洢��Ϣ�ӳ���
		Init PROTO										;��ʼ���������ӳ���
        GetResult PROTO									;�������ӳ���
		BtnOperator PROTO								;˫Ŀ�������Ϣ��������
		BtnEqual PROTO									;������Ϣ��������
		PlayMidiFile PROTO :DWORD, :DWORD
		LoadFile PROTO :DWORD, :UINT
		Compare PROTO
		CreateMap PROTO :DWORD							;��ͼ���ɳ���


;======================= End Ԥ����˵�� End =======================
;===================== Start ���ݶζ��� Start =====================
    .data
	
		hInstance		dd	?					;��������
		hEdit			dd	?					;����ı�����
		hTextM			dd	?					;�����ǩ���
		hMenu			dd	?					;�˵����
		hIcon			dd	?					;Icon���
		DialogName		db	"MINESWEEPER",0		;�Ի�������
		MenuName		db	"Menu",0			;�˵�����
		IconName		db	"Icon",0			;Icon����
		TextM			db	'M',0				;M
		Output			db	"0.",0,30 dup(0)	;����ַ���
		IsStart			db	1					;�ж��Ƿ����㿪ʼ
		HasPoint		db	0					;�ж��Ƿ����С����
		HasEqueal		db	0					;�ж��Ƿ���ڵȺ�
		Remember		dq	0.0					;��������
		Number			dq	0.0					;��¼��ʱ����
		Result			dq	0.0					;��¼���
		Operand			dq  0.0					;��¼������
		IsPacket		db	0					;���ַ���
		Operator		db	'.'					;��¼�����
		IsError			db	0					;��¼�Ƿ�����쳣
		Div0			db	"��������Ϊ�㡣",0
		FunctionError	db	"����������Ч��",0
		hGlobal			HANDLE ?				;���а��ڴ����
		pGlobal			dd ?					;pointer to allocate memory
		NumLittle		REAL8	1.0E-12
		Num10			REAL8	10.0			;ʵ��10
		Num100			REAL8	100.0			;ʵ��100 
        FileFilter		db	"Mid Files (*.txt)",0,"*.txt",0	;�ļ�������
        MidDeviceID		dd	0
		szMIDISeqr		db	"Sequencer",0
		
		FilePathA		db	128 dup(0)			;�ļ�A����
		FilePathB		db	128 dup(0)			;�ļ�B����
		hFileA			dd	?					;�ļ�A���
		hFileB		    dd	?					;�ļ�B���
		szBuffer1			byte 100 dup(0)
		szBuffer2			byte 100 dup(0)
		 p1 dd ?
		 p2 dd ?
	
		MapRow		dd	10;	��ͼ����
		MapCol		dd	10;	��ͼ����
		
		

;======================= End ���ݶζ��� End =======================        