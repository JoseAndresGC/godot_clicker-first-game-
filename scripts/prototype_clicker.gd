class_name PrototypeClicker
extends Control
##Clicker Prototype: Creating the main button for create "coins" and updating label function for the coins

@export var label : Label

var coins : int = 0

##Function for start the scene with the value 0 in the label
func _ready():
	update_label_text()

##Function and SIGNAL for when the button is pressed create 1 coin calling the function "create_coins"
func _on_button_pressed():
	create_coins()

##Function for create 1 coin/s, calling too the function for update the label 
func create_coins():
	coins += 1
	update_label_text()

##Function for update label text entering in the text mention and mention the var coins
func update_label_text():
	label.text = "Coins: %s" %coins
