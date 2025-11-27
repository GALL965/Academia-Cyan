extends Control

# Lista de texturas de avatares.
# Las asignaremos desde el Inspector.
export(Array, Texture) var avatar_textures = []

# Índice actual del avatar seleccionado
var current_index := 0

# Nodos de la escena
onready var avatar_texture_rect := $CenterVBox/AvatarHBox/AvatarTexture
onready var left_button         := $CenterVBox/AvatarHBox/LeftButton
onready var right_button        := $CenterVBox/AvatarHBox/RightButton
onready var confirm_button      := $RegistrarButton   # botón "Confirmar"


func _ready():
	# Conectar las flechas
	left_button.connect("pressed", self, "_on_left_pressed")
	right_button.connect("pressed", self, "_on_right_pressed")
	confirm_button.connect("pressed", self, "_on_confirm_pressed")

	# Mostrar el primer avatar al entrar
	if avatar_textures.size() > 0:
		current_index = clamp(current_index, 0, avatar_textures.size() - 1)
		_update_avatar()
	else:
		print("AvatarSelect: no hay texturas en 'avatar_textures'.")


func _on_left_pressed():
	if avatar_textures.size() == 0:
		return

	# Ir al avatar anterior (con ciclo)
	current_index = (current_index - 1 + avatar_textures.size()) % avatar_textures.size()
	_update_avatar()


func _on_right_pressed():
	if avatar_textures.size() == 0:
		return

	# Ir al avatar siguiente (con ciclo)
	current_index = (current_index + 1) % avatar_textures.size()
	_update_avatar()


func _update_avatar():
	# Cambiar la textura que se ve en pantalla
	avatar_texture_rect.texture = avatar_textures[current_index]


func _on_confirm_pressed():
	# Aquí ya tienes el avatar elegido
	print("Avatar seleccionado índice:", current_index)

	# Ejemplo: guardar en un autoload (si tienes uno)
	# GlobalData.selected_avatar = current_index

	# Ejemplo: cambiar de escena (ajusta la ruta)
	LoadingScreen.goto_scene("res://Scenes/UI/start.tscn")
