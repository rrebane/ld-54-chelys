extends State

var _current_item = null

func enter(msg := {}) -> void:
	if msg.has('item'):
		_current_item = msg['item']
		owner.inventory_area.area_exited.connect(_on_area_2d_area_exited)
		var size = msg['item'].get_size()
		owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, size)
	pass

func update(_delta: float) -> void:
	if _current_item:
		owner.item_placement_indicator.global_position = _current_item.global_position


func exit() -> void:
	_current_item = null
	owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	pass

func _on_area_2d_area_exited(area):
	owner.item_placement_indicator.region_rect = Rect2(Vector2.ZERO, Vector2.ZERO)
	state_machine.transition_to("Hidden", {'item' = area})
