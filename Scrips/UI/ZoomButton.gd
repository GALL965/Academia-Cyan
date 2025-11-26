extends BaseButton

# Qué tanto crece al pasar el mouse por encima
export(float) var hover_zoom := 1.06
# Zoom extra mientras el botón está presionado
export(float) var press_extra_zoom := 0.04

# Escala original del botón (por defecto Vector2(1,1))
var base_scale := Vector2.ONE

func _ready():
	# Guardamos la escala original del nodo
	base_scale = rect_scale

	# Conectamos señales del propio botón
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("pressed", self, "_on_pressed")
	connect("button_up", self, "_on_button_up")

func _on_mouse_entered():
	# Zoom cuando entra el cursor
	rect_scale = base_scale * hover_zoom

func _on_mouse_exited():
	# Vuelve al tamaño original cuando sale el cursor
	rect_scale = base_scale

func _on_pressed():
	# Un poco más de zoom mientras está presionado
	rect_scale = base_scale * (hover_zoom + press_extra_zoom)

func _on_button_up():
	# Al soltar: si el mouse sigue encima, volvemos al zoom de hover,
	# si no, al tamaño original
	if get_rect().has_point(get_local_mouse_position()):
		rect_scale = base_scale * hover_zoom
	else:
		rect_scale = base_scale
