extends Node2D
class_name LevelManager

onready var game = get_parent()

export (int) var next_level_id = 0
var current_level : Level

var levels = [
	preload("res://Scenes/Levels/1.tscn").instance(),
	preload("res://Scenes/Levels/2.tscn").instance(),
	preload("res://Scenes/Levels/3.tscn").instance(),
	preload("res://Scenes/Levels/4.tscn").instance(),
	preload("res://Scenes/Levels/5.tscn").instance(),
	preload("res://Scenes/Levels/6.tscn").instance(),
	preload("res://Scenes/Levels/7.tscn").instance(),
]

func _ready():
	print(game)


func change_level(id):
	if is_final_level():
		# TODO: Show final screen or something.
		print('Max level')
		return
		
	game.initialize()
	
	if current_level:
		swap_level_out()
		
	setup_next_level(id)
	
	game.prepare_player_for_new_level()
	
	next_level_id = id + 1
	
	
func is_final_level():
	return next_level_id == levels.size()
	

func setup_next_level(id):
	current_level = levels[id]
	current_level.connect('rotated', $Player, 'on_level_rotated')
	current_level.position = game.screen_position_to_world(Vector2(100, 640))
	game.add_child(current_level, true)
	

func swap_level_out():
	var old_level = current_level
	old_level.queue_free()
	

func next_level():
	change_level(next_level_id)
	