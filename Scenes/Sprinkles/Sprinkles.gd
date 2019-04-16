extends Node2D

func _ready():
	for n in get_children():
		if n is Particles2D:
			n.emitting = true


func _on_Timer_timeout():
	self.queue_free()
