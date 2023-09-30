extends Node2D


func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("debug_select_stage"):
		var config = {
			"stash": GlobalState.starting_items
		}
		SceneSwitcher.goto_scene("res://scenes/dungeon.tscn", config)
