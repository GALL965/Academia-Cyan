extends Node

# Diccionario simple: correo -> contraseña
var users := {}

# Último usuario registrado / logueado
var current_email := ""
var last_register_email := ""
var last_register_password := ""

func register(email: String, password: String) -> bool:
	email = email.strip_edges()
	if email == "" or password == "":
		return false

	if users.has(email):
		# Ya existe
		return false

	users[email] = password
	current_email = email
	last_register_email = email
	last_register_password = password
	print("UserAuth: usuario registrado -> ", email)
	return true


func login(email: String, password: String) -> bool:
	email = email.strip_edges()
	if email == "" or password == "":
		return false

	if not users.has(email):
		return false

	if users[email] != password:
		return false

	current_email = email
	print("UserAuth: login correcto -> ", email)
	return true
