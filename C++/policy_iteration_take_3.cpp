#include <iostream>
#include <cstdio>
#include <cmath>
#include <vector>
#include <algorithm>
#include <time.h>

using namespace std;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
class mdp_solver
{
    vector<int> state, new_state, tmp_state,Policy;
    vector<vector<int> > states;
    vector<float> U;
    int total;
    //cout << "\nTotal: "<< dim*t;
    //cout << "\n Good: "<< states.size() << endl;
    bool unchanged = false;
public:
    mdp_solver(){
    const float discount = 0.90;
    const int r = 15;
    const int t = 5;
    const int targetSize[] = {2,5,4,1,3};
    unsigned long dim =  (unsigned long)pow(r+1,t);
    }

    ~mdp_solver(){
    vector<unsigned long int> hash_code;
    FILE * mapping;
    mapping = fopen("../Matlab_OO/Mapping.txt","w");
    FILE * fid;
    fid = fopen("../Matlab_OO/Policy_P2.txt","w");
    for (int z=0;z<states.size();z++){
        hash_code.push_back(generate_hash(states[z]));
        if (hash_code[z] == 506491){
                generate_hash2(states[z]);
        }
        fprintf(fid,"%d %d\n",hash_code[z],Policy[z]);
        //fprintf(mapping, "%d : %d %d %d %d %d %d\n",hash_code[z],states[z][0],states[z][1],states[z][2],states[z][3],states[z][4],states[5][0]);
    fprintf(mapping, "%5d : %d %d %d %d : %d\n",hash_code[z],states[z][0],states[z][1],states[z][2],states[z][3], Policy[z]);
    }
    fclose(fid);
    fclose(mapping);
}
};


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
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int main(){
   mdp_solver solver;
   unsigned long tmp;
    for (int a=0;a<t;a++){
        for (int i=0;i<dim;i++){
            tmp = i;

            total = 0;
            for (int j=0;j<t+1;j++){
                solver.state.push_back(tmp%(r+1));
                tmp = tmp/(r+1);
                solver.total = solver.total + solver.state.back();
            }
            if (total==r){
                if (solver.state[a] > 0){
                    solver.state.insert(solver.state.begin(),a);
                    solver.states.push_back(solver.state);
                }
            }
            solver.state.clear();

        }
    }
    // Print out all of the allowable states
    // Clean up artifact element at end of state vector
    for (int i=0;i<solver.states.size();i++){
    //	cout << i << ": ";
        solver.states[i].erase(solver.states[i].end()-1);
        //printVector(states[i]);
    }

    // Arbitrarily set initial Policy
    srand (time(NULL));
    solver.U.resize(solver.states.size(),0);
    for (int i=0;i<solver.states.size();i++){
        solver.Policy.push_back(int (rand()%t));
        solver.U[i]=0;
    }
    int counter =0;
    float q;
    do{
            counter+=1;
            cout << counter << endl;
            solver.unchanged = true;
            for (int s=0;s<solver.states.size();s++){
                //U[s] = sum_s'[P(s'|s,a)(R(s,a,s')+discount*U[s'])]
                solver.tmp_state.clear();
                solver.tmp_state=prediction(solver.states[s],solver.Policy[s]);
                solver.U[s] = R(solver.tmp_state)+discount*U[locate(solver.states,solver.tmp_state)];
            }
            for (int s=0;s<solver.states.size();s++){
                for (int a=0;a<t;a++){
                    //q = sum_s'[P(s'|s,a)(R(s,a,s')+discount*U[s'])]
                    // This next if statement is kinda fishy
                    //test asap and remove if doesn't work or doesn't help
                    if (solver.states[a+1]<targetSize[a]){
                        solver.tmp_state.clear();
                        solver.tmp_state = prediction(solver.states[s],a);
                        q = R(solver.tmp_state)+discount*U[locate(solver.states,solver.tmp_state)];
                        if (q >solver.U[s]){
                            solver.Policy[s] = a;
                            solver.U[s] = q;
                            solver.unchanged = false;
                        }
                    }
                }
            }
    }while(!solver.unchanged);

/*
    int tot=0;
    for (int su=0;su<Policy.size();su++){
        tot+=Policy[su];

    }
    cout << (float) tot/(float)Policy.size() << endl;
    */
}
