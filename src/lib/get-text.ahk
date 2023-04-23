;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"

get_proxy_server(proxy_server_file)
; proxy_server の設定を列挙しているファイルから
; 当該設定を読み込んで文字列を返す
;
; 何かしらの設定を読み込めなかったときには
; False を返す
{
	if ( FileExist(proxy_server_file) ) {
		FileRead, var, % proxy_server_file

		Loop, Parse, var, `n
		{
			if (RegExMatch(Trim(A_LoopField), "^;") ) {
				continue
			}
			else
			if ( Trim(A_LoopField) )
			{
				return Trim(A_LoopField)
			}
		}

		return False
	}
	else
	{
		return "nil"
	}
}

;; バイナリをインターネット上から取得する
;; バイナリの取得と保存の処理が未完成
get_binary_from_internet(p_strURL, p_destination){
	global proxy_server

	StringReplace, p_destination, p_destination, /, \
	;; proxy_server.txt が存在しないか、
	;; proxy_server.txt に auto とのみ記述されているならば
	;; IE （インターネット・オプション）の設定を利用する
	;; if ( ( proxy_server = "nil" )
	;; 	 or ( proxy_server = "auto" )) {
	;; 	UrlDownloadToFile, %p_strURL%, % p_destination
	;; 	return "UrlDownloadToFile"
	;; }
	

	;; ComObjError() - AutoHotkeyJp
	;; http://sites.google.com/site/autohotkeyjp/reference/commands/ComObjError
	ComObjError(false)

    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

	;; IWinHttpRequest::SetTimeouts Method (Windows)
	;; http://msdn.microsoft.com/en-us/library/aa384061.aspx

    WebRequest.SetTimeouts(5000,5000,5000,5000)

	proxy_server := false

	if ( proxy_server ) {
		;; IWinHttpRequest::SetProxy Method (Windows)
		;; http://msdn.microsoft.com/en-us/library/aa384059.aspx

	    WebRequest.SetProxy(2, proxy_server)
	}


    WebRequest.Open("GET", p_strURL)
    WebRequest.Send()


	;; 情報を何も取得できなかったとき
	if ( error_reporting ) {
            Progress, Off
        msgbox,インターネット上から情報を取得できません
        return False
	}

    ;; 情報を取得したとき
    if ( WebRequest.Status = 200 ) {
		;; RawWrite はサイズを指定する必要あり
		;; ResponseBody が適切な値を返さない？
		;; FileAppend のバイナリモードで処理するか？
		file := FileOpen(p_destination, "w")
		file.RawWrite(WebRequest.ResponseBody)
		file.close()
    }
    
    return True
}


get_text_from_web(p_strURL, p_pattern = "", error_reporting=False)
; COM Object Reference [AutoHotkey_L]
; http://www.autohotkey.com/forum/viewtopic.php?p=377651#377651
{
	global proxy_server

	;; proxy_server.txt が存在しないか
	;; proxy_server.txt に auto とのみ記述されているならば
	;; IE （インターネット・オプション）の設定を利用する
	if ( ( proxy_server = "nil" )
		 or ( proxy_server = "auto" )) {
		w_tickcount := PF_Count()
		tmp_file := A_Temp . "\dvorakj_" . w_tickcount . ".txt"
		UrlDownloadToFile, %p_strURL%, % tmp_file
		FileRead, new_var, % tmp_file

	    if ( p_pattern ) {
	        RegExMatch(new_var, p_pattern, ver)
	        return ver
	    } else {
	        return new_var
	    }
	}


	;; ComObjError() - AutoHotkeyJp
	;; http://sites.google.com/site/autohotkeyjp/reference/commands/ComObjError
	ComObjError(false)

    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

	;; IWinHttpRequest::SetTimeouts Method (Windows)
	;; http://msdn.microsoft.com/en-us/library/aa384061.aspx

    WebRequest.SetTimeouts(5000,5000,5000,5000)

	if ( proxy_server ) {
		;; IWinHttpRequest::SetProxy Method (Windows)
		;; http://msdn.microsoft.com/en-us/library/aa384059.aspx

	    WebRequest.SetProxy(2, proxy_server)
	}


    WebRequest.Open("GET", p_strURL)

    WebRequest.Send()

    ;; 情報を取得したとき
    if ( WebRequest.Status = 200 ) {
	    if ( p_pattern ) {
	        RegExMatch(WebRequest.ResponseText, p_pattern, ver)
	        return ver
	    } else {
	        return WebRequest.ResponseText
	    }
    }
	
	
	;; 情報を何も取得できなかったとき
	if ( error_reporting ) {
            Progress, Off
        msgbox,インターネット上から情報を取得できません
	}

	return False
}


get_text_from_local(p_filename, p_pattern = "")
{
	FileRead, output_var, % p_filename

    if ( p_pattern ) {
        RegExMatch(output_var, p_pattern, ver)
        return ver
    }
    
    return output_var
}
