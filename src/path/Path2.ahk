/************************************************************************
    ファイルパス関数群 2 
    実在のパスを探す系 (全角ダメ文字問題も一応考慮)
     ※ AHKでのダメ文字問題は Loop(files) などの 文字列切出し関係で起こる。
        IfExist / FileExist()での判定自体は問題ない。

       グローバル変数 : なし
       各関数の依存性 : なし(必要関数だけ切出してコピペでも使えます)

    AHKL Ver:       1.1.08.01
    Language:       Japanease
    Platform:       Win NT (psapi.DLL使用)
    Author:         eamat.

 ************************************************************************
    2009.01.23  Path2_ExtractPath()
       "c:\program files\hoge.txt  - メモ帳" のような場合の取得対応
    2009.01.18  Path2_GetTempFileName()
    2009.07.01  Path2_ExtractPath() RegEx調整他
    2009.07.26  Path2_GetTempFileName() コメント修正他
    2009.10.23  _Path2_sample() 追加
    2012.11.11  Path2_ProcessExeNameNT() → Path2_GetExecutablePath() 名称変更
                U64対応

*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;
;; ; 動作確認用 内部ルーチン 
;; ;  単体起動時のテスト用なので削除しても問題なし
;; _Path2_AutoExecute_Sample:
;;     _Path2_sample()
;; ;    _Path2_test()
;; return

;; _Path2_sample() {
;;    buf := "c:\予定表\予\予定表.xls"

;;    ;APIやRegExチェックが面倒な時は、
;;    ;ファイルパスにもSJISにも被らない記号に一旦変換する
;;    buf := RegExReplace(buf,"(?<=[^\x80-\x9F\xE0-\xFC])\\","|") ;\ を | に変更
;;    Loop,parse,buf,|
;;    {
;;         msgbox,%A_LoopField%
;;    }
;; }

;; _Path2_test()   {
;;     ;--- 有効パスサーチ関数 のテスト ---
;;     p := A_WinDir " """ A_ProgramFiles """ [" A_Temp "] " A_WinDir " " A_WinDir
;;       .  "`n      " . A_AppDataCommon "  - メモ帳"
;;       .  "`n      Notepad - " . A_AppData
;;     a := Path2_ExtractPath(p)
;;     b := Path2_ExtractPath(p,2)
;;     c := Path2_ExtractPath(p,"ALL")
;;     msg := "Path2_ExtractPath(Target="",Multi=0)`n`n"
;;         .  "対象文字列`n --> " p "`n`n"
;;         .  "通常は最初に見つかったパスを返します。`n'" a "'`n`n"
;;         .  "Multi=nでn番目に見つかったパスを返します。`n(Multi=2の場合) : " b "`n`n"
;;         .  "Multi=ALL指定時は 改行区切りで列挙して返します。`n" c "`n`n"
;;     msgbox,1,有効パスサーチ`関数 のテスト,%msg%
;;     IfMsgBox,Cancel,    return

;;     ;--- 起動中プロセスの取得関数のテスト ---
;;     p   := Path2_GetExecutablePath()
;;     msg := "Path2_GetExecutablePath(pid=0,WinTitle=""A"")`n`n"
;;         .  "PID指定なしでアクティブウィンドウのパスを返します。`n  -> " . p . "`n`n`n"
;;     p2  := Path2_GetCommandLine()
;;     msg .= "Path2_GetCommandLine(pid=0,WinTitle=""A"")`n`n"
;;         .  "PID指定なしでアクティブウィンドウのコマンドラインを返します。`n  -> " .  p2
;;     msgbox,1,起動中プロセスの取得関数のテスト,%msg%
;;     IfMsgBox,Cancel,    return

;;     ;--- テンポラリファイル作成のテスト ---
;;     p   := Path2_GetTempFileName()
;;     msg := "Path2_GetTempFileName(TargetDir="""",PrefixString=""ahk"")`n`n"
;;         .  "指定のディレクトリにテンポラリファイルを作成します。`n  -> "
;;         .  p "`n"
;;     msgbox,1,テンポラリファイル作成のテスト,%msg%
;;     IfMsgBox,Cancel,    return
;;     if (p)
;;         FileDelete,%p%  ;一応後始末

;;     ;--- ファイルドロップ関数のテスト ---
;;     Run,notepad,,,pid
;;     msg := "Path2_DropFiles(hwnd,fnames)`n`n"
;;         .  "指定されたハンドルのウィンドウにファイルをドロップします`n"
;;         .  "とりあえずメモ帳にこのファイルをドロップしてみます`n"
;;     msgbox,4096,ファイルドロップ関数のテスト,%msg%
;;     WinActivate,ahk_pid %pid%
;;     WinWaitActive,ahk_class Notepad
;;     Path2_DropFiles("",A_LineFile)
;; }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;---------------------------------------------------------------------------
;  汎用関数

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; テンポラリファイルを作成し名前を返す。(winAPI GetTempFileName使用)
;     対象： AHK v1.0.34以降
;       TargetDir    : ファイルを作成するディレクトリ (省略時 A_temp)
;       PrefixString : ファイル接頭語(3文字以内）     (省略時 ahk)
;       リターン値 テンポラリフォルダパス(エラー時:0)
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_GetTempFileName(TargetDir="",PrefixString="ahk")  {
    TargetDir := (!TargetDir) ? A_temp : TargetDir
    if (Instr(FileExist(TargetDir),"D"))
        FileCreateDir,%TargetDir%
    VarSetCapacity(TempFileName , 260)
    ret := Dllcall("GetTempFileName",Str ,TargetDir
                                    ,Str ,SubStr(PrefixString,1,3)
                                    ,UInt,0
                                    ,Str ,TempFileName, Uint)
    return (!ret) ? ret : TempFileName
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; プロセスID or WinTitle を指定して実行ファイルパスを得る
;   対象： AHKL v1.1.08.01
;      in  pid      : プロセスID(省略時 WinTitleが対象となる)
;          WinTitle : 対象Window(pid未設定時に適用、省略時アクティブウィンドウ)
;   戻り値 : 実行ファイルパス
;
; (旧) Path2_ProcessExeNameNT()
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_GetExecutablePath(pid=0,WinTitle="A"){
    if (!pid)
        WinGet,pid,PID,%WinTitle%

	;WinGet版 (v1.1.01+)
	WinGet,path,ProcessPath,ahk_pid %pid%
	Return path
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;  プロセスID or WinTitle を指定してコマンドラインを取得
;      in  pid      : プロセスID(省略時 WinTitleが対象となる)
;          WinTitle : 対象Window(pid未設定時に適用、省略時アクティブウィンドウ)
;   戻り値 : 実行ファイルパス
;
;	※ GetCommandLineAのアドレスを取る方式は Unicode移行で使用不能？
;	   修正が大変なため、COM Object方式に変更
;
;	参考) Autohotkey スレ part11の 735
;		  http://www.wmifun.net/library/win32_process.html
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_GetCommandLine(pid=0,WinTitle="A"){
    if (!pid)
        WinGet,pid,PID,%WinTitle%

	;COM Objects使用 (AHK_L 53+) 
	For process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId = " . pid)
		Return process.CommandLine
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   ファイルドロップ関数    by 流行らせるページ管理人
;   指定ウィンドウへのファイルドロップを発生させる
;   引数
;       hwnd     : 指定されたウィンドウに
;       fnames   : ファイルをドロップする(複数対応：改行区切り)
;       WinTitle : 対象Window(hwnd未設定時に適用、省略時アクティブウィンドウ)
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_DropFiles(hwnd="",fnames="", WinTitle="A")    {
;   参考： http://lukewarm.s101.xrea.com/myscripts/index.html
;   U対応: http://www.autohotkey.com/board/topic/79145-help-converting-ahk-ahk-l/

    hwnd := (!hwnd) ? WinExist(WinTitle) : hwnd

	fns:=RegExReplace(fnames,"\n$") 
	fns:=RegExReplace(fns,"^\n") 
	hDrop:=DllCall("GlobalAlloc", UInt,0x42, UPtr,20+StrLen(fns)+2) 
	p:=DllCall("GlobalLock", UPtr,hDrop) 
	NumPut(20, p+0)  ;offset 
	NumPut(x,  p+4)  ;pt.x 
	NumPut(y,  p+8)  ;pt.y 
	NumPut(0,  p+12) ;fNC 
	NumPut(0,  p+16) ;fWide 
	p2:=p+20 
	Loop,Parse,fns,`n,`r 
	{ 
	  DllCall("RtlMoveMemory", UPtr,p2, AStr,A_LoopField, UPtr,StrLen(A_LoopField)) 
	  p2+=StrLen(A_LoopField)+1 
	} 
	DllCall("GlobalUnlock", UPtr,hDrop) 
	PostMessage,0x233,%hDrop%,0,,ahk_id %hwnd%
}

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   有効パスを抽出して返す (ダメ文字考慮改訂版)  2009.07.01
;
;     対象： AHK v1.0.48以降(While-loop使用)
;       in  Target : 対象文字列(省略時:アクティブウィンドウタイトル)
;           Multi  : n(数値)= n個に見つかったパスを返す(デフォルト:1)
;                    ALL    = 有効パスが複数あるとき改行区切りで全部返す
;       戻り値  パス情報
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_ExtractPath(Target="",Multi=1)    {
    ifEqual Target,,   WinGetTitle,Target,A

    ;--- RegEx判定用定義 ---
    ;対応する括弧 (<> と " " は↑の無効文字で対応)
    ;   []{}の全角誤爆問題は対策できてるはず
    reg := "\((.*?)\)|'(.*?)'"
         . "|(?<=^|[^\x80-\x9F\xE0-\xFC])\[(.*?[^\x80-\x9F\xE0-\xFC])\]"
         . "|(?<=^|[^\x80-\x9F\xE0-\xFC])\{(.*?[^\x80-\x9F\xE0-\xFC])\}"
         . "|（(.*?)）|「(.*?)」|｛(.*?)｝|『(.*?)』|【(.*?)】|［(.*?)］"
         . "|‘(.*?)’|“(.*?)”|〔(.*?)〕|〈(.*?)〉|《(.*?)》|＜(.*?)＞"
         . "|｀(.*?)´|｢(.*?)｣"
    ;空白Trim用
    Trim := "im)^(?: |　)*(.*?)(?: |　)*$"

    ;--- パスとして無効な文字列で分割 ---
    Target := RegExReplace(Target, "im)" 
           . "(\x22|\x2C|(?<=^|[^\x80-\x9F\xE0-\xFC])\||;|<|>|/|\*|\?|\t|`r|`n)"
           , "`n")
    Loop,Parse,Target,`n
    {   ;--- パス判定 ---
        str := !FileExist(A_LoopField) ? RegExReplace(A_LoopField, Trim,"$1") 
               : A_LoopField
        found := FileExist(str) ? str "`n" : "" , str_sav := str

        ;空白区切り or 対応する括弧でチェック 例) [c:\hoge.txt] - AppName
        If (!found)    {
            p="dmy"
            While (p)   {   ;抽出
                ss := (!p:=RegExMatch(str,"im)" reg "|(?P<sp>(?: |　)+)", $)) 
                    ? str : ""
                if (p) && ($sp) {             ;空白が先に見つかった時
                    ss  := SubStr(str,1,p-1)
                    str := SubStr(str,p+strlen($sp),strlen(str)-p)
                }else if (p) && (!$sp)   {    ;対応する括弧が見つかった時
                    While !ss
                        ss:=$%A_Index%
                    str := SubStr(str,p+strlen($),strlen(str)-p)
                }
                ;パス判定
                found .= FileExist(ss) ? ss "`n" 
                      :  FileExist(ss:=RegExReplace(ss, Trim,"$1")) ? ss "`n"
                      : ""
            }
        }

        ;見つからなかったら空白区切りで左右から削ってってみる。2009.01.23
        ; 例1) c:\program files\hoge.txt  - メモ帳
        ; 例2) Notepad -  c:\program files\hoge.txt
        ; × aaa - c:\program files\hoge - bbb  みたいなのは対応できない。
        If (!found) && Instr(str_sav," "){
            Loop,2  {
                ifNotEqual,found,,  break
                str := str_sav
                ph := A_Index   ; ph1:右から削る ph2:左から削る
                While (pos:=(ph=1) ? Instr(str," ",False, 0) : Instr(str," ")){
                    str := RegExReplace((ph=1) ? SubStr(str,1,pos-1) 
                           : SubStr(str,pos+1),"^\s*(.+?)\s*$","$1")
                    found .= FileExist(str) ? str . "`n" : ""
                    ifNotEqual,found,,  break
                }
            }
        }
        foundAll .= found
    }

    if (Multi = "ALL")
        return SubStr(foundAll,1,StrLen(foundAll)-1)
    return RegExReplace(foundAll,"m`n)(?:.*`n){" Multi-1 "}(.*$)(?:.*`n)*","$1")
}

/************** 旧版 使用停止 **********************************************

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; プロセスID or WinTitle を指定して実行ファイルパスを得る
;   対象： NT系 /  AHK v1.0.34以降
;      in  pid      : プロセスID(省略時 WinTitleが対象となる)
;          WinTitle : 対象Window(pid未設定時に適用、省略時アクティブウィンドウ)
;   戻り値 : 実行ファイルパス
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_ProcessExeNameNT(pid=0,WinTitle="A")  {
;   参考： http://cgi19.plala.or.jp/lukewarm/news/2005_05.html#14
;   by 流行らせるページ管理人 (ほぼそのまま)

    if (!pid)
        WinGet,pid,PID,%WinTitle%       ;2008.12.10 追加

    hModule := dwNeed := l := 0
    max:=VarSetCapacity(s,256)

    ; プロセスのハンドルを取り出す PROCESS_ALL_ACCESS:=0x001F0FFF
    hProcess := DllCall("OpenProcess", UInt,0x001F0FFF, Int,0, UInt,pid, Int)

    ; このプロセスの全てのモジュールのリストの最初の1個を取得する
    ; BOOL EnumProcessModules(HANDLE hProcess, MODULE *lphModule, DWORD cb,
    ;                          LPDWORD lpcbNeeded);
    if (DllCall("psapi\EnumProcessModules",Int  ,hProcess
                                          ,IntP ,hModule
                                          ,Int  ,4
                                          ,UIntP,dwNeed, Int))    {
        ; DWORD GetModuleFileNameEx(HANDLE hProcess, HMODULE hModule, LPTSTR FileName, DWORD FileNameSize);
        l:=DllCall("psapi\GetModuleFileNameExA",Int,hProcess
                                               ,Int,hModule
                                               ,Str,s
                                               ,Int,max, Int)
    }
    DllCall("psapi\CloseProcess", Int,hProcess)     ;開けたら閉める
    return SubStr(s,1,l)
}
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;  プロセスID or WinTitle を指定してコマンドラインを取得
;      in  pid      : プロセスID(省略時 WinTitleが対象となる)
;          WinTitle : 対象Window(pid未設定時に適用、省略時アクティブウィンドウ)
;   戻り値 : 実行ファイルパス
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Path2_GetCommandLine(pid=0,WinTitle="A"){

;  参考：流行らせるページ管理人氏 の MouseGesture2 スクリプト内
;        MG_CommandLine()より (ほぼそのまま)
; http://lukewarm.s101.xrea.com/myscripts/mousegesture/index.html

    if (!pid)
        WinGet,pid,PID,%WinTitle%       ;2008.12.14 追加

    ; kernel32\GetCommandLineA のアドレスへのポインタを設定?
    ptr:=(NumGet(DllCall("kernel32.dll\GetProcAddress"
          ,UInt,DllCall("kernel32.dll\GetModuleHandle",Str,"Kernel32")
          ,Str ,"GetCommandLineA",UInt)+1))

    ; プロセスのハンドルを取り出す
    hp:=DllCall("kernel32.dll\OpenProcess",UInt,0x001F0FFF,UInt,0,UInt,pid,UInt)
    VarSetCapacity(res,1024)

    ; GetCommandLineのメモリアドレスを取得してからコマンドライン文字列を取得
    DllCall("kernel32.dll\ReadProcessMemory" ,UInt ,hp
                                             ,UInt ,ptr
                                             ,UIntP,addr
                                             ,UInt ,4
                                             ,UInt ,0)
    DllCall("kernel32.dll\ReadProcessMemory" ,UInt,hp
                                             ,UInt,addr
                                             ,Str,res
                                             ,UInt,1024
                                             ,UInt,0)

    DllCall("psapi\CloseProcess", UInt,hp)  ;開けたら閉める
    return res
}
