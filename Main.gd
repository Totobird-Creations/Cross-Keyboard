extends Node



func _ready() -> void:
	if (OS.has_feature('mobile') or 'mobile' in OS.get_cmdline_args()):
		get_tree().change_scene('res://Mobile/Keyboard.tscn')
	else:
		get_tree().change_scene('res://Pc/List.tscn')
