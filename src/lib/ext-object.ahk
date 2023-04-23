"".base.__Get := "Default_ext_method_get_version"
"".base.is  := "Default_is"
"".base.concat := "Default_concat"
"".base.slice := "Default_slice"

"".base.sub := "Default_sub"
"".base.gsub := "Default_gsub"
"".base.index := "Default_index"

"".base.right  := "Default_right"
"".base.left  := "Default_left"

"".base.to_s := "Default_to_s"

; String#swapcase
; String#upcase
; String#downcase

; String#concat
; String#left
; String#right
; String#sub
; String#gsub

; String#length
; String#index

; String#to_s

; Sequence#is(type)




Default_ext_method_get_version(nonobj, key)
{
	;; key が定義済みの時に限り
	;; return を記述する
	;; そうしないと、他のメソッドを使用することができない

    if (key = "length")
        return StrLen(nonobj)
	else
	if (key = "swapcase")
	{
		newstr := ""
		Loop, Parse, nonobj
		{
			if A_LoopField is upper
				newstr .= A_LoopField.downcase
			else
				newstr .= A_LoopField.upcase
		}
	    return newstr 
	}
	else
	if (key = "upcase")
	{
		StringUpper, nonobj, nonobj
		return nonobj
	}
	else
	if (key = "downcase")
	{
		StringLower, nonobj, nonobj
		return nonobj
	}
	else
	if (key = "strip")
	{
		return Trim(nonobj)
	}
}


Default_is(nonobj, type)
{
    if nonobj is %type%
        return true
    return false
}

Default_concat(nonobj, value)
{
    return nonobj . value
}

Default_slice(nonobj, n=0, len=0)
{
    return (len = 0) ? SubStr(nonobj, n + 1)
           : SubStr(nonobj, n + 1, len)
}

Default_sub(nonobj, search_text, replace_text)
{
	StringReplace, nonobj, nonobj, %search_text%, %replace_text%
	return nonobj
}

Default_gsub(nonobj, search_text, replace_text)
{
	StringReplace, nonobj, nonobj, %search_text%, %replace_text%, All
	return nonobj
}

Default_index(nonobj, search_text, offset="0")
{
	StringGetPos, pos, nonobj, %search_text%, L, %offset%
	return pos
}

Default_right(nonobj, len)
{
	StringRight, OutputVar, nonobj, %len%
	return OutputVar
}


Default_left(nonobj, len)
{
	StringLeft, OutputVar, nonobj, %len%
	return OutputVar
}

Default_to_s(nonobj, number)
{
	return to_s_aux(nonobj, "", number)
}

;;; 10進数の数字を 10 未満の進数に変換する
to_s_aux(n, m="", number="10")
{
    if (number < 10)
    {
	    if (n = 0)
	        return m
	    else
	        return to_s_aux( n // number, mod(n, number) . m, number )
    }
	else
	if (number = 10)
		return n
	else
		return 0
}

; msgbox,% "foobarhoge".length.to_s(2)