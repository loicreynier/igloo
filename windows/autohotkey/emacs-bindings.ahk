/*
AutoHotkey script to use Emacs keybindings on Windows

References:
- https://github.com/hsswiki/windows-emacs-key-binding
- https://github.com/usuyama/emacs-like-key-bindings-windows

Hotkey prefix symbols:
- ^ = Ctrl
- ! = Alt
- + = Shit
- # = Win
- $ = Make `$^c::Send("^{c})` unable to loop itself

TODO:
- add a button to disable the script (while gaming for instance)
  better than `Suspend`
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

IsScriptActive() {
  InactiveExes := ["Code.exe", "WindowsTerminal.exe"]
  ProcessName := WinGetProcessName("A")

  State := True

  for _, Exe in InactiveExes {
    if (ProcessName == Exe) {
      State := False
    }
  }

  return State
}

#!a:: Suspend

$^f:: {
  If IsScriptActive()
    Send("{Right}")
  Else
    Send("^{f}")
}

$^b:: {
  If IsScriptActive()
    Send("{Left}")
  Else
    Send("^{b}")
}

$^a:: {
  If IsScriptActive()
    Send("{Home}")
  Else
    Send("^{a}")
}

$^e:: {
  If IsScriptActive()
    Send("{End}")
  Else
    Send("^{e}")
}

$^h:: {
  If IsScriptActive()
    Send("{Backspace}")
  Else
    Send("^{h}")
}

$^w:: {
  If IsScriptActive()
    Send("{Ctrl down}{Backspace}{Ctrl up}")
  Else
    Send("^{w}")
}

$^u:: {
  If IsScriptActive()
    Send("{Shift down}{End}{Shift up}{Delete}")
  Else
    Send("^{u}")
}

; Often used as a shortcut by programs
; $^k:: {
;   If IsScriptActive()
;     Send("{Shift down}{Home}{Shift up}{Delete}")
;   Else
;     Send("^{k}")
; }

$^m:: {
  If IsScriptActive()
    Send("{Enter}")
  Else
    Send("^{m}")
}
