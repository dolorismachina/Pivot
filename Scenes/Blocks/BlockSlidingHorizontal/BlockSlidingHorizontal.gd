extends "res://Scenes/Blocks/Block/Block.gd"

func _ready():
	pass


func activate():
	.activate()
	
	$AnimationPlayer.play("slide")
	

func _on_TimerShake_timeout():
	._on_TimerShake_timeout()
	
	
	
	
func _process(delta):
	._process(delta)
	

var animation_position = 0.0
func contact():
	animation_position = $AnimationPlayer.current_animation_position

	.contact()
	
	$AnimationPlayer.queue("slide")
	

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "slide":
		print(animation_position)
		$AnimationPlayer.seek(animation_position)