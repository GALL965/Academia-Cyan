extends Control

# ==== SEÑALES HACIA LoginFlow ====
signal go_to_name_user

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
const GENDER_GIRL := "girl"   # Niña
const GENDER_BOY  := "boy"    # Niño

# Altura máxima visible del popup (lo demás se scrollea)
const POPUP_MAX_HEIGHT := 220

var selected_gender := GENDER_NONE
var selected_day    := -1
var selected_month  := -1
var selected_year   := -1


func _ready() -> void:
	_setup_gender_buttons()
	_setup_date_options()

	if not continue_button.is_connected("pressed", self, "_on_continue_pressed"):
		continue_button.connect("pressed", self, "_on_continue_pressed")

	_update_continue_state()


# -------------------------------------------------------------------
#                          GÉNERO
# -------------------------------------------------------------------

func _setup_gender_buttons() -> void:
	if not girl_button.is_connected("pressed", self, "_on_girl_pressed"):
		girl_button.connect("pressed", self, "_on_girl_pressed")

	if not boy_button.is_connected("pressed", self, "_on_boy_pressed"):
		boy_button.connect("pressed", self, "_on_boy_pressed")

	_update_gender_visuals()


func _on_girl_pressed() -> void:
	selected_gender = GENDER_GIRL
	_update_gender_visuals()
	_update_continue_state()


func _on_boy_pressed() -> void:
	selected_gender = GENDER_BOY
	_update_gender_visuals()
	_update_continue_state()


func _update_gender_visuals() -> void:
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

func _setup_date_options() -> void:
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

	# Conectar señales de selección
	if not day_option.is_connected("item_selected", self, "_on_day_selected"):
		day_option.connect("item_selected", self, "_on_day_selected")
	if not month_option.is_connected("item_selected", self, "_on_month_selected"):
		month_option.connect("item_selected", self, "_on_month_selected")
	if not year_option.is_connected("item_selected", self, "_on_year_selected"):
		year_option.connect("item_selected", self, "_on_year_selected")

	# Limitar tamaño + popup
	_setup_popup(day_option)
	_setup_popup(month_option)
	_setup_popup(year_option)


func _setup_popup(opt: OptionButton) -> void:
	var popup := opt.get_popup()
	if not popup.is_connected("about_to_show", self, "_on_popup_about_to_show"):
		popup.connect("about_to_show", self, "_on_popup_about_to_show", [opt])


func _on_popup_about_to_show(opt: OptionButton) -> void:
	var popup := opt.get_popup()

	# Tamaño: ancho del botón, alto fijo con scroll
	popup.rect_size = Vector2(opt.rect_size.x, POPUP_MAX_HEIGHT)

	# Fuente y colores del popup
	var font := DynamicFont.new()
	font.font_data = load("res://Assets/fonts/nunito/Nunito-Black.ttf")
	font.size = 24

	popup.add_font_override("font", font)
	popup.add_color_override("font_color", Color(1, 1, 1, 1))
	popup.add_color_override("font_color_hover", Color(1, 1, 0.9, 1))
	popup.add_color_override("font_color_disabled", Color(0.8, 0.8, 0.8, 1))


func _on_day_selected(index: int) -> void:
	selected_day = int(day_option.get_item_text(index))
	_update_selected_date()
	_update_continue_state()


func _on_month_selected(index: int) -> void:
	selected_month = month_option.get_item_id(index)  # 1–12
	_update_selected_date()
	_update_continue_state()


func _on_year_selected(index: int) -> void:
	selected_year = int(year_option.get_item_text(index))
	_update_selected_date()
	_update_continue_state()


func _update_selected_date() -> void:
	if selected_day > 0 and selected_month > 0 and selected_year > 0:
		var month_index = month_option.get_selected()
		var month_text  = month_option.get_item_text(month_index)
		selected_date_lbl.text = str(selected_day) + " " + month_text + " " + str(selected_year)
	else:
		selected_date_lbl.text = "Selecciona tu fecha"


func _update_continue_state() -> void:
	var gender_ok = selected_gender != GENDER_NONE
	var date_ok = selected_day > 0 and selected_month > 0 and selected_year > 0
	continue_button.disabled = not (gender_ok and date_ok)


func _on_continue_pressed() -> void:
	# Defensa extra
	if selected_gender == GENDER_NONE:
		print("Falta seleccionar género")
		return
	if selected_day <= 0 or selected_month <= 0 or selected_year <= 0:
		print("Falta seleccionar fecha completa")
		return

	# Aquí podrías guardar en tu autoload UserSession si quieres:
	if Engine.has_singleton("UserSession"):
		if selected_gender == GENDER_GIRL:
			UserSession.set_gender("girl")
		elif selected_gender == GENDER_BOY:
			UserSession.set_gender("boy")
		UserSession.set_birthdate(selected_day, selected_month, selected_year)

	# Avisar al flujo que toca pasar a NameUser
	emit_signal("go_to_name_user")


# Compatibilidad por si el .tscn todavía tiene conectada esta función
func _on_RegistrarButton_pressed() -> void:
	_on_continue_pressed()
