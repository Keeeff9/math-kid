extends CharacterBody2D

const SPEED = 810

var bullet_scene := load("res://Scenes/bullet.tscn")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var conteo = 0

# Variable para saber si la animación está activa
var is_moving = false


func _physics_process(delta: float) -> void:
	movimientopersonaje()
	disparo()
	
	move_and_slide()

func disparo():
	if Input.is_action_just_released("ui_accept"):
		var bullet = bullet_scene.instantiate() 
		bullet.global_position = self.global_position
		conteo += 1
		if conteo == 5:
			print("5 disparos")
		get_tree().root.add_child(bullet)

# Función colisiones con objetos
func _on_area_2d_body_entered(body: Node2D) -> void:	
	if body.is_in_group("Colisiones"):
		pass

# Función moverPersonaje
func movimientopersonaje():
	var direction1 := Input.get_axis("ui_left", "ui_right")

	# Si se está moviendo a la derecha
	if Input.is_action_pressed("ui_right"):
		animation.flip_h = false
		velocity.x = SPEED 
		if not is_moving: # Reproducir solo si no estaba en movimiento
			animation.play("move")
			is_moving = true

	# Si se está moviendo a la izquierda
	elif Input.is_action_pressed("ui_left"):
		animation.flip_h = true
		velocity.x = -SPEED 
		if not is_moving: # Reproducir solo si no estaba en movimiento
			animation.play("move")
			is_moving = true

	# Si no se está moviendo
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_moving: # Volver a idle si estaba en movimiento
			animation.play("idle") 
			is_moving = false
