extends Control



const LISTITEM : Object = preload('res://Pc/ListItem.tscn')



func updateList():
	var servers = $ServerListener.servers
	var addresses = servers.keys()
	addresses.sort()

	for server in $List/Vertical.get_children():
		server.queue_free()

	var instance

	if (Data.address != ''):
		instance = LISTITEM.instance()
		instance.setAddress(Data.address)
		instance.setConnected(instance.CONNECTION_CONNECTED if Data.address in addresses else instance.CONNECTION_WAITING)
		instance.connect('setAddress', self, 'selectServer')
		$List/Vertical.add_child(instance)

	for address in addresses:
		if (address != Data.address):
			instance = LISTITEM.instance()
			instance.setAddress(address)
			instance.setConnected(instance.CONNECTION_NOT_CONNECTED)
			instance.connect('setAddress', self, 'selectServer')
			$List/Vertical.add_child(instance)



func serverFound(data):
	if (Data.address == data.address):
		$NetworkClient.isActive = true
	updateList()



func serverLost(ip):
	if (Data.address == ip):
		$NetworkClient.isActive = false
	updateList()



func selectServer(ip):
	Data.address = ip
	$NetworkClient.address = Data.address
	$NetworkClient.isActive = Data.address != ''
	updateList()



func _physics_process(delta: float) -> void:
	if (len(Data.unmanagedKeys) >= 1):
		var keys = Data.unmanagedKeys
		Data.unmanagedKeys = []
		for key in keys:
			OS.execute('python', [OS.get_user_data_dir() + '/presskey.py'] + Array(key))

	if (Data.unmanagedMouse != Vector2.ZERO):
		var mouse = Data.unmanagedMouse
		Data.unmanagedMouse = Vector2.ZERO
		OS.execute('python', [OS.get_user_data_dir() + '/movemouse.py', str(mouse.x), str(mouse.y)])

	if (len(Data.unmanagedMouseButtons) >= 1):
		var buttons = Data.unmanagedMouseButtons
		Data.unmanagedMouseButtons = []
		for button in buttons:
			OS.execute('python', [OS.get_user_data_dir() + '/pressmousebutton.py'])
