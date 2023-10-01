extends Node2D

@onready var item_scene_path = preload("res://scenes/item.tscn")

func _process(delta):
	if Input.is_action_just_pressed("debug_add_item"):
		var item_scene = item_scene_path.instantiate()
		$ItemContainer.add_child(item_scene)

func get_items_in_inventory():
	return $Area2D.get_overlapping_areas()
