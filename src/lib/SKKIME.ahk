SendSKKIMEWithShift( str )
{
    StringLeft, OutputVar1, str, 1
    StringLeft, OutputVar2, str, 3


    str := ( OutputVar1 = "@" )   ? str
        :  ( OutputVar1 = ";" )   ? str
        :  ( OutputVar1 = ":" )   ? str
        :  ( OutputVar2 = "{^}" ) ? str
        :                           "+" . str

    send( str )

    return
}