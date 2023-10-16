extends Sprite2D


@export var positive_color : Color
@export var negative_color : Color
# Called when the node enters the scene tree for the first time.
func change_to_positive_color():
	self_modulate = positive_color
	
func change_to_negative_color():
	self_modulate = negative_color
