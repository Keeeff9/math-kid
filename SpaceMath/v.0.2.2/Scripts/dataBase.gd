extends Node

@onready var http_request = $HTTPRequest
@onready var grid_container = $GridContainer  # Asegúrate de tener un GridContainer en la escena
@onready var button = $"../HBoxContainer/Button"
@onready var userNamePlay = $UserNamePlay

var url = "http://localhost/apiphpserver/game.php"  # Cambia esta URL según tu necesidad
var is_post_request = false  # Variable para distinguir entre solicitudes GET y POST

func _ready() -> void:
	if not http_request.is_connected("request_completed", Callable(self, "_on_http_request_request_completed")):
		http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))
	# load_data()  # Solicitar datos al iniciar
	if not button.is_connected("pressed", Callable(self, "_on_button_pressed")):
		button.connect("pressed", Callable(self, "_on_button_pressed"))  # Conectar el botón al método

	var key = "userNameStg"
	var value = read_from_local_storage(key)
	userNamePlay.text = value
	GlobalVariables.userName = value
	if value:
		print("Valor leído del localStorage:", value)
	else:
		print("No se encontró el dato en el localStorage")

var is_show_rating = false
func _on_button_pressed() -> void:
	# save_data()  # Llama a la función para guardar datos
	if is_show_rating:
		grid_container.visible = false
		is_show_rating = false
	else:
		load_data() # Solicitar datos al presionar el botón
		grid_container.visible = true
		is_show_rating = true

func load_data() -> void:
	is_post_request = false
	http_request.request(url)  # Realiza la solicitud GET para obtener los datos

# Función para guardar un nuevo registro
func save_data() -> void:
	var data = {
		"userName": GlobalVariables.userName,
		"score": GlobalVariables.score,
	}

	is_post_request = true
	
	var json_data = JSON.stringify(data)  # Convierte el diccionario a JSON
	var body = json_data  # El cuerpo de la solicitud debe ser una cadena JSON

	var headers = PackedStringArray()
	headers.append("Content-Type: application/json")

	# Realiza la solicitud POST
	
	var err = http_request.request(url + "?table=contacto", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		print("Error al realizar la solicitud:", err)  # Manejar el error si la solicitud falla

func _on_http_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Response code:", response_code)
	print("Response body:", body.get_string_from_utf8())

	if response_code == 200:
		var json = JSON.new()
		var error_code = json.parse(body.get_string_from_utf8())
		if error_code != OK:
			print("Error al parsear JSON:", error_code)
			return

		var data = json.data  # Acceder al resultado del análisis JSON
		if data is Array:  # Verificamos si 'data' es un Array
			# Limpiar el contenedor antes de agregar nuevos elementos
			for child in grid_container.get_children():
				child.queue_free()  # Elimina cada nodo hijo

			# Definir cuántas columnas habrá
			grid_container.columns = 2  # Cambia este número según el número de columnas que desees

			# Añadir encabezados de columna
			add_header("User Name")
			add_header("Max Score")

			# Iterar sobre cada diccionario en la lista
			for entry in data:
				if entry is Dictionary:  # Verificamos que cada entrada sea un Dictionary
					# Agregar los valores a las columnas
					add_value(entry.get("userName", "N/A"))
					add_value(str(entry.get("max_score", "N/A")))
				else:
					print("Entrada no es un Dictionary.")
		else:
			print("Error al parsear JSON. Respuesta no es un Array.")
	else:
		match response_code:
			HTTPClient.STATUS_CANT_CONNECT:
				print("Error: No se pudo conectar al servidor.")
			_:
				print("Error desconocido:", response_code)

	# Si la solicitud POST fue exitosa, recargar los datos
	# if is_post_request:
	# 	load_data()

# Función para añadir un encabezado de columna
func add_header(text: String) -> void:
	var header_label = Label.new()
	header_label.text = text
	header_label.add_theme_stylebox_override("normal", StyleBoxFlat.new())  # Estilo opcional
	header_label.set("rect_min_size", Vector2(100, 30))  # Establecer un tamaño mínimo
	grid_container.add_child(header_label)

# Función para añadir un valor a la tabla
func add_value(text: String) -> void:
	var value_label = Label.new()
	value_label.text = text
	value_label.add_theme_stylebox_override("normal", StyleBoxFlat.new())  # Estilo opcional
	value_label.set("rect_min_size", Vector2(100, 30))  # Establecer un tamaño mínimo
	grid_container.add_child(value_label)

# Define una función para leer un dato del localStorage
func read_from_local_storage(key: String) -> String:
	if Engine.has_singleton("JavaScriptBridge"):
		var script = "localStorage.getItem('" + key + "')"
		var result = JavaScriptBridge.eval(script)
		if result == null:
			return ""
		return result
	else:
		print("JavaScript singleton not available")
		return ""
