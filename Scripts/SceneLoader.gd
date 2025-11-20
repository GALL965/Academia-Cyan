extends Node

var next_scene_path := ""   # A dónde queremos ir
var extra_data = null       # Por si quiere pasar algún dato opcional

func change_scene_with_loading(target_path:String, data := null) -> void:
	next_scene_path = target_path
	extra_data = data
	# Cambiamos a la pantalla de carga
	get_tree().change_scene("res://scenes/ui/LoadingScreen.tscn")
