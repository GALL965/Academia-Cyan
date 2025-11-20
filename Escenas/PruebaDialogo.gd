extends Node2D

onready var dialog_box := $UIRoot/DialogBox

func _ready() -> void:
	dialog_box.start_dialog_from_json("res://UI/dialog/dialogo.json")
