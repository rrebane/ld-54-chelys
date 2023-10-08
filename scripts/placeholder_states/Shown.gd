extends State

var _current_item = null
var _item_prev_position

func enter(msg := {}) -> void:
	if msg.has('item'):
		_current_item = msg['item']
		owner.inventory_area.area_exited.connect(_on_area_2d_area_exited)
		var size = _current_item.get_size()
		owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, size)
		_item_prev_position = _current_item.global_position
	pass

func update(_delta: float) -> void:
	if _current_item:
		var global_pos = _current_item.global_position
		owner.item_placement_indicator.global_position = global_pos
		if _item_prev_position != global_pos:
			var collision = _current_item.is_colliding_with_items()
			var is_colliding = collision[0]
			if is_colliding:
				owner.item_placement_indicator.change_to_negative_color()
			else:
				owner.item_placement_indicator.change_to_positive_color()


func exit() -> void:
	_current_item = null
	owner.inventory_area.area_exited.disconnect(_on_area_2d_area_exited)
	owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	pass

func _on_area_2d_area_exited(area):
	owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	state_machine.transition_to("Hidden", {'item' = area})
