;;; [AHK_L] Arrays
;;; http://www.autohotkey.com/forum/topic49736.html

;;; 一度に操作しうる要素の数を制限しないようにした
;;; indexOf を改良した
;;; sort を combsort11 による非破壊のメソッドとした
;;; first や rest、extract メソッドを追加した
;;; RichObject 経由で deepcopy を追加した


; Array Lib - temp01 - http://www.autohotkey.com/forum/viewtopic.php?t=49736
;;; AutoHotkey_L: Arrays, Debugger, x64, COM, #If expression ...
;;; http://www.autohotkey.com/forum/post-364358.html&sid=bbc3d1aeceb1c8b4e760b61092cc9183#364358
Array(params*){
   static ArrBase
   If !ArrBase
   {
		ArrBase := RichObject()
		ArrBase.len := "Array_Length"
		ArrBase.indexOf := "Array_indexOf"
		ArrBase.join := "Array_Join"
		ArrBase.append := "Array_Append"
		ArrBase.insert2 := "Array_Insert2"
		ArrBase.delete := "Array_Delete"
		ArrBase.sort := "Array_Sort"
		ArrBase.reverse := "Array_Reverse"
		ArrBase.unique := "Array_Unique"
		ArrBase.extend := "Array_Extend"
		ArrBase.copy := "Array_Copy"
		ArrBase.pop := "Array_Pop"
;		ArrBase.swap := "Array_Swap"
;		ArrBase.move := "Array_Move"
;		ArrBase.contains := "Array_Contains"
		ArrBase.copy := "Array_Copy"
		ArrBase.push := "Array_Append"
		ArrBase.first := "Array_First"
		ArrBase.rest := "Array_Rest"
		ArrBase.car := "Array_First"
		ArrBase.cdr := "Array_Rest"
		ArrBase.last := "Array_Last"
		ArrBase.extract := "Array_Extract"
		ArrBase.clear := "Array_Clear"
		ArrBase.replace := "Array_Replace"
		ArrBase.replace_at_a_time := "Array_Replace_at_a_time"
	}

     arr := Object("base", ArrBase)

     for index,param in params {
          arr.insert(index, param)
     }

    Return arr
}


Array_indexOf(p_arr, p_val, p_startpos=1){
    for index,value in p_arr {
        If ( index >= p_startpos
            && value == p_val ) {

            Return index
        }
    }
} 


Array_Join(p_arr, p_sep="`n"){
    str := ""

    for index,value in p_arr {
        str .= p_arr[index] . p_sep
    }

    StringTrimRight, str, str, % StrLen(p_sep)
    return str
}


Array_Copy(p_arr){
;    Return objDeepCopy(p_arr)
    Return p_arr.clone()
}


Array_Append(p_arr, params*) {
    max_index := p_arr.MaxIndex()

    for index,value in params {
        p_arr.insert(value)
    }

    return p_arr
}


Array_Insert2(p_arr, p_index, params*) {
    for index,value in params {
        p_arr.Insert(p_index + (A_Index - 1), value)
    }

    return p_arr
}


Array_Reverse(p_arr){
    arr := Array()
    max_index := p_arr.MaxIndex()

    for index,value in p_arr {
        arr.insert(max_index - index + 1, value)
    }

    Return arr
}


Array_Sort(p_arr){
    return combsort11(p_arr, p_arr.len())
/*
    a_tmp := p_arr.copy()
    n := a_tmp.len()

    ;; バブルソート
    Loop {
        swapped := false

        Loop, % n - 1 {
            i := A_Index

            if (a_tmp[i] > a_tmp[i+1]) {
                tmp := a_tmp[i]
                a_tmp[i] := a_tmp[i+1]
                a_tmp[i+1] := tmp

                swapped := true
            }
        }

        n--
    } until (swapped = false)

    Return a_tmp
*/
}


Array_Unique(p_arr){
    max_index := p_arr.len()
    i := 0

    Loop, {
        i := A_Index
        j := i + 1

        Loop, {
            if ( i < A_Index ) {
                if ( p_arr[i] = p_arr[j] ){
                    p_arr.delete(j)
                } else {
                    j++
                }
            }
        } until (p_arr.len() < j)
    } until (p_arr.len() < A_Index )

    Return p_arr
}



Array_Extend(p_arr, params*) {
    for index,value in params {
        if IsObject(value) {
            Loop, % value.len()
                p_arr.append(value[A_Index])
        } else {
            Loop, % %value%0
                p_arr.append(%value%%A_Index%)
        }
    }

    Return p_arr
}

Array_Pop(p_arr){
    Return p_arr.delete(p_arr.len())
}


Array_Delete(p_arr, params*) {
    for index,value in params {
        p_arr.Remove(value)
        i := index
    }

    Return p_arr
}


Array_Length(p_arr){
    len := p_arr._MaxIndex()
    Return len = "" ? 0 : len
}


Array_First(p_arr) {
    Return p_arr[1]
}


Array_Rest(p_arr) {
    Return p_arr.copy().delete(1)
}


Array_Last(p_arr) {
    Return p_arr[p_arr.len()]
}


Array_Extract(p_arr, from, to) {
    a_tmp := Array()

    if ( from = to ) {
        a_tmp.append( p_arr[to] )
    } else {
        Loop, % to - from {
            a_tmp.append(p_arr[from + A_Index])
        }
    }

    Return a_tmp
}


Array_Clear(p_arr){
    Return p_arr._Remove(1, p_arr.len() )
}


Array_Replace(p_arr, search_text, replace_text) {
	if not IsObject( p_arr ) {
		if (p_arr = search_text) {
			if IsObject(replace_text)
				return replace_text.DeepCopy()
			else
				return replace_text
		}
		else
		{
			return p_arr
		}
	}
	else
	{
		new_arr := Array()
		for i, v in p_arr.DeepCopy() {
			new_arr.append(Array_Replace(v, search_text, replace_text))
		}

		return new_arr
	}
}


Array_Replace_at_a_time(p_arr, replace_arr) {
	if not IsObject( p_arr ) {
		for i,v in replace_arr {
			if (p_arr = v[1]) {
				if IsObject(v[2])
					return v[2].DeepCopy()
				else
					return v[2]
			}
		}

		return p_arr
	}
	else
	{
		new_arr := Array()
		for i, v in p_arr.DeepCopy() {
			new_arr.append(Array_Replace_at_a_time(v, replace_arr))
		}

		return new_arr
	}
}



combsort11(p_arr, p_gap){
    ;; Stephen Lacey and Richard Box. 1991. A fast, easy sort. BYTE 16, 4 (April 1991), 315-ff..
    ;; http://cs.clackamas.cc.or.us/molatore/cs260Spr03/combsort.htm


    gap := ( p_gap = 0 )  ? 1
        :  ( p_gap = 1 )  ? 1
        :  ( p_gap = 9 )  ? 11
        :  ( p_gap = 10 ) ? 11
        :  Floor( p_gap / 1.3 )

    flag := False

    Loop, % p_arr.len() - gap
    {
        if (p_arr[A_Index] > p_arr[A_Index + gap]){

            tmp := p_arr[A_Index]
            p_arr[A_Index] := p_arr[A_Index + gap]
            p_arr[A_Index + gap] := tmp

            flag := True
        }
    }

    if ( (gap = 1) and (flag = False)) {
        return p_arr.copy()
    } else {
        return combsort11(p_arr, gap)
    }
}


;; richObject(){
richObject(){
   static richObject
   If !richObject
      richObject := Object("base", Object("deepCopy", "objDeepCopy"
										, "flatten", "objFlatten"))

   return  Object("base", richObject)
}


;; objDeepCopy(ast, reserved=0)
objDeepCopy(ast, reserved=0)
{
	if !reserved
		reserved := object("copied" . &ast, 1)  ; to keep track of unique objects within top object
	if !isobject(ast)
		return ast

	copy := object("base", ast)

	for key, value in ast {
		if reserved["copied" . &value]
			continue  ; don't copy repeat objects (circular references)
		copy._Insert(key, objDeepCopy(value, reserved))
	}

	return copy
}


;; objFlatten(ast, reserved=0)
objFlatten(ast, reserved=0)
{
	if !isobject(ast)
		return ast
	if !reserved
		reserved := object("seen" . &ast, 1)  ; to keep track of unique objects within top object

	flat := richObject() ; flat object

	for key, value in ast
	{
		if !isobject(value)
			flat._Insert(value)
		else
		{
			if reserved["seen" . &value]
				continue

			next := objFlatten(value, reserved)
		
			loop % next._MaxIndex()
				flat._Insert(next[A_Index])
		}
	}

	return flat
}


