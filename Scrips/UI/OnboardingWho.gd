extends Control

const COLOR_SELECTED   = Color(1, 1, 1, 1)
const COLOR_UNSELECTED = Color(1, 1, 1, 0.4)

# --------- NODOS ---------
onready var class_button_classroom = $CenterVBox/WhoOptionsHBox/ClassVBox/ClassButton
onready var class_button_home      = $CenterVBox/WhoOptionsHBox/ClassVBox2/ClassButton

onready var yes_button  = $CenterVBox/ReadOptionsHBox/yesVbox/yesButton
onready var no_button   = $CenterVBox/ReadOptionsHBox/noVbox/noButton

onready var continue_button   = $ContinueButton
onready var false_continue_bg = $buttonFalseContinue


# --------- ESTADO ---------
var selected_target := ""          # "classroom" o "home"
var can_read_write := false        # true = sí sabe leer/escribir
var read_answer_selected := false  # ya contestó sí/no


func _ready() -> void:
	# Conexión de botones de destino
	class_button_classroom.connect("pressed", self, "_on_classroom_pressed")
	class_button_home.connect("pressed", self, "_on_home_pressed")

	# Conexión de botones de lectura
	yes_button.connect("pressed", self, "_on_yes_pressed")
	no_button.connect("pressed", self, "_on_no_pressed")

	# Botón continuar
	continue_button.connect("pressed", self, "_on_continue_pressed")

	# Estado inicial de colores y botón
	_update_target_visuals()
	_update_read_visuals()
	_update_continue_state()


# =========================
#   ¿PARA QUIÉN ES LA APP?
# =========================

func _on_classroom_pressed() -> void:
	selected_target = "classroom"
	if Engine.has_singleton("UserSession"):
		UserSession.set_target_use(selected_target)
	_update_target_visuals()


func _on_home_pressed() -> void:
	selected_target = "home"
	if Engine.has_singleton("UserSession"):
		UserSession.set_target_use(selected_target)
	_update_target_visuals()


func _update_target_visuals() -> void:
	if selected_target == "classroom":
		class_button_classroom.modulate = COLOR_SELECTED
		class_button_home.modulate      = COLOR_UNSELECTED
	elif selected_target == "home":
		class_button_classroom.modulate = COLOR_UNSELECTED
		class_button_home.modulate      = COLOR_SELECTED
	else:
		# Ninguno seleccionado
		class_button_classroom.modulate = COLOR_UNSELECTED
		class_button_home.modulate      = COLOR_UNSELECTED

	_update_continue_state()


# =========================
#   ¿SABE LEER Y ESCRIBIR?
# =========================

func _on_yes_pressed() -> void:
	can_read_write = true
	read_answer_selected = true
	if Engine.has_singleton("UserSession"):
		UserSession.set_can_read_write(can_read_write)
	_update_read_visuals()


func _on_no_pressed() -> void:
	can_read_write = false
	read_answer_selected = true
	if Engine.has_singleton("UserSession"):
		UserSession.set_can_read_write(can_read_write)
	_update_read_visuals()


func _update_read_visuals() -> void:
	if not read_answer_selected:
		yes_button.modulate = COLOR_UNSELECTED
		no_button.modulate  = COLOR_UNSELECTED
	else:
		if can_read_write:
			yes_button.modulate = COLOR_SELECTED
			no_button.modulate  = COLOR_UNSELECTED
		else:
			yes_button.modulate = COLOR_UNSELECTED
			no_button.modulate  = COLOR_SELECTED

	_update_continue_state()


# =========================
#   BOTÓN CONTINUAR
# =========================
func _update_continue_state() -> void:
	# Solo habilitar si ya eligió destino y Sí/No
	var enabled := (selected_target != "" and read_answer_selected)

	continue_button.disabled = not enabled





func _on_continue_pressed() -> void:
	# Defensa extra por si acaso
	if selected_target == "" or not read_answer_selected:
		print("Faltan respuestas en OnboardingWho")
		return

	# decidir a qué escena ir según pueda leer
	if can_read_write:
		get_tree().change_scene("res://Scenes/UI/ResultReadpositive.tscn")
	else:
		get_tree().change_scene("res://Scenes/UI/ResultReadnegative.tscn")
