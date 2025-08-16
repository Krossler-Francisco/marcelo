extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor = true
var landing_timer = 0.0
var attacking = false

func _ready():
	$animations.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not attacking:
		velocity.y = JUMP_VELOCITY

	# Ataque (solo una vez)
	if Input.is_action_just_pressed("ui_attack") and not attacking:
		attacking = true
		velocity.x = 0
		$animations.play("attack")
		return

	# Movimiento horizontal y rotación
	if not attacking:
		if direction:
			velocity.x = direction * SPEED
			$animations.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Animaciones solo si no está atacando
	if not attacking:
		if is_on_floor() and not was_on_floor:
			$animations.play("jump_down")
			landing_timer = 0.2
		elif landing_timer > 0:
			landing_timer -= delta
		else:
			decide_animation(direction)

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

func _on_animation_finished():
	# Liberar ataque solo si la animación terminada es "attack"
	if $animations.animation == "attack":
		attacking = false
