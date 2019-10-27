import './lib/jquery-3.4.1.js'

class List
	constructor: (id) ->
		@state = 'none'
		@list_node = document.querySelector(id)
		@template_node = @list_node.querySelector('template')
		@loading_node = @list_node.querySelector('.loading')
		@error_node = @list_node.querySelector('.error')
		@event_source = null

	subscribe: (path) ->
		@set_state('loading')
		@event_source = new EventSource path 
		@event_source.onmessage = (event) =>
			@update(JSON.parse(event.data))
			@set_state('good')
		@event_source.onerror = (error) =>
			console.log(error)
			@set_state('error')

	update: (datas) ->
		uids = (item_node.getAttribute('uid') for item_node in @items_nodes())
		for uid in uids
			if uid not of datas
				@item_node(uid).remove()
		for uid, data of datas 
			uids = (item_node.getAttribute('uid') for item_node in @items_nodes())
			if uid not in uids
				@add_row(uid, data)
			else
				@update_item(@item_node(uid), data)

	add_row: (uid, data) ->
		clone = document.importNode(@template_node.content, true)
		@list_node.appendChild(clone)
		item = @item_node('')
		item.style.display = 'none'
		item.setAttribute('uid', uid)
		@update_item(item, data)
		item.style.display = 'block'

	set_state: (state) ->
		if state is 'loading'
			@error_node.style.display = 'none'
			for item_node in @items_nodes
				item.style.display = 'none'
			@loading_node.style.display = 'block'
		else if state is 'good'
			@loading_node.style.display = 'none'
			@error_node.style.display = 'none'
			for item_node in @items_nodes
				item.style.display = 'block'
			console.log('good')
		else if state is 'error'
			for item_node in @items_nodes
				item.style.display = 'none'
			@loading_node.style.display = 'none'
			@error_node.style.display = 'block'

	#TODO sort list alphabetically

	items_nodes: ->
		@list_node.querySelectorAll('.item')
	
	item_node: (uid) ->
		@list_node.querySelector('.item[uid="'+uid+'"]')

class DevicesList extends List
	constructor: ->
		super('#devices-list')

	set_game: (game_name) ->
		@subscribe('/'+game_name+'/devices')

	update_item: (item, data) ->
		item.querySelector('summary').textContent = data['name']
		#TODO state, online/offline

window.addEventListener 'load', ->
	devices_list = new DevicesList
	devices_list.set_game('b3')
