extends Node

signal change_life
signal change_score
signal change_operation

var score := 0
var lifes := 3
var correct_answer = 0
var incorret_answer = []
var operation := ""
#

func _ready() -> void:
	crearDosNumerosRandom()

func global_Resetlife():
	lifes = 3

func crearRandomOperation(num1:int,num2:int)-> void:
	operation = (str(num1) + " + " + str(num2))
	correct_answer = num1 + num2

func crearDosNumerosRandom()-> void:
	incorret_answer.clear()  # Reiniciar el array cada vez que generes nuevos números
	var numRandom = RandomNumberGenerator.new()
	var num1Random = numRandom.randi_range(-20,50)
	var num2Random = numRandom.randi_range(-20,50)
	while true:	
		if num1Random != num2Random and num1Random != correct_answer and num2Random != correct_answer:
			incorret_answer.append(num1Random)
			incorret_answer.append(num2Random)
			break
