extends Node

# Diccionario simple: correo -> contraseña
var users := {}

# Último usuario registrado (para rellenar login automáticamente)
var last_registered_email := ""
var last_registered_password := ""


func register_user(email:String, password:String) -> bool:
	email = email.strip_edges()
	if email == "" or password == "":
		return false

	if users.has(email):
		# Ya existe una cuenta con este correo
		return false

	users[email] = password
	last_registered_email = email
	last_registered_password = password
	return true


func validate_login(email:String, password:String) -> bool:
	email = email.strip_edges()
	if not users.has(email):
		return false
	return users[email] == password
