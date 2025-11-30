extends Control


onready var start_button := $StartButton
# Si tu botón está dentro de un contenedor, por ejemplo CenterVBox, sería:
# onready var start_button := $CenterVBox/StartButton

func _ready():
	start_button.connect("pressed", self, "_on_start_pressed")



func _on_start_pressed():
	# Vamos directo a la pantalla de login
	get_tree().change_scene("res://Scenes/UI/LoginFlow.tscn")
