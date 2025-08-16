extends Node2D

	
func _ready():
	# Pega o centro da tela no momento em que a cena foi iniciada
	var center = get_viewport().get_visible_rect().size / 2
	# Manda o mouse real pro meio da tela
	Input.warp_mouse(center)

	# Se você também quiser que o cursor custom (Node2D) vá pro meio
	position = center
