extends MainMenuButton

func on_pressed():
	EventsBus.play_sfx.emit(pressed_sound)
	SceneSwitcher.goto_scene("res://scenes/stage_select.tscn")
