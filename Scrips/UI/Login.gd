extends Control

# ------------------ NODOS PRINCIPALES ------------------
onready var email_input      = $CenterVBox/FormGrid/EmailInput
onready var password_input   = $CenterVBox/FormGrid/PasswordInput

onready var login_button     = $LoginButton
onready var register_button  = $BottomText/registerButton
onready var recover_button   = $recoverPassword   # Por ahora sin funcionalidad


func _ready() -> void:
	# Conectar botones
	login_button.connect("pressed", self, "_on_login_pressed")
	register_button.connect("pressed", self, "_on_go_register_pressed")
	recover_button.connect("pressed", self, "_on_recover_pressed")


# ------------------ LOGIN ------------------
func _on_login_pressed() -> void:
	var email = email_input.text.strip_edges()
	var password = password_input.text

	# Validación rápida
	if email == "" or password == "":
		print("Login: faltan datos")
		return

	# Intentar login usando tu sistema local
	if not UserAuth.login(email, password):
		print("Login: correo o contraseña incorrectos")
		return

	print("Login: acceso correcto, yendo a OnboardingWho…")

	# Cambio de escena directo
	get_tree().change_scene("res://Scenes/UI/OnboardingWho.tscn")


# ------------------ IR A REGISTRO ------------------
func _on_go_register_pressed() -> void:
	print("Login: ir a la pantalla de Registro")
	get_tree().change_scene("res://Scenes/UI/Register.tscn")


# ------------------ RECUPERAR CONTRASEÑA ------------------
func _on_recover_pressed() -> void:
	print("Por ahora esto no hace nada, función pendiente.")
