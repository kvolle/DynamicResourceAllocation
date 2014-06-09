/**
 *  targeting
 *  Author: Kyle
 *  Description: First attempt at a distributed implementation
 */

model targeting

/* Insert your model definition here */

global width: 10 height:10 {
	geometry shape <- rectangle(33,100);
	int numberTargets <- 3;
	int numberVehicles <- 5;
	init {
		//list<target> target_list <- [];
		create target number: numberTargets{
			set location <- {rnd(33),rnd(33)};
		}// returns: target_list;
		//ask target_list{
		//	write "My name is: " + name;
		//}
		create vehicle number: numberVehicles{
			set location <- {rnd(33),rnd(33)+67};
		}
	}
	reflex stop_simulation when: (numberTargets = 0) or (numberVehicles = 0) {
                write "And, we're done.";
                do halt ;
    } 
}

entities {
	species target{
		int size <- rnd(5) min: 1;
		int damage <-0 max: size;

		reflex get_hit when: (length(vehicle at_distance(1)) >0){
			list<vehicle> impacting <- vehicle at_distance(1);
			ask impacting{
				robot_speed <- 0.0;
//				numberVehicles <- numberVehicles -1;
//				write "Robots: " + numberVehicles;
//				do die;
			}
			damage <- damage + length(impacting);
		}
		reflex destroyed when: (damage = size){
			numberTargets <- numberTargets -1;
			write "Targets: " + numberTargets;
			do die;
		}
		aspect square {
			draw square(3) color: rgb("blue");
		}
	}
	species vehicle skills: [moving,communicating]{
		target target_aimed_at;
		float robot_direction <- 270.0;
		float robot_speed <- 1.0;
		list<int> global_targeting <-[];
		list<int> confidence <-[];
		list<string> message_to_send <-[];
		
		init {
			target_aimed_at <- target closest_to(self);
			loop i from:0 to:numberVehicles-1{
				global_targeting <- global_targeting + nil;
//				global_targeting[i]<-100;
				confidence <- confidence + nil;
				confidence[i]<-1500;
			}
			loop i from:0 to: 2*numberVehicles-1{
				message_to_send <- message_to_send + nil;
			}
			int identity <- vehicle index_of self;
			global_targeting[identity]<-target index_of target_aimed_at;
			confidence[identity]<-0;
			//write "Vehicle " + name + " is aimed at " + target_aimed_at;
		}
		aspect circle {
			draw circle(1) color: rgb("red");
		}

		reflex dead_target when: dead(target_aimed_at){
			target_aimed_at <- target closest_to(self);
			int identity <- vehicle index_of self;
			global_targeting[identity]<-target index_of target_aimed_at;
		}
		reflex move_around when: flip (1){
	
			robot_direction <- robot_direction + 0.5*(towards(location, target_aimed_at.location)-robot_direction); 
			do move speed:robot_speed heading: robot_direction;
		}
		reflex compose when: flip(1){
			loop i from:0 to: 2*length(global_targeting)-1{
				if even(i){
					message_to_send[i] <- string(global_targeting at int(floor(i/2)));
				}
				else{
					message_to_send[i] <- string(confidence at int(floor(i/2)));
				}
			}
			list<vehicle> listeners <- vehicle at_distance(200);
			write name + " sent a message.";
			do send with: [ receivers :: listeners, protocol :: 'no-protocol', performative :: 'inform', content ::  message_to_send ];
		}
		reflex check_mail when: (!empty(messages)){
			loop i over: messages{
				loop j from: 0 to: length(i.content)-1{
					if even(j){
						int tmp_index <- j+1;
						if int(i.content at tmp_index) < confidence at int(floor(j/2)){
							int tmp <-int(j/2);
							global_targeting[tmp] <- int(i.content at j);
						}
					}
					else{
						if int(i.content at j) < confidence at int(floor(j/2)){
							confidence[int(floor(j/2))] <- int(i.content at j)+1;
						}
					}
				}
				write name + " got a message from " + i.sender + " saying " + i.content;
				//do send with : [ receivers :: i.sender, protocol :: 'no-protocol', performative :: 'accept-proposal', content :: ('Ok')];

			}
		}
	}
}

experiment experiment1 type: gui {
	output{
		display map {
			species target aspect: square;
			species vehicle aspect: circle;
		}
	}
}