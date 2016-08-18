@ECHO OFF
echo "This program will either block a user or grant permissions to all subfiles and subdirectories"
SET /P ACTION=Please press 0 to deny permissions, press 1 to grant permissions, press 2 to remove user from list: 
SET /P USER=Which user would you like to take this action with:

SET CHECK=%CD%
echo FIRST
echo %cd%

GOTO :lockAll

:wrap

for %%E in (*) do (
	echo "%%E"
	IF %ACTION% == 0 icacls "%%E" /deny %USER%:F
	IF %ACTION% == 1 icacls "%%E" /grant %USER%:F
	IF %ACTION% == 2 icacls "%%E" /remove %USER%

	IF %ACTION% == 0 icacls "%CHECK%" /deny %USER%:F
	IF %ACTION% == 1 icacls "%CHECK%" /grant %USER%:F
	IF %ACTION% == 2 icacls "%CHECK%" /remove %USER%
)

EXIT /B

:lockAll
echo %cd%
echo "-----"
for /D %%D in (*) do (
	icacls "%%D" /grant gchandler:F
	
	cd "%%D"

	for %%E in (*) do (
		IF %ACTION% == 0 icacls "%%E" /deny %USER%:F
		IF %ACTION% == 1 icacls "%%E" /grant %USER%:F
		IF %ACTION% == 2 icacls "%%E" /remove %USER%
	)
	
	call :lockAll
	cd ..
	IF %ACTION% == 0 icacls "%%D" /deny %USER%:F
	IF %ACTION% == 1 icacls "%%D" /grant %USER%:F
	IF %ACTION% == 2 icacls "%%D" /remove %USER%
)
IF %CHECK% == %cd% GOTO wrap