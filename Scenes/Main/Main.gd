extends Node2D
class_name Pivot


var current_level
var level_id = 2
var levels = [
	preload("res://Scenes/Levels/1.tscn").instance(),
	preload("res://Scenes/Levels/2.tscn").instance(),
	preload("res://Scenes/Levels/3.tscn").instance(),
	preload("res://Scenes/Levels/4.tscn").instance(),
	preload("res://Scenes/Levels/5.tscn").instance(),
	preload("res://Scenes/Levels/6.tscn").instance(),
]


var score = 0
var in_play = false
var start_time = 0
var duration = 0 # Time taken to beat a level


func _ready():
	change_level()
	

func _unhandled_input(event):
	if in_play:
		return
		
	if event is InputEventScreenTouch:
		start_game()
		
	if event.is_action_pressed("space"):
		start_game()
		
		
func _process(delta):
	if not in_play:
		return
		
	move_level()
	check_time()
	

func start_game():
	$Player.drop()
	in_play = true
	current_level.start()
	
	# Start measuring time
	start_time = OS.get_unix_time()
	
	
func stop_game():
	in_play = false
	current_level.disable_collision()
	$Player.stop()	


func move_level():
	current_level.follow_player($Player)
	

func check_time():
	var end_time = OS.get_unix_time()
	duration = OS.get_datetime_from_unix_time(end_time - start_time)
	$HUD.update_time(duration)
	
	
func restart():
	in_play = false
	reset_score()
	reset_player()
	reset_time()
	current_level.reset()
	
	
func reset_player():
	var player : Player = ($Player as Player)
	player.position = current_level.position + current_level.get_start_position()
	player.stop()
	

func reset_score():
	score = 0
	$HUD.update_score(score)


func reset_time():
	start_time = OS.get_unix_time()
	check_time()
	$HUD.update_time(duration)
	
	
func _on_TouchScreenButton_pressed():
	restart()


func _on_HUD_reset():
	restart()


func _on_Player_reached_end():
	#change_level()
	$Overlay.show(score, duration)
	$HUD.hide()
	stop_game()
	
	
func change_level():
	reset_time()
	check_time()
	reset_score()
	$Player.stop()
	$Player.focus_camera(true)
	print('Main::change_level(): ')
	if is_final_level():
		# TODO: Show final screen or something.
		print('Max level')
		return
		
	var old_level = current_level
	
	if old_level:
		old_level.queue_free()
		stop_game()
	current_level = levels[level_id]
	current_level.connect('rotated', $Player, 'on_level_rotated')
	add_child(current_level, true)
	$Player.position = screen_position_to_world(Vector2())
	level_id += 1
	current_level.position = screen_position_to_world(Vector2(-200, 200))
	$Player.tween_to(current_level.position + current_level.get_start_position())
	$Player.connect('position_reached', current_level, 'on_player_reached_start')
	

func is_final_level():
	return level_id == levels.size()
	
	
func screen_position_to_world(screen_position : Vector2) -> Vector2:
	var player_pos_on_screen = $Player.get_global_transform_with_canvas().origin
		
	return ($Player.position - player_pos_on_screen) + screen_position


func _on_Player_obstacle_touched():
	restart()


func _on_Player_collectable_collected(value):
	score += value
	$HUD.update_score(score)


func _on_Overlay_next_button_pressed():
	change_level()
	$Overlay.hide()
	$HUD.show()
