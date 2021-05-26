extends Control



export var LAYOUT : Dictionary = {
	'LETTERS': {
		'TopLeft': {
			'CC': ['s', 'd', 'g', '\''],
			'C': ['t', 'c', 'z', '.']
		},
		'TopRight': {
			'CC': ['a', 'r', 'x', '?'],
			'C': ['y', 'b', 'p', 'q']
		},
		'BottomRight': {
			'CC': ['o', 'u', 'v', 'w'],
			'C': ['n', 'm', 'f', '!']
		},
		'BottomLeft': {
			'CC': ['i', 'h', 'j', ','],
			'C': ['e', 'l', 'k', '@']
		}
	},
	'NUMBERS': {
		'TopLeft': {
			'CC': ['5', '6', '<', '>'],
			'C': ['9', '4', '#', '&']
		},
		'TopRight': {
			'CC': ['$', '%', '{', '}'],
			'C': ['0', '3', '7', '|']
		},
		'BottomRight': {
			'CC': ['.', ',', '(', ')'],
			'C': ['+', '-', '*', '/']
		},
		'BottomLeft': {
			'CC': ['1', '2', '8', '\\'],
			'C': [':', ';', '[', ']']
		}
	}
}
export(String) var currentLayout    : String = 'LETTERS' setget setLayout

export(int) var MAXFINGERLINELENGTH : int = 25
export(int) var FINGERLINEFADESPEED : int = 2

var CrossingSegments   : Object  = preload('res://Mobile/CrossingSegments.gd').new()

enum {
	CROSS_UNKNOWN,
	CROSS_COUNTERCLOCK,
	CROSS_CLOCK
}

enum {
	MOUSEMODE_IDLE,
	MOUSEMODE_KEYBOARD,
	MOUSEMODE_MOUSE
}

var startMousePos      : Vector2
var prevMousePos       : Vector2
var prevMouseInCircle  : bool    = false
var mouseMode          : int     = MOUSEMODE_IDLE
var prevMouseMode      : int     = MOUSEMODE_IDLE
var hasSentKey         : bool    = false

var crossFirst         : int
var crossAmount        : int
var crossDirection     : int



var shiftPressed       : bool    = false
var controlPressed     : bool    = false
var modPressed         : bool    = false
var alternativePressed : bool    = false



func _ready() -> void:
	setLayout('LETTERS')



func setLayout(id: String) -> void:
	currentLayout = id
	var cornerNode
	var directionNode
	var amountNode
	var amount
	var layout = LAYOUT[id]
	for corner in layout.keys():
		cornerNode = $Layout/Square/Scaling/Cross/Keys.get_node(corner)
		for direction in layout[corner].keys():
			directionNode = cornerNode.get_node(direction)
			for index in range(len(layout[corner][direction])):
				amountNode = directionNode.get_child(index)
				amountNode.text = layout[corner][direction][index]



func _physics_process(delta: float) -> void:
	if (mouseMode == MOUSEMODE_IDLE):
		var fingerline = Array($Layout/Square/Scaling/Collision/Center/FingerLine.points)
		for i in range(FINGERLINEFADESPEED):
			if (len(fingerline) <= 0): break
			fingerline.remove(0)
		$Layout/Square/Scaling/Collision/Center/FingerLine.points = PoolVector2Array(fingerline)



func _input(event: InputEvent) -> void:
	if (event is InputEventScreenDrag):
		var mousePos = $Layout/Square/Scaling/Collision/Center.to_local(event.position)

		if (mouseMode != MOUSEMODE_IDLE):
			var fingerline = Array($Layout/Square/Scaling/Collision/Center/FingerLine.points)
			fingerline.append(mousePos)
			fingerline = fingerline.slice(-MAXFINGERLINELENGTH, len(fingerline) - 1, 1)
			$Layout/Square/Scaling/Collision/Center/FingerLine.points = PoolVector2Array(fingerline)

		if (prevMousePos):
			if (mouseMode == MOUSEMODE_KEYBOARD):
				var pointsList = [
					$Layout/Square/Scaling/Collision/Center/TopLeft,
					$Layout/Square/Scaling/Collision/Center/TopRight,
					$Layout/Square/Scaling/Collision/Center/BottomRight,
					$Layout/Square/Scaling/Collision/Center/BottomLeft
				]
				var direction
				var points
				for index in range(len(pointsList)):
					points = pointsList[index].points
					direction = CrossingSegments.doIntersect(points[0], points[1], prevMousePos, mousePos)
					if (direction):
						if (direction != crossDirection and crossDirection != CROSS_UNKNOWN):
							end(true)
						else:
							if (crossDirection == CROSS_UNKNOWN):
								crossFirst = index
								crossDirection = direction
							crossAmount += 1
							if (crossAmount >= 5):
								end(true)

			elif (mouseMode == MOUSEMODE_MOUSE):
				var relative = Vector2.ZERO
				if (prevMouseMode == mouseMode):
					relative = mousePos - prevMousePos
				sendMouse(relative)

				prevMouseMode = mouseMode

		var future = mouseInCircle(mousePos)
		if (mouseMode == MOUSEMODE_KEYBOARD and crossAmount >= 1 and future and not prevMouseInCircle):
			sendKey(identifyKey())
		prevMouseInCircle = future
		prevMousePos = mousePos

	elif (event is InputEventScreenTouch):
		var mousePos = $Layout/Square/Scaling/Collision/Center.to_local(event.position)
		var future = (MOUSEMODE_KEYBOARD if mouseInCircle(mousePos) else MOUSEMODE_MOUSE) if event.pressed else MOUSEMODE_IDLE
		if (future != MOUSEMODE_IDLE and mouseMode == MOUSEMODE_IDLE):
			start()
			startMousePos = mousePos
		elif (mouseMode != MOUSEMODE_IDLE and future == MOUSEMODE_IDLE):
			if (startMousePos.distance_to(mousePos) == 0):
				sendMouseButton()
			end((not (mouseInCircle(mousePos) or hasSentKey)) and mouseMode == MOUSEMODE_KEYBOARD)
			if (mouseInCircle(mousePos)):
				sendKey('space')
		mouseMode = future
		prevMouseMode = MOUSEMODE_IDLE



func start() -> void:
	$Layout/Square/Scaling/Collision/Center/FingerLine.points = PoolVector2Array()
	crossFirst     = -1
	crossAmount    = 0
	crossDirection = CROSS_UNKNOWN
	hasSentKey     = false

func end(error: bool = false) -> void:
	mouseMode      = MOUSEMODE_IDLE
	prevMouseMode  = MOUSEMODE_IDLE
	hasSentKey     = false
	$Layout/ShiftButton/Button.pressed = false
	shiftPressed()
	$Layout/ControlButton/Button.pressed = false
	controlPressed()
	$Layout/ModButton/Button.pressed = false
	modPressed()
	$Layout/AlternativeButton/Button.pressed = false
	alternativePressed()
	if (error):
		$Layout/Square/Scaling/Cross/Animation.play('Error')



func identifyKey() -> String:
	var key
	if (crossAmount >= 1 and crossAmount <= 4):
		var layout = LAYOUT[currentLayout]
		key = layout[layout.keys()[crossFirst]]
		key = key[key.keys()[crossDirection - 1]]
		key = key[crossAmount - 1]
	crossFirst     = 0
	crossAmount    = 0
	crossDirection = CROSS_UNKNOWN
	hasSentKey     = true
	return(key)



func sendKey(key: String) -> void:
	var specials = {
		'shift' : shiftPressed,
		'ctrl'  : controlPressed,
		'cmd'   : modPressed,
		'alt'   : alternativePressed
	}
	var res = ''
	for special in specials.keys():
		if (specials[special]):
			res += special + ' '
	res += key
	Data.rpc('pressKey', res)



func sendMouse(relative: Vector2) -> void:
	Data.rpc('moveMouse', relative)



func sendMouseButton() -> void:
	Data.rpc('pressMouseButton')



func mouseInCircle(pos: Vector2) -> bool:
	return(pos.distance_to(Vector2.ZERO) <= $Layout/Square/Scaling/Collision/Center/Circle.shape.radius)





func returnPressed() -> void:
	sendKey('enter')


func switchKeyboardPressed() -> void:
	setLayout('NUMBERS' if currentLayout == 'LETTERS' else 'LETTERS')


func shiftPressed() -> void:
	shiftPressed = $Layout/ShiftButton/Button.pressed
	$Layout/ShiftButton/Highlight.visible = shiftPressed


func controlPressed() -> void:
	controlPressed = $Layout/ControlButton/Button.pressed
	$Layout/ControlButton/Highlight.visible = controlPressed


func modPressed() -> void:
	modPressed = $Layout/ModButton/Button.pressed
	$Layout/ModButton/Highlight.visible = modPressed


func alternativePressed() -> void:
	alternativePressed = $Layout/AlternativeButton/Button.pressed
	$Layout/AlternativeButton/Highlight.visible = alternativePressed
