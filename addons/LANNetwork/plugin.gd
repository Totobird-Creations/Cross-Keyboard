tool
extends EditorPlugin



func _enter_tree() -> void:
#	add_custom_type(
#		'NetworkContainer',
#		'Node',
#		load('res://addons/LANNetwork/container/container.gd'),
#		load('res://addons/LANNetwork/container/container.png')
#	)


	add_custom_type(
		'NetworkServer',
		'NetworkContainer',
		load('res://addons/LANNetwork/server/server.gd'),
		load('res://addons/LANNetwork/server/server.png')
	)
	add_custom_type(
		'ServerBroadcaster',
		'NetworkContainer',
		load('res://addons/LANNetwork/broadcaster/broadcaster.gd'),
		load('res://addons/LANNetwork/broadcaster/broadcaster.png')
	)


	add_custom_type(
		'NetworkClient',
		'NetworkContainer',
		load('res://addons/LANNetwork/client/client.gd'),
		load('res://addons/LANNetwork/client/client.png')
	)
	add_custom_type(
		'ServerListener',
		'NetworkContainer',
		load('res://addons/LANNetwork/listener/listener.gd'),
		load('res://addons/LANNetwork/listener/listener.png')
	)



func _exit_tree() -> void:
#	remove_custom_type('NetworkContainer')
	remove_custom_type('ServerBroadcaster')
	remove_custom_type('ServerListener')
