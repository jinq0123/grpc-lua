# gRPC-Lua
The Lua [gRPC](http://www.grpc.io/) binding.

NOT READY!

## Dependings
gRPC-Lua depends on
* [grpc_cb_core](https://github.com/jinq0123/grpc_cb_core)
* [lua-intf](https://github.com/SteveKChiu/lua-intf)
* [lua](https://www.lua.org/)

See [doc/conan-graph.html](http://htmlpreview.github.io/?https://github.com/jinq0123/grpc-lua/master/doc/conan-graph.html)

All these libraries can be installed by [conan](https://www.conan.io/)
C/C++ package manager.

## Build

### Quick Build
1. Install [conan](http://docs.conan.io/en/latest/installation.html).
1. `conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test`
1. `conan create user/channel --build missing`
    * The result `grpc_lua.dll`/`grpc_lua.so` is in `~/.conan/data/grpc-lua/0.1/user/channel/package/`...

### VS solution
See [premake/README.md](premake/README.md) to use premake5 to generate VS solution.

## Tutorial
Tutorial shows some codes in the route_guide example.

### Define the service
See [examples/route_guide/route_guide.proto](examples/route_guide/route_guide.proto).
```protobuf
// Interface exported by the server.
service RouteGuide {
  // A simple RPC.
  rpc GetFeature(Point) returns (Feature) {}

  // A server-to-client streaming RPC.
  rpc ListFeatures(Rectangle) returns (stream Feature) {}

  // A client-to-server streaming RPC.
  rpc RecordRoute(stream Point) returns (RouteSummary) {}

  // A Bidirectional streaming RPC.
  rpc RouteChat(stream RouteNote) returns (stream RouteNote) {}
}
...
```

### Import proto file
For both client and server codes:
```lua
local grpc = require("grpc_lua.grpc_lua")
grpc.import_proto_file("route_guide.proto")
```
No need to generate codes.

### Client
See [examples/route_guide/route_guide_client.lua](examples/route_guide/route_guide_client.lua).

#### Create a stub
```lua
    local c_channel = grpc.channel("localhost:50051")
    local stub = grcp.service_stub(c_channel, "routeguide.RouteGuide")
```

#### Call service method
+ Sync call
	* Simple RPC: ```sync_get_feature()```
		```lua
		local feature = stub.sync_request("GetFeature", point(409146138, -746188906))
		```

	* Server-side streaming RPC: ```sync_list_features()```
		```lua
		local sync_reader = stub:sync_request_read("ListFeatures", rect)
		while true do
			local feature = sync_reader.read_one()
			if not feature then break end
			print("Found feature: "..inspect(feature))
		end  -- while
		```

	* Client-side streaming RPC: ```sync_record_route()```
		```lua
		local sync_writer = stub.sync_request_write("RecordRoute")
		for i = 1, 10 do
			local feature = db.get_rand_feature()
			local loc = assert(feature.location)
			if not sync_writer.write(loc) then
				break
			end  -- if
		end  -- for
		
		-- Recv status and reponse.
		local summary, error_str, status_code = sync_writer.close()
		if summary then
			print_route_sumary(summary)
		end
		```

	* Bidirectional streaming RPC: ```sync_route_chat()```
		```lua
		local sync_rdwr = stub.sync_request_rdwr("RouteChat")
		
		for _, note in ipairs(notes) do
			sync_rdwr.write(note)
		end
		sync_rdwr.close_writing()
		
		-- read remaining
		while true do
			local server_note = sync_rdwr.read_one()
			if not server_note then break end
			print("Got message: "..inspect(server_note))
		end  -- while
		```

+ Async call

	* Simple RPC: ```get_feature_async()```
		```lua
		stub.async_request("GetFeature", point(409146138, -746188906),
			function(resp)
				print("Get feature: "..inspect(resp))
				stub.shutdown()  -- to return
			end)
		stub.run()  -- run async requests until stub.shutdown()
		```

		+ Ignore response
			```lua
			stub.async_request("GetFeature", point())  -- ignore response
			```

		+ Set error callback

			```stub.set_error_cb(function(error_str, status_code) ... end)```
			before `async_request()`

	* Run the stub
		+ Async calls need `run()`
			```lua
			stub.run()  -- run async requests until stub.shutdown()
			```
		+ ```stub.shutdown()``` ends ```stub.run()```.

	* Server-side streaming RPC: ```list_features_async()```
		```lua
		stub.async_request_read("ListFeatures", rect,
			function(f)
				assert("table" == type(f))
				print(string.format("Got feature %s at %f,%f", f.name,
					f.location.latitude/kCoordFactor, f.location.longitude/kCoordFactor))
			end,
			function(error_str, status_code)
				assert("number" == type(status_code))
				stub.shutdown()  -- To break Run().
			end)
		stub.run()  -- until stub.shutdown()
		```

	* Client-side streaming RPC: ```record_route_async()```
		```lua
		local async_writer = stub.async_request_write("RecordRoute")
		for i = 1, 10 do
			local f = db.get_rand_feature()
			local loc = f.location
			if not async_writer:write(loc) do break end  -- Broken stream.
		end  -- for
		
		-- Recv reponse and status.
		async_writer.close(
			function(resp, error_str, status_code)
				if resp then
					print_route_summary(resp)
				end  -- if
				stub.shutdown()  -- to break run()
			end)
		stub.run()  -- until stutdown()
		```

	* Bidirectional streaming RPC: ```route_chat_async()```
		```lua
		local rdwr = stub.async_request_rdwr("RouteChat",
			function(error_str, status_code)
				stub.shutdown()  -- to break run()
			end)
	
		for _, note in ipairs(notes) do
			rdwr.write(note)
		end
		rdwr.close_writing()  -- Optional.
		rdwr.read_each(function(server_note)
			assert("table" == type(server_note))
			print("Got message: "..inspect(server_note))
		end)

		stub.run()  -- until shutdown()
		```

### Server
See [examples/route_guide/route_guide_server.lua](examples/route_guide/route_guide_server.lua).

#### Start server
```lua
    local svr = grpc.server()
    svr:add_listening_port("0.0.0.0:50051")
    -- Service implementation is a table.
    local service = require("route_guide_service")
    svr:register_service("routeguide.RouteGuide", service)
    svr:run()
```

#### Implement service

Service is a table with the service functions defined in the proto file.
The function name must be the same as in the proto file.
The function parameters are different for different RPC method types.

1. Simple RPC: ```GetFeature()```
	```lua
	--- Simple RPC method.
	-- @tab request
	-- @tparam Replier replier
	function M.GetFeature(request, replier)
		assert("table" == type(request))
		assert("table" == type(replier))
		local name = get_feature_name(request)
		local response = { name = name, location = request }
		replier:reply(response);
	end  -- GetFeature()
	```

	`replier` can be copied and `reply()` later.

1. Server-side streaming RPC: ```ListFeatures()```
	```lua
	--- Server-to-client streaming method.
	-- @table rectangle
	-- @tparam Writer writer
	function M.ListFeatures(rectangle, writer)
		assert("table" == type(rectangle))
		assert("table" == type(writer))
		...
		for _, f in ipairs(db.features) do
			local l = f.location
			if l... then
				if not writer.write(f) then
					print("Failed to write.")
					break
				end  -- if not writer.write()
			end  -- if l
		end  -- for _, f
		writer.close()
	end  -- ListFeatures()
	```

1. Client-side streaming RPC: ```RecordRoute()```
	- Should return a reader table:
		```lua
		--- Client-to-server streaming method.
		-- @tab replier `Replier` object
		-- @treturn table server reader object
		function M.RecordRoute(replier)
			assert("table" == type(replier))
			return require("server_reader.RecordRouteReader"):new(replier, db)
		end  -- RecordRoute()
		```

	- the reader table should optionally have these methods
		* ```function Reader:on_msg(msg)```
		* ```function Reader:on_error(error_str, status_code)```
		* ```function Reader:on_end()```

1. Bidirectional streaming RPC: ```RouteChat()```
	* Should return a reader table.
		```lua
		--- Bi-directional streaming method.
		-- @table writer `Writer` object
		-- @treturn table server reader object
		function M.RouteChat(writer)
			assert("table" == type(writer))
			return require("server_reader.RouteChatReader"):new(writer, db)
		end  -- RouteChat()
		```

	* The reader table should optionally have methods as client-side streaming reader.

## Example codes
* [greeter_client.lua](examples/helloworld/greeter_client.lua)
* [greeter_server.lua](examples/helloworld/greeter_server.lua)
* [route_guide_client.lua](examples/route_guide/route_guide_client.lua)
* [route_guide_server.lua](examples/route_guide/route_guide_server.lua)

### How to run examples
1. Copy required exe and dll. 
   Rename [examples/conan_install.bat.example](examples/conan_install.bat.example)
   to `conan_install.bat`, and change `conandata` variable in it. Then run it.
   `conan_install.bat` will:
     + Install dependings using `conan` into `~/.conan/data`
     + Copy exe and dlls from `~/.conan/data`
		- lua-cpp.exe
		- lua-cpp.dll
		- luapbintf.dll
		- grpc_lua.dll
   
1. Start lua script
	* helloworld
		+ `lua-cpp.exe greeter_server.lua`
		+ `lua-cpp.exe greeter_client.lua`
	* route_guide
		+ `lua-cpp.exe route_guide_server.lua`
		+ `lua-cpp.exe route_guide_client.lua`

## API doc
See [doc/ldoc/html/index.html](http://htmlpreview.github.io/?https://github.com/jinq0123/grpc-lua/master/doc/ldoc/html/index.html)
