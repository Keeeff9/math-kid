extends CharacterBody2D
const SPEED = 250

var bullet_scene := preload("res://Scenes/bullet.tscn")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var conteo = 0

@onready var sprite =$mainPlayer

var animation_has_played = false


	
func _physics_process(delta: float) -> void:
	movimientopersonaje()
	disparo()
	
	
	move_and_slide()


func disparo():
	if Input.is_action_just_released("ui_accept"):
		var bullet = bullet_scene.instantiate() 
		bullet.global_position = self.global_position
		conteo +=1
		if conteo == 5:
			print("5 disparos")
			
	
	
		get_tree().root.add_child(bullet)
		
		
#funcion colisiones con objetos#
func _on_area_2d_body_entered(body: Node2D) -> void:	
	
	if body.is_in_group("Colisiones"):
		pass

	#funcion moverPersonaje
func movimientopersonaje():
	var direction1 := Input.get_axis("ui_left", "ui_right")
	
	# Si se está moviendo a la derecha
	if Input.is_action_pressed("ui_right"):
		animation.flip_h = false
		velocity.x = SPEED
		animation.play("move") 
	elif Input.is_action_pressed("ui_left"):
		animation.flip_h = true
		animation.play("move")
		velocity.x = -SPEED 
	#
	# Si no se está moviendo
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle") # Solo reproducir idle si no se está moviendo
