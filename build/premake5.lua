-- premake5.lua
--[[
Usage examples: 
	for windows: premake5.exe --os=windows vs2015
	fot linux:   premake5.exe --os=linux gmake
]]

local lua_include_dir = "../third_party/lua-5.3.4/src"

workspace "grpc_lua"
	configurations { "Debug", "Release" }
	language "C++"
	flags {
		"C++11",
		"StaticRuntime",
	}
	
	filter "configurations:Debug"
		flags { "Symbols" }
	filter "configurations:Release"
		defines { "NDEBUG" }
		optimize "On"
	filter {}

project "grpc_lua_plugin"
	kind "ConsoleApp"
	files {
		"../src/compiler/**",
	}
	links {
		"grpc_plugin_support",
	}

	filter "configurations:Debug"
		links {
			"libprotocd",
		}
	filter "configurations:Release"
		links {
			"libprotoc",
		}
	filter {}

project "grpc_lua"
	kind "SharedLib"
	files {
		"../src/lua/**",
	}
	includedirs {
		"../third_party/include",
		"../third_party/lua-intf",
		lua_include_dir,
	}
