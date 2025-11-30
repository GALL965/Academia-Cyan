extends Control

# Señal hacia LoginFlow para pasar al siguiente paso (avatar)
signal go_to_onboarding_avatar

# --------- NODOS (según tu escena) ---------
onready var name_input: LineEdit      = $CenterVBox/FormGrid/EmailInput
onready var extra_input: LineEdit     = $CenterVBox/FormGrid/PasswordInput
onready var continue_button: Button   = $continueButton

# --------- ESTADO ---------
var fields_valid := false


func _ready() -> void:
	# Conexiones de señales
	if not continue_button.is_connected("pressed", self, "_on_continue_pressed"):
		continue_button.connect("pressed", self, "_on_continue_pressed")

	if not name_input.is_connected("text_changed", self, "_on_any_text_changed"):
		name_input.connect("text_changed", self, "_on_any_text_changed")

	if extra_input and not extra_input.is_connected("text_changed", self, "_on_any_text_changed"):
		extra_input.connect("text_changed", self, "_on_any_text_changed")

	_update_continue_state()


func _on_any_text_changed(_new_text: String) -> void:
	_update_continue_state()


func _update_continue_state() -> void:
	var name_ok := name_input.text.strip_edges() != ""
	var extra_ok := true

	if extra_input:
		extra_ok = extra_input.text.strip_edges() != ""

	fields_valid = name_ok and extra_ok
	continue_button.disabled = not fields_valid


func _on_continue_pressed() -> void:
	# Defensa extra
	if not fields_valid:
		print("NameUser: aún hay campos vacíos, no debería avanzar.")
		return

	print("NameUser: campos llenos, pasando a Avatar…")
	emit_signal("go_to_onboarding_avatar")


# Compatibilidad por si el .tscn tiene conectada esta función
func _on_RegistrarButton_pressed() -> void:
	_on_continue_pressed()


func _on_continueButton_pressed():
	_on_continue_pressed()
