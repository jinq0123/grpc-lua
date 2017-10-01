project='grpc-lua'
title='grpc-lua documentation'
description='The Lua gRPC binding'
format='discount'
backtick_references=false
file={
    '../../src',
    exclude = {
    }
}
dir='html'
-- readme='doc.md'
style='!pale'
examples = {
    '../../examples',
    exclude = {
        '../../examples/route_guide/inspect.lua-3.1.0',
        '../../examples/route_guide/json.lua-0.1.0',
    }
}
sort_modules=true
convert_opt=true
