extends CharacterBody2D

@onready var data: PlayerData = $PlayerData
@onready var anim = $animations

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor = true
var landing_timer = 0.0
var attacking = false
var cursor_texture = load("res://assets/cursor/cursor_teste_2.png")

func _ready():
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	Input.set_custom_mouse_cursor(cursor_texture)

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")

	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto normal
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not attacking:
		velocity.y = data.jump_velocity

	# Super pulo
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and not attacking:
		velocity.y = data.big_jump_velocity

	# Abaixar
	if Input.is_action_just_pressed("ui_down") and not attacking:
		velocity.y = data.lower_force

	# Ataque
	if Input.is_action_just_pressed("click_esquerdo") and not attacking:
		attacking = true

		anim.flip_h = get_global_mouse_position().x < global_position.x
		anim.play("attack")
		return

	# Movimento horizontal
	if not attacking:
		if direction:
			velocity.x = direction * data.speed
			anim.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, data.speed)

	move_and_slide()

	# Animações
	if not attacking:
		if is_on_floor() and not was_on_floor:
			anim.play("jump_down")
			landing_timer = 0.2
		elif landing_timer > 0:
			landing_timer -= delta
		else:
			decide_animation(direction)

	was_on_floor = is_on_floor()

func decide_animation(direction):
	if is_on_floor():
		if direction != 0:
			anim.play("run")
		else:
			anim.play("idle")
	else:
		if velocity.y < 0:
			anim.play("jump_up")
		else:
			anim.play("falling")

func _on_animation_finished():
	if anim.animation == "attack":
		attacking = false
