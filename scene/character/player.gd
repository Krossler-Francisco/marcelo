extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor = true
var landing_timer = 0.0  # tiempo que dura jump_down
var attacking = false    # estado de ataque

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Ataque
	if Input.is_action_just_pressed("ui_attack") and not attacking:
		attacking = true
		$animations.play("attack")
		# Cuando termine la animación, volvemos al control normal
		$animations.connect("animation_finished", Callable(self, "_on_attack_finished"), CONNECT_ONE_SHOT)
		return  # no procesar más este frame para que ataque tenga prioridad

	# Movimiento horizontal y rotación
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$animations.flip_h = false
		elif direction < 0:
			$animations.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Detectar aterrizaje
	if is_on_floor() and not was_on_floor:
		$animations.play("jump_down")
		landing_timer = 0.2  # duración en segundos antes de cambiar de animación

	# Controlar animaciones
	if landing_timer > 0:
		landing_timer -= delta
	else:
		decide_animation(direction)

	# Guardar estado
	was_on_floor = is_on_floor()

func decide_animation(direction):
	if is_on_floor():
		if direction != 0:
			$animations.play("run")
		else:
			$animations.play("idle")
	else:
		if velocity.y < 0:
			$animations.play("jump_up")
		else:
			$animations.play("falling")

func _on_attack_finished(anim_name):
	if anim_name == "attack":
		attacking = false
