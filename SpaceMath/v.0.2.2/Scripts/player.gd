extends CharacterBody2D

const SPEED = 500

var bullet_scene: PackedScene = load("res://Scenes/bullet.tscn")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var parent_node := get_parent() # Para gestionar correctamente las balas

var conteo: int = 0
var is_moving: bool = false  # Si el jugador está en movimiento

func _physics_process(delta: float) -> void:
	movimientopersonaje(delta)
	if Input.is_action_just_pressed("ui_accept"):
		disparo()

	move_and_slide()  # Movimiento del personaje

# Función para disparar balas
func disparo() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position  # Posición del jugador
	parent_node.add_child(bullet)  # Se añade al nodo padre (más seguro que al root)
	
	conteo += 1
	if conteo % 5 == 0:  # Mensaje cada 5 disparos
		print("5 shoots")

# Función para gestionar el movimiento del personaje
func movimientopersonaje(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")  # Valor entre -1 y 1
	velocity.x = direction * SPEED  # Aplicamos velocidad directamente

	if direction != 0:
		actualizar_animacion(true, direction < 0)  # Movimiento activo
	else:
		actualizar_animacion(false)  # Estado idle

# Función auxiliar para actualizar las animaciones
func actualizar_animacion(moving: bool, flip: bool = false) -> void:
	if moving:
		animation.flip_h = flip
		if not is_moving:
			animation.play("move")  # Reproducir animación de movimiento
			is_moving = true
	else:
		if is_moving:
			animation.play("idle")  # Volver a la animación idle
			is_moving = false

# Detecta colisiones con objetos en el grupo "Colisiones"
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Colisiones"):
		print("Collision with:", body.name)
