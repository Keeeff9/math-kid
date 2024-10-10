extends Node

signal change_life
signal change_score
signal change_operation

var score := 0
var lifes := 3
var operation := ""
#
func global_Resetlife():
	lifes = 3

func crearRandomOperation(num1:int,num2:int)-> String:
	operation = ("Operation: "+str(num1) + " + " + str(num2))
	return operation
