extends Control

@onready var title: Label = $VBoxContainer/Title
@onready var description: Label = $VBoxContainer/Description
@onready var description_reiniciar: Label = $DescriptionReiniciar
@onready var start_button: Button = $HBoxContainer/StartButton
@onready var user_name: Label = $DataBase/UserNamePlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	description_reiniciar.text = ""
	if(GlobalVariables.lifes == 0):
		lifeCero_Gameover()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Boton Salir
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	print("played")

#Boton Comenzar 
func _on_start_button_pressed() -> void:
	GlobalVariables.global_Resetlife()
	get_tree().change_scene_to_file("res://Main_World/move_tutorial2.tscn")
	print("Game started")
	
func lifeCero_Gameover():
	var dataBase = $DataBase
	if dataBase:
		dataBase.save_data()
	else:
		print("Error: No se encontró el nodo DataBase")

	user_name.text = GlobalVariables.userName
	start_button.text = "Reiniciar"
	title.text = "Game Over"
	description.text = "¡Sigue intentado!"
	description_reiniciar.text = "Realizaste: "+ str(GlobalVariables.score) +" Puntos!!"
	if (GlobalVariables.score > 1):
		description_reiniciar.text += "\nVas por buen camino!!!!!!"
