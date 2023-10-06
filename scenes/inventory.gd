extends Node2D

@onready var item_scene_path = preload("res://scenes/item.tscn")

@export var items_container_path := NodePath()

func _process(delta):
	if GlobalState.debug and Input.is_action_just_pressed("debug_add_item"):
		var item_scene = item_scene_path.instantiate()
		$ItemContainer.add_child(item_scene)

func get_items_in_inventory():
	return $Area2D.get_overlapping_areas()

func get_clicked_item(event):
	var items = get_node(items_container_path).get_children()
	var selected_item
	for item in items:
		if item.sprite_was_clicked(event):
			selected_item = item
			break
	if selected_item:
		return selected_item
