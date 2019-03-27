extends Node2D

class_name Pivot

var lowest = 0

var in_play = false

var level2 = preload("res://Scenes/Levels/Level2/Level2.tscn").instance()

var current_level

func _ready():
	set_process(true)
	set_process_input(true)
	
	$Player.position = $Level/Pivot/Content/Start.position
	current_level = $Level
	

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if $Player.velocity == Vector2(0, 0):
			$Player.drop()
		else:
			if event.pressed and not event.is_echo():
				if event.position.x > 720 / 2:
					$LevelController.rotate_level($LevelController.Direction.RIGHT)
				else:
					$LevelController.rotate_level($LevelController.Direction.LEFT)
		
	if event.is_action_pressed("space"):
		print('s')
		$Player.drop()
		in_play = true
		
func _process(delta):
	if not in_play:
		return
		
	$HUD/MarginContainer/Label.text = str(Input.get_accelerometer())
	update_score()
	move_level()


func move_level():
	current_level.follow_player($Player)
	

func restart():
	reset_player()
	current_level.reset()
	
	
func reset_player():
	var player = ($Player as Player)
	player.position = current_level.position + current_level.get_start_position()
	player.stop()
	
	
func update_score():
	if $Player.position.y > lowest:
		lowest = floor($Player.position.y)


func _on_ScoreUpdateTimer_timeout():
	$HUD/MarginContainer/Score.text = str(lowest - 250)


func _on_TouchScreenButton_pressed():
	restart()

func _on_HUD_reset():
	restart()


func _on_Player_reached_end():
	change_level()
	
func change_level():
	print('Main::change_level(): ')
	in_play = false
	current_level.queue_free()
	var l = level2
	l.connect("ready", self, 'on_level_ready', [l])
	l.name = 'Level'
	current_level = l
	current_level.disable_collision()
	add_child(l, true)
	$Player.stop()
	
	
func on_level_ready(l):
	print('level ready', l)
	var player_pos_on_screen = $Player.get_global_transform_with_canvas().origin
	
	l.position = $Player.position - player_pos_on_screen
	print(l.position + l.get_start_position())
	#$Player.position = l.position + l.get_start_position()
	$Player.tween_to(l.position + l.get_start_position())
	$Player.connect('position_reached', l, 'on_player_reached_start')
	