extends Node2D
@onready var jugador = $Jugador  # Esto obtiene una referencia al nodo 'Jugador'
@export var enemy_scene :PackedScene #trae el escenario
#/*  Declarar las posiciones
@onready var pos1 = $PositionEnemy/Enemy1
@onready var pos2 = $PositionEnemy/Enemy2
@onready var pos3 = $PositionEnemy/Enemy3
@onready var pos4 = $PositionEnemy/Enemy4
@onready var pos5 = $PositionEnemy/Enemy5
@onready var pos6 = $PositionEnemy/Enemy6

#*/

var velocity = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.score = 0
	create_enemy()
	create_enemySinRespuesta()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	moveBackground()
#Mover el escenario	
func moveBackground():
	$Parallax2D.scroll_offset.y +=velocity
	
func create_enemySinRespuesta():
	var enemy1Solo = enemy_scene.instantiate()
	var enemy2Solo = enemy_scene.instantiate()
	
	var randomPosition = RandomNumberGenerator.new()
	var positionX = randomPosition.randi_range( 50,340)
	var position2X = randomPosition.randi_range(360,700)
	
	while positionX == position2X:
		position2X = randomPosition.randi_range(100,1300)
		break
	enemy1Solo.position = Vector2(positionX,+200)
	enemy2Solo.position = Vector2(position2X,+150)
	add_child(enemy1Solo)
	add_child(enemy2Solo)
#Generar el asteroide y posicion random 


func create_enemy():
	var positions = [pos1,pos2,pos3,pos4,pos5,pos6]
	positions.shuffle()	
	var position_select = positions.slice(0,3)
	
	var enemy1 = enemy_scene.instantiate()
	var enemy2 = enemy_scene.instantiate()
	var enemy3 = enemy_scene.instantiate()

	#Obtener la posicion fija para los tres asteroides
	enemy1.position = Vector2(position_select[0].position.x,-10)
	enemy2.position = Vector2(position_select[1].position.x,-10)
	enemy3.position = Vector2(position_select[2].position.x,-10)
	print("Se elegieron las posiciones:" , position_select[0].position , position_select[1] , position_select[2])
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

	
#crear el enemigo cada cierto tiempo 
func _on_timer_enemy_timeout() -> void:
	create_enemy()
	create_enemySinRespuesta()
