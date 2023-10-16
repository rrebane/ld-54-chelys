@tool
extends Area2D

const TILE_SIZE = 50
const OFFSET = 2
const OFFSET_VECTOR = Vector2(OFFSET,OFFSET)

@export var attack = 0
@export var defence = 0
@export var health = 0
@export var item_name = "Shield"


@export var run = false : 
	set (value):
		_create_collision_shape(value)
	get:
		return true

var original_position = null
var _backpack = null

func _ready():
	add_to_group('item')

func sprite_was_clicked(event):
	return $Sprite2D.get_rect().has_point($Sprite2D.to_local(event.position))
	
func _create_collision_shape(_bool):
	var sprite: Sprite2D = get_node('Sprite2D')
	if not sprite:
		print("No sprite found on item: " + item_name)
		return
	
	# Also turn off centered just in case
	sprite.centered = false
	
	var size = sprite.texture.get_size()
	var width_in_tiles = ceil(size.x / TILE_SIZE)
	var height_in_tiles = ceil(size.y / TILE_SIZE)
	var collision_polygon = CollisionPolygon2D.new()
	
	add_child(collision_polygon)
	collision_polygon.set_owner(self)
	
	var polygon_points = [
		Vector2.ZERO + OFFSET_VECTOR,
		Vector2(0 + OFFSET, TILE_SIZE * height_in_tiles - OFFSET),
		Vector2(TILE_SIZE * width_in_tiles - OFFSET, TILE_SIZE * height_in_tiles - OFFSET),
		Vector2(TILE_SIZE * width_in_tiles - OFFSET, 0 + OFFSET),
	]
	collision_polygon.polygon = polygon_points

func get_size():
	var size = $Sprite2D.texture.get_size()
	var width_in_tiles = ceil(size.x / TILE_SIZE)
	var height_in_tiles = ceil(size.y / TILE_SIZE)
	return Vector2(width_in_tiles * TILE_SIZE, height_in_tiles * TILE_SIZE)
	
func is_colliding_with_items():
	var areas = get_overlapping_areas()
	var is_colliding = false
	var items = []
	for area in areas:
		if area.is_in_group('item'):
			is_colliding = true
			items.append(area)
	return [is_colliding, items]

func become_replaced(event_pos, inventory_position, inventory_sprite_size):
	var dir = 1 if event_pos.x > global_position.x else -1
	var tween = get_tree().create_tween()
	var inventory_top_left = (inventory_position - inventory_sprite_size / 2)
	var item_width = $Sprite2D.texture.get_size().x
	var target = inventory_top_left - Vector2(item_width, 0)  if dir == 1 else inventory_top_left + Vector2(inventory_sprite_size.x, 0)
	tween.tween_property(self, "global_position", target, 0.3).set_trans(Tween.TRANS_SINE)
