
local function conan_basic_setup()
	includedirs { conan_includedirs }
	libdirs { conan_libdirs }
	links { conan_libs }
end  -- conan_basic_setup

	filter { "configurations:Debug", "platforms:x32" }
		require("conanpremake_debug_x32")
		conan_basic_setup()
	filter { "configurations:Debug", "platforms:x64" }
		require("conanpremake_debug_x64")
		conan_basic_setup()
	filter { "configurations:Release", "platforms:x32" }
		require("conanpremake_release_x32")
		conan_basic_setup()
	filter { "configurations:Release", "platforms:x64" }
		require("conanpremake_release_x64")
		conan_basic_setup()
	filter {}

