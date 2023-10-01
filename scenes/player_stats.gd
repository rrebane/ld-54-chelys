extends Label

var _attack = 0
var _defence = 0
var _health = 0

func _ready():
	EventsBus.update_player_status.connect(_update_status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update_status(params):
	if "attack" in params:
		_attack = params["attack"]
		
	if "defence" in params:
		_defence = params["defence"]
		
	if "health" in params:
		_health = params["health"]
		
	if _health < 0:
		_health = 0
		
	text = "Player ATK: {attack}, DEF: {defence}, HP: {health}".format({
		"attack" = _attack,
		"defence" = _defence,
		"health" = _health
	})
