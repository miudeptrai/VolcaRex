extends CharacterBody2D

const GRAVITY: float = 1800.0;
const JUMP_FORCE: float = 700.0;

var is_game_over: bool = false;
var play_animation: bool = false;

#var jump_pressed_time: float = -1.0; #about 694 - 701 ms
#var was_on_floor: bool = false;

signal game_over;

func _on_game_start() -> void:
	play_animation = true;

func _on_hit() -> void:
	print("Hit");
	game_over.emit();
	is_game_over = true;
	$AnimatedSprite2D.play("die");

func _ready() -> void:
	add_to_group("rex");
	
	get_parent().game_start.connect(_on_game_start);

func _physics_process(delta: float) -> void:
	if (is_on_floor() and not is_game_over and play_animation):
		$AnimatedSprite2D.play("walk");
	
	if (not is_on_floor()):
		velocity.y += GRAVITY * delta;
	
	#var on_floor = is_on_floor();
#
	#if (on_floor and not was_on_floor and jump_pressed_time != -1):
		#var landed_time = Time.get_ticks_msec();
		#var gap_ms = landed_time - jump_pressed_time;
		#print("Gap:", gap_ms, "ms");
#
		#jump_pressed_time = -1;  # reset
#
	#was_on_floor = on_floor
	
	# Jump
	if (is_on_floor() and Input.is_action_just_pressed("jump") and not is_game_over):
		velocity.y = -JUMP_FORCE;
		$AnimatedSprite2D.play("idle");
		
		#jump_pressed_time = Time.get_ticks_msec();
	
	move_and_slide();
