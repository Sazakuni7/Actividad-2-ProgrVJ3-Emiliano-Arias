
extends CharacterBody2D
class_name Player

signal im_dead

@export var WALK_FORCE := 900.0
@export var WALK_MAX_SPEED := 180.0
@export var STOP_FORCE := 1100.0
@export var PUSH_FORCE := 95.0
@export var TURN_SPEED := 12.0
@export var SHOOT_COOLDOWN := 0.22
@export var Bullet: PackedScene

var facing_direction := Vector2.RIGHT
var can_shoot := true

func _physics_process(delta):
	# Create forces. En esta actividad la fuerza puede venir de 8 direcciones.
	var accel := Vector2.ZERO
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_bottom") #se leen los cuatro inputs como un vector 2d
	var stop := true

	 # la diferencia con el demo es que con este input ya no estamos ligados a movernos a una sola direccion a la vez
	if input_direction != Vector2.ZERO:
		facing_direction = input_direction.normalized()
		accel = facing_direction * WALK_FORCE
		stop = false
		rotation = rotate_toward(rotation, facing_direction.angle(), TURN_SPEED * delta)

	# Resbalar al frenar para mejorar como se siente el movimiento, parecido a la demo.
	if stop:
		velocity = velocity.move_toward(Vector2.ZERO, STOP_FORCE * delta)

	# Integrar aceleracion a velocidad y limitar velocidad maxima.
	velocity += accel * delta
	velocity = velocity.limit_length(WALK_MAX_SPEED) #con esto no gana mas velocidad si nos movemos en diagonal

	# move_and_slide permite deslizar por paredes usando velocity.
	move_and_slide()
	push_dynamic_bodies()

	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func push_dynamic_bodies() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()

		if body is RigidBody2D:
			var impulse_position = collision.get_position() - body.global_position
			body.apply_impulse(-collision.get_normal() * PUSH_FORCE, impulse_position) #logica para empujar y girar la caja

func shoot() -> void:
	if Bullet == null:
		return

	can_shoot = false
	var bullet = Bullet.instantiate()
	bullet.global_position = global_position + facing_direction * 18.0
	bullet.set("direction", facing_direction)
	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(SHOOT_COOLDOWN).timeout
	can_shoot = true

func lose() -> void:
	# No intentar matarlo dos veces.
	if is_queued_for_deletion():
		return

	im_dead.emit()
