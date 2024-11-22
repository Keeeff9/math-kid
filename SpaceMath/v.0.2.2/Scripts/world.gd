extends Node2D

@onready var jugador = $Jugador  # Referencia al nodo 'Jugador'
@export var enemy_scene: PackedScene  # Escena del enemigo

# Posiciones de los enemigos
@onready var pos1 = $PositionEnemy/Enemy1
@onready var pos2 = $PositionEnemy/Enemy2
@onready var pos3 = $PositionEnemy/Enemy3
@onready var pos4 = $PositionEnemy/Enemy4
@onready var pos5 = $PositionEnemy/Enemy5
@onready var pos6 = $PositionEnemy/Enemy6

var velocity = 1.0  # Velocidad para mover el fondo

func _ready() -> void:
	print("Posición inicial:", pos1.position.y)
	GlobalVariables.score = 0  # Reinicia el puntaje al comenzar
	create_enemy()  # Genera los enemigos iniciales

func _process(delta: float) -> void:
	move_background()  # Mueve el fondo

# Mueve el fondo de forma continua
func move_background():
	$Parallax2D.scroll_offset.y += velocity

# Genera enemigos en posiciones aleatorias
func create_enemy():
	var positions = [pos1, pos2, pos3, pos4, pos5, pos6]
	positions.shuffle()  # Mezcla las posiciones para asignarlas aleatoriamente
	var position_select = positions.slice(0, 3)  # Selecciona 3 posiciones aleatorias

	var enemy1 = enemy_scene.instantiate()
	var enemy2 = enemy_scene.instantiate()
	var enemy3 = enemy_scene.instantiate()

	# Asigna posiciones a los enemigos
	enemy1.position = Vector2(position_select[0].position.x, position_select[0].position.y)
	enemy2.position = Vector2(position_select[1].position.x, position_select[1].position.y)
	enemy3.position = Vector2(position_select[2].position.x, position_select[2].position.y)

	# Añade enemigos a la escena
	add_child(enemy1)
	add_child(enemy2)
	add_child(enemy3)

	# Añadir enemigos al grupo para detección de colisiones
	enemy1.add_to_group("enemy")
	enemy2.add_to_group("enemy")
	enemy3.add_to_group("enemy")

	GlobalVariables.enemigos_escena = 3  # Actualiza el conteo de enemigos

	# Obtiene los nodos de etiqueta de cada enemigo
	var enemyLabel1 = enemy1.get_node("Respuesta")
	var enemyLabel2 = enemy2.get_node("Respuesta")
	var enemyLabel3 = enemy3.get_node("Respuesta")

	# Mezcla respuestas correctas e incorrectas
	var answerArray = [GlobalVariables.correct_answer, GlobalVariables.incorret_answer[0], GlobalVariables.incorret_answer[1]]
	answerArray.shuffle()

	# Asigna las respuestas mezcladas a los enemigos
	var enemyLabels = [enemyLabel1, enemyLabel2, enemyLabel3]
	for i in range(enemyLabels.size()):
		enemyLabels[i].text = "  " + str(answerArray[i])

# Llama a create_enemy cuando el temporizador se agota
func _on_timer_enemy_timeout() -> void:
	create_enemy()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volver"):
		get_tree().change_scene_to_file("res://Main_World/Tutorial1.tscn")
