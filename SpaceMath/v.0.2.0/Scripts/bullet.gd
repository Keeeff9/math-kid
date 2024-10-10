extends Area2D
var speed := 500
@onready var bullet: Area2D = $"."



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position.y -= speed * delta
	

#Funcion para que desaparezca de la escena el disparo
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()



#func _on_body_entered(body: Node2D) -> void:
	#print(body.name == "enemy")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		GlobalVariables.score += 1 
		GlobalVariables.emit_signal("change_score")		#Estas deben pasar luego cuando disare y sea correcta
		area.queue_free()
		bullet.queue_free() 
		var numR = RandomNumberGenerator.new()
		var num1 = numR.randi_range(1, 10)
		var num2 = numR.randi_range(1, 10)
		GlobalVariables.crearRandomOperation(num1, num2)
		GlobalVariables.emit_signal("change_operation")
		print(GlobalVariables.operation)
