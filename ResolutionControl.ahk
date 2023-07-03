#Requires AutoHotkey v2.0

SetTimer CheckProcess, 5000
SetTimer GetCurrentResolution, 60000

screenResolution := GetInitialResolution()
gameMode := 0

gameSettings := [
				["ffxiv_dx11.exe"	,[2560,1440]],	;Final Fantasy 14
				["Yakuza5.exe"		,[1920,1080]],	;Yakuza 5
				["hl2.exe"			,[2560,1440]],	;Team Fortress 2
				["Titanfall2.exe"	,[1920,1080]]	;Titanfall 2
]

CheckProcess()
{
	global screenResolution
	global gameMode
	global gameSettings
	
	gameIsOpen := 0
	targetResolution := [,]

	Loop gameSettings.Length
	{
		if(ProcessExist(gameSettings[A_Index][1]))
		{
			gameIsOpen := 1
			targetResolution := gameSettings[A_Index][2]
		}
	}
	
	if (gameIsOpen = 1)
	{
		gameMode := 1
		if(screenResolution != (targetResolution[1] "x" targetResolution[2]))
		{
			ChangeResolution(targetResolution[1],targetResolution[2],32)
		}
	}
	else
	{
		if(gameMode = 1)
		{
			gameMode := 0
			ChangeResolution(3840,2160,32)
		}
	}
	return
}

GetCurrentResolution()
{
	RunWait "ResolutionCheck.ahk"
	global screenResolution := FileRead("resolution.txt")
	return
}

;For some reason cannot detect the proceding resolution changes done by the change resolution
GetInitialResolution()
{
	width := A_ScreenWidth
	height := A_ScreenHeight
	return (width "x" height)
}

ChangeResolution(screenWidth,screenHeight,colourDepth)
{
	global screenResolution

	deviceMode := Buffer(156)
	NumPut("int",156,deviceMode,36)	;Sets the dmSize

	DllCall("EnumDisplaySettingsA","UInt",0,"UInt",-1,"Ptr",deviceMode)	;We get the current settings

	;NumPut("UInt",0x5c0000,deviceMode,40)		;Used to change dmFields but it seems to have been redundant
	NumPut("UInt",colourDepth,deviceMode,104)	;Changes dmBitsPerPel
	NumPut("UInt",screenWidth,deviceMode,108)	;Changes dmPelsWidth
	NumPut("UInt",screenHeight,deviceMode,112)	;Changes dmPelsHeight

	DllCall("ChangeDisplaySettingsA","Ptr",deviceMode,"UInt",0)	;We make a call with the settings we put down

	screenResolution := screenWidth "x" screenHeight
	return
}