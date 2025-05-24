#Requires AutoHotkey v2.0
#SingleInstance Force

MsgBox("Clipboard Owoifier v1.0`n~ Now for AHK V2!`n`nThis script allows you to Owoify selected text in Discord and other applications.`n`nPress CTRL+ALT+H for help.`n`nPress OK to continue.")

; === CONFIG ===
global stutterChance := 8       ; Higher = rarer stutter. Use 1 to disable.

global isLowercase := false     ; Set to true to force lowercase. Toggled by hotkey.
global stutterEnabled := true   ; Set to false to disable stuttering. Toggled by hotkey.
global appendsEnabled := true   ; Set to false to disable appends after punctuation. Toggled by hotkey.

global _phrase_pairs := [
    ["tion", "shun"], ["na", "nya"], ["ne", "nye"], ["ni", "nyi"], ["no", "nyo"], ["nu", "nyu"],
    ["wha", "wa"], ["you", "nyu"], ["l", "w"], ["r", "w"]
]
global _phrase_appends := ["(´･ω･`)", "^w^", ":3", ";w;", "x3", "owo", "nya~", "uwu"]

global punctuationPattern := "([.?!]+)(?=\s|$)"   ; e.g. "Hi!" -> match "!"
global stutterPattern := "\b(\w)"                ; e.g. "hello" -> match "h"
; =================

logError(errMsg) {
    FileAppend A_Now " - " errMsg "`n", A_ScriptDir "\owo_dev.log"
}

getRandomAppend() {
    global _phrase_appends
    rand := Random(1, _phrase_appends.Length)
    return _phrase_appends[rand]
}

insertAppends(str) {
    global punctuationPattern
    newStr := str
    startPos := 1

    while pos := RegExMatch(newStr, punctuationPattern, &obj, startPos) {
        append := getRandomAppend()
        matchLen := StrLen(obj[1])
        insertPos := pos + matchLen
        ; Always add a space after the append
        newStr := SubStr(newStr, 1, insertPos) . " " . append . " " . SubStr(newStr, insertPos + 1)
        startPos := insertPos + StrLen(append) + 2 ; +2 for the two spaces
    }

    ; Remove any trailing space(s) at the end
    return RegExReplace(newStr, "\s+$", "")
}

applyStutter(str) {
    global stutterChance, stutterPattern
    stutterStr := str
    startPos := 1

    while pos := RegExMatch(stutterStr, stutterPattern, &obj, startPos) {
        if Random(1, stutterChance) = 1 {
            matchText := obj[1]
            rep := matchText "-" matchText
            stutterStr := SubStr(stutterStr, 1, pos - 1) . rep . SubStr(stutterStr, pos + StrLen(matchText))
            startPos := pos + StrLen(rep)
        } else {
            startPos := pos + StrLen(obj[1])
        }
    }

    return stutterStr
}

convertString(str) {
    global _phrase_pairs
    global stutterEnabled
    global appendsEnabled
    owoStr := str
    
    if stutterEnabled
        owoStr := applyStutter(str)

    if appendsEnabled
        owoStr := insertAppends(owoStr)
    
    for item in _phrase_pairs {
        oldStr := item[1], newStr := item[2]
        owoStr := StrReplace(owoStr, oldStr, newStr)
    }

    return owoStr
}

escapeDiscordCharacters(str) {
    return StrReplace(str, "``", "\``")
}

processOwoify(*) {
    global isLowercase
    ClipSaved := ClipboardAll()
    A_Clipboard := ""

    Sleep 100
    Send "^a"
    Sleep 50
    Send "^x"
    Sleep 100

    if !ClipWait(2) || A_Clipboard = "" {
        logError("No text selected or clipboard timeout")
        MsgBox("No text selected!")
        A_Clipboard := ClipSaved
        return
    }

    A_Clipboard := convertString(A_Clipboard)

    if isLowercase
        A_Clipboard := StrLower(A_Clipboard)

    if WinActive("ahk_exe discord.exe")
        A_Clipboard := escapeDiscordCharacters(A_Clipboard)

    Send "^v"
    Sleep 100
    A_Clipboard := ClipSaved
}

ShowHelp() {
    MsgBox(
        "==== Owoifier Help ====`n" 
        . "Hotkeys:`n"
        . "CTRL+ALT+O: Owoify selected text.`n"
        . "CTRL+ALT+L: Toggle forced lowercase.`n"
        . "CTRL+ALT+S: Toggle stutter.`n"
        . "CTRL+ALT+A: Toggle appends after punctuation.`n"
        . "CTRL+ALT+H: Show this help message."
        . "`n`n"
        . "==== Info ====`n"
        . "Stutter chance: 1 in " . stutterChance . ".`n"
        . "Forced lowercase: " . (isLowercase ? "ON" : "OFF") . ".`n"
        . "Stutter enabled: " . (stutterEnabled ? "ON" : "OFF") . ".`n"
        . "Appends enabled: " . (appendsEnabled ? "ON" : "OFF") . ".`n"
        . "====================="
    )
}

ToggleLowercase() {
    global isLowercase
    isLowercase := !isLowercase
    MsgBox("Forced lowercase is now " (isLowercase ? "ON" : "OFF") ".")
}

ToggleStutter() {
    global stutterEnabled
    stutterEnabled := !stutterEnabled
    MsgBox("Stutter is now " (stutterEnabled ? "ON" : "OFF"))
}

ToggleAppends() {
    global appendsEnabled
    appendsEnabled := !appendsEnabled
    MsgBox("Appends after punctuation are now " (appendsEnabled ? "ON" : "OFF"))
}

; === Hotkey Bindings ===
^!h:: ShowHelp()
^!o:: processOwoify()
^!l:: ToggleLowercase()
^!s:: ToggleStutter()
^!a:: ToggleAppends()
