extends Node2D
class_name SaveSystem


onready var game = get_parent()
var save_data = []


func _ready():
	var file = File.new()
	if not file.file_exists("res://save.txt"):
		init_empty_save()
	else:
		load_from_file()
		print(save_data)


# Modify level data and save to file.
func save(data):
	print(data)
	save_data[data.id] = data
	if data.id < save_data.size() - 1:
		print("Sewq")
		save_data[data.id + 1].state = "unlocked"
	save_to_file()
	

# Create a new save file with default values.
func init_empty_save():
	print("Creating new save file...")
	
	var level_count = game.get_node("LevelManager").levels.size()
	
	for i in range(level_count):
		var data = create_default_data(i)
		save_data.push_back(data)
	
	save_data[0].state = "unlocked"
	
	save_to_file()
	
	
func save_to_file():
	var file = File.new()
	file.open("res://save.txt", File.WRITE)
	
	var string = JSON.print(save_data, "  ")
	file.store_string(string)
	
	file.close()
	

func load_from_file():
	var file = File.new()
	file.open("res://save.txt", File.READ)
	var data = file.get_as_text()
	save_data = JSON.parse(data).result
	
	file.close()
	
	
func create_default_data(id):
	return {
		"id": id,
		"score": 0,
		"time": "0:00",
		"state": "locked"
	}
	