extends CharacterBody2D

const GRAVITY: float = 1800.0;

var already_hit: bool = false;
var moveable: bool = true;
const OFFSETY: float = 1000.0;

var ready_to_deploy = true;

const LEFT_WRAP: float = -550.0;
#var right_wrap: float = 530.0;
#var offsety = 10;

signal hit_rex;

# Get the current game speed
func get_speed() -> float:
	return get_parent().speed;

func _on_game_over() -> void:
	moveable = false;

func _ready() -> void:
	add_to_group("obstacle");
	
	# Connect to Rex
	var rex := get_tree().get_first_node_in_group("rex");
	hit_rex.connect(rex._on_hit);
	rex.game_over.connect(_on_game_over);

func _physics_process(delta: float) -> void:
	if (not is_on_floor()):
		velocity.y += GRAVITY * delta;
	
	if (moveable and not ready_to_deploy):
		global_position.x -= get_speed() * delta;
	
	move_and_slide();
	
	# Check if touching Rex
	for i in range(get_slide_collision_count()):
		var collider := get_slide_collision(i).get_collider();
		if (collider.name == "Rex" and not already_hit):
			#print("Is hit_rex connected?", hit_rex.get_connections());
			hit_rex.emit();
			already_hit = true;
			print("Game Over touched Rex");
	
	# Check if ready
	if (global_position.x <= LEFT_WRAP and not ready_to_deploy):
		$CollisionShape2D.disabled = true;
		set_deferred("global_position", Vector2(global_position.x, global_position.y + OFFSETY));;
		ready_to_deploy = true;
		print(self, " ready");
	
	# Wrap around (must be after collision checking)
	#if (global_position.x <= left_wrap):
		#print("Last pos: ", global_position.x);
		#var new_pos := Vector2(right_wrap, global_position.y - offsety);
		#set_deferred("global_position", new_pos);
		#print("Wrapped pos: ", global_position.x);
		#return;
