extends Node2D

enum Turn { PLAYER_TURN, ENEMY_TURN }

@export var turn_time = 1.0

@onready var current_turn = Turn.PLAYER_TURN

var player = null
var enemy = null

var _turn_time_left = 0

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("debug_combat_win"):
		combat_end(true)
	if Input.is_action_just_pressed("debug_combat_lose"):
		combat_end(false)
	
	if _turn_time_left > 0:
		_turn_time_left -= delta
		return
	
	match current_turn:
		Turn.PLAYER_TURN:
			player_turn()
			current_turn = Turn.ENEMY_TURN
			_turn_time_left = turn_time
		Turn.ENEMY_TURN:
			enemy_turn()
			current_turn = Turn.PLAYER_TURN
			_turn_time_left = turn_time
		
func player_turn():
	pass

func enemy_turn():
	pass

func combat_end(win):
	# TODO results
	EventsBus.combat_end.emit(win)
