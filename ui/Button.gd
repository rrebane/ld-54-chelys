extends TextureButton
class_name  MainMenuButton

@export var pressed_sound : AudioStream

func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	# Overwrite in inherited class
	pass
