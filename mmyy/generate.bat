@echo off

	cd %~dp0premake
	premake4 codeblocks
	premake4 codelite
	premake4 gmake
	premake4 vs2002
	premake4 vs2003
	premake4 vs2005
	premake4 vs2008
	premake4 vs2010
	premake4 xcode3
	premake4 xcode4

pause
exit /b 0
