#ASTEROIDES
extends Area2D
var choque_enemy  := false
var gravityy: Vector2 = Vector2(0, 45)
var velocity: Vector2 = Vector2.ZERO
@onready var respuesta: Label = $Respuesta
var numeroRandom = 0
var graviti_incremented =false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity += gravityy * delta
	position += velocity * delta

	

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
	queue_free()
	

		
			
