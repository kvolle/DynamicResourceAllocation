#include <iostream>
#include <cstdio>
#include <cmath>
#include <vector>
//#include <iterator>
#include <algorithm>

const float discount = 0.95;
const int r = 2;
const int t = 2;
const int targetSize[] = {1,1};

using namespace std;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
void printVector(vector <int> &vec){

for (int i=0;i<vec.size();i++){
	printf("%2d ",vec[i]);
}
printf("\n");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
float R(vector <int> current_state, int action){

float reward=0;

if (current_state[0] != action){
reward -= 1;
}
//cout << "Targeting and action: " << current_state[0] << "  " << action << endl;
//cout << "Goal size and value : " << targetSize[action] << " " << current_state[action+1] << endl;
//cout << "Curr size and value : " << targetSize[current_state[0]] << " " << current_state[current_state[0]+1] << endl;

reward +=(targetSize[action]-current_state[action+1]);
reward -=(targetSize[current_state[0]]-current_state[current_state[0]+1]);

//cout << "Reward: " << reward << endl;
return reward;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int locate(vector <vector<int> > &state_space,vector<int> &state){
//cout << state[0] << " " << state[1] << " " << state[2] << endl;
for (int i=0;i<state_space.size();i++){
	if (equal(state_space[i].begin(),state_space[i].end(), state.begin())){
		return i;
	}
	//cout << state_space[i][0] << " " << state_space[i][1] << " " << state_space[i][2] << endl;
}
return -1;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
vector<int> prediction(vector<int> &state, int action){

vector<int> new_state;


// The action of switching to the one already targetted is equivalent to staying
if(action == state[0]){
//	cout << "STAY" << endl;
	return state;
}

// Make a copy of the state
copy(state.begin(),state.end(),back_inserter(new_state));

// If switching to a target that already has every robot attacking it, that is bad and we don't let it
if (state[action+1] == r){
	new_state[0] = -1;
	return new_state;
}
// The one that was previously targeted decrements
new_state[new_state[0]+1]-=1;
// The one that is being targeted now increments
new_state[action+1] +=1;
// The id of the one being targeted is updated
new_state[0] = action;

//cout << new_state[0] << " " << new_state[1] << " " << new_state[2] << endl;

return new_state;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int argmax_a(vector<int>&state, vector<int> &allowable, vector<int> &allowable_values){
int total_value[allowable.size()];
int max_index = 0;
vector <int> local_state;

copy(state.begin(),state.end(),back_inserter(local_state));
for (int a=0;a<allowable.size();a++){
//	total_value[a] = R(local_state,a)+discount*allowable_values[a];
	if (total_value[a] > total_value[max_index]){
		max_index = a;
	}
}
return max_index;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int argmax(vector<int> actions, vector<int> rewards){
	// This function takes vectors of allowed actions and the associated rewards and returns the best action
	int max_action;
	int max_reward;
	max_action = 173;
	max_reward = -1;
	for (int i=0;i<actions.size();i++){
		if (rewards[i] >max_reward){
			max_reward = rewards[i];
			max_action = actions[i];
		}
	}
	return max_action;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int main(){

unsigned long tmp;

unsigned long dim =  (unsigned long)pow(r+1,t);

vector<int> state;
vector<vector<int> > states;

//cout << dim << endl;
int total;

for (int a=0;a<t;a++){
	for (int i=0;i<dim;i++){
		tmp = i;

		total = 0;
		for (int j=0;j<t+1;j++){
			state.push_back(tmp%(r+1));
			tmp = tmp/(r+1);
			total = total + state.back();
		}
		if (total==r){
			if (state[a] > 0){
				state.insert(state.begin(),a);
				states.push_back(state);
			}
		}
		state.clear();

	}
}


// Print out all of the allowable states
// Clean up artifact element at end of state vector
for (int i=0;i<states.size();i++){
//	cout << i << ": ";
	states[i].erase(states[i].end()-1);
	//printVector(states[i]);
}

//cout << "\nTotal: "<< dim*t;
//cout << "\n Good: "<< states.size() << endl;


vector<int> Policy;
vector<float> V;
Policy.resize(states.size(),0);
V.resize(states.size(),0);

vector<int> new_state;
vector<int> allowable;
//vector<int> allowable_result;
vector<int> allowable_value;

for (int iterations=0;iterations<10;iterations++){
	for (int s=0;s<states.size();s++){
		for (int action=0;action<t;action++){

			new_state = prediction(states[s], action);
			if (new_state[0] >= 0){
//			if (locate(states,new_state)>=0){
				allowable.push_back(action);
//				allowable_result.push_back(locate(states,new_state));//TODO figure out why this had >0
				allowable_value.push_back(V[locate(states,new_state)]);
			}
			new_state.clear();
		}

		// The old way of doing things
		/*
		// Policy(s) = argmax_a(R(s'|s,a)+discount*V(s'))
		Policy[s] = argmax_a(states[s],allowable,allowable_value);
		// V(s) = R(s'|s,Pi(s))+discount*V(s')
		V[s] = R(states[s],Policy[s])+discount*V[allowable_result[Policy[s]]];
		*/
		cout << s << ":"<<endl;
		printVector(allowable_value);
		Policy[s] = argmax(allowable,allowable_value);
		V[s] = R(states[s],Policy[s]) + discount*allowable_value[Policy[s]]; // Might have issues with reward/utility
		allowable.clear();
//		allowable_result.clear();
		allowable_value.clear();
	}
}


cout << endl << endl;

for (int z=0;z<states.size();z++){

printf("%d: %d\n",z,Policy[z]);
//printVector(states[z]);

}
/*
cout <<"1: " << R(states[0],0) << endl;
cout <<"2: " << R(states[0],1) << endl;
cout <<"3: " << R(states[1],0) << endl;
cout <<"4: " << R(states[1],1) << endl;
cout <<"5: " << R(states[2],0) << endl;
cout <<"6: " << R(states[2],1) << endl;
cout <<"7: " << R(states[3],0) << endl;
cout <<"8: " << R(states[3],1) << endl;
*/


}
