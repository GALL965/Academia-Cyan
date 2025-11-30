extends Control

const SCREENS := {
	"start":            preload("res://Scenes/UI/start.tscn"),
	"login":            preload("res://Scenes/UI/Login.tscn"),
	"register":         preload("res://Scenes/UI/Register.tscn"),
	"name_user":        preload("res://Scenes/UI/nameUser.tscn"),
	"date_gen":         preload("res://Scenes/UI/DateGenUser.tscn"),
	"onboarding_who":   preload("res://Scenes/UI/OnboardingWho.tscn"),
	"onboarding_avatar": preload("res://Scenes/UI/OnboardingAvatar.tscn"),
	"result_read_pos":  preload("res://Scenes/UI/ResultReadpositive.tscn"),
	"result_read_neg":  preload("res://Scenes/UI/ResultReadnegative.tscn")
}

onready var _container: Control        = $ScreenContainer
onready var _anim: AnimationPlayer     = $AnimationPlayer

var _current_screen: Node = null
var _current_key := ""
var _pending_key := ""


func _ready() -> void:
	# Asegurarnos de que el pivot del contenedor esté centrado
	_update_container_pivot()
	if not get_tree().is_connected("screen_resized", self, "_on_screen_resized"):
		get_tree().connect("screen_resized", self, "_on_screen_resized")

	# Pantalla inicial del flujo
	_show_screen_immediate("login")
	if _anim.has_animation("screen_in"):
		_anim.play("screen_in")



func _show_screen_immediate(key: String) -> void:
	if _current_screen:
		_current_screen.queue_free()
		_current_screen = null

	var scene_res = SCREENS.get(key, null)
	if scene_res == null:
		push_error("Pantalla no registrada en SCREENS: %s" % key)
		return

	var instance: Node = scene_res.instance()
	_container.add_child(instance)
	_current_screen = instance
	_current_key = key

	_connect_child_signals(instance)


func go_to_screen(key: String) -> void:
	if key == _current_key:
		return

	_pending_key = key

	if _anim.has_animation("screen_out"):
		_anim.play("screen_out")
	else:
		_show_screen_immediate(_pending_key)
		_pending_key = ""


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "screen_out" and _pending_key != "":
		_show_screen_immediate(_pending_key)
		_pending_key = ""
		if _anim.has_animation("screen_in"):
			_anim.play("screen_in")


func _connect_child_signals(child: Node) -> void:
	# Login
	if child.has_signal("go_to_register"):
		child.connect("go_to_register", self, "_on_child_go_to_register")
	if child.has_signal("go_to_onboarding_who"):
		child.connect("go_to_onboarding_who", self, "_on_child_go_to_onboarding_who")

	# Register
	if child.has_signal("go_to_login"):
		child.connect("go_to_login", self, "_on_child_go_to_login")
	if child.has_signal("go_to_name_user"):
		child.connect("go_to_name_user", self, "_on_child_go_to_name_user")

	# nameUser / resultados → DateGen
	if child.has_signal("go_to_date_gen"):
		child.connect("go_to_date_gen", self, "_on_child_go_to_date_gen")

	# DateGen → Who
	if child.has_signal("go_to_onboarding_who"):
		child.connect("go_to_onboarding_who", self, "_on_child_go_to_onboarding_who")

	# Who → resultados de lectura
	if child.has_signal("go_to_result_read_pos"):
		child.connect("go_to_result_read_pos", self, "_on_child_go_to_result_read_pos")
	if child.has_signal("go_to_result_read_neg"):
		child.connect("go_to_result_read_neg", self, "_on_child_go_to_result_read_neg")

	# NameUser → Avatar
	if child.has_signal("go_to_onboarding_avatar"):
		child.connect("go_to_onboarding_avatar", self, "_on_child_go_to_onboarding_avatar")

	# Avatar → start (o lo que decidas al final)
	if child.has_signal("go_to_start"):
		child.connect("go_to_start", self, "_on_child_go_to_start")



# --------- HANDLERS DE FLUJO ---------
func _on_child_go_to_onboarding_avatar() -> void:
	go_to_screen("onboarding_avatar")

func _on_child_go_to_login() -> void:
	go_to_screen("login")

func _on_child_go_to_register() -> void:
	go_to_screen("register")

func _on_child_go_to_name_user() -> void:
	go_to_screen("name_user")

func _on_child_go_to_date_gen() -> void:
	go_to_screen("date_gen")

func _on_child_go_to_onboarding_who() -> void:
	go_to_screen("onboarding_who")

func _on_child_go_to_result_read_pos() -> void:
	go_to_screen("result_read_pos")

func _on_child_go_to_result_read_neg() -> void:
	go_to_screen("result_read_neg")

func _on_child_go_to_start() -> void:
	go_to_screen("start")



func _update_container_pivot() -> void:
	# Centrar el pivot del contenedor para que la escala sea desde el centro
	_container.rect_pivot_offset = _container.rect_size / 2


func _on_screen_resized() -> void:
	_update_container_pivot()
