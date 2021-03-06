local FOLDER = os.getenv("CRYENGINETHREEFOLDER") or "NOTFOUND"

-- replaces \ with / and removes the last / if there are any
FOLDER = FOLDER:gsub("\\", "/"):gsub("(/)$", "")

if not os.isdir(FOLDER) then
	error(cryengine3 .. " is not a valid directory")
end
	
local function bslash(str)
	return str:gsub("/", "\\")
end

local f = string.format
local cmd = {}
local paths

local link_dir = function(a,b)
	table.insert(cmd, f([[rmdir /S /Q "TARGET_DIR\%s"]], bslash(a)))
	table.insert(cmd, f([[LINK_DIR "TARGET_DIR\%s" "WORKING_DIR\%s"]], bslash(a), bslash(b)))
end

local link_fil = function(a,b)
	table.insert(cmd, f([[del /S /F "TARGET_DIR\%s"]], bslash(a)))
	table.insert(cmd, f([[LINK_FIL "TARGET_DIR\%s" "WORKING_DIR\%s"]], bslash(a), bslash(b)))
end

local function copy(a, b) 
	table.insert(cmd, f([[copy "WORKING_DIR\%s" "TARGET_DIR\%s"]], bslash(a), bslash(b))) 
end


local function include_external(libname, libs)
	if _ACTION == "link" then
		copy(libname .. "/bin32/*", "bin32")
	else
		includedirs("../" .. libname .. "/src")
		includedirs("../" .. libname .. "/include")
		
		libdirs("../" .. libname .. "/lib/")
		if libs then
			for k,v in pairs(libs) do
				links(v)
			end
		else
			links(libname)
		end
		
		files("../" .. libname .. "/src/**.h")
		files("../" .. libname .. "/src/**.hpp")
		files("../" .. libname .. "/src/**.cpp")
		
		paths["oohh/bound/external/" .. libname .. "/*"] = path.getabsolute("../" .. libname .. "/src")
	end
end

local function exists(cmd)
	os.execute("@echo off")
	local exists = os.execute("help " .. cmd) == 1 -- lol
	os.execute("@echo on")

	return exists
end

local LINK_DIR
local LINK_FIL

if exists("mklink") then
	LINK_DIR = "mklink /d"
	LINK_FIL = "mklink"
else
	LINK_DIR = "linkd"
	LINK_FIL = "FSUTIL hardlink create"
end

if _ACTION == "link" then
	cmd = {}

	table.insert(cmd, [[rmdir "TARGET_DIR\data"]])
	table.insert(cmd, [[mkdir "TARGET_DIR\data"]])
	table.insert(cmd, [[rmdir /S /Q "TARGET_DIR\lua"]])
	table.insert(cmd, [[mkdir "TARGET_DIR\lua"]])
	table.insert(cmd, [[rmdir /S /Q "TARGET_DIR\lua\includes"]])
	table.insert(cmd, [[mkdir "TARGET_DIR\lua\includes"]])

	-- main dll
	link_fil("bin32/CryGame.dll", "oohh/content/bin32/CryGame.dll")
	
	-- init
	link_fil("lua/init.lua", "mmyy/lua/init.lua")	
	
	-- main lua folder links
	link_dir("lua/includes/modules", "mmyy/lua/includes/modules")
	link_dir("lua/includes/nil", "mmyy/lua/includes/nil")
	link_dir("lua/includes/standard", "mmyy/lua/includes/standard")
	
	-- the addon folder
	link_dir("addons", "oohh/content/addons")
	
	link_dir("lua/includes/cryengine3", "oohh/content/lua/includes/cryengine3")
	
	-- extra overrides
	link_dir("Game/Scripts", "oohh/content/Game/Scripts")
	link_dir("Game/Entities", "oohh/content/Game/Entities")	

	link_dir("Game/Levels/oh_island", "oohh/content/Game/Levels/oh_island")
	link_dir("Game/Levels/oh_grass", "oohh/content/Game/Levels/oh_grass")
	link_dir("Game/Levels/oh_construct", "oohh/content/Game/Levels/oh_construct")
	
	-- lua dependencies
	copy("mmyy/lib/lua51.dll", "bin32")
	
	-- vs2010 dependencies
	-- debug
	copy("oohh/content/bin32/msvcr100d.dll", "bin32")
	copy("oohh/content/bin32/msvcp100d.dll", "bin32")
	
	-- vs2012 dependencies
	-- debug
	copy("oohh/content/bin32/msvcr110d.dll", "bin32")
	copy("oohh/content/bin32/msvcp110d.dll", "bin32")
	-- release
	copy("oohh/content/bin32/msvcr110.dll", "bin32")
	copy("oohh/content/bin32/msvcp110.dll", "bin32")
	
	-- auto login
	copy("oohh/content/tools/CryDevLogin.exe", "Tools")
	copy("oohh/content/bin32/msvcr110.dll", "Tools")
	copy("oohh/content/bin32/msvcp110.dll", "Tools")
	
	include_external("awesomium")
	include_external("cairo")
	include_external("bass")

	for i, line in ipairs(cmd) do
		line = line:gsub("LINK_DIR", LINK_DIR)
		line = line:gsub("LINK_FIL", LINK_FIL)
		line = line:gsub("WORKING_DIR", bslash(path.getabsolute("../")))
		line = line:gsub("TARGET_DIR", bslash(FOLDER))

		print(line)
			
		os.execute(line)
	end

return end

paths = {
	["gamedll/*"] = path.getabsolute("../gamedll"),
	["oohh/*"] = path.getabsolute("../oohh"),
	["oohh/mmyy/*"] = path.getabsolute("../mmyy/include"),
}

solution("oohh")
	location(FOLDER .. "/oohh_project_files/" .. _ACTION)
	
	platforms("x32")
	
	defines("FORCE_STANDARD_ASSERT")
	defines("NDEBUG")
	defines("GAMEDLL_EXPORTS")
	defines("_XKEYCHECK_H")
	defines("CE3")

	configurations{"Debug", "Release"}
	
	project("GameDLL")

		flags("FloatFast")
		flags("NoRTTI")
		flags("NoMinimalRebuild")
		
		buildoptions
		{
			"/Gy",
			"/GS",
			"/GF",
			"/MP",
			"/arch:SSE",
		}
		
		linkoptions
		{
			("/BASE:\"@%s,GameDll\""):format(path.getabsolute("../gamedll/BaseAddress.Win32.txt")),
		}
	
		language("C++")
		kind("SharedLib")

		targetname("CryGame")		
	
		targetdir(FOLDER .. "/Bin32")
		debugdir(FOLDER .. "/Bin32/")
		objdir(FOLDER .. "/BinTemp/")
		
		includedirs("../oohh/")
		includedirs("../mmyy/include/")
		
		include_external("awesomium")
		include_external("cairo")
		include_external("bass")
		include_external("directx", {"d3dx9", "d3dx11"})
		
		includedirs(FOLDER .. "/Code/CryEngine/CryAction/")
		includedirs(FOLDER .. "/Code/CryEngine/CryCommon/")		
	
		includedirs("../gamedll/")
		includedirs(FOLDER .. "/Code/SDKs/boost/")
		includedirs(FOLDER .. "/Code/SDKs/STLPORT/")
	
		files("../gamedll/**.h")
		files("../gamedll/**.cpp")

		files("../mmyy/include/**.cpp")
		files("../mmyy/include/**.hpp")

		files("../oohh/**.hpp")
		files("../oohh/**.cpp")
				
		excludes("../oohh/content/*")

		vpaths(paths)
		
		libdirs("../mmyy/lib/")
		links("lua51")
		
		local bin32dir = bslash(path.getabsolute("../oohh/content/bin32/"))
		local dllpath = bslash(FOLDER .. "/bin32/CryGame.dll")
		os.execute(([[del /S /F "%s"]]):format(dllpath))
		postbuildcommands(([[xcopy /Y "%s" "%s"]]):format(dllpath, bin32dir))
		
		debugargs("-noborder -dx9")
		debugdir(FOLDER.."/bin32")
		
		configuration("debug")
			flags("Symbols")
			
		configuration("release")
			flags("Optimize")