extends Node2D


var alpha_start = 0.15
var alpha_end = 0.0


func _ready():
	for n in get_children():
		if n is Particles2D:
			n.emitting = true


func _on_Timer_timeout():
	self.queue_free()


func set_color(color):
	var gradient_colors = create_gradient_colors(color)
	for n in get_children():
		if n is Particles2D:
			set_color_ramp(n, gradient_colors)
			

func create_gradient_colors(color):
	var colors_array = [
		Color(color.r, color.g, color.b, alpha_start),
		Color(color.r, color.g, color.b, alpha_end)
	]
	
	return PoolColorArray(colors_array)
	
	
func set_color_ramp(particles, gradient_colors):
	particles.process_material.color_ramp.gradient.colors = gradient_colors
	