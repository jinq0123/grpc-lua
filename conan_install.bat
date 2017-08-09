REM Please install conan first: 
REM http://docs.conan.io/en/latest/installation.html

conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test
REM Augument -s means --settings
conan install --build missing -s build_type=Release -s arch=x86_64 -s compiler.runtime=MD
move conanpremake.lua build/conanpremake_release_x64.lua
conan install --build missing -s build_type=Release -s arch=x86 -s compiler.runtime=MD
move conanpremake.lua build/conanpremake_release_x32.lua
conan install --build missing -s build_type=Debug -s arch=x86_64 -s compiler.runtime=MDd
move conanpremake.lua build/conanpremake_debug_x64.lua
conan install --build missing -s build_type=Debug -s arch=x86 -s compiler.runtime=MDd
move conanpremake.lua build/conanpremake_debug_x32.lua
conan remote remove remote_bintray_jinq0123
