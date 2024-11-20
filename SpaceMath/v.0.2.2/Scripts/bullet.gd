extends Area2D
var speed := 400
@onready var bullet: Area2D = $"."
@onready var animated_sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var success: AudioStreamPlayer = $Succes
@onready var fail: AudioStreamPlayer = $Fail
@onready var collisionBullet: CollisionShape2D = $CollisionShape2D

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
		animated_sprite.hide()
		
		var enemyLabel = area_enemy.get_node("Respuesta").text.strip_edges().to_int()
		if(enemyLabel == GlobalVariables.correct_answer):
			print("Le dio al que era")
			success.play()
			GlobalVariables.score += 10
			GlobalVariables.emit_signal("change_score")
			
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				if enemy.has_node("CollisionShape2D"):
					enemy.get_node("CollisionShape2D").queue_free()
				else:
					print("Error: 'CollisionShape2D' no encontrado en 'enemy'.")
				
				if enemy.has_node("Animations"):
					var animation_player = enemy.get_node("Animations") as AnimatedSprite2D
					if animation_player is AnimatedSprite2D:
						animation_player.play("succes")
					else:
						print("Error: El nodo 'Animations' no es un AnimationPlayer.")
				else:
					print("Error: 'Animations' no encontrado en 'enemy'.")
			await get_tree().create_timer(success.stream.get_length()).timeout
			for enemy in enemies:
				if enemy != null:
					enemy.queue_free()
			bullet.queue_free()
			var numR = RandomNumberGenerator.new()
			var num1 = numR.randi_range(1, 6)
			var num2 = numR.randi_range(1, 6)
			GlobalVariables.crearRandomOperation(num1,num2)
			GlobalVariables.crearDosNumerosRandom()
			GlobalVariables.emit_signal("change_operation")
		else:
			if area_enemy.has_node("CollisionShape2D"):
				area_enemy.get_node("CollisionShape2D").queue_free()
			
			if GlobalVariables.score > 0:
				print("Todavia tiene puntos")
				GlobalVariables.score -= 5
			else:
				GlobalVariables.lifes -= 1
				GlobalVariables.emit_signal("change_life")
				if GlobalVariables.lifes == 0:
					call_deferred("CambiarMenu")
			
			GlobalVariables.emit_signal("change_score")
			fail.play()
			area_enemy.get_node("Animations").play("fail")
			await get_tree().create_timer(fail.stream.get_length()).timeout
			bullet.queue_free()
			area_enemy.queue_free()
			
func CambiarMenu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
