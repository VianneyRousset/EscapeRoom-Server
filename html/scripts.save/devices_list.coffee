define () ->

	class DevicesList
		constructor: (@app) ->
			@event_source

	subscribe: (path) ->
		@event_source = new EventSource(path) 
		event_source.onmessage = (event) ->
			@update(event.data)

	update: (devices) ->
		for uid, device of devices
			console.log(device)
