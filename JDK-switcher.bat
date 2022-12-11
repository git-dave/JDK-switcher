@echo off

setlocal EnableDelayedExpansion

rem use findstr to strip blank lines
for /f "usebackq skip=1 tokens=*" %%i in (`wmic OS get OSArchitecture ^| findstr /r /v "^$"`) do (
	set "_bits=%%i"
	rem extract first 2 characters
	set "_bits=!_bits:~0,2!"
	echo Your PC is a !_bits! bits OS Architecture
)

if !_bits! equ 64 (
	set jdkDir="C:\Program Files\java\*"
) else if !_bits! equ 32 (	
	set jdkDir="C:\Program Files (x86)\java\*"
)

set current_java_home=%JAVA_HOME%
echo:
echo Your Current JAVA_HOME is set to %current_java_home%

echo:
echo To switch to your choice of JDK, select the number option
echo:

rem Repeat the process again if the user provide a wrong option not listed
:begin

set /a options=0
for /d %%d in (%jdkDir%) do (
	set var=%%d
	rem Only display if folder is a jdk folder not jre
 	if "!var:~22,3!" equ "jdk" (
 		echo Enter [!options!] to switch to !var:~22,15!
 		rem set /a arr_index = !options! - 1
 		set jdk_array[!options!]=!var!
 		set /a options += 1
 	)
)

echo.
set /p user_response= Enter switch option ? 

set indice=0

:jdkLoop
if not defined jdk_array[!indice!] (
	goto :error
)else (
	if !user_response! equ !indice! (
		setx /m JAVA_HOME "!jdk_array[%indice%]!"
		echo Successfully switched your JAVA_HOME to "!jdk_array[%indice%]!"
		goto :done
	)
	set /a indice +=1
	goto :jdkLoop
)	

:error
echo Your option number !user_response! was not among the list of options

rem Redirect the user to re-enter a correct option
echo.
goto :begin

:done
endlocal
echo.
pause