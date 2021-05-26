extends Node



var address               : String

var unmanagedKeys         : Array   = []
var unmanagedMouse        : Vector2 = Vector2.ZERO
var unmanagedMouseButtons : Array   = []



remote func pressKey(key: String) -> void:
	unmanagedKeys.append(key.split(' '))



remote func moveMouse(relative: Vector2) -> void:
	unmanagedMouse += relative



remote func pressMouseButton() -> void:
	unmanagedMouseButtons.append(0)



remote func logMessage(message: String) -> void:
	print(message)
