extends Node2D # O puede ser cualquier tipo de nodo que uses

var dialogo_activado := false

func _process(_delta):
	if Input.is_action_just_pressed("W") and not dialogo_activado:
		mostrar_dialogo()
		dialogo_activado = true

func mostrar_dialogo():
	var diag_scene = preload("res://diag.tscn")
	var dialogo = diag_scene.instance()

	# Configura el diálogo
	dialogo.dialog_lines = [
		"bonjour!",
		"me llaman Kelly",
		"pero tú me puedes llamar mi reina",
		"como sea",
		"invíteme unas takis, ¿no? Tira paro"
	]

	dialogo.expression_paths = [
		"res://Assets/Sprites/kells1.png",
		"res://Assets/Sprites/kells2.png",
		"res://Assets/Sprites/kells3.png",
		"res://Assets/Sprites/kells1.png",
		"res://Assets/Sprites/kells4.png"
	]

	dialogo.voice_path = "res://Assets/Fx/voice/mon.wav"

	# Agrega el diálogo a la escena
	add_child(dialogo)
