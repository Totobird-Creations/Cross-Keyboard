extends NetworkContainer
class_name ServerListener, 'res://addons/LANNetwork/listener/listener.png'



signal listener_ready()
signal server_found(data)
signal server_lost(ip)



var                    __isReady           : bool          = false

const                  DEFAULTPORT         : int           = 42268



export(int           ) var port     : int           = DEFAULTPORT
export(float, 1, 1024) var interval : float         = 2.0         setget setInterval

export(Dictionary)     var servers  : Dictionary    = {
}



var                        socket          : PacketPeerUDP = PacketPeerUDP.new()
var                        timer           : Timer         = Timer.new()



func setInterval(value: float):
	interval = value
	timer.wait_time = interval



func _enter_tree() -> void:
	timer.one_shot = false
	timer.autostart = true
	timer.connect('timeout', self, 'cleanup')
	self.add_child(timer)
	timer.start()
	socket.listen(port)
	emit_signal('listener_ready')



func _process(delta: float) -> void:
	if (socket.get_available_packet_count() >= 1):
		var connIp   = socket.get_packet_ip()
		var connPort = socket.get_packet_port()
		var connData = socket.get_packet().get_string_from_ascii()

		if (connIp != '' and connPort >= 1):
			if (not connIp in servers.keys()):
				connData = parse_json(connData)
				connData['address']  = connIp
				connData['lastSeen'] = OS.get_unix_time()
				servers[connIp] = connData
				emit_signal('server_found', connData)
			else:
				servers[connIp]['lastSeen'] = OS.get_unix_time()



func cleanup() -> void:
	var time = OS.get_unix_time()
	var server
	for ip in servers.keys():
		server = servers[ip]
		if (time - server['lastSeen'] > interval):
			servers.erase(ip)
			emit_signal('server_lost', ip)



func _exit_tree() -> void:
	socket.close()
