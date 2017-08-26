;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Region When running compiled script, Install needed DLLs if they don't exist yet
	If NOT FileExists("ImageSearchDLLx32.dll") Then FileInstall("ImageSearchDLLx32.dll", "ImageSearchDLLx32.dll", 1)
	If NOT FileExists("ImageSearchDLLx64.dll") Then FileInstall("ImageSearchDLLx64.dll", "ImageSearchDLLx64.dll", 1)
	If NOT FileExists("msvcr110d.dll") Then FileInstall("msvcr110d.dll", "msvcr110d.dll", 1)
	If NOT FileExists("msvcr110.dll") Then FileInstall("msvcr110.dll", "msvcr110.dll", 1)
#EndRegion
Local $h_imagesearchdll = -1
#Region ImageSearch Startup/Shutdown

Func _winapi_wow64enablewow64fsredirection($benable)
		Local $aret = DllCall("kernel32.dll", "boolean", "Wow64EnableWow64FsRedirection", "boolean", $benable)
		If @error Then Return SetError(@error, @extended, 0)
		Return $aret[0]
EndFunc


	Func _imagesearchstartup()
		_winapi_wow64enablewow64fsredirection(True)
		$sosarch = @OSArch
		$sautoitx64 = @AutoItX64
		If $sosarch = "X86" OR $sautoitx64 = 0 Then
			$h_imagesearchdll = DllOpen("ImageSearchDLLx32.dll")
			If $h_imagesearchdll = -1 Then Return "DllOpen failure"
		ElseIf $sosarch = "X64" AND $sautoitx64 = 1 Then
			$h_imagesearchdll = DllOpen("ImageSearchDLLx64.dll")
			If $h_imagesearchdll = -1 Then Return "DllOpen failure"
		Else
			Return "Inconsistent or incompatible Script/Windows/CPU Architecture"
		EndIf
		Return True
	EndFunc

	Func _imagesearchshutdown()
		DllClose($h_imagesearchdll)
		_winapi_wow64enablewow64fsredirection(False)
		Return True
	EndFunc

#EndRegion ImageSearch Startup/Shutdown
#Region ImageSearch UDF

	Func _imagesearch($findimage, $resultposition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
		Return _imagesearcharea($findimage, $resultposition, 0, 0, @DesktopWidth, @DesktopHeight, $x, $y, $tolerance, $transparency)
	EndFunc

	Func _imagesearcharea($findimage, $resultposition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $tolerance = 0, $transparency = 0)
		If NOT FileExists($findimage) Then Return "Image File not found"
		If $tolerance < 0 OR $tolerance > 255 Then $tolerance = 0
		If $h_imagesearchdll = -1 Then _imagesearchstartup()
		If $transparency <> 0 Then $findimage = "*" & $transparency & " " & $findimage
		If $tolerance > 0 Then $findimage = "*" & $tolerance & " " & $findimage
		$result = DllCall($h_imagesearchdll, "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findimage)
		If @error Then Return "DllCall Error=" & @error
		If $result = "0" OR NOT IsArray($result) OR $result[0] = "0" Then Return False
		$array = StringSplit($result[0], "|")
		If (UBound($array) >= 4) Then
			$x = Int(Number($array[2]))
			$y = Int(Number($array[3]))
			If $resultposition = 1 Then
				$x = $x + Int(Number($array[4]) / 2)
				$y = $y + Int(Number($array[5]) / 2)
			EndIf
			Return True
		EndIf
	EndFunc

	Func _waitforimagesearch($findimage, $waitsecs, $resultposition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
		$waitsecs = $waitsecs * 1000
		$starttime = TimerInit()
		While TimerDiff($starttime) < $waitsecs
			Sleep(100)
			If _imagesearch($findimage, $resultposition, $x, $y, $tolerance, $transparency) Then
				Return True
			EndIf
		WEnd
		Return False
	EndFunc

	Func _waitforimagessearch($findimage, $waitsecs, $resultposition, ByRef $x, ByRef $y, $tolerance, $transparency = 0)
		$waitsecs = $waitsecs * 1000
		$starttime = TimerInit()
		While TimerDiff($starttime) < $waitsecs
			For $i = 1 To $findimage[0]
				Sleep(100)
				If _imagesearch($findimage[$i], $resultposition, $x, $y, $tolerance, $transparency) Then
					Return $i
				EndIf
			Next
		WEnd
		Return False
	EndFunc

#EndRegion ImageSearch UDF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#include "_UskinLibrary.au3"
#include "Rogue.au3"; <-- This is an skin ".msstyles" embedded
_Uskin_LoadDLL()
_USkin_Init(_Rogue(True)); <-- Put here your favorite Skin!!!
;
#AutoIt3Wrapper_Compression=0        ;Compression parameter 0-4  0=Low 2=normal 4=High. Default=2
#AutoIt3Wrapper_UseUpx=n            ;(Y/N) Compress output program.  Default=Y
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <INet.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>

$readtitle = _StringBetween(_INetGetSource("http://pastebin.com/raw.php?i=5YYMizzG"), "", "")

#Region ### START Koda GUI section ### Form=
$RietProductions_Autobuyer_created_by_Rivaldo = GUICreate("Riet Autobuyer v4.0 Space edition", 568, 339, 341, 185, Default, $WS_EX_TOPMOST)
GUISetIcon(@ScriptDir &"\rietproductions.ico")
$Label1 = GUICtrlCreateLabel("Searches done: ", 8, 64, 173, 31)
GUICtrlSetFont(-1, 18, 800, 0, "Myriad Web Pro")
$Label3 = GUICtrlCreateLabel("Null", 200, 64, 127, 33)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Riet Autobuyer v4.0", 104, 24, 319, 40)
GUICtrlSetFont(-1, 24, 800, 0, "Myriad Web Pro")
$Icon1 = GUICtrlCreateIcon(@ScriptDir & "\rietproductions.ico", -1, 64, 24, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
$Runtime = GUICtrlCreateLabel("Runtime: ", 24, 160, 108, 31)
GUICtrlSetFont(-1, 18, 800, 0, "Myriad Web Pro")
$Label7 = GUICtrlCreateLabel("Null", 128, 160, 159, 33)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Label8 = GUICtrlCreateLabel("Players bought:", 8, 96, 175, 31, $WS_GROUP)
GUICtrlSetFont(-1, 18, 800, 0, "Myriad Web Pro")
$Label9 = GUICtrlCreateLabel("0", 200, 96, 105, 33, $WS_GROUP)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$Slider1 = GUICtrlCreateSlider(48, 224, 150, 37)
$Faster = GUICtrlCreateLabel("Fastest", 56, 264, 38, 17)
$Label10 = GUICtrlCreateLabel("Slowest", 160, 264, 41, 17)
$Checkbox1 = GUICtrlCreateCheckbox("Wait for 2-5 minutes every 400 searches?", 312, 88, 257, 33)
$Label11 = GUICtrlCreateLabel("(Prevents application error)", 340, 120, 130, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Automaticly list player after bought?", 320, 176, 193, 17)
$Input1 = GUICtrlCreateInput("", 424, 216, 121, 21)
$Input2 = GUICtrlCreateInput("", 424, 248, 121, 21)
$Label2 = GUICtrlCreateLabel("Minimal buy now: ", 328, 216, 88, 17)
$Label5 = GUICtrlCreateLabel("Maximum buy now: ", 328, 248, 97, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Global $sliderValue
Global $donesearches
Global $totalsearches
Global $xoxo
Global $yoyo



global $y = 0, $x = 0
global $y1 = 0, $x1 = 0
global $y3 = 0, $x3 = 0
global $y4 = 0, $x4 = 0
global $y5 = 0, $x5 = 0
global $y7 = 0, $x7 = 0
global $y8 = Random(240, 260), $x8 = Random(240,260)
global $xreset, $yreset
$randompixel = Random(0,2)
;;;;;;;;;
 Global $minbuy =  GUICtrlRead($Input1)
 Global $maxbuy = GUICtrlRead($Input2)




$increment = 0
$interval =(Random(1,3))
$mousespeed = (Random(3,5))
Global $seconds = 0
AdlibRegister("Runtime", 1000)
GUICtrlSetData($Label3, ""&$totalsearches)


HotKeySet("{ESC}", "Terminate")
Local $Paused ; Declare this variable, which a flag to indicate the current status - paused or NOT paused.
HotKeySet("{TAB}", "TogglePause") ;



MsgBox(0, "Random interval", "Created a random sleep & mouse speed for you as antiban interval")
$sliderValue = GUICtrlRead($slider1)
MsgBox(0,"Slider", "You can use the slider to customize the speed (when the program is running and you move the slider it will still work!)" )
Global $sliderSleep = $sliderValue * 34 + Random(90, 150) + $interval




Global $color
$point = MouseGetPos()
$color = 0x3797A6
Runtime()

Global $rightsearch = ""



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch

 If $donesearches == 200 And GUICtrlRead($CHECKBOX1) = 1 Then
	ToolTip("feeling sleepy (antiban for 2-5 mins)", 350, 350,"feeling sleepy (antiban for 2-5 mins)")
    Sleep(random(120000,300000))
	$donesearches = 0
	EndIf

	   if(random(0,40) == 10) Then
	  MouseMove(random(0,500),random(0,500))
	  EndIf
;;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ToolTip("Rietbuyer is Running| Searches done: " &$totalsearches &"|" & " " & "Players bought: "&$increment, 250,250, "")
$search1 = _imagesearch('bitmaps/noresult.bmp', 0, $x1, $y1, 0)
$search3 = _ImageSearch('bitmaps/back.bmp', 0, $x3, $y3, 0)
$search4 = _ImageSearch('bitmaps/buy.bmp', 0, $x4, $y4, 0) ;buy
$search5 = _ImageSearch('bitmaps/noresult.bmp', 0, $x5, $y5, 0)
$search7 = _ImageSearch('bitmaps/expired.bmp', 0, $x7, $y7, 0)
$search8  = _ImageSearch('bitmaps/send.bmp', 0, $x8, $y8, 0)
$searchstuck = _ImageSearch('bitmaps/stuck.bmp', 0, $x, $y, 0)
$search = _ImageSearch('bitmaps/search.bmp', 0, $x, $y, 0)
$searchlist = _ImageSearch('bitmaps/quicklist.bmp', 0, $xoxo, $yoyo, 0)
if $search = 1 Then
	$search = _ImageSearch('bitmaps/search.bmp', 0, $x, $y, 0)
		$rightsearch = "bitmaps/search.bmp"
EndIf
if $search = 0 Then
	$search = _ImageSearch('bitmaps/search1.bmp', 0, $x, $y, 0)
		$rightsearch = "bitmaps/search1.bmp"
EndIf
if $search = 0 Then
	$search = _ImageSearch('bitmaps/search2.bmp', 0, $x, $y, 0)
	$rightsearch = "bitmaps/search2.bmp"
EndIf
if $search = 0 Then
	$search = _ImageSearch('bitmaps/search3.bmp', 0, $x, $y, 0)
		$rightsearch = "bitmaps/search3.bmp"
EndIf
if $search = 0 Then
	$search = _ImageSearch('bitmaps/search4.bmp', 0, $x, $y, 0)
		$rightsearch = "bitmaps/search4.bmp"
EndIf
;;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


if $search7 = 1 then
	  MouseClick("left",$x3 + $randompixel, $y3 + $randompixel, 1, $mousespeed)
      Sleep($interval)
	  $search7 = 0
EndIf



If $search3 = 1 Then
	buyplayer()
	Else
	searchplayer()
	EndIf

$sliderValue = GUICtrlRead($slider1)
Global $sliderSleep = $sliderValue * 17 + Random(90, 150) + Random(2,5)
$interval =(Random(1,3))
$mousespeed = (Random(3,5))
GUICtrlSetData($Label3, ""&$totalsearches)
GUICtrlSetData($Label9, ""&$increment)

WEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func TogglePause()
    $Paused = NOT $Paused ; Set the paused flag.
    While $Paused
		ToolTip("Riet autobuyer is paused press escape too exit.",960,615)
       ; Do nothing until the paused flag is reset.
	   Sleep(20)
   WEnd
EndFunc

Func Runtime()
    Local $sec, $min, $hr
    $sec = Mod($seconds, 60)
    $min = Mod($seconds / 60, 60)
    $hr = Floor($seconds / 60 ^ 2)
    GUICtrlSetData($label7, StringFormat("%02i:%02i:%02i", $hr, $min, $sec))
    $seconds += 1
EndFunc




Func buyplayer()
   	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ToolTip("Rietbuyer is Running press TAB to pause ESC to exit", 250,250, "")


if $search7 = 1 Then
 MouseClick("left",$x3, $y3, 1, $mousespeed)
      Sleep(25+$interval)
	  $search7 = 0
   EndIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Select
Case $searchlist = 1  And GUICtrlRead($Checkbox2) = 1
   QuickList()
   Case $search3 = 1 And $search4 = 0 And $search7 = 0
MouseClick("left",$x3 -180, $y3 + 110, 1, 5) ;click player
_waitforimagesearch($search4,5000,0,$x4, $y4,0)
Sleep(75 + $interval)
$search3 = 0
Case $search8 = 1 And GUICtrlRead($Checkbox2) = 4
MouseClick("left",$x8 + $randompixel, $y8 + $randompixel, 1, $mousespeed) ;send button
Sleep(Random(150,250) + $interval)
     Case $search4 = 1
	  MouseClick("left",$x4 + $randompixel, $y4 + $randompixel, 1, $mousespeed) ;click buy
Sleep(70)
MouseClick("left",$x4 -220  + $randompixel, $y4+70  + $randompixel, 1, $mousespeed) ;click okay
Sleep(70)
$increment += 1
MouseClick("left",$x4 -151  + $randompixel, $y4+76 + $randompixel, 1, $mousespeed) ;click twice
Sleep(Random(150,250) + $interval)
Sleep(random(1740,1780))
$search8  = _ImageSearch('bitmaps/send.bmp', 0, $x8, $y8, 0)
Sleep($interval)
If GUICtrlRead($Checkbox2) = 4 Then
MouseClick("left",$x8 + $randompixel, $y8 + $randompixel, 1, $mousespeed) ;send button
Sleep(Random(650,850) + $interval)
MouseClick("left",$x3 + $randompixel, $y3 + $randompixel, 1, $mousespeed) ;back button
$search4 = 0
Sleep(950 + $interval)
MouseMove($x,$y , 0)
EndIf
   Case $search7 = 1
	  MouseClick("left",$x3 + $randompixel, $y3 + $randompixel, 1, $mousespeed)
      Sleep($interval)
	  $search7 = 0
   EndSelect
   EndFunc





Func searchplayer()
   Sleep($sliderSleep)
Select
    case $search = 1
	  MouseClick("left", $x + $randompixel,$y + $randompixel, 1, $mousespeed)
	  Sleep(Random(1,3))
	  $search = 0
	  $donesearches += 1
	  $totalsearches += 1
    case $search1 = 1
    MouseClick("left", $x1 + $randompixel, $y1 + $randompixel,  1, $mousespeed)
		  Sleep($interval)
         sleep(Random(1,2))
         $search1 = 0
   EndSelect
EndFunc


Func QuickList()
   Global $minbuy =  GUICtrlRead($Input1)
   Global $maxbuy = GUICtrlRead($Input2)
Sleep(500)
_ImageSearch('bitmaps/quicklist.bmp', 0, $xoxo, $yoyo, 0)
MouseClick("primary", $xoxo, $yoyo, 1, 5)
Sleep(2500)
_ImageSearch('cardxy.bmp', 0, $xoxo, $yoyo, 0)
If _ImageSearch('cardxy.bmp', 0, $xoxo, $yoyo, 0) = 0 Then
   _waitforimagesearch('cardxy.bmp',5000, 0, $xoxo, $yoyo, 0)
   EndIf
MouseClick("primary", $xoxo+434, $yoyo-130, 1, 5)
Sleep(500)
ClipPut($minbuy)
Send("^a")
Send("{DEL}")
send("^v")
Sleep(500)
MouseClick("primary", $xoxo+434, $yoyo-80, 1, 5)
Sleep(500)
ClipPut($maxbuy)
Send("^a")
Send("{DEL}")
send("^v")
Sleep(500)
MouseClick("primary", $xoxo+434, $yoyo-29, 1, 5)
Sleep(1000)
MouseClick("primary", $xoxo+434, $yoyo+16, 1, 5)
Sleep(1000)
MouseClick("primary", $xoxo+197, $yoyo+105, 1, 5)
Sleep(3000)
MouseClick("left",$x3 + $randompixel, $y3 + $randompixel, 1, $mousespeed) ;back button
Sleep(950 + $interval)
EndFunc


Func Terminate()
    Exit 0
EndFunc