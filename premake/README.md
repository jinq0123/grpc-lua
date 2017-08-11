# Use premake5 to generate VS solution

1. Download premake5.exe and put it here.
1. Install [conan](http://docs.conan.io/en/latest/installation.html).
1. `conan_install.bat`, which re-generates conanpremake files.
1. `premake5.exe vs2015` or `premake5.exe vs2013`
1. Use the generated `vs2015/grpc_lua.sln`
	+ The pre-generated `vs2015/grpc_lua.sln` can not use directly because it contains absolute paths.
