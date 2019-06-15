extends Node2D
class_name Pivot


var score = 0
var in_play = false
var start_time = 0
var duration = 0 # Time taken to beat a level
var player_ready = false


func _ready():
	#change_level(0)
	pass

func _unhandled_input(event):
	if in_play or not player_ready:
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
	$LevelManager.current_level.start()
	
	# Start measuring time
	start_time = OS.get_unix_time()
	
	
func stop_game():
	in_play = false
	player_ready = false
	$LevelManager.current_level.disable_collision()
	$LevelManager.current_level.stop()
	$Player.stop()	


func move_level():
	$LevelManager.current_level.follow_player($Player)
	

func check_time():
	var end_time = OS.get_unix_time()
	duration = OS.get_datetime_from_unix_time(end_time - start_time)
	$HUD.update_time(duration)
	
	
func restart():
	in_play = false
	player_ready = true
	reset_score()
	reset_player()
	reset_time()
	$LevelManager.current_level.reset()
	
	
func reset_player():
	var player : Player = ($Player as Player)
	player.position = ($LevelManager.current_level.position 
										+ $LevelManager.current_level.get_start_position())
	player.stop()
	player.reset()
	

func reset_score():
	score = 0
	$HUD.update_score(score)


func reset_time():
	start_time = OS.get_unix_time()
	check_time()
	$HUD.update_time(duration)
	

func initialize():
	reset_time()
	reset_score()
	player_ready = false
	$Player.stop()


func prepare_player_for_new_level():
	$Player.position = screen_position_to_world(Vector2())
	$Player.focus_camera(false)
	$Player.tween_to(
		$LevelManager.current_level.position 
		+ $LevelManager.current_level.get_start_position())
	$Player.connect('position_reached', $LevelManager.current_level, 'on_player_reached_start')
	
	
func screen_position_to_world(screen_position : Vector2) -> Vector2:
	var player_pos_on_screen = $Player.get_global_transform_with_canvas().origin
		
	return ($Player.position - player_pos_on_screen) + screen_position


func _on_Player_obstacle_touched():
	restart()


func _on_Player_collectable_collected(value):
	score += value
	$HUD.update_score(score)


func _on_Overlay_next_button_pressed():
	$LevelManager.next_level()
	$Overlay.hide()
	$HUD.show()


func _on_Player_fell_off():
	restart()


func _on_Player_is_waiting():
	player_ready = true


func _on_TouchScreenButton_pressed():
	restart()


func _on_HUD_reset():
	restart()


func _on_Player_reached_end():
	#change_level()
	$Overlay.show(score, duration)
	$HUD.hide()
	stop_game()


func _on_LevelSelect_level_selected(id):
	print("level selected: ", id)
	$LevelManager.change_level(id)

	$HUD/LevelSelect.visible = false
	