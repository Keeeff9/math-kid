extends Control
@onready var song: AudioStreamPlayer = $song

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.visible = false
	$Planet.visible = false
	$Title.visible = false
	$Restart.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tab_pause"):
		pausa()
	
func pausa(): 
	var is_paused = not get_tree().paused
	get_tree().paused  = is_paused
	$Background.visible = is_paused
	$Planet.visible = is_paused
	$Title.visible = is_paused
	$Restart.visible = is_paused




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Reiniciar"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
