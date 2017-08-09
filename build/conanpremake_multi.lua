
	filter { "configurations:Debug", "platforms:x32" }
		require("conanpremake_debug_x32")
	filter { "configurations:Debug", "platforms:x64" }
		require("conanpremake_debug_x64")
	filter { "configurations:Release", "platforms:x32" }
		require("conanpremake_release_x32")
	filter { "configurations:Release", "platforms:x64" }
		require("conanpremake_release_x64")
	filter {}

	includedirs { conan_includedirs }
	libdirs { conan_libdirs }
	links { conan_libs }
