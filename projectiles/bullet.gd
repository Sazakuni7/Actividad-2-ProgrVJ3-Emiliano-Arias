extends Area2D

@export var speed := 420.0
@export var lifetime := 1.2

var direction := Vector2.RIGHT

func _ready() -> void:
	# Area2D avisa cuando toca un cuerpo, mismo patron que spike.gd en la demo.
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"): # si toca algo que tiene metodo hit() lo llama
		body.hit()

	queue_free()
