REM Generate lua document.

REM Remove old html files.
rmdir /S /Q html

set LUA=lua_tools\lua-cpp.exe
set LDOC=lua_tools\LDoc-1.4.6\ldoc.lua
%LUA% -e "package.cpath = 'lua_tools/?.dll;'..package.cpath" ^
      -e "package.path = 'lua_tools/Penlight-1.5.2/lua/?.lua;'..package.path" ^
      %LDOC% .

pause
