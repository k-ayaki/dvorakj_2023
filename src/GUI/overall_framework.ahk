;;; ============================================================================
;;; ---------------- フォントサイズに応じて設定項目の大きさを変更する
;;; ============================================================================

bLargerScale := ( 100 < GetDPI() ) ? 1
             :   0

TreeViewR := ( bLargerScale ) ? "R21"
          :                     "R26"


GroupBoxX := 180
GroupBoxW := ( bLargerScale ) ? 470
:                     400

GroupBoxH := "R3"

EditW := ( bLargerScale ) ? 370
:                     300

DoubleGroupBoxX := 190
DoubleGroupBoxW := ( bLargerScale ) ? 450
:                     380

SliderW := ( bLargerScale ) ? 370
        :                     290


LayoutGroupBoxW := ( bLargerScale ) ? 305
                :                     265

LayoutGroupBoxH := ( bLargerScale ) ? "R1"
                :                     "R1.4"

LayoutGroupBoxY := ( bLargerScale ) ? 410
                :                     400

LayoutTextY := LayoutGroupBoxY + 20
LayoutTextW := LayoutGroupBoxW - 20



RunButtonX := ( bLargerScale ) ? 340
           :                     360

RunButtonY := ( bLargerScale ) ? 460
           :                     440

RunButtonH := ( bLargerScale ) ? "R2"
           :                     "R3"


TabW := ( bLargerScale ) ? 490
     :                     420

TabH := ( bLargerScale ) ? "R19"
     :                     "R21"


SpecialKeyW := ( bLargerScale ) ? 125
            :                     110


GuiH := ( bLargerScale ) ? 500
     :                     480

GuiW := ( bLargerScale ) ? 670
     :                     600



set_GUI_name_of_EnglishLayout()
set_GUI_name_of_JapaneseLayout()



set_GUI_name_of_EnglishLayout() {
    global 

    name_of_EnglishLayout := get_filename_without_extension( FilePathOfUserEnglishLayout )

    ;; 設定ファイルの相対パスを更新する
    GuiControl, Text, FilePathOfUserEnglishLayout, % FilePathOfUserEnglishLayout

    ;; 設定ウィンドウ内の表示を更新する
    GuiControl, Text, name_of_EnglishLayout, % name_of_EnglishLayout

    return
}

set_GUI_name_of_JapaneseLayout() {
    global 

    name_of_JapaneseLayout := get_filename_without_extension( FilePathOfUserJapaneseLayout )

    name_of_JapaneseLayout := (nJapaneseLayoutMode = 1) ? "日本語入力を常に使用しない"
                           :  (nJapaneseLayoutMode = 3) ? "常に「" . name_of_JapaneseLayout . "」を使用する"
                           :  name_of_JapaneseLayout


    ; かな入力のときには、［かな］を末尾に表示
    If ( Is_kana_typing_mode ) {
        name_of_JapaneseLayout .= "［かな］"
    }

    ; skkime 入力のときには、[skkime]を末尾に表示
    If ( Is_skkime_mode ) {
        name_of_JapaneseLayout .= " [skkime]"
    }

    ; googleime 入力のときには、[googleime]を末尾に表示
    If ( Is_googleime_mode ) {
        name_of_JapaneseLayout .= " [google]"
    }


    ;; 設定ファイルの相対パスを更新する
    GuiControl, Text, FilePathOfUserJapaneseLayout, % FilePathOfUserJapaneseLayout

    ;; 設定ウィンドウ内の表示を更新する
    GuiControl, Text, name_of_JapaneseLayout, % name_of_JapaneseLayout

    ;;; ツールチップ内の表示を更新する
    Menu, Tray, Tip
        , 
            (LTrim
                %name_of_EnglishLayout%
                %name_of_JapaneseLayout%
            )

    return
}




;;; ============================================================================
;;; ---------------- TreeView
;;; ============================================================================

Gui, Add, TreeView
        , AltSubmit x10 y15 %TreeViewR% W150 gChange_state_of_treeview

P1 :=TV_Add("キーボード", 0, "Expand")
    P1_1 := TV_Add("入力全般", P1, "Expand")
    P1_1_1 := TV_Add("SandS など", P1_1)
    P1_1_2 := TV_Add("待機と遅延", P1_1)
    P1_1_3 := TV_Add("IME 関連", P1_1)
    P1_1_4 := TV_Add("修飾キー関連", P1_1)

    P1_2 := TV_Add("直接入力", P1)
    P1_3 := TV_Add("日本語入力", P1)

    P1_4 := TV_Add("単一キー", P1, "Expand")
    P1_4_1 := TV_Add("[Esc] など", P1_4)
    P1_4_2 := TV_Add("[Enter] など", P1_4)
    P1_4_3 := TV_Add("[Win]", P1_4)
    P1_4_4 := TV_Add("[無変換] など", P1_4)
    P1_4_5 := TV_Add("カーソルキー", P1_4)
    P1_4_6 := TV_Add("[Home] など", P1_4)
    P1_4_7 := TV_Add("[Insert] など", P1_4)
    P1_4_8 := TV_Add("[Pause] など", P1_4)
    P1_4_9 := TV_Add("ファンクションキー", P1_4)
    P1_4_10 := TV_Add("テンキー", P1_4)

P2 :=TV_Add("マウス")
P3 :=TV_Add("その他", 0, "Expand")
    p3_1 := TV_Add("起動時の設定", p3)
    p3_2 := TV_Add("起動時の自動実行", p3)
    p3_3 := TV_Add("ホットキー", p3)
    p3_4 := TV_Add("画面", p3)

treeview_id_arr := Array( P1 ; , 1)
                        , P1_1_2 ; , 2)
                        , P1_1_3 ; , 3)
                        , P1_1_4 ; , 4)
                        , P1_2 ; , 5)
                        , P1_3 ; , 6)
                        , P1_4 ; , 7)
                        , P1_4_2 ; , 8)
                        , P1_4_3 ; , 9)
                        , P1_4_4 ; , 10)
                        , P1_4_5 ; , 11)
                        , P1_4_6 ; , 12)
                        , P1_4_7 ; , 13)
                        , P1_4_8 ; , 14)
                        , P1_4_9 ; , 15)
                        , P1_4_10 ; , 16)
                        , p2 ; , 17)
                        , p3 ; , 18)
                        , p3_1  ;, 18
                        , p3_2  ; 19
                        , p3_3 ;20
                        , p3_4) ;21

;;; ============================================================================
;;; ---------------- 設定ウィンドウの下部に使用しているキーボード配列名を表示
;;; ============================================================================

Gui, Add, GroupBox
        , x20 y%LayoutGroupBoxY% %LayoutGroupBoxH% w%LayoutGroupBoxW% vdisplay_of_english_layout
        ,　直接入力用配列
Gui, Add, GroupBox
        , x+20 yp+0 hp+0 wp+0 vdisplay_of_japanese_layout
        ,日本語入力用配列


Gui, Add, Text
        , x25 y%LayoutTextY% R1 w%LayoutTextW% Center vname_of_EnglishLayout
        , %name_of_EnglishLayout%

Gui, Add, Text
        , x+40 yp+0 hp+0 wp+0 Center vname_of_JapaneseLayout
        , %name_of_JapaneseLayout%


;;; ============================================================================
;;; ---------------- タブ名
;;; ============================================================================

;; 調整のために、空のテキストを設置する
Gui, Add, text
        , x160 y0
        , 

;; tab で切り替えるようにする
Gui, Add, Tab2
        , AltSubmit -Wrap xp+10 y-25  w%TabW% %TabH% vtab_number
        , 1||2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|


;; テキスト入力欄が空のときは入力プロンプトを表示する
;; [FUNCTION] SetEditCueBanner [AHK_L]
;; http://www.autohotkey.com/forum/topic81973.html

set_edit_cue_banner(HWND, Cue) {
    ;; EM_SETCUEBANNER message
    ;; http://msdn.microsoft.com/en-us/library/windows/desktop/bb761639(v=vs.85).aspx
    
   Static EM_SETCUEBANNER := (0x1500 + 1)
   return DllCall("SendMessageW"
                    , "Ptr", HWND
                    , "Uint", EM_SETCUEBANNER
                    , "Ptr", True
                    , "WStr", Cue)
}

