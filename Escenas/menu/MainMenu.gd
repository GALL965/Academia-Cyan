extends Control
var _base_scale := {}

var _idle_buttons := []
var _base_pos := {}
var _idle_phase := {}

onready var _tween := $Tween
onready var _vbox := $VBoxContainer
onready var _btn_math := $Math
onready var _btn_hist := $Hist
onready var _btn_salir := $Salir
onready var _btn_geo := $geo
onready var _btn_nat := $nat
onready var _btn_esp := $esp
onready var _btn_menu := $Menu
onready var _btn_pers := $Pers


const COLOR_NORMAL := Color(1, 1, 1, 1)
const COLOR_HOVER  := Color(0.85, 0.85, 0.85, 1)

func _ready():
	randomize()

	_idle_buttons = [_btn_math, _btn_pers, _btn_menu, _btn_hist, _btn_nat, _btn_geo, _btn_esp]
	
	for b in [_btn_math, _btn_hist, _btn_salir, _btn_pers, _btn_menu,  _btn_nat, _btn_geo, _btn_esp]:
		# Escala base para las animaciones
		_base_scale[b] = b.rect_scale

		# Guarda posición base para el flotado
		if b in _idle_buttons:
			_base_pos[b] = b.rect_position
			_idle_phase[b] = randf() * TAU  # desfase para que no se muevan igual

		b.modulate = COLOR_NORMAL
		b.connect("mouse_entered", self, "_on_button_mouse_entered", [b])
		b.connect("mouse_exited", self, "_on_button_mouse_exited", [b])
		b.connect("pressed", self, "_on_button_pressed_anim", [b])

	_play_intro_animation()



# =====================
# LÓGICA DE NAVEGACIÓN
# =====================




func _on_Jugar_pressed():
	_start_exit_animation("_go_to_world")

func _go_to_world():
	return

func _on_Opciones_pressed():
	_start_exit_animation("_go_to_options")

func _go_to_options():
	return

func _on_Salir_pressed():
	_start_exit_animation("_quit_game")

func _quit_game():
	get_tree().quit()

# =====================
# ANIMACIONES MENÚ
# =====================


func _play_intro_animation():

	_vbox.modulate.a = 0.0
	_vbox.rect_position += Vector2(0, 40)

	_tween.interpolate_property(
		_vbox, "rect_position",
		_vbox.rect_position,
		_vbox.rect_position - Vector2(0, 40),
		0.35,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		_vbox, "modulate:a",
		0.0,
		1.0,
		0.35,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	_tween.start()


func _start_exit_animation(next_method_name):
	_tween.stop_all()

	var start_pos = _vbox.rect_position
	var end_pos = start_pos + Vector2(0, 40)

	_tween.interpolate_property(
		_vbox, "rect_position",
		start_pos,
		end_pos,
		0.25,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)
	_tween.interpolate_property(
		_vbox, "modulate:a",
		1.0,
		0.0,
		0.25,
		Tween.TRANS_QUAD,
		Tween.EASE_IN
	)

	_tween.connect(
		"tween_all_completed",
		self,
		"_on_exit_animation_finished",
		[next_method_name],
		CONNECT_ONESHOT
	)
	_tween.start()

func _on_exit_animation_finished(next_method_name):
	# Llamamos al método que cambia de escena / sale del juego
	call_deferred(next_method_name)

# =====================
# ANIMACIONES DE HOVER Y CLICK
# =====================

func _on_button_mouse_entered(button):
	var base = _base_scale[button]
	_tween.interpolate_property(
		button, "rect_scale",
		button.rect_scale,
		base * 1.05,
		0.08,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		button, "modulate",
		button.modulate,
		COLOR_HOVER,
		0.08,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	_tween.start()


func _on_button_mouse_exited(button):
	var base = _base_scale[button]
	_tween.interpolate_property(
		button, "rect_scale",
		button.rect_scale,
		base,
		0.10,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		button, "modulate",
		button.modulate,
		COLOR_NORMAL,
		0.10,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	_tween.start()


func _on_button_pressed_anim(button):
	var base = _base_scale[button]
	_tween.interpolate_property(
		button, "rect_scale",
		button.rect_scale,
		base * 1.1,
		0.06,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		button, "rect_scale",
		base * 1.1,
		base,
		0.10,
		Tween.TRANS_SINE,
		Tween.EASE_IN,
		0.06
	)
	_tween.start()

func _process(delta):
	var t = OS.get_ticks_msec() / 1000.0
	for b in _idle_buttons:
		var phase = _idle_phase[b]
		var y = sin(t * 1.5 + phase) * 2.0
		b.rect_position = _base_pos[b] + Vector2(0, y)

func _on_Math_pressed():
	LoadingScreen.goto_scene("res://Escenas/games/math/pizz.tscn")
