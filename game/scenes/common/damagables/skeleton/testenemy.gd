
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var MOVESPEED = 3
var collision_rect
var accel = 1
var TILESIZE = 32
var sprite_offset
var direction = 1
var falling = false
var is_dying = false
var is_hurt = false
var animation_player
var current_animation = "walk"
var player
var hpclass = preload("res://gui/hud/hp.scn")
var hud
var hp = 1
var hurt_delay = 10
var current_delay = 0
var walk_delay = 60
var current_walk_delay = 0

func check_dying():
	if (hp >= 0):
		is_dying = true
		is_hurt = false
		if (has_node("damagable")):
			remove_child(get_node("damagable"))

func check_motion(frontX, space_state):
	if (!is_dying):
		if(current_delay == 0):
			var damageTiles = collision_rect.get_overlapping_areas()
			for i in damageTiles:
				if (i.has_node("weapon")):
					var hp_obj = hpclass.instance()
					hud.add_child(hp_obj)
					var hitpos = hp_obj.calculate_hitpos(i.get_global_pos(), i.get_node("weapon").get_shape().get_extents(), get_pos(), sprite_offset)
					hp -= 1
					is_hurt = true
					check_dying()
					# TODO - calculate damage helper method
					hp_obj.display_damage(hitpos, 1)
					player.get_node("player").set("hit_enemy", true)
					current_delay += 1
					current_walk_delay += 1
	
		if (!is_hurt):
			var frontTile = space_state.intersect_ray(Vector2(frontX, get_global_pos().y - sprite_offset.y), Vector2(frontX, get_global_pos().y + sprite_offset.y - 1))
		
			if (frontTile != null && frontTile.has("position")):
				direction = direction * -1
			
			frontTile = space_state.intersect_ray(Vector2(frontX + direction*MOVESPEED, get_global_pos().y + sprite_offset.y), Vector2(frontX + direction*MOVESPEED, get_global_pos().y + sprite_offset.y + TILESIZE))
			if (frontTile == null || !frontTile.has("position")):
				direction = direction * -1
			if (frontTile != null && frontTile.has("collider")):
				var collider = frontTile["collider"]
				if (collider.get_name() == "player" && collider.get_global_pos().y - collider["sprite_offset"].y > get_global_pos().y + sprite_offset.y):
					direction = direction * -1
			
			move(Vector2(MOVESPEED * direction, 0))

func step_vertical(frontX, space_state):
	var desiredY = accel
	
	var floorTile = space_state.intersect_ray(Vector2(frontX, get_global_pos().y + sprite_offset.y), Vector2(frontX, get_global_pos().y + sprite_offset.y + desiredY), [player.get_node("player")])
	
	falling = true
	
	if (floorTile != null && floorTile.has("position")):
		if (floorTile["position"].y <= get_global_pos().y + sprite_offset.y && floorTile["position"].y > get_global_pos().y - sprite_offset.y):
			desiredY = get_global_pos().y + sprite_offset.y - floorTile["position"].y - 1
			falling = false
			accel = 1
	
	if (falling):
		accel += 1
	
	move(Vector2(0, desiredY))

func check_animation(new_animation):
	if (is_dying):
		new_animation = "die"
	if (is_hurt):
		new_animation = "hurt"
	return new_animation

func die():
	queue_free()

func _fixed_process(delta):
	var space = get_world_2d().get_space()
	var space_state = Physics2DServer.space_get_direct_state(space)

	var frontX = get_global_pos().x + direction * sprite_offset.x

	check_motion(frontX, space_state)
	
	step_vertical(frontX, space_state)
	
	var new_animation = "walk"
	
	new_animation = check_animation(new_animation)
	
	get_node(new_animation).set_scale(Vector2(direction, 1))
	
	if (current_delay > 0):
		current_delay += 1
		if (current_delay >= hurt_delay):
			current_delay = 0
	
	if (new_animation != current_animation):
		animation_player.play(new_animation)
		current_animation = new_animation
	
	if (is_hurt && !animation_player.is_playing()):
		is_hurt = false
	
	if (is_dying && !animation_player.is_playing()):
		die()

func _ready():
	collision_rect = get_node("damagable")
	sprite_offset = get_node("damagable/CollisionShape2D").get_shape().get_extents()
	animation_player = get_node("AnimationPlayer")
	player = get_tree().get_root().get_node("world/playercontainer")
	hud = get_tree().get_root().get_node("world/gui/hpcontainer")
	set_fixed_process(true)