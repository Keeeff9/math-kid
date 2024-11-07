extends Area2D
var speed := 300
@onready var bullet: Area2D = $"."
@onready var animated_sprite: AnimatedSprite2D =  $AnimatedSprite2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle") 
	

func _process(delta: float) -> void:
	position.y -= speed * delta
	

#Funcion para que desaparezca de la escena el disparo
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()




func _on_area_entered(area_enemy: Area2D) -> void:
	if area_enemy.is_in_group("enemy"):
		var enemyLabel = area_enemy.get_node("Respuesta").text.strip_edges().to_int()

		if(enemyLabel == GlobalVariables.correct_answer):
			print("Le dio al que era")
			GlobalVariables.score += 1 
			GlobalVariables.emit_signal("change_score")	 
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				enemy.queue_free()	
			bullet.queue_free() 
			var numR = RandomNumberGenerator.new()
			var num1 = numR.randi_range(1, 10)
			var num2 = numR.randi_range(1, 10)
			GlobalVariables.crearRandomOperation(num1,num2)
			GlobalVariables.crearDosNumerosRandom()
			GlobalVariables.emit_signal("change_operation")
		else:
			bullet.queue_free()
			area_enemy.queue_free() 
			

	

		
			
