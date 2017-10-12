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
