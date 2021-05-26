extends Control



signal setAddress(ip)

enum {
	CONNECTION_NOT_CONNECTED
	CONNECTION_CONNECTED,
	CONNECTION_WAITING
}

var address   : String = ''                       setget setAddress
var connected : int    = CONNECTION_NOT_CONNECTED setget setConnected



func setAddress(ip: String) -> void:
	address = ip
	$Address.text = address



func setConnected(value: int) -> void:
	connected = value
	$Connect.text = 'Disconnect' if value == CONNECTION_CONNECTED else 'Waiting' if value == CONNECTION_WAITING else 'Connect'



func connectPressed() -> void:
	emit_signal('setAddress', address if connected == CONNECTION_NOT_CONNECTED else '')
