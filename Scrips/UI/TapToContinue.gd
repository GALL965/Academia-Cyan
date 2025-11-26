extends Control
# Pantalla de "toca en cualquier lado para continuar"

export(String, FILE, "*.tscn") var next_scene_path := ""

func _input(event: InputEvent) -> void:
	# Click de mouse
	if event is InputEventMouseButton and event.pressed:
		_go_next()

	# Toque en pantalla (móvil)
	if event is InputEventScreenTouch and event.pressed:
		_go_next()


func _go_next() -> void:
	if next_scene_path == "":
		print("TapToContinue: next_scene_path no está configurado")
		return

	print("TapToContinue: cambiando a ", next_scene_path)
	get_tree().change_scene(next_scene_path)
