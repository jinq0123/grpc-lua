# Todo

* ServiceStub add Request() and AsyncRequest()
* grpc_cb support string message.
	+ Reply string

* ServiceStub.get_completion_queue()
* blocking_run(completion_queue)

* Use method name instead of method index?

* c_service_stub
	+ set_default_error_cb()
	+ set_error_cb()
	+ set_timeout_ms()
	
* Fix ChannelSptr like ServiceStub(ChannelSptr) -> GetServiceStub(Channel&)
