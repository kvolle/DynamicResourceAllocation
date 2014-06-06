#include <iostream>
#include <cstdio>
#include <cmath>
#include <vector>
#include <algorithm>
#include <time.h>

using namespace std;

const int r = 15;
const int t = 5;
const int targetSize[] = {2,5,4,1,3};
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void printVector(vector <int> &vec){

for (int i=0;i<vec.size();i++){
	printf("%2d ",vec[i]);
}
printf("\n");
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int generate_hash(vector<int> state){

    int tmp;
    tmp = 0;
    for (int i =1; i<state.size();i++){
        tmp += ceil(state[i]*pow(r,i-1));
    }
    tmp += ceil(state[0]*pow(r,t));
    return tmp;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vector<vector<int> > back_action(vector<int>state){
    vector<vector<int> > presults;
    vector<int> tmp;
    for (int init_target=0;init_target<t;init_target++){
        if ((init_target!=state[0])&&(true)){
            tmp.push_back(init_target);
            for (int i=1;i<state.size();i++){
                tmp.push_back(state[i]);
            }
            tmp[state[0]+1] = tmp[state[0]+1]-1;
            tmp[init_target+1] = tmp[init_target+1]+1;
            presults.push_back(tmp);
            tmp.clear();
        }
    }
    return presults;
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bool unseen(int hash, vector<int> seen_hash){
    for (int i=0;i<seen_hash.size();i++){
        if (hash == seen_hash[i])
            return false;
    }
    return true;
}

int main(){
    vector<vector<int> > frontier;
    vector<vector<int> > seen;
    vector<int> frontier_hash;
    vector<int> seen_hash;
    vector<int> policy;
    int tmp_hash;
    vector<int> tmp_state;

    // Generate all ideal states
    for (int i=0;i<t;i++){
        tmp_state.push_back(i);
        for (int j=0;j<t;j++)
            tmp_state.push_back(targetSize[j]);
        frontier.push_back(tmp_state);
        seen.push_back(tmp_state);
        tmp_hash = generate_hash(tmp_state);
        frontier_hash.push_back(tmp_hash);
        seen_hash.push_back(tmp_hash);
        policy.push_back(NAN);
        tmp_state.clear();

    }
    vector<vector<int> > new_frontier;
    vector<int> new_frontier_hash;
    int counter = 0;
    vector<vector<int> > presults;
    do{
    cout << frontier.size() << "   " << seen.size() << endl;
    new_frontier.clear();
    new_frontier_hash.clear();

    for (int f=0;f<frontier.size();f++){
        presults = back_action(frontier[f]);
        printVector(frontier[f]);
        for (int p=0;p<presults.size();p++){
            tmp_state = presults[p];
            tmp_hash = generate_hash(tmp_state);
            if (unseen(tmp_hash,seen_hash)){
                seen.push_back(tmp_state);
                seen_hash.push_back(tmp_hash);
                policy.push_back(frontier[f][0]);
                new_frontier.push_back(tmp_state);
                new_frontier_hash.push_back(tmp_hash);
                cout << "NEW STATE" << endl;
            }

            tmp_state.clear();
        }
    }
    frontier.swap(new_frontier);
    frontier_hash.swap(new_frontier_hash);
    new_frontier.clear();
    new_frontier_hash.clear();
    ++counter;
    }while((frontier.size()>0)&&(counter<7));

    FILE * fid;
    FILE * fid2;
    fid = fopen("../Matlab_OO/back_mapping.txt","w");
    fid2 = fopen("../Matlab_OO/back_policy.txt","w");

    for (int q=0;q<seen.size();q++){
        fprintf(fid,"%d : %d %d %d %d %d %d\n",seen_hash[q],seen[q][0],seen[q][1],seen[q][2],seen[q][3],seen[q][4],seen[q][5]);
        fprintf(fid2,"%d | %d\n",policy[q],seen_hash[q]);
    }

return 1;
}
