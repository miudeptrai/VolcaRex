extends CharacterBody2D

const LEFT_WRAP: float = -520.0;
const FLOOR_WIDTH: float = 520.0;

var moveable: bool = true;

func get_speed() -> float:
	return get_parent().speed;

func _on_game_over() -> void:
	moveable = false;

func _ready() -> void:
	add_to_group("floor");
	
	get_parent().get_node("Rex").game_over.connect(_on_game_over);

func _process(delta: float) -> void:
	# Moveable is for stopping the floor when games over
	if (moveable):
		global_position.x -= get_speed() * delta;
	
	# Wrap around
	if (global_position.x <= LEFT_WRAP):
		set_deferred("global_position", Vector2(global_position.x + FLOOR_WIDTH * 2, global_position.y));
