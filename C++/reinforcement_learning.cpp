#include <iostream>
#include <vector>
#include <time.h>
#include <cmath>
#include <algorithm>

using namespace std;

const int robots = 15;
const int targets = 5;
const int targetSize[] = {2,5,4,1,3};


int main(int argc, char *argv[]){
    srand (time(NULL));
    // Generate n random states
    int n = 1000;
    vector<double> tmp_state;
    vector<vector<double> > random_states;
    for (int i=0;i<n;i++){
        tmp_state.push_back(floor(rand()*targets));
        for (int t=0;t<5;t++)
            tmp_state.push_back(rand());
        random_states.push_back(tmp_state);
        tmp_state.clear();
    }
    cout << random_states.size() << endl;
return 0;
}
