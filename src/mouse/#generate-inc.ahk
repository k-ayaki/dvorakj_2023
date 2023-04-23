;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"

;; フォルダ以下の *.ahk を探し出し、 
;; #include %A_LineFile%..\test.ahk の形式で列挙する

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force

save_filename := "#inc.ahk"

file_list := get_file_list(Object())
string := ";; -*-mode: ahk; coding:utf-8-with-signature-dos-*-`n`n"
string .= add_hash_include(file_list)

save_to(string, save_filename)

ExitApp


get_file_list(arr){
    Loop, .\*.ahk, 0, 1
    {
        ;; ファイル名が # から始まるものは、処理対象のファイルから除外する
        if ("#" != SubStr(A_LoopFileName, 1, 1)) {
            arr.insert("%A_LineFile%\." . A_LoopFileFullPath)
        }
    }
    
    return arr
}


add_hash_include(arr){
    str := ""
    
    for index, value in arr {
        str .= "#include " . value . "`n"
    }
    
    return str
}


save_to(String, filename){
    file := FileOpen(filename, "w")
    File.Write(String)
    file.close()
}