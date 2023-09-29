extends Button

@export var pressed_sound : AudioStream


func _on_pressed():
	EventsBus.play_sfx.emit(pressed_sound)
	SceneSwitcher.goto_scene("res://scenes/game.tscn")
	pass # Replace with function body.
