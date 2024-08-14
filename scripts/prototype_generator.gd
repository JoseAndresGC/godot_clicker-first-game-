class_name Prototype_Generator
extends Control
## Prototype of passive generator of coins for clicker

## export the label 
@export var label : Label

## export the main button
@export var button : Button

## export the timer that will be generate the coins
@export var timer : Timer

## our coins variable
var coins : int = 0

## 
func _ready():
	update_label_text()

## our function for create coins and ref for update the label with every coin created
func create_coins():
	coins += 1
	update_label_text()

## our function for update and modify the label
func update_label_text():
	label.text = "Coins: %s" %coins

## our function for begin generating coins when the time start and when the button is used it will be dissable
func begin_generating_coins():
	timer.start()
	button.disabled = true

## signal node of the main button with a ref of the timer function
func _on_button_pressed():
	begin_generating_coins()

## signal node of the timer with a ref of the function for create coins when the timer is on
func _on_timer_timeout():
	create_coins()
