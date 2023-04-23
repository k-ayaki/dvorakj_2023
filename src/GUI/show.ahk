;; ============================================================================
;;; ---------------- ウィンドウを表示
;;; ============================================================================


Gui, Add, StatusBar
    , 
    ,

SB_SetParts(150, 300)
;; 入力情報
;; キーストローク
;; 空き
;; 空き
;; 現在時刻

SB_SetText("`t" . dvorakj_current_version " 版`t" , 1)

if not ( A_IsCompiled ) {
	SB_SetText("`t"  "script version `t" , 3)
}




;;; 起動時にウィンドウを表示しないとき
if ( is_Minimising_Window ) {
    Gui, Show
        , x%GuiX% y%GuiY% w%GuiW% h%GuiH% Minimize
        , DvorakJ

} else {
    Gui, Show
        , x%GuiX% y%GuiY% w%GuiW% h%GuiH%
        , DvorakJ
}

