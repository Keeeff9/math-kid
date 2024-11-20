# ASTEROIDES
extends Area2D

var choque_enemy := false
var gravityy: Vector2 = Vector2(0, 70)
var velocity: Vector2 = Vector2.ZERO
@onready var enemy_animation: AnimatedSprite2D = $Animations
@onready var respuesta: Label = $Respuesta
var numeroRandom = 0
var graviti_incremented = false
@onready var collisionEnemy: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# Obtiene todos los hijos directos del nodo
	var hijos = get_children()
	
	# Itera sobre los hijos y realiza acciones con cada uno
	for hijo in hijos:
		if hijo.name == "Animations":
			enemy_animation = hijo

func _physics_process(delta: float) -> void:
	velocity += gravityy * delta
	position += velocity * delta

func play_destruction_animation(correct: bool) -> void:
	if correct:
		enemy_animation.play("succes")  # Reproducir animación de acierto
	else:
		enemy_animation.play("fail")  # Reproducir animación de error
	
	# Esperar a que la animación termine antes de eliminar el nodo
	# Asegúrate de que enemy_animation esté definido y tenga una propiedad animation_length
	if enemy_animation and enemy_animation.has_method("animation_length"):
		var animation_length = enemy_animation.animation_length
		if typeof(animation_length) == TYPE_FLOAT:
			await get_tree().create_timer(animation_length).timeout
		else:
			print("Error: animation_length no es un valor numérico.")
	else:
		print("Error: enemy_animation no está definido o no tiene una propiedad animation_length.")
	#queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		choque_enemy = true
		GlobalVariables.lifes -= 1
		GlobalVariables.emit_signal("change_life")
		if GlobalVariables.lifes <= 0:
			call_deferred("CambiarMenu")
		#queue_free()
		
		play_destruction_animation(false)
		body.get_node("Shield").play()
		body.activar_escudo()

func CambiarMenu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Función para que desaparezcan los enemigos de la pantalla
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if GlobalVariables.enemigos_escena > 0:
		GlobalVariables.enemigos_escena -= 1
		if GlobalVariables.enemigos_escena == 1:
			GlobalVariables.lifes -= 1
			play_destruction_animation(false)
			GlobalVariables.emit_signal("change_life")
			if GlobalVariables.lifes <= 0:
				call_deferred("CambiarMenu")
	#queue_free()  # Elimina el nodo del árbol
