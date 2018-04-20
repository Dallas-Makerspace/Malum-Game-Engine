
extends Node2D

var night = [Color(7/255.0, 8/255.0, 17/255.0), Color(7/255.0, 34/255.0, 58/255.0)]
var sunrise = [Color(49/255.0, 69/255.0, 116/255.0), Color(1, 160/255.0, 69/255.0)]
var color
var timer
var limit


func _ready():
	ProjectSettings.set("blood_count", 0)
	ProjectSettings.set("show_blood_counter", true)
	color = get_node("ParallaxBackground/ParallaxLayer/sky").get_material()
	color.set_shader_param("start", night[0])
	color.set_shader_param("stop", night[1])
	var level = ProjectSettings.get("levels")[ProjectSettings.get("current_level")]
	timer = level.time
	limit = timer * 1.0
	set_physics_process(true)

func _physics_process(delta):
	timer -= 1
	var start = sunrise[0].linear_interpolate(night[0], ease(timer/limit, 0.4))
	var stop = sunrise[1].linear_interpolate(night[1], ease(timer/limit, 0.4))
	color.set_shader_param("start", start)
	color.set_shader_param("stop", stop)
	if (timer <= 0):
		ProjectSettings.set("sun", true)
		set_physics_process(false)
