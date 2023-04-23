;; 直接入力と日本語入力のどちらの入力方式で出力するか
GetOutputLang() {
    global lang_mode
    global bAlphanumericMode

    lang := ( bAlphanumericMode ) ? "en" ; 一時的に直接入力で出力するとき
         :  ( lang_mode = "en" )  ? "en" ; 直接入力用配列のとき
         :  "jp"

    return lang
}
