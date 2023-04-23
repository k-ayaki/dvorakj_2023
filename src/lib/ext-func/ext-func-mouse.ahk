swap_mouse_button(str)
; マウスの左右のボタンを入れ替える
{
	global bswap_mouse_button

	if not (a_IsCompiled)
		bswap_mouse_button := True

	return % ( bswap_mouse_button != True) ? str
			: (str = "{LButton}") ? "{RButton}"
			: "{LButton}"
}