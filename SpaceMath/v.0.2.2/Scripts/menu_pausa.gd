extends Control
@onready var song: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.visible = false
	$Planet.visible = false
	$Title.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tab_pause"):
		get_tree().paused  = not get_tree().paused
		var is_paused = get_tree().paused
		$Background.visible = is_paused
		$Planet.visible = is_paused
		$Title.visible = is_paused

		
