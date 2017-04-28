-- premake5.lua
--[[
Usage examples: 
	for windows: premake5.exe --os=windows vs2015
	fot linux:   premake5.exe --os=linux gmake
]]

workspace "grpc_lua"
	configurations { "Debug", "Release" }
	language "C++"
	flags {
		"C++11",
	}
	libdirs {
		"../third_party/lib",
		"../third_party/lib/%{cfg.buildcfg}",
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
	targetname "grpc_lua"
	targetprefix ""  -- linux: grpc_lua.so

	files {
		"../src/lua/**",
	}

	--[[
	From: https://github.com/SteveKChiu/lua-intf
	By default LuaIntf expect the Lua library to build under C++.
	If you really want to use Lua library compiled under C,
	you can define LUAINTF_LINK_LUA_COMPILED_IN_CXX to 0:
	--]]
	-- defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }

	includedirs {
		"../third_party/include",
		"../third_party/lua-intf",
		"../third_party/lua/src",
	}
	links {
		"lua53",
		"grpc_cb",
	}

	filter { "system:windows" }
		defines {
			"_WIN32_WINNT=0x0600",  -- i.e. Windows 7 target
			"GRPC_CB_DLL_IMPORT",
		}
		links {
			"ws2_32",
		}
	filter {}