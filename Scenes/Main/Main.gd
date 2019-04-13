extends Node2D
class_name Pivot


var score = 0
var in_play = false

var levels = [
	preload("res://Scenes/Levels/Level1/Level1.tscn").instance(),
	preload("res://Scenes/Levels/Level2/Level2.tscn").instance(),
	preload("res://Scenes/Levels/Level3/Level3.tscn").instance(),
	preload("res://Scenes/Levels/TestLevel.tscn").instance()
]

var current_level
var level_id = 3


func _ready():
	change_level()
	

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if $Player.velocity == Vector2(0, 0):
			start_game()
		
	if event.is_action_pressed("space"):
		start_game()
		
		
func _process(delta):
	if not in_play:
		return
		
	move_level()
	

func start_game():
	$Player.drop()
	in_play = true
	current_level.start()
	
	
func stop_game():
	in_play = false
	current_level.disable_collision()
	$Player.stop()	


func move_level():
	current_level.follow_player($Player)
	

func restart():
	reset_score()
	reset_player()
	current_level.reset()
	
	
func reset_player():
	var player : Player = ($Player as Player)
	player.position = current_level.position + current_level.get_start_position()
	player.stop()
	

func reset_score():
	score = 0
	$HUD.update_score(score)
	
func _on_TouchScreenButton_pressed():
	restart()


func _on_HUD_reset():
	restart()


func _on_Player_reached_end():
	change_level()
	
	
func change_level():
	print('Main::change_level(): ')
	if level_id == levels.size():
		print('Max level')
		return
		
	var old_level = current_level
	
	if old_level:
		old_level.queue_free()
		#stop_game()
	$Player.stop()
	current_level = levels[level_id]
	current_level.connect('rotated', $Player, 'on_level_rotated')
	current_level = current_level
	add_child(current_level, true)
	$Player.position = $Level/Pivot/Content/Start.position
	level_id += 1
	current_level.position = screen_position_to_world(Vector2(0, 0))
	#$Player.position = current_level.position + current_level.get_start_position()
	$Player.tween_to(current_level.position + current_level.get_start_position())
	$Player.connect('position_reached', current_level, 'on_player_reached_start')
	

func screen_position_to_world(screen_position : Vector2) -> Vector2:
	var player_pos_on_screen = $Player.get_global_transform_with_canvas().origin
		
	return ($Player.position - player_pos_on_screen) + screen_position


func _on_Player_contact(block):
	current_level.set_current_block(block)


func _on_Player_obstacle_touched():
	restart()


func _on_Player_collectable_collected(value):
	score += value
	$HUD.update_score(score)
