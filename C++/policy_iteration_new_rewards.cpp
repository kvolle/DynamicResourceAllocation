#include <iostream>
#include <cstdio>
#include <cmath>
#include <vector>
#include <algorithm>
#include <time.h>

using namespace std;

const float discount = 0.90;
const int r = 15;
const int t = 5;
const double targetPriority[] = {1,1,1,1,1};//{20,50,40,10,30};
const double threshold[] = {0.83,0.93,0.97,0.59,0.93};
const double robot_effectiveness = 0.70;
const double attrition_rate = 0.15;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
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
double R(vector<int> state){
    double reward = 0;
    // Calculate the Pk on each target;
    double tmp_pk;
    double pk_vector[5];
    for (int t=1;t<state.size();t++){
        tmp_pk=1;
        for (int a=0;a<state[t];a++){
            tmp_pk*=(1-robot_effectiveness+robot_effectiveness*attrition_rate);
        }
        reward += (1-tmp_pk-threshold[t-1]);
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
int main(){
   vector<int> state, new_state, tmp_state,Policy;
   vector<vector<int> > states;
   vector<float> U;
   int total;
   bool unchanged = false;
   unsigned long tmp;
   unsigned long dim =  (unsigned long)pow(r+1,t);
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
    // Arbitrarily set initial Policy
    srand (time(NULL));
    U.resize(states.size(),0);

    for (int i=0;i<states.size();i++){
        tmp_state = states[i];
        Policy.push_back(*min_element(tmp_state.begin()+1,tmp_state.end()));
        //Policy.push_back(int (rand()%t));
        U[i]=0;
    }
    int counter =0;
    float q;
    vector<int> location_tmp;
    vector<vector<int> > location_vector;
    vector<vector<int> > prediction_tmp;
    vector<vector<vector<int> > > prediction_vector;
    cout << "Pre-calculations" << endl;
    for (int s=0;s<states.size();s++){
        for (int a=0;a<t;a++){
            tmp_state = prediction(states[s],a);
            prediction_tmp.push_back(tmp_state);
            location_tmp.push_back(locate(states,tmp_state));
        }
        prediction_vector.push_back(prediction_tmp);
        location_vector.push_back(location_tmp);
        prediction_tmp.clear();
        location_tmp.clear();
    }
    cout << "Solver" << endl;
    do{
            counter+=1;
            unchanged = true;
            for (int s=0;s<states.size();s++){
                //U[s] = sum_s'[P(s'|s,a)(R(s,a,s')+discount*U[s'])]
                tmp_state.clear();
                tmp_state=prediction_vector[s][Policy[s]];
                U[s] = R(tmp_state)+discount*U[location_vector[s][Policy[s]]];
            }
            for (int s=0;s<states.size();s++){
                for (int a=0;a<t;a++){
                    //q = sum_s'[P(s'|s,a)(R(s,a,s')+discount*U[s'])]
                    //tmp_state.clear();
                    tmp_state = prediction_vector[s][a];
                    q = R(tmp_state)+discount*U[location_vector[s][a]];
                    if (q >U[s]){
                        Policy[s] = a;
                        U[s] = q;
                        unchanged = false;
                    }
                }
            }
    }while(!unchanged);
    cout << counter << endl;
    vector<unsigned long int> hash_code;
    FILE * mapping;
    mapping = fopen("../Matlab_OO/Mapping.txt","w");
    FILE * fid;
    fid = fopen("../Matlab_OO/Policy_P2.txt","w");
    for (int z=0;z<states.size();z++){
        hash_code.push_back(generate_hash(states[z]));
        fprintf(fid,"%d %d\n",hash_code[z],Policy[z]);
        fprintf(mapping, "%5d : %d %d %d %d %d %d : %d\n",hash_code[z],states[z][0],states[z][1],states[z][2],states[z][3], states[z][4],states[z][5], Policy[z]);
    }
    fclose(fid);
    fclose(mapping);
}
