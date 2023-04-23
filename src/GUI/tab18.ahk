Gui, tab, 18

Gui, Add, GroupBox
        , x%GroupBoxX% y20 w%GroupBoxW% R3 
        , DvorakJ の自動起動

Gui, Add, Checkbox
        , xp+20 yp+25 vis_shortcut_link gset_is_shortcut_link Checked%is_shortcut_link%
        , ログオン時に DvorakJ を起動する(&L)
        
Gui, Add, text
        , xp+15 yp+20
        , 　※スタートアップにショートカットリンクを登録します




Gui, Add, GroupBox
        , x%GroupBoxX% y+40 w%GroupBoxW%
        , 設定画面の非表示

Gui, Add, Checkbox
        , xp+20 yp+25 vis_Minimising_Window gset_is_minimising_Window Checked%is_Minimising_Window%
        , DvorakJ 起動時に設定画面を最小化する(&M)
    



Gui, Add, GroupBox
        , x%GroupBoxX% y+40 w%GroupBoxW%
        , 更新情報の自動取得

Gui, Add, Checkbox
        , xp+20 yp+30 vis_Checking_Update_On_StartUp gset_is_Checking_Update_On_StartUp Checked%is_Checking_Update_On_StartUp%
        , DvorakJ 起動時にソフトウェアの更新情報を取得する(&U)

      
if ( !A_IsCompiled ) {
    Gui, Add, GroupBox
            , x%GroupBoxX% y+30 w%GroupBoxW% R2
            , デバッグ
    
    Gui, Add, Checkbox
            , xp+20 yp+20 vshow_menu_for_debug_p gset_show_menu_for_debug_p Checked%show_menu_for_debug_p%
            , デバッグ用メニューを表示する(&D)　　※スクリプト版のみ利用可能
}
        