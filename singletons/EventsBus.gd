extends Node

# Singleton for using events globally
# To add a signal, define a new signal here, e.g 'signal my_signal'
# To emit from any other script, do EventsBus.my_signal.emit()
# To handle signal in any script, do EventsBus.my_signal.connect(my_callback) 

signal play_sfx
signal combat_end
signal dungeon_end
signal player_death
signal enemy_death

signal item_picked_up(item)
signal item_dropped(item)
signal add_to_combat_log(text)
signal update_player_status
signal update_enemy_status
