extends Node2D

enum Result { PLAYER_WIN, PLAYER_LOSE }
enum State { PLAYER_TURN, ENEMY_TURN, COMBAT_END }

@export var turn_time = 0.5

@onready var _overlay = $CanvasLayer
@onready var _overlay_label = $CanvasLayer/Control/TextureRect/MarginContainer/RichTextLabel

var player_scene = preload("res://scenes/player.tscn")
var enemy_scene = preload("res://scenes/enemies/enemy.tscn")

var _current_state = State.PLAYER_TURN
var _turn_time_left = 0

var _player = null
var _enemy = null

var _combat_result = {}

func _ready():
	_player = player_scene.instantiate()
	_enemy = enemy_scene.instantiate()
	$PlayerPosition.add_child(_player)
	$EnemyPosition.add_child(_enemy)
	
	EventsBus.player_death.connect(_player_death)
	EventsBus.enemy_death.connect(_enemy_death)
	
	_overlay.show()
	
	EventsBus.add_to_combat_log.connect(_add_to_combat_log)

func _process(delta):
	if GlobalState.debug and Input.is_action_just_pressed("debug_combat_win"):
		_enemy_death(5)
	if GlobalState.debug and Input.is_action_just_pressed("debug_combat_lose"):
		_player_death()
	
	if _turn_time_left > 0:
		_turn_time_left -= delta
		return
	
	match _current_state:
		State.PLAYER_TURN:
			_current_state = State.ENEMY_TURN
			_turn_time_left = turn_time
			player_turn()
		State.ENEMY_TURN:
			_current_state = State.PLAYER_TURN
			_turn_time_left = turn_time
			enemy_turn()
		State.COMBAT_END:
			if Input.is_action_just_pressed("continue"):
				combat_end(_combat_result)
			
			
func _player_death():
	_combat_result["winner"] = Result.PLAYER_LOSE
	_current_state = State.COMBAT_END
	_add_to_combat_log("\nYou were defeated!\nPress SPACE to return to main menu.")
	_overlay.show()
	
func _enemy_death(gold_earned, text = "You won!"):
	_combat_result["gold"] = gold_earned
	_combat_result["winner"] = Result.PLAYER_WIN
	_current_state = State.COMBAT_END
	_add_to_combat_log("\n{text} You earned {gold} gold.\nPress SPACE to continue.".format({"text": text, "gold": gold_earned}))
	_overlay.show()
		
func player_turn():
	var damage = _player.attack()
	_enemy.take_damage(damage)

func enemy_turn():
	var damage = _enemy.attack()
	_player.take_damage(damage)

func combat_end(result):
	if "gold" in result:
		GlobalState.player_gold += result["gold"]
		
	var player_win = result["winner"] == Result.PLAYER_WIN
	EventsBus.combat_end.emit(player_win)

func _add_to_combat_log(text):
	_overlay_label.text += '\n'
	_overlay_label.text += text
	
