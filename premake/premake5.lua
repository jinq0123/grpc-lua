-- premake5.lua
--[[
Usage examples: 
	for windows: premake5.exe --os=windows vs2015
	fot linux:   premake5.exe --os=linux gmake
]]

workspace "grpc_lua"
	location (_ACTION)  -- subdir vs2015 (or gmake, ...)
	configurations { "Release", "Debug" }
	platforms { "x64", "x32" }

	language "C++"
	flags {
		"C++11",
	}

	require("conanpremake_multi")  -- for third-party libs

	filter "configurations:Debug"
		flags { "Symbols" }
	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
	filter {}

project "grpc_lua"
	kind "SharedLib"
	targetname "grpc_lua"
	targetprefix ""  -- linux: grpc_lua.so

	files {
		"../src/cpp/**",
		"../src/**.lua",
		"../examples/**.lua",
		"../examples/**.proto",
		"../examples/**.json",
	}
	includedirs {
		"../src/cpp",
	}

	--[[
	From: https://github.com/SteveKChiu/lua-intf
	By default LuaIntf expect the Lua library to build under C++.
	If you really want to use Lua library compiled under C,
	you can use lua.lib instead of lua-cpp.lib and:
		defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }
	--]]

	filter { "system:windows" }
		defines {
			"_WIN32_WINNT=0x0600",  -- i.e. Windows 7 target
		}
	filter {}
