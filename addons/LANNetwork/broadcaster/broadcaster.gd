extends NetworkContainer
class_name ServerBroadcaster, 'res://addons/LANNetwork/broadcaster/broadcaster.png'



signal broadcaster_opened()
signal broadcaster_closed()



var                    __isReady           : bool          = false

const                  DEFAULTPORT         : int           = 42268



export(bool          ) var isActive : bool          = false       setget setActive
export(int           ) var port     : int           = DEFAULTPORT
export(float, 0, 1024) var interval : float         = 0.5         setget setInterval

export(Dictionary)     var data     : Dictionary    = {
	'name' : 'My Server'
}



var                        socket          : PacketPeerUDP
var                        timer           : Timer         = Timer.new()



func _ready() -> void:
	__isReady = true
	if (isActive):
		setActive(true, true)



func setInterval(value: float):
	interval = value
	timer.wait_time = interval



func _enter_tree() -> void:
	timer.one_shot = false
	timer.autostart = true
	timer.connect('timeout', self, 'broadcast')
	self.add_child(timer)
	timer.start()



func setActive(value: bool, ignorePrev: bool = false) -> void:
	if (__isReady):
		if ((isActive or ignorePrev) and not value):
			emit_signal('broadcaster_closed')
			timer.stop()
			if (socket != null):
				socket.close()

		elif (value and (ignorePrev or not isActive)):
			socket = PacketPeerUDP.new()
			socket.set_broadcast_enabled(true)
			socket.set_dest_address('255.255.255.255', port)
			emit_signal('broadcaster_opened')

	isActive = value



func broadcast() -> void:
	if (isActive):
		var packet = to_json(data).to_ascii()
		socket.put_packet(packet)



func open() -> void:
	setActive(true)

func close() -> void:
	setActive(false)



func _exit_tree() -> void:
	setActive(false)
