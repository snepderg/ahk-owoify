#NoEnv
#SingleInstance force
; #IfWinActive ahk_exe discord.exe

; Init
startMsg :=
(
"AutoHotKey Owoifier Version 1.1

~ Written by Major#3577

{ Press ALT+O to convert text field contents. }"
)

MsgBox % startMsg

convertString( str )
{
  _phrase_pairs := [ ["tion", "shun"], ["na", "nya"], ["ne", "nye"], ["ni", "nyi"], ["no", "nyo"], ["nu", "nyu"], ["wha", "wa"], ["you", "nyu"], ["l", "w"], ["r", "w"] ]
  _phrase_appends := ["(´･ω･``)", "`^w`^", ":3", "`;`;w`;`;", "x3", "owo", "nya~", "uwu", "~"]

  owoStr := str
  
  for _, item in _phrase_pairs
  {
    oldStr := item[1]
    newStr := item[2]

    owoStr := StrReplace( global owoStr, oldStr, newStr )
  }

  Random rand, 1, _phrase_appends.MaxIndex()
  owoStr := owoStr . " " . _phrase_appends[rand]

  Return %owoStr%
}

; Hotkey Declaration
!o::
Clipboard := ""
Send ^a
Sleep 10
Send ^x
Sleep 10
Clipboard := convertString(Clipboard)
Send ^v
Return