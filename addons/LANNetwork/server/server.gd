extends NetworkContainer
class_name NetworkServer, 'res://addons/LANNetwork/server/server.png'



signal server_opened()
signal server_closed()



var                    __isReady        : bool                     = false

export(int)          var port           : int                      = 42268
export(int, 0, 1024) var maxConnections : int                      = 10
export(bool)         var isActive       : bool                     = false setget setActive

var peer                                : NetworkedMultiplayerENet



func _ready() -> void:
	__isReady = true
	if (isActive):
		setActive(true, true)



func setActive(value: bool, ignorePrev: bool = false) -> void:
	if (__isReady):
		if ((isActive or ignorePrev) and not value):
			emit_signal('server_closed')
			isActive = false
			get_tree().set_network_peer(null)

		elif (value and (ignorePrev or not isActive)):
			isActive = true
			peer = NetworkedMultiplayerENet.new()
			if (peer.create_server(port, maxConnections) != OK):
				print('Server could not be created on port {port}'.format({'port': port}))
				return
			get_tree().set_network_peer(peer)
			emit_signal('server_opened')

	isActive = value



func open() -> void:
	setActive(true)

func close() -> void:
	setActive(false)



func _exit_tree() -> void:
	setActive(false)
