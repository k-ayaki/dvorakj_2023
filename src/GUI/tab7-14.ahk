Add_GUI_DropDownList_and_Edit( "[ESC]"
                            , "[全角/半角]"
                            , "[Tab]"
                            , "[Caps Lock]" )

Add_GUI_DropDownList_and_Edit( "[Back Space]"
                            , "[Enter]" )

Add_GUI_DropDownList_and_Edit( "[左 Win]"
                            , "[右 Win]" )

Add_GUI_DropDownList_and_Edit( "[Space]"
                            , "[無変換]"
                            , "[変換]"
                            , "[かな]" 
                            , "[メニュー]" )

Add_GUI_DropDownList_and_Edit( "[←]"
                            , "[→]"
                            , "[↑]"
                            , "[↓]" )

Add_GUI_DropDownList_and_Edit( "[Home]"
                            , "[End]"
                            , "[Page Up]"
                            , "[Page Down]" )

Add_GUI_DropDownList_and_Edit( "[Insert]"
                            , "[Delete]" )


Add_GUI_DropDownList_and_Edit( "[Print Screen]"
                            , "[Scroll Lock]"
                            , "[Pause]" )



;;; ---------------------------------------------
;;; ---------------------------------------------
;;; ---------------------------------------------


Get_GUI_DropDownList_text_of_keys() {
    static GUI_DropDownList_for_key_output := "
        (Join| LTrim 
            そのまま
            --------------------
            何も発行しない
            --------------------
            直接入力にする
            日本語入力にする
            --------------------
            {←}
            {→}
            {↑}
            {↓}
            --------------------
            {Home}
            {End}
            {Page Up}
            {Page Down}
            --------------------
            {ESC}
            {全角/半角}
            {Tab}
            {Caps Lock}
            --------------------
            {Back Space}
            {Enter}
            --------------------
            {Space}
            {無変換}
            {変換}
            {カタカナ/ひらがな}
            {メニュー}
            --------------------
            {Insert}
            {Delete}
            --------------------
            ★独自の設定
        )"

    return GUI_DropDownList_for_key_output
}


Add_GUI_DropDownList_and_Edit( params* ) {
    global 

    local N

    static GUI_DropDownList_nth := 0
    static GUI_ypos

    static GUI_special_key_category_pos := Array("x200", "xp+110", "xp+140", "x+35")
    static GUI_special_key_category_text := Array("キー名", "直接入力時", "日本語入力時", "　")

    static tab_number := 6


    ;; タブに番号をつけ、生成する
    tab_number += 1
    Gui, Tab, % tab_number

    ;; 見出しを設定する
    for index,x_pos in GUI_special_key_category_pos {
        Gui, Add, Text
                , %x_pos% y10
                , % GUI_special_key_category_text[A_Index]
    }


    ;; 設定対象のキー名を個別に表示する
    for index,param in params {
        GUI_nth_key += 1
        GUI_default_n := 1

        GUI_ypos := ( A_Index = 1 ) ? 35
                                    : GUI_ypos + 70

        ;; キー名
        Gui, Add, Text
                , x180 y%GUI_ypos%
                , % param





        ;; 直接入力用の設定入力欄
        N := key_%GUI_nth_key%_en_number
        Gui, Add, DropDownList
                , x270 y%GUI_ypos% w130 +ReadOnly R15 Choose%N% AltSubmit vkey_%GUI_nth_key%_en_number gset_GUI_key_%GUI_nth_key%_setting
                , % Get_GUI_DropDownList_text_of_keys()

        Gui, Add, Edit
                , xp+0 y+10 wp+0 hwndkey_%GUI_nth_key%_en_text vkey_%GUI_nth_key%_en_text gset_GUI_key_%GUI_nth_key%_setting
                , % key_%GUI_nth_key%_en_text
                
        set_edit_cue_banner(key_%GUI_nth_key%_en_text, "「★独自の設定」用")



        ;; 日本語入力用の設定入力欄
        N := key_%GUI_nth_key%_jp_number
        Gui, Add, DropDownList
                , x440 y%GUI_ypos% w130 +ReadOnly R15 Choose%N% AltSubmit vkey_%GUI_nth_key%_jp_number gset_GUI_key_%GUI_nth_key%_setting
                , % Get_GUI_DropDownList_text_of_keys()

        Gui, Add, Edit
                , xp+0 y+10 wp+0 hwndkey_%GUI_nth_key%_jp_text vkey_%GUI_nth_key%_jp_text gset_GUI_key_%GUI_nth_key%_setting
                , % key_%GUI_nth_key%_jp_text

        set_edit_cue_banner(key_%GUI_nth_key%_jp_text, "「★独自の設定」用")
    }

    return
}

