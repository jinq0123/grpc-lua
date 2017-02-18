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
		lua_include_dir,
	}
	libdirs {
		"../third_party/lib",
		"../third_party/lib/%{cfg.buildcfg}",
	}
	links {
		"lua",
		"grpc_cb",
		"grpc",
		"gpr",
		"zlib",
		"ssleay32",
		"libeay32",
	}

	if os.is("windows") then
		defines {
			"_WIN32_WINNT=0x0600"  -- i.e. Windows 7 target
		}
		links {
			"ws2_32",
		}
	end