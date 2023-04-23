conv_str_for_sending( p_str, unicode_mode = 0 ) {
    global Is_kana_typing_mode
    global Is_skkime_mode
    global Is_googleime_mode_auto_detected

    global is_US_keyboard

    ;; ローマ字入力とかな入力
    global path_general_string_replace
    global path_general_reg_ex_replace

    ;; ローマ字入力
    global path_romanization_string_replace
    global path_romanization_reg_ex_replace

    global path_romanization_skkime_string_replace
    global path_romanization_skkime_reg_ex_replace

    ;; カナ入力
    global path_kana_string_replace
    global path_kana_reg_ex_replace

    global path_kana_googleime_string_replace
    global path_kana_googleime_reg_ex_replace



    static a_StringReplace_pattern := Object()
    static a_StringReplace_replacement := Object()
    static a_RegExReplace_pattern := Object()
    static a_RegExReplace_replacement := Object()

    static a_romanization_StringReplace_pattern := Object()
    static a_romanization_StringReplace_replacement := Object()
    static a_romanization_RegExReplace_pattern := Object()
    static a_romanization_RegExReplace_replacement := Object()

    static a_romanization_skkime_StringReplace_pattern := Object()
    static a_romanization_skkime_StringReplace_replacement := Object()
    static a_romanization_skkime_RegExReplace_pattern := Object()
    static a_romanization_skkime_RegExReplace_replacement := Object()

    static a_kana_StringReplace_pattern := Object()
    static a_kana_StringReplace_replacement := Object()
    static a_kana_RegExReplace_pattern := Object()
    static a_kana_RegExReplace_replacement := Object()

    static a_kana_googleime_StringReplace_pattern := Object()
    static a_kana_googleime_StringReplace_replacement := Object()
    static a_kana_googleime_RegExReplace_pattern := Object()
    static a_kana_googleime_RegExReplace_replacement := Object()


    if ( a_StringReplace_pattern.GetCapacity() = 0 ) {
        store_list_of_pattern_replacement( path_general_string_replace
                                        , a_StringReplace_pattern
                                        , a_StringReplace_replacement )
        store_list_of_pattern_replacement( path_general_reg_ex_replace
                                        , a_RegExReplace_pattern
                                        , a_RegExReplace_replacement )

        ;; ローマ字入力
        store_list_of_pattern_replacement( path_romanization_string_replace
                                        , a_romanization_StringReplace_pattern
                                        , a_romanization_StringReplace_replacement )
        store_list_of_pattern_replacement( path_romanization_reg_ex_replace
                                        , a_romanization_RegExReplace_pattern
                                        , a_romanization_RegExReplace_replacement )

        store_list_of_pattern_replacement( path_romanization_skkime_string_replace
                                        , a_romanization_skkime_StringReplace_pattern
                                        , a_romanization_skkime_StringReplace_replacement )
        store_list_of_pattern_replacement( path_romanization_skkime_reg_ex_replace
                                        , a_romanization_skkime_RegExReplace_pattern
                                        , a_romanization_skkime_RegExReplace_replacement )


        ;; カナ入力
        store_list_of_pattern_replacement( path_kana_string_replace
                                        , a_kana_StringReplace_pattern
                                        , a_kana_StringReplace_replacement )
        store_list_of_pattern_replacement( path_kana_reg_ex_replace
                                        , a_kana_RegExReplace_pattern
                                        , a_kana_RegExReplace_replacement )

        store_list_of_pattern_replacement( path_kana_googleime_string_replace
                                        , a_kana_googleime_StringReplace_pattern
                                        , a_kana_googleime_StringReplace_replacement )
        store_list_of_pattern_replacement( path_kana_googleime_reg_ex_replace
                                        , a_kana_googleime_StringReplace_pattern
                                        , a_kana_googleime_StringReplace_replacement )


        ;; a_StringReplace_pattern に何も追加されていないとき
        ;; とりあえず現在時刻を追加する
        if ( a_StringReplace_pattern.GetCapacity() = 0 ) {
            w_tickcount := PF_Count()
            a_StringReplace_pattern.insert(w_tickcount . "_" . w_tickcount)
        }
    }


    ;; コマンドへと変換する
    StringReplace, p_str, p_str, {直接入力へ}, IME_SET(0), All
    StringReplace, p_str, p_str, {日本語入力へ}, IME_SET(1), All


    ;; 組み込み変数の展開
    ;; AutoHotkeyJp: 組み込み変数
    ;; https://sites.google.com/site/autohotkeyjp/reference/Variables

    StringReplace, p_str, p_str, {ComSpec}, %ComSpec%, All ; コンソールシェル(多くの場合「cmd.exe」)のフルパス。
    StringReplace, p_str, p_str, {A_Temp}, %A_Temp%, All ; テンポラリフォルダのフルパス。
    StringReplace, p_str, p_str, {A_OSType}, %A_OSType%, All ; Windows9x系なら「WIN32_WINDOWS」、NT系なら「WIN32_NT」。
    StringReplace, p_str, p_str, {A_OSVersion}, %A_OSVersion%, All ; "WIN_VISTA", "WIN_2003", "WIN_XP", "WIN_2000", "WIN_NT4", "WIN_95", "WIN_98", "WIN_ME"
    StringReplace, p_str, p_str, {A_Language}, %A_Language%, All ; システムの言語をあらわす4桁の16進数値。
    StringReplace, p_str, p_str, {A_ComputerName}, %A_ComputerName%, All ; 現在のコンピュータのネットワーク上での名前
    StringReplace, p_str, p_str, {A_UserName}, %A_UserName%, All ; ログインしているユーザー名
    StringReplace, p_str, p_str, {A_IsAdmin}, %A_IsAdmin%, All ; ユーザーが管理者権限を有している場合「1」、管理者権限がない場合「0」。9x系では常に「1」。
    StringReplace, p_str, p_str, {A_WinDir}, %A_WinDir%, All ; Windowsディレクトリのパス。(例:C:\Windows)
    StringReplace, p_str, p_str, {ProgramFiles}, %ProgramFiles%, All ; Program Filesディレクトリのパス。(例:C:\Program Files)
    StringReplace, p_str, p_str, {A_AppData}, %A_AppData%, All ; Application Dataフォルダのフルパス。
    StringReplace, p_str, p_str, {A_AppDataCommon}, %A_AppDataCommon%, All ; 全ユーザー共通のApplication Dataフォルダのフルパス。
    StringReplace, p_str, p_str, {A_Desktop}, %A_Desktop%, All ; デスクトップフォルダのフルパス。
    StringReplace, p_str, p_str, {A_DesktopCommon}, %A_DesktopCommon%, All ; AllUsersの共通デスクトップフォルダのフルパス。
    StringReplace, p_str, p_str, {A_StartMenu}, %A_StartMenu%, All ; スタートメニューフォルダのフルパス。
    StringReplace, p_str, p_str, {A_StartMenuCommon}, %A_StartMenuCommon%, All ; AllUsersの共通スタートメニューフォルダのフルパス。
    StringReplace, p_str, p_str, {A_Programs}, %A_Programs%, All ; スタートメニューの「プログラム」フォルダのフルパス。
    StringReplace, p_str, p_str, {A_ProgramsCommon}, %A_ProgramsCommon%, All ; AllUsersの共通スタートメニューの「プログラム」フォルダのフルパス。
    StringReplace, p_str, p_str, {A_Startup}, %A_Startup%, All ; スタートアップフォルダのフルパス。
    StringReplace, p_str, p_str, {A_StartupCommon}, %A_StartupCommon%, All ; AllUsersの共通スタートアップフォルダのフルパス。
    StringReplace, p_str, p_str, {A_MyDocuments}, %A_MyDocuments%, All ; My Documentsフォルダのフルパス。
    StringReplace, p_str, p_str, {A_ScreenHeight}, %A_ScreenHeight%, All ; 画面の横幅と高さ。




    for index,pattern in a_StringReplace_pattern {
        replacement := a_StringReplace_replacement[index]
        StringReplace, p_str, p_str, %pattern%, %replacement%, All
    }

    for index,pattern in a_RegExReplace_pattern {
        replacement := a_RegExReplace_replacement[index]
        StringReplace, p_str, p_str, %pattern%, %replacement%, All
    }



    if ( unicode_mode = 0 ) {
        If ( Is_kana_typing_mode ) { ; かな入力時
            if ( Is_googleime_mode_auto_detected ) {

                for index,pattern in a_kana_googleime_StringReplace_pattern {
                    replacement := a_kana_googleime_StringReplace_replacement[index]
                    StringReplace, p_str, p_str, %pattern%, %replacement%, All
                }

                for index,pattern in a_kana_googleime_RegExReplace_pattern {
                    replacement := a_kana_googleime_RegExReplace_replacement[index]
                    p_str := RegExReplace(p_str, pattern, replacement)
                }
            }

            for index,pattern in a_kana_StringReplace_pattern {
                replacement := a_kana_StringReplace_replacement[index]
                StringReplace, p_str, p_str, %pattern%, %replacement%, All
            }

            for index,pattern in a_kana_RegExReplace_pattern {
                replacement := a_kana_RegExReplace_replacement[index]
                p_str := RegExReplace(p_str, pattern, replacement)
            }
        } else { ; ローマ字入力時
            if ( Is_skkime_mode ) {
                for index,pattern in a_romanization_skkime_StringReplace_pattern {
                    replacement := a_romanization_skkime_StringReplace_replacement[index]
                    StringReplace, p_str, p_str, %pattern%, %replacement%, All
                }

                for index,pattern in a_romanization_skkime_RegExReplace_pattern {
                    replacement := a_romanization_skkime_RegExReplace_replacement[index]
                    p_str := RegExReplace(p_str, pattern, replacement)
                }
            }


            for index,pattern in a_romanization_StringReplace_pattern {
                replacement := a_romanization_StringReplace_replacement[index]
                StringReplace, p_str, p_str, %pattern%, %replacement%, All
            }

            for index,pattern in a_romanization_RegExReplace_pattern {
                replacement := a_romanization_RegExReplace_replacement[index]
                p_str := RegExReplace(p_str, pattern, replacement)
            }
        }


        ;; US keyboard 向けに
        ;; 以下の文字をキーコードで出力する
        ;; 101 キーボードのキーコードによること
        if ( is_US_keyboard ) {
            ;; 置換の都合上、
            ;; + がつくもの、すなわちシフトキーとともにキーを送信するものをまず設定する
            ;; + がつくもの
            StringReplace, p_str, p_str, +{vkBAsc028}, +{sc009}, All ; *
            StringReplace, p_str, p_str, +{vk38sc009}, +{sc00A}, All ; ( 
            StringReplace, p_str, p_str, +{vk39sc00A}, +{sc00B}, All ; )

            StringReplace, p_str, p_str, +{vkBDsc00C},  {sc00D}, All ; equal
            StringReplace, p_str, p_str, +{vk32sc003}, +{sc028}, All ; " (double)
            StringReplace, p_str, p_str, +{vk36sc007}, +{sc008}, All ; & (amp)
            StringReplace, p_str, p_str, +{vk37sc008},  {sc028}, All ; ' (single)
            StringReplace, p_str, p_str, +{vkE2sc073}, +{sc00C}, All ; _ (under score)
            StringReplace, p_str, p_str, +{vkBBsc027}, +{sc00D}, All ; + (plus)
            StringReplace, p_str, p_str, +{vkC0sc01A},  {sc029}, All ; ` (accent grave)
            StringReplace, p_str, p_str, +{vkDEsc00D}, +{sc029}, All ; ~ (tilde)

            ;; + がつかないもの
            StringReplace, p_str, p_str, {vkC0sc01A}, +{sc003}, All   ; atmark
            StringReplace, p_str, p_str, {vkDEsc00D}, +{sc007}, All ; {^}

            StringReplace, p_str, p_str, {vkBAsc028}, +{sc027}, All  ; colon
            StringReplace, p_str, p_str, {vkBBsc027}, {sc027}, All   ; semi colon
        }
    }

    return iterate_str(p_str)
}



store_list_of_pattern_replacement( p_filename, ByRef a_pattern, ByRef a_replacement ) {
    if ( FileExist( get_file_full_path( p_filename ) ) ) {
        FileRead, tmp_list, % get_file_full_path( p_filename )

        tmp_list := remove_comment_out(tmp_list)

/*
        ;; "," を "`," に置換する
        comma := ","
        comma_escaped := "```,"
        StringReplace, tmp_list, tmp_list, %comma%, %comma_escaped%, All

        ;; ";" を "`;" に置換する
        semi_colon := ";"
        semi_colon_escaped := "```;"
        StringReplace, tmp_list, tmp_list, %semi_colon%, %semi_colon_escaped%, All

        ; "`" そのものを出力するとき
        ;; "`" を "``" に置換する
        tmp_list := RegExReplace(tmp_list, "``[^,;]", "````")
*/

        Loop, Parse, tmp_list, `r, `n
        {
            str := Trim( A_LoopField )
            if ( str ) {
                RegExMatch(str, "S)^(.+)\t(.+)$", $)

                a_pattern.insert( Trim($1) )
                a_replacement.insert( Trim($2) )
            }
        }
        
        return
    }

    msgbox_option( 0, "設定ファイルの検索"
                    , "以下のファイルを読み込めません"
                    , ""
                    , p_filename)
    return
}



iterate_str(p_str) {
    ;; <あいうえお 5> のように、
    ;; < > 内の前半に繰り返す文字列が、後半に繰り返す回数が記述されているとき
    while ( RegExMatch(p_str, "S)<(.+?)\s+(\d+)>", argv) ) {
        newStr := ""

        Loop,% argv2 {
            newStr .= argv1
        }

        p_str := RegExReplace(p_str, "S)<(.+?)\s+(\d+)>", newStr, "", 1)
    }

    return p_str
}




ConvStrWithoutXTU( str )
{
    global nJapaneseLayoutMode
    global Is_kana_typing_mode

    global b_pre_xtu

    if ( nJapaneseLayoutMode = 3 )
    {
        if ( !( Is_kana_typing_mode ))
        {
            ;; 前回の出力処理で末尾の xtu を取り除いたとき
            if ( b_pre_xtu )
            {
                ;; 出力する文字列の先頭が子音のときには
                ;; その子音を二つ重ねることにする
                NewStr := RegExReplace(str, "^([ksthmyrwgzdbpxl])(,*)", "$1$1$2")

                ;; 上記の処理を行わなかった文字列については、
                ;; xtu を先頭に追加する
                str := ( NewStr != str ) ? NewStr
                    : "xtu" . str

                b_pre_xtu = 0
            }


            ;; 出力する文字列の先頭が子音のときには
            ;; その子音を二つ重ねることにする
            str := RegExReplace(str, "^xtu([ksthmyrwgzdbpxl])(,*)", "$1$1$2")


            ;; 文字列中に「っ」が二度連続して出現するとき
            if ( str = "xxtu")
            {
                str := "xtu"
                b_pre_xtu = 1
            }
            else
            {
                ;; 出力する文字列の末尾が xtu のときには
                ;; xtu を削除する
                NewStr := RegExReplace(str, "(.*)xtu$", "$1")


                ;; 末尾の xtu を削除したとき
                if ( NewStr != str )
                {
                    ;; 次回の出力処理では、xtu を付け加える
                    b_pre_xtu = 1
                    str := NewStr
                }
            }
        }
    }

    return str
}


ConvConstToTime( str )
{
    static temp_A_Hour

    static A_YYYY_JP
    static A_Year_JP
    
    static A_MM_JP
    static A_Mon_JP
    static A_DD_JP
    
    static A_MMM_JP
    static A_MMMM_JP
    
    static A_Hour_JP
    static A_Hour_12
    static A_Hour_12_JP 
    
    static A_DDD_JP
    static A_DDDD_JP


    ; 一時間間隔で、変数の値を更新する
    if (temp_A_Hour != A_Hour)
    {
        temp_A_Hour = A_Hour

        A_YYYY_JP := ConvNumToJPNum(A_YYYY)
        A_Year_JP := ConvNumToJPNum(A_Year)

        A_MM_JP   :=ConvNumToJPNum(A_MM)
        A_Mon_JP  := ConvNumToJPNum(A_Mon)
        A_DD_JP   := ConvNumToJPNum(A_DD)

        A_MMM_JP  := ConvNumToJPNum(A_Mon)
        A_MMM_JP_kana  := ConvNumToJPNum_kana(A_Mon)
        A_MMMM_JP := A_MMM_JP . "月"
        A_MMMM_JP_kana := A_MMM_JP_kana . "がつ"

        A_Hour_JP := ConvNumToJPNum(A_Hour)
        A_Hour_12 := (Mod(A_Hour, 12) < 10 ) ? "0" . Mod(A_Hour, 12)
                    : Mod(A_Hour, 12)

        A_Hour_12_JP := ConvNumToJPNum(A_Hour_12)

        A_DDD_JP  := (A_WDay = 1) ? "日"
                  :  (A_WDay = 2) ? "月"
                  :  (A_WDay = 3) ? "火"
                  :  (A_WDay = 4) ? "水"
                  :  (A_WDay = 5) ? "木"
                  :  (A_WDay = 6) ? "金"
                  :  "土"

        A_DDD_JP_kana  := (A_WDay = 1) ? "にち"
                      :  (A_WDay = 2) ? "げつ"
                      :  (A_WDay = 3) ? "か"
                      :  (A_WDay = 4) ? "すい"
                      :  (A_WDay = 5) ? "もく"
                      :  (A_WDay = 6) ? "きん"
                      :  "ど"

        A_DDDD_JP := A_DDD_JP . "曜"
        A_DDDD_JP_kana := A_DDD_JP_kana . "よう"
    }

    ; 関数を呼び出す毎に、変数の値を更新する
    A_Min_JP  := ConvNumToJPNum(A_Min)
    A_Sec_JP  := ConvNumToJPNum(A_Sec)
    A_MSec_JP := ConvNumToJPNum(A_MSec)


    StringReplace, str, str, {A_Hour_12}, %A_Hour_12%, All

    StringReplace, str, str, {A_YYYY_JP}, %A_YYYY_JP%, All ; 現在日時の年を表す4桁の数字(...2004...)
    StringReplace, str, str, {A_Year_JP}, %A_Year_JP%, All ; 現在日時の年を表す4桁の数字(...2004...)
    StringReplace, str, str, {A_MM_JP}, %A_MM_JP%, All ; 月を表す2桁の数字(01...12)
    StringReplace, str, str, {A_Mon_JP}, %A_Mon_JP%, All ; 月を表す2桁の数字(01...12)
    StringReplace, str, str, {A_DD_JP}, %A_DD_JP%, All ; 日を表す2桁の数字(01...31)
    StringReplace, str, str, {A_MDay_JP}, %A_MDay_JP%, All ; 日を表す2桁の数字(01...31)
    StringReplace, str, str, {A_MMM_JP}, %A_MMM_JP%, All
    StringReplace, str, str, {A_MMMM_JP}, %A_MMMM_JP%, All
    StringReplace, str, str, {A_DDD_JP}, %A_DDD_JP%, All
    StringReplace, str, str, {A_DDDD_JP}, %A_DDDD_JP%, All
    StringReplace, str, str, {A_Hour_JP}, %A_Hour_JP%, All
    StringReplace, str, str, {A_Hour_12_JP}, %A_Hour_12_JP%, All
    StringReplace, str, str, {A_Min_JP}, %A_Min_JP%, All
    StringReplace, str, str, {A_Sec_JP}, %A_Sec_JP%, All
    StringReplace, str, str, {A_Msec_JP}, %A_Msec_JP%, All

    StringReplace, str, str, {A_DDD_JP_kana}, %A_DDD_JP_kana%, All
    StringReplace, str, str, {A_DDDD_JP_kana}, %A_DDDD_JP_kana%, All



    StringReplace, str, str, {A_YYYY}, %A_YYYY%, All ; 現在日時の年を表す4桁の数字(...2004...)
    StringReplace, str, str, {A_Year}, %A_Year%, All ; 現在日時の年を表す4桁の数字(...2004...)
    StringReplace, str, str, {A_MM}, %A_MM%, All ; 月を表す2桁の数字(01...12)
    StringReplace, str, str, {A_Mon}, %A_Mon%, All ; 月を表す2桁の数字(01...12)
    StringReplace, str, str, {A_DD}, %A_DD%, All ; 日を表す2桁の数字(01...31)
    StringReplace, str, str, {A_MDay}, %A_MDay%, All ; 日を表す2桁の数字(01...31)
    StringReplace, str, str, {A_MMMM}, %A_MMMM%, All ; 月の名称(...July...)
    StringReplace, str, str, {A_MMM}, %A_MMM%, All ; 月を表す3文字の省略名(...Jul...)
    StringReplace, str, str, {A_DDDD}, %A_DDDD%, All ; 曜日を表す文字列(Sunday...)
    StringReplace, str, str, {A_DDD}, %A_DDD%, All ; 曜日を表す3文字の省略名(Sun...)
    StringReplace, str, str, {A_WDay}, %A_WDay%, All ; 曜日を表す1文字の数字(1...7)1が日曜
    StringReplace, str, str, {A_YDay}, %A_YDay%, All ; 1年の中で何日目か(1...366)
    StringReplace, str, str, {A_YWeek}, %A_YWeek%, All ; 西暦年と週番号をつなげたISO8601形式の文字列(...200453...)
    StringReplace, str, str, {A_YDay}, %A_YDay%, All ; 1月1日からの日数を表す1～3桁の数(1...366)
    StringReplace, str, str, {A_Hour}, %A_Hour%, All ; 時を表す2桁の数字(00...23)
    StringReplace, str, str, {A_Min}, %A_Min%, All ; 分を表す2桁の数字(00...59)
    StringReplace, str, str, {A_Sec}, %A_Sec%, All ; 秒を表す2桁の数字(00...59)
    StringReplace, str, str, {A_MSec}, %A_MSec%, All ; ミリ秒を表す3桁の数字(000...999)。
    StringReplace, str, str, {A_Now}, %A_Now%, All ; 現在時刻をYYYYMMDDHH24MISSの書式で表したもの
    StringReplace, str, str, {A_NowUTC}, %A_NowUTC%, All ; UTC時刻をYYYYMMDDHH24MISSの書式で表したもの
    w_tickcount := PF_Count()
    StringReplace, str, str, {w_tickcount}, %w_tickcount%, All ; OSが起動してからの経過時間(ミリ秒)

    return str
}


ConvNumToJPNum(str) {
    StringReplace, str, str, 0, 〇, ALL
    StringReplace, str, str, 1, 一, ALL
    StringReplace, str, str, 2, 二, ALL
    StringReplace, str, str, 3, 三, ALL
    StringReplace, str, str, 4, 四, ALL
    StringReplace, str, str, 5, 五, ALL
    StringReplace, str, str, 6, 六, ALL
    StringReplace, str, str, 7, 七, ALL
    StringReplace, str, str, 8, 八, ALL
    StringReplace, str, str, 9, 九, ALL


    return str
}

ConvNumToJPNum_kana(str) {
    StringReplace, str, str, 0, れい, ALL
    StringReplace, str, str, 1, いち, ALL
    StringReplace, str, str, 2, に, ALL
    StringReplace, str, str, 3, さん, ALL
    StringReplace, str, str, 4, し, ALL
    StringReplace, str, str, 5, ご, ALL
    StringReplace, str, str, 6, ろく, ALL
    StringReplace, str, str, 7, しち, ALL
    StringReplace, str, str, 8, はち, ALL
    StringReplace, str, str, 9, く, ALL

    return str
}
