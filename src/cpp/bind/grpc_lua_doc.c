// lua doc. No code.

/// grpc C module.
// Wraps grpc_cb_core library.
// @module grpc_lua.c

/// @type Channel
;
/// Constructor.
// @function Channel
// @string target host and port, like "a.b.com:6666" or "1.2.3.4:6666".
// @usage grpc_lua_c.Channel("localhost:6666")
;

/// @type ServiceStub
;
/// Constructor.
// @function ServiceStub
// @tparam Channel c_channel
// @usage grcp_lua_c.ServiceStub(c_channel)
;
/// Sync request.
// @function sync_request
// @string method_name
// @string request serialized message
// @usage stub:sync_request("SayHello", s)
;
/// Async request.
// @function async_request
// @string method_name
// @string request serialized message
// @func[opt] on_response response callback, `function(response_str)`
// @func[opt] on_error error handler, `function(error_str, status_code)`
;
/// Blocking run.
// Run async requests until shutdown.
// @function run
;
/// Shutdown.
// To end the blocking run.
// @function shutdown
;

/// @type Server
;
/// Constructor.
// @function Server
;
/// Add listening port.
// @function add_listening_port
// @treturn int returns bound port number on success, 0 on failure.
;
/// Register service.
// @function register_service
// @param service_descriptor
// @param service
;
/// Blocking run.
// Run the server.
// @function run
;

/// @type Replier
;
/// Constructor.
// @function Replier
// @param call
;
/// Reply.
// @function reply
// @string response_str serialized message
;
