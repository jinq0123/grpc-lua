# How to implement client streaming rpc service?

Client streaming is client-side streaming or bi-directional streaming.

To implement a client streaming rpc service,
 user should a lua table like following:
 
```
impl = {
	on_msg = function(msg)
		assert("table" == type(msg))
	end  -- on_msg()
	
	on_error = function(error_str, status_code)
		assert("string" == type(error_str))
		assert("number" == type(status_code))  -- int type
	end  -- on_error()
	
	on_end = function()
	end  -- on_end()
}
``` 

These functions can be nil.

## Difference from 

[grpc_cb](https://github.com/jinq0123/grpc_cb) has a base class "ServerReader"
which has a default 'OnError()' implement which close the writer or replier immediately.
In lua, user should provide similar function in `on_error()` like the route_guide example:
```
function Reader:on_error(error_str, status_code)
    self._replier.reply_error(error_str, status_code)
end
```
```
function Reader:on_error(error_str, status_code)
    self._writer:close()
end
```
