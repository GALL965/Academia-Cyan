extends Control

# ==== RUTAS DE LOS NODOS (según tu .tscn) ====

onready var girl_button       = $CenterVBox/ContentHBox/GenderVBox/GenderOptionsHBox/GirlVBox/GirlButton
onready var boy_button        = $CenterVBox/ContentHBox/GenderVBox/GenderOptionsHBox/boyVBox/boyButton

onready var day_option        = $CenterVBox/ContentHBox/BirthVBox/DatePanel/DateVBox/DateSelectorsHBox/DayOption
onready var month_option      = $CenterVBox/ContentHBox/BirthVBox/DatePanel/DateVBox/DateSelectorsHBox/MonthOption
onready var year_option       = $CenterVBox/ContentHBox/BirthVBox/DatePanel/DateVBox/DateSelectorsHBox/YearOption
onready var selected_date_lbl = $CenterVBox/ContentHBox/BirthVBox/DatePanel/DateVBox/SelectedDateLabel

onready var continue_button   = $RegistrarButton   # botón "Continuar" morado


# ==== CONSTANTES Y ESTADO ====

const GENDER_NONE := ""
const GENDER_GIRL := "girl"
const GENDER_BOY  := "boy"

var selected_gender := GENDER_NONE
var selected_day    := -1
var selected_month  := -1
var selected_year   := -1


func _ready():
	_setup_gender_buttons()
	_setup_date_options()
	_update_continue_state()


# -------------------------------------------------------------------
#                          GÉNERO
# -------------------------------------------------------------------

func _setup_gender_buttons():
	girl_button.connect("pressed", self, "_on_girl_pressed")
	boy_button.connect("pressed", self, "_on_boy_pressed")
	_update_gender_visuals()


func _on_girl_pressed():
	selected_gender = GENDER_GIRL
	_update_gender_visuals()
	_update_continue_state()


func _on_boy_pressed():
	selected_gender = GENDER_BOY
	_update_gender_visuals()
	_update_continue_state()


func _update_gender_visuals():
	var girl_style = girl_button.get_stylebox("normal")
	var boy_style  = boy_button.get_stylebox("normal")

	if girl_style is StyleBoxFlat and boy_style is StyleBoxFlat:
		if selected_gender == GENDER_GIRL:
			girl_style.bg_color.a = 0.35
			boy_style.bg_color.a  = 0.15
		elif selected_gender == GENDER_BOY:
			girl_style.bg_color.a = 0.15
			boy_style.bg_color.a  = 0.35
		else:
			girl_style.bg_color.a = 0.15
			boy_style.bg_color.a  = 0.15


# -------------------------------------------------------------------
#                          FECHA
# -------------------------------------------------------------------

func _setup_date_options():
	# Días
	day_option.clear()
	for d in range(1, 32):
		day_option.add_item(str(d))

	# Meses
	var months = [
		"enero", "febrero", "marzo", "abril", "mayo", "junio",
		"julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"
	]
	month_option.clear()
	for i in range(months.size()):
		month_option.add_item(months[i], i + 1) # id = número de mes (1–12)

	# Años (ajusta el rango si quieres)
	year_option.clear()
	for y in range(2015, 2026):
		year_option.add_item(str(y))

	# Conectar señales
	day_option.connect("item_selected", self, "_on_day_selected")
	month_option.connect("item_selected", self, "_on_month_selected")
	year_option.connect("item_selected", self, "_on_year_selected")

	# Forzar fuente, colores y tamaño de botón + popup
	_setup_option_visuals(day_option)
	_setup_option_visuals(month_option)
	_setup_option_visuals(year_option)


func _setup_option_visuals(opt: OptionButton) -> void:
	# Fuente propia (usa tu Nunito-Black)
	var font = DynamicFont.new()
	font.font_data = load("res://Assets/fonts/nunito/Nunito-Black.ttf")
	font.size = 26

	# Aplicar fuente al botón
	opt.add_font_override("font", font)

	# Colores de texto del botón
	opt.add_color_override("font_color", Color(1, 1, 1, 1))
	opt.add_color_override("font_color_hover", Color(1, 1, 1, 1))
	opt.add_color_override("font_color_disabled", Color(0.8, 0.8, 0.8, 1))

	# Popup interno (el desplegable)
	var popup = opt.get_popup()
	popup.add_font_override("font", font)
	popup.add_color_override("font_color", Color(1, 1, 1, 1))
	popup.add_color_override("font_color_hover", Color(1, 1, 1, 1))
	popup.add_color_override("font_color_disabled", Color(0.8, 0.8, 0.8, 1))

	# Limitar tamaño del popup cuando se vaya a mostrar (para que no sea gigante)
	if not popup.is_connected("about_to_show", self, "_on_popup_about_to_show"):
		popup.connect("about_to_show", self, "_on_popup_about_to_show", [opt, popup])


func _on_popup_about_to_show(opt: OptionButton, popup: PopupMenu) -> void:
	# Ancho igual al botón
	var w = opt.rect_size.x
	# Alto máximo del popup (ajusta a gusto: 180, 220, 260, etc.)
	var h = 220
	popup.rect_size = Vector2(w, h)


func _on_day_selected(index):
	selected_day = int(day_option.get_item_text(index))
	_update_selected_date()
	_update_continue_state()


func _on_month_selected(index):
	selected_month = month_option.get_item_id(index)  # 1–12
	_update_selected_date()
	_update_continue_state()


func _on_year_selected(index):
	selected_year = int(year_option.get_item_text(index))
	_update_selected_date()
	_update_continue_state()


func _update_selected_date():
	if selected_day > 0 and selected_month > 0 and selected_year > 0:
		var month_index = month_option.get_selected()
		var month_text  = month_option.get_item_text(month_index)
		selected_date_lbl.text = str(selected_day) + " " + month_text + " " + str(selected_year)
	else:
		selected_date_lbl.text = "Selecciona tu fecha"


# -------------------------------------------------------------------
#                          CONTINUAR
# -------------------------------------------------------------------

func _update_continue_state():
	var gender_ok = selected_gender != GENDER_NONE
	var date_ok = selected_day > 0 and selected_month > 0 and selected_year > 0
	continue_button.disabled = not (gender_ok and date_ok)


func _on_RegistrarButton_pressed():
	if continue_button.disabled:
		return

	# Aquí ya tienes:
	#   selected_gender ("girl" o "boy")
	#   selected_day, selected_month, selected_year
	# Luego los guardas o pasas a la siguiente escena.
	# get_tree().change_scene("res://Scenes/UI/SiguientePaso.tscn")
