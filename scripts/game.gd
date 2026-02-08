extends Node2D

signal game_start;

var score: int = 0;
var speed: float = 195.0;

var first_jump: bool = true;

const SPEED_THRESHOLD: int = 10;
const SPEED_INCREASE: float = 5.0;
const MAX_SPEED: float = 800.0;

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("jump") and first_jump):
		first_jump = false;
		game_start.emit();
		$Label.visible = false;
		$Timer.start();
		set_process(false);

func _on_timer_timeout() -> void:
	score += 1;
	
	# Update speed
	if (score % SPEED_THRESHOLD == 0):
		speed = minf(MAX_SPEED, speed + SPEED_INCREASE);
		#print("New speed %d" % speed);
	
	$Score.text = "Score: %d" % score;
	$Timer.start();


func _on_rex_game_over() -> void:
	$Timer.stop();
