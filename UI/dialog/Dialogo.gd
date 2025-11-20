extends Control

export(float) var text_speed := 0.03

var dialog_lines := []
var expression_paths := []
var voice_path := ""

var dialog_index := 0
var current_text := ""
var char_index := 0
var is_typing := false
var finished := false
var voice_stream = null

onready var text_label   := $PanelContainer/MarginContainer/TextLabel

onready var portrait     := $Character

onready var char_timer   := $CharTimer
onready var voice_player := $VoicePlayer

func _ready() -> void:
	text_label.bbcode_enabled = true
	set_process_unhandled_input(true)

func start_dialog_from_arrays(lines: Array, expressions: Array, voice: String) -> void:
	dialog_lines = lines
	expression_paths = expressions
	voice_path = voice
	
	dialog_index = 0
	finished = false
	
	if voice_path != "":
		var s = load(voice_path)
		if s:
			voice_stream = s
	
	_next_line()

func start_dialog_from_json(json_path: String) -> void:
	var f := File.new()
	if not f.file_exists(json_path):
		print("No existe JSON de diálogo: ", json_path)
		return
	f.open(json_path, File.READ)
	var data = parse_json(f.get_as_text())
	f.close()
	
	if typeof(data) != TYPE_DICTIONARY or not data.has("conversation"):
		print("Formato JSON de diálogo inválido")
		return
	
	var lines := []
	var expressions := []
	var voice := ""
	
	for entry in data["conversation"]:
		lines.append(entry.get("text", ""))
		expressions.append(entry.get("expression", ""))
		voice = entry.get("voice", voice) # usa la última, o la misma siempre
	
	start_dialog_from_arrays(lines, expressions, voice)

func _unhandled_input(event):
	if not visible:
		return
	
	if event.is_action_pressed("ui_accept"):
		if finished:
			queue_free()
		elif is_typing:
			_finish_current_line()
		else:
			_next_line()

func _next_line() -> void:
	if dialog_index >= dialog_lines.size():
		# Ya no hay más líneas
		finished = true
		return
	
	current_text = str(dialog_lines[dialog_index])
	dialog_index += 1
	
	# Reiniciar texto
	text_label.bbcode_text = ""
	char_index = 0
	is_typing = true
	
	# Cambiar expresión si existe
	if dialog_index - 1 < expression_paths.size():
		var path = expression_paths[dialog_index - 1]
		if path != "":
			var tex = load(path)
			if tex:
				portrait.texture = tex
			else:
				print("No pude cargar expresión: ", path)

	
	# Iniciar timer para letra por letra
	char_timer.start(text_speed)

func _finish_current_line() -> void:
	# Imprimir de golpe
	text_label.bbcode_text = current_text
	is_typing = false
	char_timer.stop()

func _on_CharTimer_timeout() -> void:
	if not is_typing:
		return
	
	if char_index >= current_text.length():
		char_timer.stop()
		is_typing = false
		return
	
	var c := current_text[char_index]
	text_label.bbcode_text += c
	
	if c != " " and voice_stream:
		voice_player.stream = voice_stream
		voice_player.play()
	
	char_index += 1
