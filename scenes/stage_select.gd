extends Node2D


func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_dungeon_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var config = {
				"stash": GlobalState.starting_items
			}
		SceneSwitcher.goto_scene("res://scenes/dungeon.tscn", config)
		pass # Replace with function body.


func _on_texture_rect_mouse_entered():
	$AnimationPlayer.play("hover")
	pass # Replace with function body.


func _on_texture_rect_mouse_exited():
	$AnimationPlayer.stop()
	pass # Replace with function body.
