extends Node2D

var stash = []

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func config(params):
	stash = params["stash"]

func hide_backpack():
	hide()
	$CanvasLayer.hide()
	
func show_backpack():
	show()
	$CanvasLayer.show()
