# res://Escenas/games/math/RunasTutorialGame.gd
extends Control

signal ejemplo_terminado  # Se emite cuando el jugador resuelve bien la suma

# Botones de runas
var runa_buttons := []
var valores_actuales := []  # valores que se muestran en los botones
var seleccion := []         # valores seleccionados
var suma_objetivo := 0
var ejemplo_actual := 0

onready var target_label  := $TargetLabel
onready var current_label := $CurrentLabel
onready var info_label    := $InfoLabel
onready var cast_button   := $CastButton
onready var grid          := $GridContainer


func _ready() -> void:
	# Recoger todos los botones del grid
	for child in grid.get_children():
		if child is Button:
			runa_buttons.append(child)
			if not child.is_connected("pressed", self, "_on_runa_pressed"):
				child.connect("pressed", self, "_on_runa_pressed", [child])

	if not cast_button.is_connected("pressed", self, "_on_cast_pressed"):
		cast_button.connect("pressed", self, "_on_cast_pressed")

	# Por defecto puedes iniciar oculto, el flujo te llamará a set_ejemplo()
	hide()


func set_ejemplo(index: int) -> void:
	# Llamado desde el flujo para preparar el ejemplo 1 o 2
	ejemplo_actual = index
	seleccion.clear()

	match index:
		1:
			# Ejemplo sencillo: suma 5 + 3 = 8
			suma_objetivo = 8
			valores_actuales = [5, 3, 1, 2, 4, 6, 7, 9, 0]
		2:
			# Ejemplo un poco más complejo: por ejemplo 4 + 8 = 12
			suma_objetivo = 12
			valores_actuales = [4, 8, 3, 9, 2, 5, 7, 1, 6]
		_:
			suma_objetivo = 0
			valores_actuales = [0, 0, 0, 0, 0, 0, 0, 0, 0]

	# Opcional: mezclar los valores para simular "la mecánica de mezcla"
	randomize()
	valores_actuales.shuffle()

	# Asignar los valores a los botones
	for i in range(runa_buttons.size()):
		var b: Button = runa_buttons[i]
		b.pressed = false
		b.text = str(valores_actuales[i])

	# Actualizar texto de UI
	target_label.text  = "Meta: %d" % suma_objetivo
	info_label.text    = "Selecciona runas que sumen la meta y luego presiona Lanzar!"
	_actualizar_suma_actual()

	# Asegurarse de que se vea cuando se use este ejemplo
	show()


func _on_runa_pressed(button: Button) -> void:

	var valor := int(button.text)

	if button.pressed:
		seleccion.append(valor)
	else:
		seleccion.erase(valor)

	_actualizar_suma_actual()


func _actualizar_suma_actual() -> void:
	var total := 0
	for v in seleccion:
		total += v

	current_label.text = "Actual: %d" % total


func _on_cast_pressed() -> void:
	var total := 0
	for v in seleccion:
		total += v

	if total == suma_objetivo:
		$nice.play()
		$nice2.play()
		info_label.text = "¡Correcto! Has alcanzado la meta."
		emit_signal("ejemplo_terminado")
	else:
		$bad.play()
		info_label.text = "Aún no es la suma correcta, intenta de nuevo."
