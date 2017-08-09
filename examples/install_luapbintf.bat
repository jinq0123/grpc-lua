REM Install luapbintf/0.1@jinq0123/testing

REM Ignore if ERROR: Remote 'jinq0123' already exists with same URL
conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test
REM Using debug_x64
conan install luapbintf/0.1@jinq0123/testing --build missing -s build_type=Debug -s arch=x86_64 -s compiler.runtime=MDd
REM Ignore if ERROR: Remote 'remote_bintray_jinq0123' not found in remotes
conan remote remove remote_bintray_jinq0123
