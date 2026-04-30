extends CharacterBody2D

signal defeated

# Parametros expuestos al editor.
@export var PATROL_SPEED := 75.0
@export var CHASE_SPEED := 125.0
@export var WALK_FORCE := 600.0
@export var PUSH_FORCE := 70.0
@export var TURN_SPEED := 10.0
@export var DETECTION_RADIUS := 150.0
@export var Corpse: PackedScene
@export var patrol_points: Array[Vector2] = [Vector2(520, 240), Vector2(800, 240), Vector2(800, 420), Vector2(520, 420)]

var _target_index := 0
var _player: Node2D
var _dead := false

func _ready() -> void:
	_player = get_tree().current_scene.get_node_or_null("player")

func _physics_process(delta: float) -> void:
	if _dead:
		return

	var desired_direction := _get_desired_direction()
	var desired_speed := CHASE_SPEED if _is_player_close() else PATROL_SPEED #si el jugador esta cerca, velocidad de persecucion, si no, velocidad de patrulla

	if desired_direction != Vector2.ZERO:
		rotation = rotate_toward(rotation, desired_direction.angle(), TURN_SPEED * delta)

	velocity = velocity.move_toward(desired_direction * desired_speed, WALK_FORCE * delta)
	move_and_slide()
	push_dynamic_bodies()

func hit() -> void:
	if _dead:
		return

	_dead = true
	defeated.emit()
	_spawn_corpse()
	queue_free()

func _get_desired_direction() -> Vector2:
	if _is_player_close():
		return global_position.direction_to(_player.global_position) #logica de persecución

	var target := patrol_points[_target_index]
	if global_position.distance_to(target) < 12.0:
		_target_index = (_target_index + 1) % patrol_points.size()
		target = patrol_points[_target_index]

	return global_position.direction_to(target)

func _is_player_close() -> bool:
	return _player != null and global_position.distance_to(_player.global_position) <= DETECTION_RADIUS

func push_dynamic_bodies() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()

		if body is RigidBody2D:
			var impulse_position = collision.get_position() - body.global_position
			body.apply_impulse(-collision.get_normal() * PUSH_FORCE, impulse_position)

func _spawn_corpse() -> void:
	if Corpse == null:
		return

	var corpse = Corpse.instantiate()
	corpse.global_position = global_position
	corpse.global_rotation = global_rotation
	get_tree().current_scene.call_deferred("add_child", corpse)

func _on_hit_area_body_entered(body: Node2D) -> void:
	if _dead:
		return

	if body.is_in_group("player") and body.has_method("lose"):
		body.lose() #cuando toca al jugador, perder
