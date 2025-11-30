extends Control

enum Estado {
	DIALOGO_INICIAL,
	EJEMPLO_1,
	DIALOGO_MEDIO,
	EJEMPLO_2,
	DIALOGO_FINAL
}

const DURACION_FADE := 0.3

var estado_actual := -1

onready var dialog_box := $UIRoot/DialogBox
onready var juego      := $Runas          # o $RunasTutorialGame si lo renombraste
onready var tween      := $TweenUI        # Tween que agregaste a la escena


func _ready() -> void:
	# Estado inicial de visibilidad
	dialog_box.show()
	dialog_box.modulate.a = 1.0

	juego.hide()
	juego.modulate.a = 0.0

	# Conexiones
	if not dialog_box.is_connected("dialog_finished", self, "_on_dialog_finished"):
		dialog_box.connect("dialog_finished", self, "_on_dialog_finished")

	if not juego.is_connected("ejemplo_terminado", self, "_on_ejemplo_terminado"):
		juego.connect("ejemplo_terminado", self, "_on_ejemplo_terminado")

	_cambiar_estado(Estado.DIALOGO_INICIAL)


# --------- TRANSICIONES ---------

func _fade_in(node: CanvasItem) -> void:
	tween.stop_all()
	node.modulate.a = 0.0
	tween.interpolate_property(
		node, "modulate:a",
		0.0, 1.0,
		DURACION_FADE,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.start()


func _mostrar_dialogo(json_path: String) -> void:
	juego.hide()
	dialog_box.show()
	dialog_box.start_dialog_from_json(json_path)
	_fade_in(dialog_box)


func _mostrar_juego(ejemplo_index: int) -> void:
	dialog_box.hide()
	juego.show()
	juego.set_ejemplo(ejemplo_index)
	_fade_in(juego)


# --------- FLUJO DE ESTADO ---------

func _cambiar_estado(nuevo_estado: int) -> void:
	estado_actual = nuevo_estado

	match estado_actual:
		Estado.DIALOGO_INICIAL:
			_mostrar_dialogo("res://UI/dialog/tutorial_runas_1.json")

		Estado.EJEMPLO_1:
			_mostrar_juego(1)

		Estado.DIALOGO_MEDIO:
			_mostrar_dialogo("res://UI/dialog/tutorial_runas_2.json")

		Estado.EJEMPLO_2:
			_mostrar_juego(2)

		Estado.DIALOGO_FINAL:
			_mostrar_dialogo("res://UI/dialog/tutorial_runas_3.json")


func _on_dialog_finished() -> void:
	match estado_actual:
		Estado.DIALOGO_INICIAL:
			_cambiar_estado(Estado.EJEMPLO_1)
		Estado.DIALOGO_MEDIO:
			_cambiar_estado(Estado.EJEMPLO_2)
		Estado.DIALOGO_FINAL:
			# Aquí ya acaba el tutorial, manda al juego completo o a donde quieras
			LoadingScreen.goto_scene("res://Escenas/games/math/Runas.tscn")


func _on_ejemplo_terminado() -> void:
	match estado_actual:
		Estado.EJEMPLO_1:
			_cambiar_estado(Estado.DIALOGO_MEDIO)
		Estado.EJEMPLO_2:
			_cambiar_estado(Estado.DIALOGO_FINAL)
