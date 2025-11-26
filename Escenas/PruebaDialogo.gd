extends Node2D

onready var dialog_box := $UIRoot/DialogBox

func _ready() -> void:

	if not dialog_box.is_connected("dialog_finished", self, "_on_dialog_finished"):
		dialog_box.connect("dialog_finished", self, "_on_dialog_finished")


	dialog_box.start_dialog_from_json("res://UI/dialog/dialogo.json")
	
func _on_dialog_finished() -> void:
	print("El diálogo terminó, aquí haces lo que quieras")
	LoadingScreen.goto_scene("res://Escenas/menu/MainMenu.tscn")
