extends CanvasLayer

@onready var life_label_count: Label = $Control/Label_Lifes/LifeLabelCount
@onready var score_label: Label = $Control/MarginContainer/VBoxContainer_Score/ScoreLabel
@onready var question_label: Label = $Control/MarginContainer/VBoxContainer_Question/QuestionLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_text_life()
	GlobalVariables.change_life.connect(change_text_life)
	GlobalVariables.change_score.connect(change_text_score)
	GlobalVariables.change_operation.connect(change_operation)
	var numRandomInicializar = RandomNumberGenerator.new()
	var num1Ini = numRandomInicializar.randi_range(0,10)
	var num2Ini = numRandomInicializar.randi_range(0,10)
	GlobalVariables.crearRandomOperation(num1Ini, num2Ini) #inicar con valores random
	change_operation()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_text_life():
	life_label_count.text  = str(GlobalVariables.lifes)
func change_text_score():
	score_label.text = "Score: "+ str(GlobalVariables.score)
func change_operation():
	question_label.text = GlobalVariables.operation
	
