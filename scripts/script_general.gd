extends Control

## variables/diccionarios

var score = 0 ## score principal
var score_secundario = 0 ## indica los puntos por segundo
var scoreAutomaticoPorSec = 0
var regulador ## por si hay que bajarle el tiempo de actualizacion del frame a delta
var multiplicador = 1

var mejoras = {
	'Mejora1' : {'costo': 15, 'incremento': 0.1},
	'Mejora2' : {'costo': 100, 'incremento': 1},
	'Mejora3' : {'costo': 1000, 'incremento': 8},
}

var logros = {
	'Primer Click!' : false,
	'100 Clicks!' : false,
	'1000 Clicks!' : false
}

var mejDeLasMejoras = { ## copiando las mejoras secundarias del cookie clicker, pero cutre (????
	'MejoraDelClick1' : {'costo_mej_click': 100, 'multiplicador': multiplicador * 2},
	'MejoraDelClick2' : {'costo_mej_click': 500, 'multiplicador': multiplicador * 2},
	'Mejora3' : {}, ## sin nombre o efecto aún <EN DESARROLLO>
}

@onready var ventana_emergente_mej_sec_1: Label = $BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1/Ventana_Emergente_mej_Sec1
@onready var ventana_emergente_mej_sec_2: Label = $BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2/Ventana_Emergente_mej_Sec2

var ventanasEmergentesTextos = {
	'MejSecundaria1' : ventana_emergente_mej_sec_1,
	'MejSecundaria2' : ventana_emergente_mej_sec_2,
}

## resto del codigo.....

func _ready() -> void:
	$ZonaPrincipalJugable/LabelPrincipalDePuntos.text = 'PUNTOS: ' + str(score)
	$ZonaPrincipalJugable/LabelPrincipalPuntosDecimales.text = 'por segundo: ' + str(score_secundario)
	##para que funcione mirar la info de la mejora 1
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1.visible = false 
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1/Ventana_Emergente_mej_Sec1.visible = false
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1.connect("mouse_entered", Callable(self, "ventanaEmergenteMej_sec1_mouseIn"))
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1.connect("mouse_exited", Callable(self, "ventanaEmergenteMej_sec1_mouseOut"))
	##para que funcione mirar la info de la mejora 2
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2.visible = false
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2/Ventana_Emergente_mej_Sec2.visible = false
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2.connect("mouse_entered", Callable(self, "ventanaEmergenteMej_sec2_mouseIn"))
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2.connect("mouse_exited", Callable(self, "ventanaEmergenteMej_sec2_mouseOut"))
	costo_en_label_mej_sec()
	costo_en_boton_act()
	check_logros1()
	check_logros2()
	check_logros3()

func _process(delta: float) -> void:
	score += scoreAutomaticoPorSec * delta
	$ZonaPrincipalJugable/LabelPrincipalDePuntos.text = 'PUNTOS: ' + str(int(score)) ## Actualizar el label principal con el score redondeado, osea sin 4 millones de decimales 
	actualizarEstadoDeLogro1()
	actualizarEstadoDeLogro2()
	actualizarEstadoDeLogro3()
	check_logros1()
	check_logros2()
	check_logros3()

func _on_boton_principal_clicker_pressed() -> void:
	score += multiplicador
	$ZonaPrincipalJugable/LabelPrincipalDePuntos.text = 'PUNTOS: ' + str(score)

func _on_boton_mejora_1_pressed() -> void:
	comprar_mejora('Mejora1') ##funcion para comprar las mejoras

func _on_boton_mejora_2_pressed() -> void:
	comprar_mejora('Mejora2') 

func _on_boton_mejora_3_pressed() -> void:
	comprar_mejora('Mejora3')

func comprar_mejora(nombre_mejora: String):
	var mejora = mejoras[nombre_mejora]
	if score >= mejora['costo']:
		score -= mejora['costo']
		scoreAutomaticoPorSec += mejora['incremento']
		score_secundario += mejora['incremento'] ## si una mejora es comprada, almacena el valor que aumente esa mejora en la variable score_secundario
		$ZonaPrincipalJugable/LabelPrincipalPuntosDecimales.text = 'por segundo: ' + str(score_secundario)
		mejora['costo'] *= 2 ## esta linea incrementa el valor de la mejora por cada compra
		costo_en_boton_act() ## funcion que actualiza el label principal con el incremento de las mejoras
		print('mejora comprada') ## se imprime en la consola, deberia de mostrarse en el juego en prox actualizacion 
	else:
		print('No tenei plata papu') ## se imprime en la consola, deberia de mostrarse en el juego en prox actualizacion 

func costo_en_boton_act(): ## permite ver en tiempo real el costo actual de las mejoras
	$BoxContainerUpdates/VBoxContainerUpdate1/Boton_Mejora1.text = 'MEJORA 1 COSTO: ' + str(mejoras['Mejora1']['costo'])
	$BoxContainerUpdates/VBoxContainerUpdate2/Boton_Mejora2.text = 'MEJORA 2 COSTO: ' + str(mejoras['Mejora2']['costo'])
	$BoxContainerUpdates/VBoxContainerUpdate3/Boton_Mejora3.text = 'MEJORA 3 COSTO: ' + str(mejoras['Mejora3']['costo'])

func costo_en_label_mej_sec(): ## permite ver en tiempo real el costo actual de las mejoras secundarias
	## info mejora secundaria 1
	ventana_emergente_mej_sec_1.text = 'El raton es el doble de eficaz
	
	Costo: ' + str(mejDeLasMejoras['MejoraDelClick1']['costo_mej_click'])
	## info mejora secundaria 2
	ventana_emergente_mej_sec_2.text = 'El raton es el doble de eficaz
	
	Costo: ' + str(mejDeLasMejoras['MejoraDelClick2']['costo_mej_click'])

func _on_boton_mej_secundaria_1_pressed() -> void: 
	compra_mejoras_secundaria('MejoraDelClick1')

func _on_boton_mej_secundaria_2_pressed() -> void:
	compra_mejoras_secundaria('MejoraDelClick2')

func compra_mejoras_secundaria(nombre_mej_mejora: String): ## en desarrollo
	var mej_mejora = mejDeLasMejoras[nombre_mej_mejora]
	if score >= mej_mejora['costo_mej_click']:
		score -= mej_mejora['costo_mej_click']
		multiplicador *= mej_mejora['multiplicador']
		print('mejora secundaria comprada')
	elif score < mej_mejora['costo_mej_click']: ## si no hay suficiente score, los botones se deben desactivar <EN DESARROLLO>
		$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1.disabled = true
		print('no tenei plata para la mejora secundaria papuardo')

func check_logros1():
	if score >= 1 and not logros['Primer Click!']:
		logros['Primer Click!'] = true
		$HBoxContainer/Label_Logros_Padre/Logros_label.text += '\nPrimer Click conseguido!'
		actualizarEstadoDeLogro1()

func check_logros2():
	if score >= 100 and not logros['100 Clicks!']:
		logros['100 Clicks!'] = true
		$HBoxContainer/Label_Logros_Padre/Logros_label2.text += '\n100 Clicks conseguidos!' 
		actualizarEstadoDeLogro2()

func check_logros3():
	if score >= 1000 and not logros['1000 Clicks!']:
		logros['1000 Clicks!'] = true
		$HBoxContainer/Label_Logros_Padre/Logros_label3.text += '\n1000 Clicks conseguidos!'
		actualizarEstadoDeLogro3() 

func actualizarEstadoDeLogro1(): ## Si cuando un logro aparece en pantalla, el proximo punto añadido en score desaparece el aviso del logro
	if score > 1 and logros['Primer Click!'] == true: ## cuando se cumple la meta del logro inmediatamente se oculta
		$HBoxContainer/Label_Logros_Padre/Logros_label.visible = false

func actualizarEstadoDeLogro2():
	if score > 100 and logros['100 Clicks!'] == true:
		$HBoxContainer/Label_Logros_Padre/Logros_label2.visible = false

func actualizarEstadoDeLogro3():
	if score > 1000 and logros['1000 Clicks!'] == true:
		$HBoxContainer/Label_Logros_Padre/Logros_label3.visible = false

func ventanaEmergenteMej_sec1_mouseIn():
	## primera mejora
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1.visible = true
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1/Ventana_Emergente_mej_Sec1.visible = true

func ventanaEmergenteMej_sec1_mouseOut():
	## primera mejora
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1.visible = false
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria1/Panel_De_Pantalla_Emergente_meg_Sec1.visible = false

func ventanaEmergenteMej_sec2_mouseIn():
	## segunda mejora
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2.visible = true
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2/Ventana_Emergente_mej_Sec2.visible = true

func ventanaEmergenteMej_sec2_mouseOut():
	## segunda mejora
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2.visible = false
	$BoxContainerUpdates/HBoxContainer/Boton_mej_Secundaria2/Panel_De_Pantalla_Emergente_meg_Sec2.visible = false
