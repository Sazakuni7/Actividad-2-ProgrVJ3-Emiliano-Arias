extends Area2D

signal player_entered

func _ready() -> void:
	# Igual que las areas de la demo, se conecta body_entered por codigo.
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered.emit() #emitir señal de victoria si el jugador entra al area2d
