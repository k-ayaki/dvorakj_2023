;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"


Check_IME_name:
	ime_layout_name := Get_layout_text()
	SetFormat, Integer, D

	Is_googleime_mode_auto_detected := RegExMatch(ime_layout_name, "i)google")
return
