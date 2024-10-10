extends Node

@onready var http_request = $HTTPRequest
@onready var grid_container = $GridContainer  # Asegúrate de tener un GridContainer en la escena
@onready var name_input = $NameInput         # Asegúrate de tener un LineEdit para el nombre
@onready var phone_input = $PhoneInput        # Asegúrate de tener un LineEdit para el teléfono
@onready var email_input = $EmailInput        # Asegúrate de tener un LineEdit para el correo electrónico
@onready var button = $Button

var url = "http://localhost/apiphpserver/index.php"  # Cambia esta URL según tu necesidad
var is_post_request = false  # Variable para distinguir entre solicitudes GET y POST

func _ready() -> void:
	http_request.connect("request_completed", Callable(self, "_on_http_request_request_completed"))
	load_data()  # Solicitar datos al iniciar
	button.connect("pressed", Callable(self, "_on_button_pressed"))  # Conectar el botón al método

func load_data() -> void:
	is_post_request = false
	http_request.request(url)  # Realiza la solicitud GET para obtener los datos

func _on_button_pressed() -> void:
	save_data()  # Llama a la función para guardar datos

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Response code:", response_code)
	print("Response body:", body.get_string_from_utf8())

	if response_code == 200:
		var json = JSON.new()
		var error_code = json.parse(body.get_string_from_utf8())
		if error_code != OK:
			print("Error al parsear JSON")
			return

		var data = json.data  # Acceder al resultado del análisis JSON
		if data is Array:  # Verificamos si 'data' es un Array
			# Limpiar el contenedor antes de agregar nuevos elementos
			for child in grid_container.get_children():
				child.queue_free()  # Elimina cada nodo hijo

			# Definir cuántas columnas habrá
			grid_container.columns = 3  # Cambia este número según el número de columnas que desees

			# Añadir encabezados de columna
			add_header("Name")
			add_header("Phone")
			add_header("Email")

			# Iterar sobre cada diccionario en la lista
			for entry in data:
				if entry is Dictionary:  # Verificamos que cada entrada sea un Dictionary
					# Agregar los valores a las columnas
					add_value(entry.get("name", "N/A"))
					add_value(entry.get("phone", "N/A"))
					add_value(entry.get("email", "N/A"))
				else:
					print("Entrada no es un Dictionary.")
		else:
			print("Error al parsear JSON. Respuesta no es un Array.")
	else:
		print("Error en la solicitud:", response_code)

	# Si la solicitud POST fue exitosa, recargar los datos
	if is_post_request:
		load_data()

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

# Función para guardar un nuevo registro
func save_data() -> void:
	var data = {
		"name": name_input.text,
		"phone": phone_input.text,
		"email": email_input.text,
		"image": "NoImage.webp"  # O algún valor predeterminado
	}
	
	var json_data = JSON.stringify(data)  # Convierte el diccionario a JSON
	var body = json_data  # El cuerpo de la solicitud debe ser una cadena JSON

	var headers = PackedStringArray()
	headers.append("Content-Type: application/json")

	# Realiza la solicitud POST
	is_post_request = true
	var err = http_request.request(url + "?table=contacto", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		print("Error al realizar la solicitud:", err)  # Manejar el error si la solicitud falla
