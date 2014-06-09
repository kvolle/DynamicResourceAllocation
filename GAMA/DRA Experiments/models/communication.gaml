/**
 *  communication
 *  Author: Kyle
 *  Description: 
 */

model communication

global{
	int robots <- 2;

	init{
		create robot number:robots returns: speakers;
	}
}

entities{
	species robot skills: [communicating]{
		list<int> targeting <- [rnd(4), rnd(4)];
		list<int> locality <- [0,0];
		list<string> message_to_send <-["T","e","s","t"];
		reflex compose when: (flip(1)){
			loop i from:0 to: 2*length(targeting)-1{
				if even(i){
					message_to_send[i] <- string(targeting at int(floor(i/2)));
				}
				else{
					message_to_send[i] <- string(locality at int(floor(i/2)));
				}
			}
		}
		reflex say_hello when: (time = 0) {
			list<robot> listeners <- robot at_distance(200);
			write name + " sent a message.";
			do send with: [ receivers :: listeners, protocol :: 'no-protocol', performative :: 'inform', content ::  message_to_send ];
		}
		reflex hear_hello when: !(empty(messages)){
			loop i over: messages{
				loop j from: 0 to: length(i.content)-1{
					if even(j){
						//write "J is even " + j;
						int tmp <-int(j/2);
						targeting[tmp] <- int(i.content at j);
					}
					else{
						int tmp <- int(floor(j/2));
						//locality[tmp]<- int(i.content at j);
					}
				}
				//set location  <- {float(i.content at 0),float(i.content at 1)};
				write name + " got a message from " + i.sender + " saying " + i.content;
				//do send with : [ receivers :: i.sender, protocol :: 'no-protocol', performative :: 'accept-proposal', content :: ('Ok')];

			}
		}
		aspect square{
			draw square(3) color: rgb("blue");
		}
	}
}

experiment Comunication_Experiment type: gui {
	output{
		display map {
			species robot aspect: square;
		}
	}
}