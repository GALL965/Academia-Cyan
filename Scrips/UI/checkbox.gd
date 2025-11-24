extends Control

# RUTAS EXACTAS SEGÚN TU ÁRBOL
onready var yes_button      = $CenterVBox/ReadOptionsHBox/yesVbox/yesButton
onready var no_button       = $CenterVBox/ReadOptionsHBox/noVbox/noButton
onready var continue_button = $CenterVBox/ContinueButton

const CHECK_OFF_BG := Color(1, 1, 1, 0.0)  # transparente
const CHECK_ON_BG  := Color(1, 1, 1, 0.4)  # blanco semi-opaco

var can_read = null  # true / false / null


func _ready():
	yes_button.connect("pressed", self, "_on_yes_pressed")
	no_button.connect("pressed", self, "_on_no_pressed")

	_update_checkbox_visuals()
	_update_continue_state()


func _on_yes_pressed():
	can_read = true
	_update_checkbox_visuals()
	_update_continue_state()


func _on_no_pressed():
	can_read = false
	_update_checkbox_visuals()
	_update_continue_state()


func _update_checkbox_visuals():
	var yes_style = yes_button.get_stylebox("normal")
	var no_style  = no_button.get_stylebox("normal")

	if yes_style is StyleBoxFlat and no_style is StyleBoxFlat:
		if can_read == true:
			yes_style.bg_color = CHECK_ON_BG
			no_style.bg_color = CHECK_OFF_BG
		elif can_read == false:
			yes_style.bg_color = CHECK_OFF_BG
			no_style.bg_color = CHECK_ON_BG
		else:
			yes_style.bg_color = CHECK_OFF_BG
			no_style.bg_color = CHECK_OFF_BG


func _update_continue_state():
	var ready = can_read != null
