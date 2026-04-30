extends AnimatableBody2D

@export var travel := Vector2(0, 160)
@export var speed := 80.0

var _origin := Vector2.ZERO
var _direction := 1.0

func _ready() -> void:
	_origin = global_position

func _physics_process(delta: float) -> void:
	var target := _origin + travel * _direction
	global_position = global_position.move_toward(target, speed * delta) #mover de posicion inicial a posicion destino

	if global_position.distance_to(target) < 2.0:
		_direction *= -1.0 #invertir dirección al llegar
