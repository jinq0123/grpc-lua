REM Please install conan first: 
REM http://docs.conan.io/en/latest/installation.html

REM Ignore if ERROR: Remote 'jinq0123' already exists with same URL
conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test

set arg=--build missing --build outdated --update

REM Augument -s means --settings
conan install .. %arg% -s build_type=Release -s arch=x86_64 -s compiler.runtime=MD
move conanpremake.lua conanpremake_release_x64.lua
conan install .. %arg% -s build_type=Release -s arch=x86 -s compiler.runtime=MD
move conanpremake.lua conanpremake_release_x32.lua
conan install .. %arg% -s build_type=Debug -s arch=x86_64 -s compiler.runtime=MDd
move conanpremake.lua conanpremake_debug_x64.lua
conan install .. %arg% -s build_type=Debug -s arch=x86 -s compiler.runtime=MDd
move conanpremake.lua conanpremake_debug_x32.lua

REM Ignore if ERROR: Remote 'remote_bintray_jinq0123' not found in remotes
conan remote remove remote_bintray_jinq0123
