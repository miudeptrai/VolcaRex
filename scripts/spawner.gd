extends Node2D

const SINGLE_LARGE_TREE = preload("uid://sgp31qxs7aaf");
const DOUBLE_TREE = preload("uid://dmq7sno4otabi");
const TRIPLE_TREE = preload("uid://dxu21tiephrur")

var spawner_range: Array[float] = [0.9, 3.0];
# size: small (1/2) normal (1) big(2), range [a,b);
var size_range: Array = [
	{"min": 0.0,  "max": 0.5,  "size": 0.5}, 
	{"min": 0.5,  "max": 0.99, "size": 1.0},
	{"min": 0.99, "max": 1.0,  "size": 2.0}
];

var variety_range: Array = [
	{"min": 0.0,  "max": 0.4,  "scene": SINGLE_LARGE_TREE}, 
	{"min": 0.4,  "max": 0.7, "scene": DOUBLE_TREE},
	{"min": 0.7,  "max": 1.0, "scene": TRIPLE_TREE}
];

var my_obs = [];

func spawn_ob() -> void:
	# Variations
	var random: float = randf(); #[0,1]
	var variation;
	for r in variety_range:
		# [a,b);
		if (random >= r.min and random < r.max):
			variation = r.scene;
			break;
	
	var avail: bool = false;
	var ob;
	if (not my_obs.is_empty()):
		for o in my_obs:
			if (o.ready_to_deploy and o.get_scene_file_path() == variation.resource_path):
				avail = true;
				ob = o;
				break;
	
	if (not avail):
		ob = variation.instantiate();
		get_parent().add_child(ob);
		my_obs.append(ob);
	
	# Size manipulation
	random = randf();
	var size: float;
	for r in size_range:
		# [a,b);
		if (random >= r.min and random < r.max):
			size = r.size;
			break;
	
	ob.get_node("CollisionShape2D").disabled = true;
	ob.scale = Vector2(size, size);
	ob.global_position = global_position;
	ob.get_node("CollisionShape2D").disabled = false;
	
	ob.ready_to_deploy = false;
	print("Obs avail: %d" % my_obs.size());


func _on_timer_timeout() -> void:
	spawn_ob();
	$Timer.start(randf_range(spawner_range[0], spawner_range[1]));

func _on_game_over() -> void:
	$Timer.stop();

func _ready() -> void:
	get_tree().get_first_node_in_group("rex").game_over.connect(_on_game_over);
	
	$Timer.start(randf_range(spawner_range[0], spawner_range[1]));
