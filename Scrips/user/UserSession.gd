extends Node

var registered_email := ""
var registered_password := ""
var is_registered := false
var is_logged_in := false

func register(email: String, password: String) -> void:
	registered_email = email
	registered_password = password
	is_registered = true

func can_login(email: String, password: String) -> bool:
	return is_registered \
		and email == registered_email \
		and password == registered_password
