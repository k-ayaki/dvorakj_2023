;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"
status_of_progress(now, max){
    string := ""
    Loop, %max% {
        if (A_Index <= now) {
            string .= "★"
        } else {
            string .= "☆"
        }
    }
    

    ;; 7/8: ★★★★★★★☆
    return now . "/" . max . ": " . string
}

