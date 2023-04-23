;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"

my_traytip(text, more_option=""){
    global dvorakj_dir

    seconds := 3
    TrayTip, DvorakJ, %text%, %seconds%, 17
    return text
}