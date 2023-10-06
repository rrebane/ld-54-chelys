@tool
extends Area2D

const TILE_SIZE = 50

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
		Vector2.ZERO,
		Vector2(0, TILE_SIZE * height_in_tiles),
		Vector2(TILE_SIZE * width_in_tiles, TILE_SIZE * height_in_tiles),
		Vector2(TILE_SIZE * width_in_tiles, 0),
	]
	collision_polygon.polygon = polygon_points

