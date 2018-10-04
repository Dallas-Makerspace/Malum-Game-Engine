########################################
# File: Enemy Script
# Author: John Thummel
########################################
extends Sprite

#==VARIABLES============================
var player_x = -50
var player_y = 100

var player_near = false
var x_dist
var y_dist
var charge_x = false
var charge_y = false
var charge_time = 1.0      #enemy charges at player in 3s intervals
var charge_count = 0
var anim_count = 0       #total time in animation
var ai_count = 0         #total time in AI
const frame_time = 0.125 #speed of footfalls
var speed = 5            #distance per frame
var idle_frame = 7


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=INIT-=
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=LOOP-=
func _process(delta):
	ai(delta)


#=FUNCTIONS=============================

#-----------------------------AI-LOGIC--
func ai(time_d):
	if player_near:
		ai_count = 0
		charge_count += time_d
		if(charge_x == false) and (charge_y == false):
			x_dist = player_x - position.x
			y_dist = player_y - (position.y)
		
		if(abs(x_dist)>abs(y_dist)): #player is LEFT or RIGHT
			if (charge_x == false):
				charge_x = true #start charging left/right
			if (charge_x == true) and (charge_count < charge_time):
				if(x_dist>0):
					if(x_dist<25):
						attack(time_d, 2)
					else:
						anim(1,6, 2, time_d) #RIGHT
				else:
					if(abs(x_dist)<25):
						attack(time_d, 4)
					else:
						anim(1,6, 4, time_d) #LEFT
		else: #player is UP or DOWN
			if (charge_y == false):
				charge_y = true #start charging up/down
			if (charge_y == true) and (charge_count < charge_time):
				if(y_dist>0):
					if(y_dist<25):
						attack(time_d, 1)
					else:
						anim(1,6, 1, time_d) #DOWN
				else:
					if(abs(y_dist)<25):
						attack(time_d, 3)
					else:
						anim(1,6, 3, time_d) #UP
		if(charge_count >= charge_time):
			charge_count = 0 #when charge for (charge_time)sec is
			charge_x = false #complete then reset counter
			charge_y = false

	#player not near then patrol
	else:
		charge_count = 0
		ai_count += time_d
		
		if(ai_count <= 5):
			anim(1,6, 2, time_d) #RIGHT
		elif(ai_count > 5 and ai_count <= 10):
			anim(1,6, 1, time_d) #DOWN
		elif(ai_count > 10 and ai_count <= 15):
			anim(1,6, 4, time_d) #LEFT
		elif(ai_count > 15 and ai_count <= 20):
			anim(1,6, 3, time_d) #UP
		elif(ai_count > 20 and ai_count <= 21):
			anim(7,7, 1, time_d) #IDLE
		#elif(ai_count > 21 and ai_count <= 25):
		#	attack(time_d)
		else:
			ai_count = 0

#-------------------------------ATTACK--
#---(delta, dir{DOWN=1, RIGHT=2, UP=3, LEFT=4})
func attack(time_d, dir):
	anim(8,11, dir, time_d)

#------------------------------ANIMATE--
func anim(start_frame, end_frame, row, time_d):
	#keep track of total time passed framed between 0-0.25
	anim_count += time_d
	if (anim_count >= frame_time):
		anim_count = 0
	
		#increase or reset frame
		if region_rect.position.y != ((row-1)*65):
			region_rect.position.y = ((row-1)*65)
			
		if region_rect.position.x >= (65*(end_frame-1)):
			region_rect.position.x = (65*(start_frame-1))
			
		if (start_frame != idle_frame) and (end_frame != idle_frame):
			region_rect.position.x += 65
			
			if(start_frame==1) and (row==1):
				move("y", "+") #move DOWN
			elif(start_frame==1) and (row==2):
				move("x", "+") #move RIGHT
			elif(start_frame==1) and (row==3):
				move("y", "-") #move UP
			elif(start_frame==1) and (row==4):
				move("x", "-") #move LEFT
				
			#no walk IDLE
		elif region_rect.position.x != (65*(start_frame-1)):
			region_rect.position.x = (65*(start_frame-1))

#---------------------------------MOVE--
func move(axis, dir):
	#walk DOWN/UP
	if axis=="y":
		if dir=="+":
			position.y += speed
		elif dir=="-":
			position.y -= speed
	#walk RIGHT/LEFT
	if axis=="x":
		if dir=="+":
			position.x += speed
		elif dir=="-":
			position.x -= speed

#---------------------------TEST-INPUT--
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if(player_near == false):
				player_near = true
			else:
				player_near = false