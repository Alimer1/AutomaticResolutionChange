#Requires AutoHotkey v2.0

CheckCurrentResolution()

CheckCurrentResolution()
{
	width := A_ScreenWidth
	height := A_ScreenHeight
	resolution := width "x" height
	FileDelete "resolution.txt"
	FileAppend resolution, "resolution.txt"
	ExitApp
}