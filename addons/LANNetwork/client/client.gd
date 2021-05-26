extends NetworkContainer
class_name NetworkClient, 'res://addons/LANNetwork/client/client.png'



signal client_connected()
signal connection_failed()

signal client_disconnected()
signal server_disconnected()



var                    __isReady        : bool                     = false

export(String)       var address        : String                   = 'localhost'
export(int)          var port           : int                      = 42268
export(bool)         var isActive       : bool                     = false setget setActive

var peer                                : NetworkedMultiplayerENet



func _ready() -> void:
	__isReady = true
	if (isActive):
		setActive(true, true)



func setActive(value: bool, ignorePrev: bool = false) -> void:
	if (__isReady):
		if ((isActive or ignorePrev) and not value):
			emit_signal('client_disconnected')
			isActive = false
			get_tree().set_network_peer(null)

		elif (value and (ignorePrev or not isActive)):
			isActive = true
			peer = NetworkedMultiplayerENet.new()
			if (peer.create_client(address, port) != OK):
				print('Server could not be created on port {port}'.format({'port': port}))
				return
			get_tree().connect('connected_to_server', self, 'client_connected')
			get_tree().connect('connection_failed', self, 'connection_failed')
			get_tree().connect('server_disconnected', self, 'server_disconnected')
			get_tree().set_network_peer(peer)

	isActive = value



func client_connected() -> void:
	emit_signal('client_connected')

func connection_failed() -> void:
	emit_signal('connection_failed')

func server_disconnected() -> void:
	emit_signal('server_disconnected')
