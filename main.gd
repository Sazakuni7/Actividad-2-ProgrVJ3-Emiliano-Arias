extends Node2D
# Escena principal del nivel, administra condiciones del juego.

@onready var player: Player = $player
@onready var camera: Camera2D = $Camera2D
@onready var hud_label: Label = $CanvasLayer/HUDLabel
@onready var message_label: Label = $CanvasLayer/MessageLabel

var _game_finished := false
var enemies_alive := 0

func _ready() -> void: #Conectar señales, cuando el jugador muere, perder y cuando llega al area verde con el enemigo derrotado, ganar
	player.im_dead.connect(_on_player_dead) 
	$GoalArea.player_entered.connect(_on_goal_reached)

	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies_alive = enemies.size()
	for enemy in enemies:
		enemy.defeated.connect(_on_enemy_defeated)

	_update_hud()

func _process(_delta: float) -> void:
	camera.global_position = player.global_position

	if Input.is_key_pressed(KEY_R):
		get_tree().paused = false
		get_tree().reload_current_scene()

#Condiciones de juego
func _on_player_dead() -> void:
	_finish_game("Perdiste. El enemigo te alcanzo. Presiona R para reiniciar.")

func _on_goal_reached() -> void:
	if enemies_alive > 0:
		_show_message("Todavia quedan enemigos. Eliminalos antes de entrar a la zona verde.", false)
		return

	_finish_game("Ganaste. Eliminaste a todos y llegaste a la meta. Presiona R para jugar otra vez.")

func _on_enemy_defeated() -> void:
	enemies_alive = max(enemies_alive - 1, 0)
	_update_hud()

func _finish_game(text: String) -> void:
	if _game_finished:
		return

	_game_finished = true
	get_tree().paused = true #pausar la escena al terminar el juego
	_show_message(text, true)

func _show_message(text: String, centered: bool) -> void:
	if centered:
		message_label.text = text
		hud_label.text = ""
	else:
		hud_label.text = text
		message_label.text = ""

func _update_hud() -> void:
	if enemies_alive > 0:
		_show_message("Enemigos restantes: %d. Eliminalos y llega a la zona verde. Espacio dispara. R reinicia." % enemies_alive, false)
	else:
		_show_message("Todos los enemigos eliminados. Ahora entra a la zona verde. R reinicia.", false)
