set_various_timers()
; タイマーの間隔を更新する
{
	global

    
	;;; 「マウスをくるくる回すとスクロール」を使用するとき
	if ( is_KuruKuruScroll ) {
	    SetTimer, Scroll_Rotation, 30
	} else {
	    SetTimer, Scroll_Rotation, Off
	}

	;; 直接入力における同時打鍵の設定を更新するために、
	;; キーボード配列の設定を更新しておく
	if ((lang_mode = "en") and (lang = "ENG")) { ; 直接入力のままのとき
	    GoSub, Switch_Layout_to_English
	}
	else
	if ((lang_mode = "jp") and (lang = "JPN")) { ; 日本語入力用配列を常に使用しているとき
	    GoSub, Switch_Layout_to_Japanese
	}

	;;; 300 ミリ秒毎に Caps Lock の値を調べ続ける
	setTimer, CheckCapsLockState, 300

	;;; IME の状態を定期的に調べる
	SetTimer, IME_GET, %IMEms%
	
	;; IME の名称を定期的に調べる
	SetTimer, Check_IME_name, 300
	
	
	return
}
