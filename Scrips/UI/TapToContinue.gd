extends Control
# Pantalla de "toca en cualquier lado para continuar"

signal go_to_date_gen


func _input(event: InputEvent) -> void:
	# Click de mouse
	if event is InputEventMouseButton and event.pressed:
		_go_next()

	# Toque en pantalla (móvil)
	if event is InputEventScreenTouch and event.pressed:
		_go_next()

	# (Opcional) tecla Enter o Espacio
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ENTER or event.scancode == KEY_SPACE:
			_go_next()


func _go_next() -> void:
	print("TapToContinue: pidiendo ir a DateGenUser")
	emit_signal("go_to_date_gen")
