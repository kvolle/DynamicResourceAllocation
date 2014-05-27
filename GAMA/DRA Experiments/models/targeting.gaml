/**
 *  targeting
 *  Author: Kyle
 *  Description: First attempt at a distributed implementation
 */

model targeting

/* Insert your model definition here */

global width: 10 height:10 {
	geometry shape <- rectangle(33,100);
	int numberTargets <- 30;
	int numberVehicles <- 150;
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
				numberVehicles <- numberVehicles -1;
				write "Robots: " + numberVehicles;
				do die;
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
	species vehicle skills: [moving]{
		target target_aimed_at;
		int robot_direction <- 45;
		init {
			target_aimed_at <- target closest_to(self);
			//write "Vehicle " + name + " is aimed at " + target_aimed_at;
		}
		aspect circle {
			draw circle(1) color: rgb("red");
		}

		reflex dead_target when: dead(target_aimed_at){
			target_aimed_at <- target closest_to(self);
		}
		reflex move_around when: flip (1){
			robot_direction <- robot_direction + 0.5*(towards(location, target_aimed_at.location)-robot_direction); 
			do move speed:1 heading: robot_direction;
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