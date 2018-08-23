def myProg():
  # THIS IS A MODIFIED VERSION OF THE ROBOTIQ URCAP  
  #aliases for the gripper variable names
  ACT = 1
  GTO = 2
  ATR = 3
  ARD = 4
  FOR = 5
  SPE = 6
  OBJ = 7
  STA = 8
  FLT = 9
  POS = 10
  PRE = 11
  def rq_init_connection(gripper_sid=9, gripper_socket="1"):
  	socket_open("127.0.0.1",63352, gripper_socket)
  	socket_set_var("SID", gripper_sid,  gripper_socket)
  	ack = socket_read_byte_list(3, gripper_socket)
  end
  ##########################
  # Returns True if list_of_bytes is [3, 'a', 'c', 'k']
  def is_ack(list_of_bytes):
  	if (list_of_bytes[0] != 3):
  		return False
  	end
  	if (list_of_bytes[1] != 97):
  		return False
  	end
  	if (list_of_bytes[2] != 99):
  		return False
  	end
  	if (list_of_bytes[3] != 107):
  		return False
  	end
  	return True
  end
  def is_not_ack(list_of_bytes):
  	if (is_ack(list_of_bytes)):
  		return False
  	else:
  		return True
  	end
  end
  ##################
  def rq_set_var(var_name, var_value, gripper_socket="1"):
  	sync()
  	if (var_name == ACT):
  		socket_set_var("ACT", var_value, gripper_socket)
  	elif (var_name == GTO):
  		socket_set_var("GTO", var_value, gripper_socket)
  	elif (var_name == ATR):
  		socket_set_var("ATR", var_value, gripper_socket)
  	elif (var_name == ARD):
  		socket_set_var("ARD", var_value, gripper_socket)
  	elif (var_name == FOR):
  		socket_set_var("FOR", var_value, gripper_socket)
  	elif (var_name == SPE):
  		socket_set_var("SPE", var_value, gripper_socket)
  	elif (var_name == POS):
  		socket_set_var("POS", var_value, gripper_socket)
  	else:
  	end
  	sync()
  	ack = socket_read_byte_list(3, gripper_socket)
  	sync()
  	while(is_not_ack(ack)):
  		textmsg("rq_set_var : retry", " ...")
  		textmsg("rq_set_var : var_name = ", var_name)
  		textmsg("rq_set_var : var_value = ", var_value)
  		if (ack[0] != 0):
  			textmsg("rq_set_var : invalid ack value = ", ack)
  		end
  		socket_set_var(var_name , var_value,gripper_socket)
  		sync()
  		ack = socket_read_byte_list(3, gripper_socket)
  		sync()
  	end
  end

  def rq_get_var(var_name, nbr_bytes, gripper_socket="1"):
  	if (var_name == FLT):
  		socket_send_string("GET FLT",gripper_socket)
  		sync()
  	elif (var_name == OBJ):
  		socket_send_string("GET OBJ",gripper_socket)
  		sync()
  	elif (var_name == STA):
  		socket_send_string("GET STA",gripper_socket)
  		sync()
  	elif (var_name == PRE):
  		socket_send_string("GET PRE",gripper_socket)
  		sync()
  	else:
  	end
  	var_value = socket_read_byte_list(nbr_bytes, gripper_socket)
  	sync()
  	return var_value
  end
  ############################
  def is_STA_gripper_activated (list_of_bytes):
  	if (list_of_bytes[0] != 1):
  		return False
  	end
  	if (list_of_bytes[1] == 51):
  		return True
  	end
  	return False
  end
  ###############
  def rq_set_sid(gripper_sid=9, gripper_socket="1"):
    socket_set_var("SID", gripper_sid,  gripper_socket)
    sync()
    return is_ack(socket_read_byte_list(3, gripper_socket))
  end
  def rq_reset(gripper_socket="1"):
  	rq_gripper_act = 0
  	rq_obj_detect = 0
  	rq_mov_complete = 0
  
  	rq_set_var(ACT,0, gripper_socket)
  	rq_set_var(ATR,0, gripper_socket)
  end
  def rq_is_gripper_activated(gripper_socket="1"):
  	gSTA = rq_get_var(STA, 1, gripper_socket)
  
  	if(is_STA_gripper_activated(gSTA)):
  		rq_gripper_act = 1
  		return True
  	else:
  		rq_gripper_act = 0
  		return False
  	end
  end

  def rq_activate(gripper_socket="1"):
  	rq_gripper_act = 0
		if (not rq_is_gripper_activated(gripper_socket)):
			rq_reset(gripper_socket)
		end
  	rq_set_var(ACT,1, gripper_socket)
  end
  ###################
  def rq_set_pos(pos, gripper_socket="1"):
  	rq_set_var(GTO,0, gripper_socket)
  
  	rq_set_var(POS, pos, gripper_socket)
  
  	gPRE = rq_get_var(PRE, 3, gripper_socket)
  	pre = (gPRE[1] - 48)*100 + (gPRE[2] -48)*10 + gPRE[3] - 48
  	sync()
  	while (pre != pos):
          rq_set_var(POS, pos, gripper_socket)
  		gPRE = rq_get_var(PRE, 3, gripper_socket)
  		pre = (gPRE[1] - 48)*100 + (gPRE[2] -48)*10 + gPRE[3] - 48
  		sync()
  	end
  end
  def rq_go_to(gripper_socket="1"):
  	rq_set_var(GTO,1, gripper_socket)
  end
  def rq_move(pos, gripper_socket="1"):
  	rq_mov_complete = 0
  	rq_obj_detect = 0
  
  	rq_set_pos(pos, gripper_socket)
  	rq_go_to(gripper_socket)
  end
  #################################
  # The main content should be inserted manually here
  rq_init_connection()
  rq_set_sid()
  rq_activate()
  rq_move(255)   # open
end
