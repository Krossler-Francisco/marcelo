# PlayerData.gd
extends Node
class_name PlayerData

# --- Atributos base ---
@export var speed: float = 350.0
@export var jump_velocity: float = -400.0
@export var big_jump_velocity: float = -560.0
@export var lower_force: float = 500.0

# --- Status do jogador ---
signal health_changed(current, max)

@export var max_health: int = 100
var current_health: int = 30

# --- Métodos de vida ---
func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health, max_health)

func reset_health() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)
