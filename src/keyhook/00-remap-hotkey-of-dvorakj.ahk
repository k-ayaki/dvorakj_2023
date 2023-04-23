;; -*-mode: ahk; coding:utf-8-with-signature-dos-*-"

remap_dvorakj_hotkey(){
    global
    static error_text
    
    If not ( is_hotkey_of_DvorakJ ) {
        return False
    }

    error_text := ""

    for i, dvorakj_hotkey in ["suspend_key", "resume_key", "toggle_key", "restart_key"]
    {
        for j, raw_v in string_to_array(%dvorakj_hotkey%, "|")
        {
            subroutine_name := "sub_" . RTrims(dvorakj_hotkey, "_key")
            v := raw_v
            v := string_replace(v, "S-", "+")
            v := string_replace(v, "C-", "^")
            v := string_replace(v, "A-", "!")
            v := string_replace(v, "W-", "#")
            v := string_replace(v, "->", " & ")
        
            try
            {
                Hotkey, %v%, %subroutine_name%
            }
            catch
            {
                if ("" = error_text) {
                    error_text .= "ホットキーを設定できません。`n`n"
                    error_text .= "action`thotkey`t`n"
                    error_text .= "-----------------------`n"
                }
                
                error_text .= RTrims(dvorakj_hotkey, "_key") "`t" raw_v "`t( " v " )`n"
            }
        }
    }
    
    if not ("" = error_text) {
        msgbox, , ホットキーを設定できません - DvorakJ,      %error_text%
    }
    
    return True
}


sub_suspend:
    Suspend, Permit
    toggle_status_of_dvorakj(True)
return

sub_resume:
    Suspend, Permit
    toggle_status_of_dvorakj(False)
    
return

sub_toggle:
    Suspend, Permit
    toggle_status_of_dvorakj( !( A_IsSuspended ) )
return

sub_restart:
    reload
return


