get_modified_keys_pressed_down(){
    ;; �C���L�[�̉����󋵂�c������
    modified_keys := ""

    if ( GetKeyState("shift", "P") )
        modified_keys .= "+"

    if ( GetKeyState("alt", "P") )
        modified_keys .= "!"

    if ( GetKeyState("ctrl", "P") )
        modified_keys .= "^"

    if (( GetKeyState("lwin", "P") ) or ( GetKeyState("rwin", "P") ) )
        modified_keys .= "#"


	return modified_keys
}
