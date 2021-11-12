#NoEnv
#SingleInstance force

; Init
startMsg :=
(
"AutoHotKey Owoifier [DEV]

~ Written by Major#3577

~ This build does not reflect the final state of the script. These are tests.

{ Press ALT+O to convert text field contents. }"
)

MsgBox % startMsg

global is_lowercase = 0 ; Set this to 1 or 0 to enable/disable forced lowercase.
global stutterChance = 8 ; Set this to any number above 1 to set the stutter odds. The higher the rarer the chance.

global _phrase_pairs := [ ["tion", "shun"], ["na", "nya"], ["ne", "nye"], ["ni", "nyi"], ["no", "nyo"], ["nu", "nyu"], ["wha", "wa"], ["you", "nyu"], ["l", "w"], ["r", "w"] ]
global _phrase_appends := ["(´･ω･``)", "`^w`^", ":3", "`;`;w`;`;", "x3", "owo", "nya~", "uwu"]

global pattern := "((?<=\w)[.?!]+(?=\s))"

getRandomAppend()
{
  Random rand, 1, _phrase_appends.MaxIndex()
  return _phrase_appends[rand]
}

insertAppends( str )
{
  newStr := str

  matchCount = 0
  
  ; Get total number of matches
  RegExReplace( str, pattern, "", matchCount )
  ; MsgBox, matches found: %matchCount%

  startPos = 1

  loop %matchCount%
  {
    append := getRandomAppend()
    
    newStr := RegExReplace( newStr, pattern, "$0" . " " . append, _, 1, startPos )

    RegExMatch( newStr, "O)" . pattern, obj, startPos )

    startPos := obj.Pos() + 1
    ; MsgBox, new startPos is `"%startPos%`"
  }

  return % newStr
}

global stutterPattern := "((?<=^|\s)\w(?=\w))"

applyStutter( str )
{
  stutterStr := str

  ; Get total number of matches
  RegExReplace( stutterStr, stutterPattern, "", matchCount )
  ; MsgBox, matches found: %matchCount%

  startPos = 1

  loop %matchCount%
  {
    Random, rand, 1, %stutterChance%

    if( rand = 1 )
    {
      ; MsgBox, Randcheck Passed!

      stutterStr := RegExReplace( stutterStr, stutterPattern, "" . "$0" . "-" . "$0", _, 1, startPos )
      ; MsgBox, % stutterStr
    }

    RegExMatch( stutterStr, "O)" . stutterPattern, obj, startPos )

    startPos := obj.Pos() + 1
    ; MsgBox, new startPos is `"%startPos%`"
  }

  return % stutterStr
}

convertString( str )
{
  owoStr := str
  owoStr := applyStutter( owoStr )
  owoStr := insertAppends( owoStr )
  
  for _, item in _phrase_pairs
  {
    oldStr := item[1]
    newStr := item[2]

    owoStr := StrReplace( owoStr, oldStr, newStr )
  }

  ; owoStr := applyStutter( owoStr )

  return % owoStr
}

; Escapes Discord characters so the formatting isn't a problem.
; Could escape stuff besides backtick, but it causes more problems.
escapeDiscordCharacters( str )
{
  escapedStr := str

  escapeChar := "``" ; Has to be escaped because AHK syntax.

  escapedStr := StrReplace( escapedStr, escapeChar, "\``" )

  return % escapedStr
}

; Hotkey Declaration
!o::
clipboard := ""
Send, ^a
Sleep, 10
Send, ^x
ClipWait, 2
clipboard := convertString( clipboard )

if ( is_lowercase = 1 )
{
  StringLower, clipboard, clipboard
}

Send, ^v
return

#IfWinActive ahk_exe discord.exe ; Discord only. Fixes some issues with styling.
!o::
clipboard := ""
Send, ^a
Sleep, 10
Send, ^x
ClipWait, 2
clipboard := convertString( clipboard )

if ( is_lowercase = 1 )
{
  StringLower, clipboard, clipboard
}

clipboard := escapeDiscordCharacters( clipboard )

Send, ^v
return