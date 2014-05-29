#include <iostream>
#include <cstdio>
#include <cmath>
#include <vector>
#include <algorithm>
#include <time.h>

const float discount = 0.90;
const int r = 5;
const int t = 5;
const int targetSize[] = {1,1,1,1,1};//{2,5,4,1,3};//{2,5,7,4,7};

using namespace std;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
void printVector(vector <int> &vec){

for (int i=0;i<vec.size();i++){
	printf("%2d ",vec[i]);
}
printf("\n");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
void pv(vector <float> &vec){

for (int i=0;i<vec.size();i++){
	printf("%2f ",vec[i]);
}
printf("\n");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
/*
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
*/
float R(vector<int> state){
int reward = 0;
	for (int i=0;i<state.size()-1;i++){
        if(abs(state[i+1]-targetSize[i])>100){
//            cout << "   " << state[i+1] << " : " << targetSize[i] << endl;
        }
		reward -= abs(state[i+1]-targetSize[i]);
	}
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
int argmax(vector<int> actions, vector<float> rewards){
	// This function takes vectors of allowed actions and the associated rewards and returns the best action
	int max_action;
	int max_reward;
	max_action = 173;
	max_reward = -100;
	for (int i=0;i<actions.size();i++){
		if (rewards[i] >max_reward){
			max_reward = rewards[i];
			max_action = actions[i];
		}
	}
	return max_action;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
unsigned long int generate_hash(vector<int> state){

    int tmp;
    tmp = 0;
    for (int i =1; i<state.size();i++){
        tmp += ceil(state[i]*pow(r,i-1));
    }
    tmp += ceil(state[0]*pow(r,t));
    //cout << endl;
    //printVector(state);
    //cout << tmp << endl;
    return tmp;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
unsigned long int generate_hash2(vector<int> state){
    vector<int> debug;

    int tmp;
    tmp = 0;
    for (int i =1; i<state.size();i++){
        tmp += ceil(state[i]*pow(r,i-1));
        cout << state[i]*pow(r,i-1) << endl;
        debug.push_back(ceil(state[i]*pow(r,i-1)));
    }
    tmp += state[0]*pow(r,t);
    //cout << state[0]*pow(r,t) << endl;
    //debug.push_back(tmp);
    printVector(debug);
cout << endl << " Hash is: " <<tmp << endl;
    return tmp;
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

cout << "\nTotal: "<< dim*t;
cout << "\n Good: "<< states.size() << endl;


vector<int> Policy;
srand (time(NULL));
for (int i=0;i<states.size();i++){
    Policy.push_back(rand()%t);
}

vector<float> U;
vector<float> U_prime;

bool changed = true;

U.resize(states.size(),0);
U_prime.resize(states.size(),0);

vector<int> new_state;
vector<int> tmp_state;
vector<int> allowable;
vector <vector<int> >allowable_result;
vector<float> allowable_utility;
vector<unsigned long int> hash_code;


for (int s=0;s<states.size();s++){
    U_prime[s] = R(states[s]);
}

cout << endl;
do{
//for (int cnt = 0;cnt<100;cnt++){
   	U.swap(U_prime);
	U_prime.clear();
	U_prime.resize(states.size(),0);
    for (int st = 0;st<states.size();st++){
        new_state = prediction(states[st],Policy[st]);
        U_prime[st] = R(states[st])+discount*R(new_state);
        new_state.clear();
    }

    // TODO policy-eval
	for (int s=0;s<states.size();s++){
		for (int action=0;action<t;action++){
			new_state = prediction(states[s], action);
			if (new_state[0] >= 0){
				allowable.push_back(action);
				allowable_utility.push_back(U[locate(states,new_state)]);
				allowable_result.push_back(new_state);
			}
			new_state.clear();
		}
		tmp_state = prediction(states[s],Policy[s]);
		/*
		if (argmax(allowable,allowable_utility) == 173){
            cout << "Allowable:" << endl;
            printVector(allowable);
            cout << "Utility:" << endl;
            pv(allowable_utility);
            system("pause");
		}
		*/
		// If any of the allowable actions results in higher utility than current policy
		if (U[argmax(allowable,allowable_utility)] > U[locate(states,tmp_state)]){
                Policy[s] = argmax(allowable,allowable_utility);
                changed = true;
		}
		tmp_state.clear();

		allowable.clear();
		allowable_result.clear();
		allowable_utility.clear();
	}
    changed = false;

}while(changed);

vector<int> a;
a.push_back(4);
a.push_back(14);
a.push_back(0);
a.push_back(0);
a.push_back(0);
a.push_back(1);


cout << endl << endl;

FILE * mapping;
mapping = fopen("../Matlab/Mapping.txt","w");
FILE * fid;
fid = fopen("../Matlab/Policy_P2.txt","w");
for (int z=0;z<states.size();z++){
    hash_code.push_back(generate_hash(states[z]));
    if (hash_code[z] == 506491){
            generate_hash2(states[z]);
    }
    fprintf(fid,"%d %d\n",hash_code[z],Policy[z]);
    //fprintf(mapping, "%d : %d %d %d %d %d %d\n",hash_code[z],states[z][0],states[z][1],states[z][2],states[z][3],states[z][4],states[5][0]);
fprintf(mapping, "%5d : %d %d %d %d %d %d\n",hash_code[z],states[z][0],states[z][1],states[z][2],states[z][3],states[z][4],states[z][5]);

    //cout << hash_code[z] << " : " ;
    //printVector(states[z]);
}

fclose(fid);
int tot=0;
for (int su=0;su<Policy.size();su++){
    tot+=Policy[su];

}
cout << (float) tot/(float)Policy.size() << endl;
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
