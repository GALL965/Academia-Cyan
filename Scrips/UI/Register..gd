extends Control

# --------- NODOS PRINCIPALES ---------
onready var email_input               = $CenterVBox/FormGrid/EmailInput
onready var password_input            = $CenterVBox/FormGrid/PasswordInput
onready var confirm_password_input    = $CenterVBox/FormGrid/ConfirmPasswordInput

onready var show_password_button      = $CenterVBox/FormGrid/PasswordInput/ShowPasswordButton
onready var show_password_button2     = $CenterVBox/FormGrid/ConfirmPasswordInput/ShowPasswordButton2

onready var register_button           = $RegistrarButton
onready var login_link_button         = $BottomText/LoginButton

# --------- ESTADO INTERNO ---------
var password_visible := false
var confirm_password_visible := false


func _ready() -> void:
	# Conectar botones de mostrar/ocultar contraseña
	show_password_button.connect("pressed", self, "_on_show_password_pressed")
	show_password_button2.connect("pressed", self, "_on_show_confirm_password_pressed")

	# Botones principales
	register_button.connect("pressed", self, "_on_register_pressed")
	login_link_button.connect("pressed", self, "_on_login_link_pressed")


# --------- OJO 1: CONTRASEÑA ---------
func _on_show_password_pressed() -> void:
	password_visible = not password_visible
	password_input.secret = not password_visible


# --------- OJO 2: CONFIRMAR CONTRASEÑA ---------
func _on_show_confirm_password_pressed() -> void:
	confirm_password_visible = not confirm_password_visible
	confirm_password_input.secret = not confirm_password_visible


# --------- REGISTRO ---------
func _on_register_pressed() -> void:
	var email = email_input.text.strip_edges()
	var pass1 = password_input.text
	var pass2 = confirm_password_input.text

	if email == "" or pass1 == "" or pass2 == "":
		print("Register: faltan datos")
		return

	if pass1 != pass2:
		print("Register: las contraseñas no coinciden")
		return

	# Registrar usuario en el "backend" local
	var ok = UserAuth.register(email, pass1)
	if not ok:
		print("Register: el usuario ya existe o los datos son inválidos")
		return

	print("Register: registro OK, yendo a Login…")

	# IR A LOGIN (sin LoadingScreen)
	get_tree().change_scene("res://Scenes/UI/Login.tscn")


# --------- LINK: INICIA SESIÓN ---------
func _on_login_link_pressed() -> void:
	print("Register: ir a Login desde el link inferior")
	get_tree().change_scene("res://Scenes/UI/Login.tscn")
