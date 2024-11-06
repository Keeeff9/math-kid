#ASTEROIDES
extends Area2D
var choque_enemy  := false
var gravityy: Vector2 = Vector2(0, 40)
var velocity: Vector2 = Vector2.ZERO
@onready var respuesta: Label = $Respuesta
var numeroRandom = 0

func _ready() -> void:
	#crearnumrandom()
	pass

func _physics_process(delta: float) -> void:
	velocity += gravityy * delta
	position += velocity * delta
	#masrapidoasteroides()
	

# esta funcion tengo que ponerla en jugador para que cuando choque le baje vida 
func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("player_group")):
		choque_enemy == true 
		GlobalVariables.lifes -=1
		GlobalVariables.emit_signal("change_life")
		if(GlobalVariables.lifes <= 0):
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		print("End")
		queue_free()


#Funcion para que desaparezca los enemigos de la pantalla
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	#GlobalVariables.lifes -=1
	#GlobalVariables.emit_signal("change_life")		
	#if(GlobalVariables.lifes <= 0):
		#get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	#print("Salio de la pantalla")
	queue_free()
	#
#func masrapidoasteroides():
	#if(GlobalVariables.score == 3):
		#gravityy += Vector2(0, 0.2)
		#print("Aumento la gravedad")
		#
		
			
#funciones del label
#func crearnumrandom():
	#numeroRandom = RandomNumberGenerator.new()
	#var num1 = numeroRandom.randi_range(1,10)
	#var num2 = numeroRandom.randi_range(1,10)
	#var respuestaRandom = num1 + num2
	#respuesta.text = str(num1," + ",num2)
	#print("La respuesta es:", respuestaRandom)
