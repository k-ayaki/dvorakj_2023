; Redirect Scrool Function  スクロール制御
;   ・加速対応
;   ・Word / Excel / VBE / 秀丸等の分割ペインも互換スクロールで操作可能
;
;   単体 / 組込み両対応  2008/05/25 (AutoHotkey 1.0.47.06)
;   組込み時 
;     #Include WheelScroll.ahk
;     Gosub,WheelInit             ;初期化 :AutoExecuteセクションに記述
;---------------------------------------------------------------------------


;==============================================
;     Functions
;==============================================
WheelRedirect(mode=0,dir="")
;-------------------------------------------------------------
;   ホイールリダイレクト
;   mode 0:縦スクロール  1:横スクロール (省略時:縦)
;   dir  0:UP(LEFT)      1:DOWN(RIGHT)  (省略時:ホイール準拠)
;-------------------------------------------------------------
{
;-------------------------------------------------------
;   初期化
;-------------------------------------------------------
    ;--- オプション ---
    static DefaultScrollMode = 0           ;基本動作モード  0:WHELL 1:互換SCROLL
    static AcclSpeed         = 0           ;加速時の倍率(0で加速OFF)
    static AcclTOut          = 0           ;加速タイムアウト値(ms)
    static ScrlCount         := 1           ;互換スクロール行数

    ;ホイールで動かすコントロールのクラスリスト
    static MouseWhellList := "MozillaWindowClass,Edit"

    ;互換モードで動かすコントロールのクラスリスト
    static VScroolList :=
                            (LTrim C Join,
                                "
                                MdiClient            ;MDI親 (MS-Accessなど)
                                VbaWindow            ;VisualBasicEditor
                                 _WwB                 ;MS-Word(編集領域全体)
                                Excel7               ;MS-Excel
                                ;;;;;  OModule       ;MS-Access97   2008.05.20
                                "
                            )


    ;MDI事前アクティブ化リスト (ｱｸﾃｨﾌﾞ子ｳｨﾝﾄﾞｳのみﾊﾞｰがあるｱﾌﾟﾘなど)
    static MdiActivateList := "Excel7"            ;MS-Excel

    ;--- 互換モード カスタム動作 ---
    ;無視リスト(バイパスして親コントロールを制御する)
    static BypassCtlList :=
                            (LTrim C Join,
                                "
                                 ScrollBar         ;スクロールバー本体
                                  _WwG              ;MS-Word分割ペイン(一つ上の_WwBで制御)
                                "
                            )

    ;禁止リスト：ｽｸﾛｰﾙﾊﾝﾄﾞﾙが取れない時は、互換モードを使用しない
    static NullShwndTabooList := "Excel7"         ;MS-Excel(クラッシュ対策)

    ;---- 横スクロール カスタム動作 ---
    ;横スクロール除外リスト
    static HDisavledList := ""


    CoordMode,Mouse,Screen
    MouseGetPos,mx,my,hwnd,ctrl,3
    WinGetClass,wcls, ahk_id %hwnd%
    SendMessage,0x84,0,% (my<<16)|mx,,ahk_id %ctrl% ;WM_NCHITTEST
    If (ErrorLevel = 0xFFFFFFFF)
        MouseGetPos,,,,ctrl,2
    ifEqual,ctrl,,  SetEnv,ctrl,%hwnd%              ;2008.05.25
    WinGetClass,ccls,ahk_id %ctrl%

    ;; 横スクロール時のみ
    ;; バイパスして親コントロールを制御する
    if ( mode = 1 )
    {
        ;無視リストチェック：1階層上のコントロールを制御対象とする
        ifInString, BypassCtlList, %ccls%
        {
            ctrl := DllCall("GetParent",UInt,ctrl, UInt)
            WinGetClass,ccls,ahk_id %ctrl%
        }
    }

    ;MDI事前アクティブ化リストチェック : 非ｱｸﾃｨﾌﾞ子ｳｨﾝﾄﾞｳをｱｸﾃｨﾌﾞ化
    if ccls in %MdiActivateList%
    {
        MdiClient := DllCall("GetParent",UInt,ctrl, UInt)
        SendMessage, 0x229, 0,0,,ahk_id %MdiClient% ;WM_MDIGETACTIVE
        if (ctrl != ErrorLevel) {
            if(ccls = "Excel7")     {               ;Excelカスタム
                WinActivate, ahk_id %hwnd%
                MouseClick,Left
            }
            Else    PostMessage,0x222, %ctrl%,0,,ahk_id %MdiClient%
        }
    }
    scnt := GetScrollBarHwnd(shwnd,mx,my,ctrl,mode) ;ｽｸﾛｰﾙﾊﾝﾄﾞﾙ取得

    ;スクロール動作指定
    scmode := DefaultScrollMode<<1 | mode
    if ccls in %HDisavledList%          ;横スクロール禁止
        scmode &= 0x10
    if ccls in %MouseWhellList%         ;ホイールモード
        scmode &= 0x01
    if ccls in %VScroolList%            ;互換モード
    {
        ;; Shift を実際に押しているときのみ互換モードに移行する
        if ( GetKeyState("Shift", "P") )
            scmode |= 0x10
    }
    
    if (!shwnd) {                       ;互換モード禁止リスト
        if ccls in %NullShwndTabooList%
            scmode  = 0
    }

    if (!scmode)
        MOUSEWHELL(dir)
    Else    
        SCROLL(ctrl,mode,shwnd,dir,ScrlCount,AcclSpeed,AcclTOut)
}

GetScrollBarHwnd(byref shwnd, mx,my,Cntlhwnd,mode=0)
;----------------------------------------------------------------------------
; 該当コントロールのスクロールハンドルを返す
;   戻り値 指定方向のスクロールオブジェクト数
;   out    shwnd       スクロールハンドル格納先
;   in     mx,my       マウス位置
;          Cntlhwnd    対象コントロールのハンドル
;          mode        0:VSCROLL(縦) 1:HSCROLL(横)
;----------------------------------------------------------------------------
{
    ;兄弟スクロールバー : ｽｸﾛｰﾙﾊﾞｰが配下ではなく同列にあるｱﾌﾟﾘ
    static BrotherScroolBarList := "TkfInnerView.UnicodeClass"    ;萌ディタ


    shwnd = 0
    WinGet,lst,ControlList,ahk_id %Cntlhwnd%
    WinGetClass,pcls, ahk_id %Cntlhwnd%

    ;配下にスクロールバーなし
    ifNotInString, lst, ScrollBar
    {   ;兄弟指定がある場合は、自分と同列のスクロールバーを探す
        if pcls in %BrotherScroolBarList%
        {
            Cntlhwnd := DllCall("GetParent",UInt,Cntlhwnd, UInt)
            WinGet,lst,ControlList,ahk_id %Cntlhwnd%
            WinGetClass,pcls, ahk_id %Cntlhwnd%
        }
        else return 0
    }

    ;スクロールバーコントロールの抽出
    vcnt = 0
    hcnt = 0
    Loop,Parse,lst,`n
    {
        ifNotInstring A_LoopField , ScrollBar
            Continue
        ControlGet,hwnd, Hwnd,,%A_LoopField%,ahk_id %Cntlhwnd%
        WinGetpos, sx,sy,sw,sh, ahk_id %hwnd%

        if (sw < sh)    {   ;縦スクロール
            vcnt++
            WinGetpos, vx%vcnt%,vy%vcnt%,vw%vcnt%,vh%vcnt%, ahk_id %hwnd%
            if (vi = "")
            || ((vy%vi%!=sy)&&((sy<my)&&(vy%vi%<sy))||((vy%vi%>my)&&(vy%vi%>sy))) ;上下分割
            || ((vx%vi%!=sx)&&((sx>mx)&&(vx%vi%>sx))||((vx%vi%<mx)&&(vx%vi%<sx))) ;左右分割
            {
                vi := vcnt
                if (mode = 0)   {
                    ret   := vcnt
                    shwnd := hwnd
                }
            }
        }
        if (sw > sh)    {   ;横スクロール
            hcnt++
            WinGetpos, hx%hcnt%,hy%hcnt%,hw%hcnt%,hh%hcnt%, ahk_id %hwnd%
            if (hi = "")
            || ((hx%hi%!=sx)&&((sx<mx)&&(hx%hi%<sx))||((hx%hi%>mx)&&(hx%hi%>sx)))           ;左右(Excel型)
            || ((hy%hi%!=sy)&&((sy+sh>my)&&(hy%hi%>sy))||((hy%hi%+hh%hi%<my)&&(hy%hi%<sy))) ;上下(Word型)
            {
                hi := hcnt
                if (mode = 1)   {
                    ret   := hcnt
                    shwnd := hwnd
                }
            }
        }
    }

    ;---アクティブペインにしかバーがないアプリ、可能ならペインを切り替える---
    ;[秀丸]用 カスタム：分割ウィンドウ切り替え
    if (pcls = "HM32CLIENT") && !((vy1 <= my) && (vy1+vh1 >= my))
        PostMessage, 0x111, 142,  0, ,ahk_id %Cntlhwnd%   ;WM_COMMAND
    ;------------------------------------------------------------------------

    return ret
}

;------ MouseClick Scrool Control ------------------------------------------

MOUSEWHELL(dir="")
;----------------------------------------------------------------------------
; MouseClick によるスクロール
;       dir         前後方向 0:UP 1:DOWN
;;----------------------------------------------------------------------------
{
    if ( dir = 1 )
        MouseClick, WheelDown
    else
        MouseClick, WheelUp
}

;------ PostMessage Scrool Control ------------------------------------------

SCROLL(hwnd,mode=0,shwnd=0,dir="", ScrlCnt=1,ASpeed=0,ATOut=300)
;----------------------------------------------------------
; WM_SCROLLによる任意コントロールスクロール
;       hwnd        該当コントロールのウィンドウハンドル
;       mode        0:VSCROLL(縦) 1:HSCROLL(横)
;       shwnd       スクロールバーのハンドル
;       dir         前後方向 0:SB_LINEUP/LEFT 1:SB_LINEDOWN/RIGHT
;
;       ScrlCnt      :スクロール行数
;       ASpeed       :加速時の倍率(0で加速OFF)
;       ATOut        :加速タイムアウト値(ms)
;----------------------------------------------------------
{
    static ACount

    ;加速
    If (A_PriorHotkey <> A_ThisHotkey) || (ATOut < A_TimeSincePriorHotkey) 
       || (0 >= ASpeed)
        ACount := ScrlCnt
    Else
        ACount += ScrlCnt * ASpeed

    ;wParam: 方向
    if (dir = "")
    {
        ifInstring A_ThisHotkey, WheelUp
             dir = 0                        ;SB_LINEUP   / SB_LINELEFT
        Else dir = 1                        ;SB_LINEDOWN / SB_LINERIGHT
    }
    
    ;0x114:WM_HSCROLL  0x115:WM_VSCROLL
    msg := 0x115 - mode


    Loop, %ACount%
        PostMessage, %msg%, %dir%, %shwnd%, , ahk_id %hwnd%
    PostMessage, %msg%, 8, %shwnd%, , ahk_id %hwnd% ;SB_ENDSCROLL
}

