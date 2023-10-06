extends Node2D

@onready var item_scene_path = preload("res://scenes/item.tscn")
@onready var item_placement_indicator = $ItemPlacementIndicator

@export var items_container_path := NodePath()

var item_on_inventory = false : 
	set (value):
		item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
		item_on_inventory = value
	get:
		return item_on_inventory


func _ready():
	item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)

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



func _on_area_2d_area_entered(area):
	if area.is_in_group('item'):
		item_on_inventory = true
		var size = area.get_size()
		item_placement_indicator.region_rect = Rect2(Vector2.ZERO, size)
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	item_on_inventory = false
	pass # Replace with function body.
