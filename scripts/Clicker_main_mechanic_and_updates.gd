extends Node2D

var cookie_count = 0
var cookies_por_segundo = 0

var mejoras = {
	"mejora1": {
		"precio": 10,
		"bonificacion": 1,
		"comprada": 0
	}
}

@onready var label_cookies = $Label
@onready var boton_cookie = $Button

func _ready():
	label_cookies.text = str(cookie_count)

func _process(delta):
	cookie_count += cookies_por_segundo * delta
	label_cookies.text = str(cookie_count)

func _on_button_pressed() -> void:
	cookie_count += 1
	label_cookies.text = str(cookie_count)

func comprar_mejora(nombre_mejora):
	var mejora = mejoras[nombre_mejora]
	if cookie_count >= mejora.precio:
		cookie_count -= mejora.precio
		mejora.comprada += 1
		cookies_por_segundo += mejora.bonificacion * mejora.comprada
		mejora.precio *= 2
		print("Mejora comprada!")
	else:
		print("No tienes suficientes galletas.")

func _on_button_2_pressed() -> void:
	comprar_mejora("mejora1")