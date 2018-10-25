########################################
# File: PlayerSheet.gd
# Author: John Thummel
########################################
extends Sprite

#==VARIABLES============================
var alive = true
var player_near = false
var x_dist
var y_dist
var sprite_h = 256
var sprite_w = 256
var anim_count = 0       #total time in animation
var ai_count = 0         #total time in AI
const frame_time = 0.175   #speed of footfalls
var speed = 7          #distance per frame
var idle_frame = 6
var key_pressed = {
	KEY_UP : false,
	KEY_DOWN : false,
	KEY_LEFT : false,
	KEY_RIGHT : false}


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=INIT-=
func _ready():

	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=LOOP-=
func _process(delta):
	anim_count += delta
	#key_pressed[KEY_DOWN]=true
	#key_pressed[KEY_RIGHT]=true
	if(alive):
		set_process_input(true)

		keystate_handler()
		#place inside anim

#=FUNCTIONS=============================

#-------------------------------ATTACK--
#---(delta, dir{DOWN=1, RIGHT=2, UP=3, LEFT=4})
func attack(time_d, dir):
	anim(8,11, dir)

func fade():
	pass

#------------------------------ANIMATE--
func anim(start_frame, end_frame, row):#, time_d):
	#keep track of total time passed framed between 0-0.25
	#anim_count += time_d
	if (anim_count >= frame_time):
		anim_count = 0

		#increase or reset frame
		if region_rect.position.y != ((row-1)*sprite_h):
			region_rect.position.y = ((row-1)*sprite_h)

		if region_rect.position.x >= (sprite_w*(end_frame-1)):
			region_rect.position.x = (sprite_w*(start_frame-1))


		if (start_frame != idle_frame) and (end_frame != idle_frame):
			region_rect.position.x += sprite_w

			if(start_frame==1) and (row==7):
				move("y", "+") #move DOWN
			elif(start_frame==1) and (row==5):
				move("x", "+") #move RIGHT
			elif(start_frame==1) and (row==3):
				move("y", "-") #move UP
			elif(start_frame==1) and (row==1):
				move("x", "-") #move LEFT

			elif(start_frame==1) and (row==2):
				move("xy", "-") #move UP+LEFT
			elif(start_frame==1) and (row==4):
				move("xy", "+") #move UP+RIGHT
			elif(start_frame==1) and (row==6):
				move("yx", "+") #move DOWN+RIGHT
			elif(start_frame==1) and (row==8):
				move("yx", "-") #move DOWN+LEFT

			#no walk IDLE
		elif region_rect.position.x != (sprite_w*(start_frame-1)):
			region_rect.position.x = (sprite_w*(start_frame-1))

#---------------------------------MOVE--
func move(axis, xdir):
	#walk DOWN/UP
	if axis=="y":
		if xdir=="+":
			get_parent().position.y += speed
		elif xdir=="-":
			get_parent().position.y -= speed
	#walk RIGHT/LEFT
	if axis=="x":
		if xdir=="+":
			get_parent().position.x += speed
		elif xdir=="-":
			get_parent().position.x -= speed

	#Walk UP + LEFT/RIGHT
	if axis=="xy":
		if xdir=="+":
			get_parent().position.x += (speed / sqrt(2))
			get_parent().position.y -= (speed / sqrt(2))
		elif xdir=="-":
			get_parent().position.x -= (speed / sqrt(2))
			get_parent().position.y -= (speed / sqrt(2))
	#Walk DOWN + RIGHT/LEFT
	if axis=="yx":
		if xdir=="+":
			get_parent().position.x += (speed / sqrt(2))
			get_parent().position.y += (speed / sqrt(2))
		elif xdir=="-":
			get_parent().position.x -= (speed / sqrt(2))
			get_parent().position.y += (speed / sqrt(2))

#---------------------------TEST-INPUT--
func _input(event):
	if event is InputEventKey:

		if event.pressed and event.scancode == KEY_SPACE:
			if(player_near == false):
				player_near = true
			else:
				player_near = false

		if event.pressed and event.scancode == KEY_UP:
			key_pressed[KEY_UP] = true
		if !event.pressed and event.scancode == KEY_UP:
			key_pressed[KEY_UP] = false

		if event.pressed and event.scancode == KEY_DOWN:
			key_pressed[KEY_DOWN] = true
		if !event.pressed and event.scancode == KEY_DOWN:
			key_pressed[KEY_DOWN] = false

		if event.pressed and event.scancode == KEY_LEFT:
			key_pressed[KEY_LEFT] = true
		if !event.pressed and event.scancode == KEY_LEFT:
			key_pressed[KEY_LEFT] = false


		if event.pressed and event.scancode == KEY_RIGHT:
			key_pressed[KEY_RIGHT] = true
		if !event.pressed and event.scancode == KEY_RIGHT:
			key_pressed[KEY_RIGHT] = false

		#else:
		#	anim(6,6, 1) #IDLE

func keystate_handler():
	if(alive):
		if(key_pressed[KEY_LEFT] == true and key_pressed[KEY_RIGHT] == true):
			key_pressed[KEY_LEFT] = false
	
		if(key_pressed[KEY_UP] == true and key_pressed[KEY_DOWN] == true):
			key_pressed[KEY_DOWN] = false
	
		if(key_pressed[KEY_UP] == true):
			if(key_pressed[KEY_LEFT] == false and key_pressed[KEY_RIGHT] == false):
				anim(1,4, 3) #UP
			elif(key_pressed[KEY_LEFT] == true):
				anim(1,4, 2) #UP+LEFT
			elif(key_pressed[KEY_RIGHT] == true):
				anim(1,4, 4) #UP+RIGHT
	
		if(key_pressed[KEY_DOWN] == true):
			if(key_pressed[KEY_LEFT] == false and key_pressed[KEY_RIGHT] == false):
				anim(1,4, 7) #DOWN
			elif(key_pressed[KEY_RIGHT] == true):
				anim(1,4, 6) #DOWN+RIGHT
			elif(key_pressed[KEY_LEFT] == true):
				anim(1,4, 8) #DOWN+LEFT
	
		if(key_pressed[KEY_LEFT] == true and key_pressed[KEY_UP] == false and key_pressed[KEY_DOWN] == false):
			anim(1,4, 1) #LEFT
	
		if(key_pressed[KEY_RIGHT] == true and key_pressed[KEY_UP] == false and key_pressed[KEY_DOWN] == false):
			anim(1,4, 5) #RIGHT