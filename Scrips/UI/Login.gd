extends Control

# --------- SEÑALES HACIA LoginFlow ---------
signal go_to_register
signal go_to_onboarding_who

# ------------------ NODOS PRINCIPALES ------------------
onready var email_input: LineEdit    = $CenterVBox/FormGrid/EmailInput
onready var password_input: LineEdit = $CenterVBox/FormGrid/PasswordInput

onready var login_button: Button     = $LoginButton
onready var register_button: Button  = $BottomText/registerButton
onready var recover_button: Button   = $recoverPassword   # Por ahora sin funcionalidad


func _ready() -> void:
	# Conectar botones (evitando duplicados por si acaso)
	if not login_button.is_connected("pressed", self, "_on_login_pressed"):
		login_button.connect("pressed", self, "_on_login_pressed")

	if not register_button.is_connected("pressed", self, "_on_register_pressed"):
		register_button.connect("pressed", self, "_on_register_pressed")

	if not recover_button.is_connected("pressed", self, "_on_recover_pressed"):
		recover_button.connect("pressed", self, "_on_recover_pressed")


# ------------------ LOGIN ------------------
func _on_login_pressed() -> void:
	var email := email_input.text.strip_edges()
	var password := password_input.text

	if email == "" or password == "":
		print("Login: faltan datos")
		return

	# Ajusta esto a tu lógica real de autenticación
	var ok := UserAuth.login(email, password)
	if not ok:
		print("Login: credenciales inválidas")
		return

	print("Login OK, yendo a OnboardingWho…")
	# EN VEZ DE change_scene, avisamos al flujo:
	emit_signal("go_to_onboarding_who")


# ------------------ REGISTRO ------------------
func _on_register_pressed() -> void:
	emit_signal("go_to_register")


# Compatibilidad por si tu .tscn aún llama a estos métodos antiguos
func _on_go_register_pressed() -> void:
	_on_register_pressed()

func _on_registerButton_pressed() -> void:
	_on_register_pressed()


# ------------------ RECUPERAR CONTRASEÑA ------------------
func _on_recover_pressed() -> void:
	print("Por ahora esto no hace nada, función pendiente.")
