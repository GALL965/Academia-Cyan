extends Node

# ----- LOGIN / REGISTRO BÁSICO -----
var registered_email := ""
var registered_password := ""
var is_registered := false
var is_logged_in := false
var email: String = ""

# ----- CAMPOS DE ONBOARDING EXISTENTES -----
var target_use: String = ""      # "classroom" o "home"
var can_read_write: bool = false # true = sabe leer/escribir

# ----- NUEVOS CAMPOS: DATOS DEL ALUMNO -----
# Internamente uso "girl"/"boy" para simplificar lógica
# pero visualmente tú muestras "Niña"/"Niño".
var child_gender := ""           # "girl" o "boy"
var birth_day := 0
var birth_month := 0
var birth_year := 0


func register(email: String, password: String) -> void:
	registered_email = email
	registered_password = password
	is_registered = true


func can_login(email: String, password: String) -> bool:
	return is_registered \
		and email == registered_email \
		and password == registered_password


func clear() -> void:
	email = ""
	is_logged_in = false
	
	target_use = ""
	can_read_write = false
	
	child_gender = ""
	birth_day = 0
	birth_month = 0
	birth_year = 0


func set_login(email_value: String) -> void:
	email = email_value
	is_logged_in = true


func set_target_use(value: String) -> void:
	# value esperado: "classroom" o "home"
	target_use = value


func set_can_read_write(value: bool) -> void:
	can_read_write = value


func set_child_gender(gender: String) -> void:
	# Esperado: "girl" o "boy"
	child_gender = gender


func set_birth_date(day: int, month: int, year: int) -> void:
	birth_day = day
	birth_month = month
	birth_year = year
