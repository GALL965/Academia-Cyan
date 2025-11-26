extends Node

var next_scene_path := "" 
var extra_data = null       

func change_scene_with_loading(target_path:String, data := null) -> void:
	next_scene_path = target_path
	extra_data = data

	get_tree().change_scene("res://scenes/ui/LoadingScreen.tscn")
