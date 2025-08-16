# UI.gd
extends CanvasLayer

@onready var health_bar = $HealthBar

func _ready():
	# supondo que PlayerData esteja como autoload (singleton)
	player_data.connect("health_changed", Callable(self, "_on_health_changed"))

	# Inicializa a barra com a vida atual
	_on_health_changed(player_data.current_health, player_data.max_health)

func _on_health_changed(current: int, max: int) -> void:
	health_bar.max_value = max
	health_bar.value = current
