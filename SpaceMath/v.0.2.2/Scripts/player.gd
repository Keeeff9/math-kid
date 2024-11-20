extends CharacterBody2D

const SPEED = 500

var bullet_scene: PackedScene = load("res://Scenes/bullet.tscn")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var shield_animation: AnimatedSprite2D = $shield
@onready var shoot: AudioStreamPlayer = $Shoot
@onready var shield_sound: AudioStreamPlayer = $Shield
@onready var parent_node := get_parent() # Para gestionar correctamente las balas

@onready var shoot_timer: Timer = $ShootTimer
var shoot_can =	true
var conteo: int = 0
var is_moving: bool = false  # Si el jugador está en movimiento

func _ready() -> void:
	# Asegurarnos de que el escudo está inicialmente oculto
	shield_animation.visible = false

func _physics_process(delta: float) -> void:
	movimientopersonaje(delta)
	if Input.is_action_just_pressed("ui_accept") and shoot_can:
		shoot.play()
		disparo()

	move_and_slide()  # Movimiento del personaje

	# Detectar colisiones con otros cuerpos
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		_on_body_collided(collision.get_collider())

# Función para disparar balas
func disparo() -> void:
	shoot_can =false
	shoot_timer.start()
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position  # Posición del jugador
	parent_node.add_child(bullet)  # Se añade al nodo padre (más seguro que al root)
	
	conteo += 1
	if conteo % 5 == 0:  # Mensaje cada 5 disparos
		print("5 shoots")

# Función para gestionar el movimiento del personaje
func movimientopersonaje(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")  # Valor entre -1 y 1
	velocity.x = direction * SPEED 

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

# Detecta colisiones con otros cuerpos
func _on_body_collided(collider: Node) -> void:
	if collider.is_in_group("enemy"): 
		print("Collision with:", collider.name)
		await activar_escudo()

# Función para activar el escudo y reproducir sonido
func activar_escudo() -> void:
	shield_animation.visible = true  # Mostrar el escudo
	shield_animation.play("activate")  # Cambia a la animación de activación (ajusta el nombre si es diferente)
	shield_sound.play()  # Reproducir el sonido del escudo
	await get_tree().create_timer(shield_sound.stream.get_length()).timeout  # Esperar a que termine la animación
	shield_animation.visible = false  # Ocultar el escudo después de la animación

#Funcoin del temporizador, conectandola al nodo
func _on_shoot_timer_timeout() -> void:
	shoot_can = true
