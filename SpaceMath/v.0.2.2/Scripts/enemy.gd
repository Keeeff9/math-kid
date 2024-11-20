# ASTEROIDES
extends Area2D

var choque_enemy := false
var gravityy: Vector2 = Vector2(0, 65)
var velocity: Vector2 = Vector2.ZERO
@onready var enemy_animation: AnimatedSprite2D = $Sprite2D
@onready var respuesta: Label = $Respuesta
var numeroRandom = 0
var graviti_incremented = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity += gravityy * delta
	position += velocity * delta

func play_destruction_animation(correct: bool) -> void:
	if correct:
		enemy_animation.play("succes")  # Reproducir animación de acierto
	else:
		enemy_animation.play("fail")  # Reproducir animación de error

	# Esperar a que la animación termine antes de eliminar el nodo
	await get_tree().create_timer(enemy_animation.animation_length).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_group"):
		choque_enemy = true
		GlobalVariables.lifes -= 1
		GlobalVariables.emit_signal("change_life")
		if GlobalVariables.lifes <= 0:
			call_deferred("CambiarMenu")
		queue_free()

func CambiarMenu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Función para que desaparezcan los enemigos de la pantalla
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if GlobalVariables.enemigos_escena > 0:
		GlobalVariables.enemigos_escena -= 1
		if GlobalVariables.enemigos_escena == 1:
			GlobalVariables.lifes -= 1
			GlobalVariables.emit_signal("change_life")
			if GlobalVariables.lifes <= 0:
				call_deferred("CambiarMenu")
	queue_free()  # Elimina el nodo del árbol
