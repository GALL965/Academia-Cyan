extends Control

# --------- SEÑALES HACIA LoginFlow ---------
signal go_to_login
signal go_to_name_user

# --------- NODOS PRINCIPALES ---------
onready var email_input: LineEdit            = $CenterVBox/FormGrid/EmailInput
onready var password_input: LineEdit         = $CenterVBox/FormGrid/PasswordInput
onready var confirm_password_input: LineEdit = $CenterVBox/FormGrid/ConfirmPasswordInput

onready var show_password_button: Button     = $CenterVBox/FormGrid/PasswordInput/ShowPasswordButton
onready var show_password_button2: Button    = $CenterVBox/FormGrid/ConfirmPasswordInput/ShowPasswordButton2

onready var register_button: Button          = $RegistrarButton
onready var login_link_button: Button        = $BottomText/LoginButton

# --------- ESTADO INTERNO ---------
var password_visible := false
var confirm_password_visible := false


func _ready() -> void:
	# Botones de mostrar/ocultar contraseña

	# Botones principales
	if not register_button.is_connected("pressed", self, "_on_register_pressed"):
		register_button.connect("pressed", self, "_on_register_pressed")

	if not login_link_button.is_connected("pressed", self, "_on_login_button_pressed"):
		login_link_button.connect("pressed", self, "_on_login_button_pressed")


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
	var email := email_input.text.strip_edges()
	var pass1 := password_input.text
	var pass2 := confirm_password_input.text

	if email == "" or pass1 == "" or pass2 == "":
		print("Register: faltan datos")
		return

	if pass1 != pass2:
		print("Register: las contraseñas no coinciden")
		return

	# Registrar usuario en el "backend" local
	var ok := UserAuth.register(email, pass1)
	if not ok:
		print("Register: el usuario ya existe o los datos son inválidos")
		return
	print("Register: registro OK, regresando a Login…")
	emit_signal("go_to_login")


func _on_login_button_pressed() -> void:
	# Volver a la pantalla de login
	emit_signal("go_to_login")


# Compatibilidad por si el .tscn aún tiene una conexión antigua:
# (LoginButton -> _on_LoginButton_pressed)
func _on_LoginButton_pressed() -> void:
	_on_login_button_pressed()
