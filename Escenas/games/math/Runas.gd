extends Control

# --- CONFIGURACIÓN NUMÉRICA ---
const VALOR_MIN := 1
const VALOR_MAX := 9
const OBJETIVO_MIN := 10
const OBJETIVO_MAX := 20

var tiempo_total := 60.0       # segundos de partida
var tiempo_restante := 0.0

# --- NODOS ---
onready var target_label      := $TargetLabel
onready var current_sum_label := $CurrentLabel
onready var time_label        := $TimeLabel
onready var grid              := $GridContainer
onready var cast_button       := $CastButton
onready var info_label        := $InfoLabel
onready var round_timer       := $RoundTimer
onready var tween_ui          := $TweenUI      # Tween para sacudir

# --- DATOS DEL TABLERO ---
var grid_values := []          # valores de las 9 runas
var objetivo := 0              # número objetivo del hechizo actual

# --- ESTADÍSTICAS DE LA PARTIDA ---
var hechizos_totales := 0
var hechizos_correctos := 0
var hechizos_incorrectos := 0

# --- ANIMACIÓN DE FLOTAR ---
const FLOAT_AMPLITUDE := 4.0   # desplazamiento vertical en píxeles
const FLOAT_SPEED := 1.0       # velocidad de oscilación

var _base_positions := []      # posición base de cada botón
var _float_phases := []        # desfase para que no se muevan igual
var _float_time := 0.0

# --- SHAKE UI ---
var _grid_base_pos := Vector2()
var _shake_offset_x := 0.0


func _ready() -> void:
	randomize()

	# Conectar señales de botones de runa
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		btn.toggle_mode = true
		if not btn.is_connected("toggled", self, "_on_runa_toggled"):
			btn.connect("toggled", self, "_on_runa_toggled", [i])

	# Conectar botón de lanzar
	if not cast_button.is_connected("pressed", self, "_on_cast_button_pressed"):
		cast_button.connect("pressed", self, "_on_cast_button_pressed")

	# Conectar timer
	if not round_timer.is_connected("timeout", self, "_on_round_timer_timeout"):
		round_timer.connect("timeout", self, "_on_round_timer_timeout")

	# Guardar posiciones base para la animación de “flotar”
	_base_positions.resize(grid.get_child_count())
	_float_phases.resize(grid.get_child_count())
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		_base_positions[i] = btn.rect_position
		_float_phases[i] = rand_range(0.0, PI * 2.0)

	# Posición base del grid (para el shake)
	_grid_base_pos = grid.rect_position

	iniciar_partida()


func iniciar_partida() -> void:
	# Tomar el tiempo desde el Timer (lo que tengas configurado en la escena)
	tiempo_total = round_timer.wait_time

	hechizos_totales = 0
	hechizos_correctos = 0
	hechizos_incorrectos = 0

	tiempo_restante = tiempo_total
	round_timer.start()

	cast_button.disabled = false
	info_label.text = ""

	_refrescar_tablero()
	_actualizar_suma_actual()
	_actualizar_tiempo_label()


func _refrescar_tablero() -> void:
	objetivo = randi() % (OBJETIVO_MAX - OBJETIVO_MIN + 1) + OBJETIVO_MIN

	var cantidad_combinacion := 3
	if objetivo <= 18:
		cantidad_combinacion = (randi() % 2) + 2  # 2 o 3
	else:
		cantidad_combinacion = 3

	var combinacion := _generar_combinacion_valida(objetivo, cantidad_combinacion)

	grid_values.clear()
	grid_values.resize(9)

	# Posiciones para la combinación correcta
	var indices := []
	while indices.size() < cantidad_combinacion:
		var idx := randi() % 9
		if not indices.has(idx):
			indices.append(idx)

	# Asigna los números de la combinación
	for i in range(cantidad_combinacion):
		var idx = indices[i]
		grid_values[idx] = combinacion[i]

	# Rellena el resto con números aleatorios 1–9
	for i in range(9):
		if grid_values[i] == null:
			grid_values[i] = randi() % (VALOR_MAX - VALOR_MIN + 1) + VALOR_MIN

	# Actualiza texto de botones y resetea selección
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		btn.pressed = false
		btn.text = str(grid_values[i])

	# Actualiza objetivo en la UI
	target_label.text = "Objetivo: " + str(objetivo)
	_actualizar_suma_actual()


func _generar_combinacion_valida(valor_objetivo: int, cantidad: int) -> PoolIntArray:
	var numeros := PoolIntArray()

	if cantidad == 2:
		var intentos := 0
		while intentos < 100:
			var a := randi() % (VALOR_MAX - VALOR_MIN + 1) + VALOR_MIN
			var b := valor_objetivo - a
			if b >= VALOR_MIN and b <= VALOR_MAX:
				numeros.append(a)
				numeros.append(b)
				return numeros
			intentos += 1
		return _generar_combinacion_valida(valor_objetivo, 3)

	if cantidad == 3:
		var intentos2 := 0
		while intentos2 < 500:
			var a2 := randi() % (VALOR_MAX - VALOR_MIN + 1) + VALOR_MIN
			var b2 := randi() % (VALOR_MAX - VALOR_MIN + 1) + VALOR_MIN
			var c2 := valor_objetivo - a2 - b2
			if c2 >= VALOR_MIN and c2 <= VALOR_MAX:
				numeros.append(a2)
				numeros.append(b2)
				numeros.append(c2)
				return numeros
			intentos2 += 1

		numeros.append(3)
		numeros.append(3)
		numeros.append(valor_objetivo - 6)
		return numeros

	return numeros


func _on_runa_toggled(pressed: bool, index: int) -> void:
	_actualizar_suma_actual()


func _obtener_indices_seleccionados() -> PoolIntArray:
	var seleccionados := PoolIntArray()
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		if btn.pressed:
			seleccionados.append(i)
	return seleccionados


func _calcular_suma_actual() -> int:
	var suma := 0
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		if btn.pressed:
			suma += grid_values[i]
	return suma


func _actualizar_suma_actual() -> void:
	var suma := _calcular_suma_actual()
	current_sum_label.text = "Suma actual: " + str(suma)


func _on_cast_button_pressed() -> void:
	if round_timer.is_stopped():
		return  # Tiempo terminado

	var seleccionados := _obtener_indices_seleccionados()
	var cantidad_sel := seleccionados.size()

	if cantidad_sel < 2 or cantidad_sel > 3:
		info_label.text = "Elige 2 o 3 runas."
		return

	var suma := _calcular_suma_actual()
	hechizos_totales += 1

	if suma == objetivo:
		hechizos_correctos += 1
		info_label.text = "¡Hechizo correcto!"
		$nice.play()
		$nice2.play()
		_shake_success()
	else:
		hechizos_incorrectos += 1
		if suma < objetivo:
			$bad.play()
			info_label.text = "Te faltó energía."
		else:
			info_label.text = "Te pasaste de energía."
			$over.play()
		_shake_error()

	_refrescar_tablero()


func _process(delta: float) -> void:
	_float_time += delta

	# Actualizar tiempo con décimas de segundo
	if not round_timer.is_stopped():
		tiempo_restante = round_timer.get_time_left()
		_actualizar_tiempo_label()

	# Animación de flotación de las runas
	for i in range(grid.get_child_count()):
		var btn = grid.get_child(i)
		var base_pos : Vector2 = _base_positions[i]
		var offset_y := sin(_float_time * FLOAT_SPEED + _float_phases[i]) * FLOAT_AMPLITUDE
		btn.rect_position = Vector2(base_pos.x, base_pos.y + offset_y)

	# Aplicar shake al grid (mueve todo el tablero)
	grid.rect_position = _grid_base_pos + Vector2(_shake_offset_x, 0)


func _actualizar_tiempo_label() -> void:
	var t := max(tiempo_restante, 0.0)
	t = stepify(t, 0.1)  # redondear a 1 decimal
	time_label.text = "Tiempo: " + "%0.1f" % t + " s"


func _on_round_timer_timeout() -> void:
	cast_button.disabled = true

	if has_node("/root/AcademiaStats"):
		var stats = get_node("/root/AcademiaStats")
		stats.registrar_partida_runas(hechizos_totales, hechizos_correctos, hechizos_incorrectos)

	info_label.text = "Fin. Hechizos: %d  Correctos: %d" % [hechizos_totales, hechizos_correctos]


# --- SHAKE HELPERS ---

func _shake(amplitude: float, duration: float) -> void:
	tween_ui.stop_all()
	_shake_offset_x = 0.0

	var step := duration / 4.0
	# izquierda-derecha-izquierda-centro
	tween_ui.interpolate_property(self, "_shake_offset_x", 0.0, amplitude, step, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween_ui.interpolate_property(self, "_shake_offset_x", amplitude, -amplitude, step * 2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, step)
	tween_ui.interpolate_property(self, "_shake_offset_x", -amplitude, 0.0, step, Tween.TRANS_SINE, Tween.EASE_IN, step * 3.0)
	tween_ui.start()


func _shake_success() -> void:
	_shake(6.0, 0.25)


func _shake_error() -> void:
	_shake(14.0, 0.3
	)
