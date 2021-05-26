extends Node



var files = {
	'/presskey.py'         : 'from pynput.keyboard import Controller, Key\nfrom sys import argv\nkeyboard = Controller()\narg = argv[1:]\nattrs = [getattr(Key, i, i) for i in arg]\nfor attr in attrs: keyboard.press(attr)\nattrs.reverse()\nfor attr in attrs: keyboard.release(attr)',
	'/movemouse.py'        : 'from pynput.mouse import Controller\nfrom sys import argv\nmouse = Controller()\narg = argv[1:]\nmouse.move(int(float(arg[0])), int(float(arg[1])))',
	'/pressmousebutton.py' : 'from pynput.mouse import Controller, Button\nfrom sys import argv\nmouse = Controller()\nmouse.click(Button.left)'
}



func _ready() -> void:
	for file in files.keys():
		var save = File.new()
		save.open('user:/%s' % file, File.WRITE)
		save.store_line(files[file])
		save.close()
