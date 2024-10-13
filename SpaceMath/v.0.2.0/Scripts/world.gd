extends Node2D
@onready var jugador = $Jugador  # Esto obtiene una referencia al nodo 'Jugador'
@export var enemy_scene :PackedScene #trae el escenario
#/*  Declarar las posiciones
@onready var pos1 = $PositionEnemy/Enemy1
@onready var pos2 = $PositionEnemy/Enemy2
@onready var pos3 = $PositionEnemy/Enemy3
#*/

var velocity = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.score = 0
	create_enemy()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moveBackground()
	_on_timer_timeout()	

#Mover el escenario	
func moveBackground():
	$Parallax2D.scroll_offset.y +=velocity
	
#Generar el asteroide y posicion random 
func create_enemy():
	
	var enemy1 = enemy_scene.instantiate()
	var enemy2 = enemy_scene.instantiate()
	var enemy3 = enemy_scene.instantiate()
	#Obtener la posicion fija para los tres asteroides
	enemy1.position = Vector2(pos1.position.x,-10)
	enemy2.position = Vector2(pos2.position.x,-10)
	enemy3.position = Vector2(pos3.position.x,-10)
	add_child(enemy1)
	add_child(enemy2)
	add_child(enemy3)
	
	#obtner el label Respuesta de enemy
	var enemyLabel1 = enemy1.get_node("Respuesta")
	var enemyLabel2 = enemy2.get_node("Respuesta")
	var enemyLabel3 = enemy3.get_node("Respuesta")
	
	
	var answerArray = [GlobalVariables.correct_answer,GlobalVariables.incorret_answer[0],GlobalVariables.incorret_answer[1]]
	answerArray.shuffle()

	var enemyLabels = [enemyLabel1, enemyLabel2, enemyLabel3]
	for i in range(enemyLabels.size()):
		enemyLabels[i].text = "  " + str(answerArray[i])

	
#Velocidad del escenario a los tiros/asteroides
func _on_timer_timeout() -> void:
	if jugador.conteo == 5:
		velocity += 2.0
		print("Velocidad: ",velocity)
		jugador.conteo = 0

#crear el enemigo cada cierto tiempo 
func _on_timer_enemy_timeout() -> void:
	create_enemy()
