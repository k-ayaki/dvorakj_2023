tooltip_pos_mode( p_text,p_caret_X, p_caret_Y, p_number=1 )
; tooltip コマンドを関数として使用する
{
	ToolTip, %p_text%,%p_caret_X%, %p_caret_Y%, %p_number%
	return p_text
}


tooltip( p_str* )
; tooltip コマンドの text の部分を可変長引数として取る
; その可変長引数の各引数については、評価後に改行する
{
	t := ""
	for i,v in p_str {
		t .= v "`n"
	}

	tooltip,% t
			,
			,
			, 1

	return t
}

msgbox( p_str* )
; tooltip 関数と同様、
; msgbox コマンドの text の部分を可変長引数として取る
; その可変長引数の各引数については、評価後に改行する
{
	t := ""
	for i,v in p_str {
		t .= v "`n"
	}

	msgbox,% t

	return t
}

msgbox_option( p_options=0, p_title="", p_str* )
; tooltip 関数と同様、
; msgbox コマンドの text の部分を可変長引数として取る
; その可変長引数の各引数については、評価後に改行する
{
	t := ""
	for i,v in p_str {
		t .= v "`n"
	}

	; 以下の形式では MsgBox のオプションを認識しないので、
	; p_options の値によりコマンドを変更する
	; MsgBox, %p_options%, %p_title%, %t%

	if (p_options = 0 )
		MsgBox, 0, %p_title%, %t%
	else
	if (p_options = 1 )
		MsgBox, 1, %p_title%, %t%
	else
	if (p_options = 0x1134 )
		MsgBox, 0x1134, %p_title%, %t%


	return t
}




send_and_tooltip(p_str="" ) {
	tooltip,% send( p_str )
			,
			,
			, 1

	return p_str
}

send_and_msgbox( p_str ) {
	msgbox,% send( p_str )

	return p_str
}


AddMenuItem( MenuItemName="", Label="", SubMenu="")
; メニューの項目を効率的に追加する
{
    static static_MenuName
    static static_obj

    If !IsObject(static_obj)
    {
        static_obj := Object("count", 0) 
    }

    ;; AddMenuItem()
    if ( !( MenuItemName ) )
    {
        Menu, %static_MenuName%, Add
    }
    else
    if ( !( Label ) ) ; AddMenuItem( MenuItemName )
    {
        static_obj.count := static_obj.count + 1
        static_obj[static_obj.count] := MenuItemName
        static_MenuName := static_obj[static_obj.count]
    }
    else
    if ( Submenu ) ; AddMenuItem( MenuItemName, , Label, SubMenu)
    {
        ;; サブメニューを展開するとき
        Menu, %MenuItemName%, Add
            , %Label%
            , :%static_MenuName%

        static_obj.count := static_obj.count - 1
        static_MenuName := static_obj[static_obj.count]
    }
    else
    {
        Menu, %static_MenuName%, Add
            , %MenuItemName%
            , %Label%
    }

    return
}
