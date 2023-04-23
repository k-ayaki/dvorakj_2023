Gui, Tab, 1

Gui, Add, Checkbox
        , x200 y40  vis_SandS gset_is_SandS Checked%is_SandS%
        , SandS: [Space] に [Shift] の機能も担わせる(&S)

Gui, Add, Checkbox
        , xp+0 yp+25 vis_US_keyboard gset_is_US_keyboard Checked%is_US_keyboard%
        , 101 キー（英語配列）のキーボードを使用している(&U)



Gui, Add, Checkbox
        , x200 y+40 vis_Muhenkan_Henkan gset_is_Muhenkan_Henkan Checked%is_Muhenkan_Henkan%
        , [無変換] + [文字] と [変換] + [文字](&M)

Gui, Add, Edit
        , xp+0 y+10 w%EditW% ReadOnly vFilePathOfUserShortcutKeyMuhenkanHenkan
        , % (FilePathOfUserShortcutKeyMuhenkanHenkan = "error") ? "未選択"
                                                                : FilePathOfUserShortcutKeyMuhenkanHenkan


Gui, Add, Button
        , x+10 yp-3 w50 gSelectingShortcutKeyMuhenkanHenkanSettingFile
        , 選択...


;; ========================================

Gui, Tab, 2

Gui, Add, GroupBox
        , x%GroupBoxX% y+40 w%GroupBoxW% R9
        , キー入力を待機する時間 (0---500 ミリ秒)

;;; テキストの配置
Gui, Add, text
        , xp+15 yp+20
        , 　※表示待機中に別のキーが押されたら
Gui, Add, text
        , xp+0 y+5
        , 　※それらのキーを同時に打鍵されたものとして処理する
Gui, Add, text
        , xp+0 y+5
        , 　※この設定は「順に打鍵する配列」使用時に無効となる


SliderW_simultaneous_stroke := SliderW - 70


;;; テキストの配置
Gui, Add, text
        , x200 yp+40
        , 直接入力

;;; スライドの配置
Gui, Add, Slider
        , xp+70 yp-5 w%SliderW_simultaneous_stroke% Range0-500 TickInterval50 Line10 ToolTipBottom vSimultaneousStroke_ENG_1 gset_SimultaneousStroke_ENG
        , % MaximalGT_ENG

;;; 編集欄の配置
Gui, Add, Edit
        , x+5 yp+0 w35 hwndMaximalGT_ENG vSimultaneousStroke_ENG_2 gset_SimultaneousStroke_ENG
        , % MaximalGT_ENG

        set_edit_cue_banner(MaximalGT_ENG, "40")

;;; テキストの配置
Gui, Add, text
        , xp+40 yp+5
        , ミリ秒


;;; テキストの配置
Gui, Add, text
        , x200 yp+50
        , 日本語入力

;;; スライドの配置
Gui, Add, Slider
        , xp+70 yp-5 w%SliderW_simultaneous_stroke% Range0-500 TickInterval50 Line10 ToolTipBottom vSimultaneousStroke_JPN_1 gset_SimultaneousStroke_JPN
        , % MaximalGT_JPN

;;; 編集欄の配置
Gui, Add, Edit
        , x+5 yp+0 w35 hwndMaximalGT_JPN vSimultaneousStroke_JPN_2 gset_SimultaneousStroke_JPN
        , % MaximalGT_JPN

        set_edit_cue_banner(MaximalGT_JPN, "40")
        
;;; テキストの配置
Gui, Add, text
        , xp+40 yp+5
        , ミリ秒


;;; key delay
Gui, Add, GroupBox
        , x%GroupBoxX% y+40 w%GroupBoxW% R5
        , キーを発行する際に遅延させる時間 (0---100 ミリ秒)

Gui, Add, text
        , xp+15 yp+20
        , 　※パソコンの性能やアプリケーションの負荷によっては

Gui, Add, text
        , xp+0 y+5
        , 　※遅延時間を長く設定しないと発行したキーが認識されない


;;; スライドの配置
Gui, Add, Slider
        , xp+5 yp+30 w%SliderW% Range0-100 TickInterval10 Line10 ToolTipBottom vkey_delay_1 gset_key_delay_1
        , % key_delay

;;; 編集欄の配置
Gui, Add, Edit 
        , x+5 yp+0 w35 hwndkey_delay vkey_delay_2 gset_key_delay_2
        , % key_delay

        set_edit_cue_banner(key_delay, "40")

;;; テキストの配置
Gui, Add, text
        , xp+40 yp+5
        , ミリ秒

;; ========================================

Gui, Tab, 3

    ;; GropBox ======================================== 
Gui, Add, GroupBox
        , x%GroupBoxX% y20 w%GroupBoxW% R2
        , IME の状態を検出する間隔 (50---500 ミリ秒)


;;; スライドの配置
Gui, Add, Slider
        , xp+15 yp+20 w%SliderW% Range50-500 TickInterval50 Line10 ToolTipBottom vIMEms_1 gset_IMEms_1
        , % IMEms

;;; 編集欄の配置
Gui, Add, Edit 
        , x+5 yp+0 w35 hwndIMEms vIMEms_2 gset_IMEms_2
        , % IMEms

        set_edit_cue_banner(IMEms, "50")

;;; テキストの配置
Gui, Add, text
        , xp+40 yp+5
        , ミリ秒


    ;; GropBox ======================================== 
Gui, Add, GroupBox
        , x%GroupBoxX% y+30 w%GroupBoxW% R4
        , IMEの利用

Gui, Add, Checkbox
        , xp+20 yp+20 vis_sending_by_way_of_WM_p gset_is_sending_by_way_of_WM_p Checked%is_sending_by_way_of_WM_p%
        , IME を経由せずに、特定の文字と記号を直接発行する(&I)

Gui, Add, Checkbox
        , xp+0 yp+25 vIs_skkime_mode gset_Is_skkime_mode Checked%Is_skkime_mode%
        , skkime を使用している(&S)

Gui, Add, Checkbox
        , xp+0 yp+25 vIs_googleime_mode gset_Is_googleime_mode Checked%Is_googleime_mode%
        , Google 日本語入力を使用している(&G)　※ローマ字入力がおかしくなる場合


    ;; GropBox ======================================== 
Gui, Add, GroupBox
        , x%GroupBoxX% y+30 w%GroupBoxW% R8
        , IME の状態の変更 （「直接入力」と「日本語入力」の切り替え）(&K)


;; 英語配列のキーボードの [~] は、日本語配列のキーボードの [全角] にあたる
;; どちらも sc029
IMEToggleKeysArr := Array("[Ctrl] + [Space] (&C)"
                        , "[Win] + [Space] (&W)"
                        , "[Alt] + [Space] (&A)"
                        , "[無変換] + [変換] と [変換] + [無変換] (&M)"
                        , "[Alt] + [~] (&Z)　　※101キー（英語配列）のキーボード用")

xpos := GroupBoxX + 20
Loop, % IMEToggleKeysArr._MaxIndex()
{
    b := IME_toggle_key_%A_Index%

    if ( A_Index = 1 )
    {
        Gui, Add, Checkbox
                , xp+20 yp+25 vIME_toggle_key_%A_Index% gset_IME_toggle_key_%A_Index% Checked%b%
                , % IMEToggleKeysArr[A_Index]
    }
    else
    {
        Gui, Add, Checkbox
                , x%xpos% y+15 vIME_toggle_key_%A_Index% gset_IME_toggle_key_%A_Index% Checked%b%
                , % IMEToggleKeysArr[A_Index]
    }
}

;; ========================================

Gui, Tab, 4


Gui, Add, GroupBox
        , x%GroupBoxX% y20 w%GroupBoxW% R6
        , 修飾キーを押し下げている場合に QWERTY 配列を使用する


Gui, Add, Checkbox
        , xp+20 yp+30 vis_Using_QWERTY_with_CTRL gset_is_Using_QWERTY_with_CTRL Checked%is_Using_QWERTY_with_CTRL%
        , [Ctrl](&C)

Gui, Add, Checkbox
        , xp+0 yp+30 vis_Using_QWERTY_with_Alt gset_is_Using_QWERTY_with_Alt Checked%is_Using_QWERTY_with_Alt%
        , [Alt](&A)

Gui, Add, Checkbox
        , xp+0 yp+30 vis_Using_QWERTY_with_Win gset_is_Using_QWERTY_with_Win Checked%is_Using_QWERTY_with_Win%
        , [Win](&W)



Gui, Add, Checkbox
        , x200 y+50 vis_User_Shortcut_Key gset_is_User_Shortcut_Key Checked%is_User_Shortcut_Key%
        , 独自のショートカットキー(&S)


Gui, Add, Edit
        , xp+0 y+10 w%EditW% R1 ReadOnly vFilePathOfUserShortcutKey
        , % (FilePathOfUserShortcutKey = "error") ? "未選択"
                                                  : FilePathOfUserShortcutKey

Gui, Add, Button
        , x+10 yp-3 w50 gSelectingShortcutKeySettingFile
        , 選択...

