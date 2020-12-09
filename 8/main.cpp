#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;

enum Op {
    ACC,
    JMP,
    NOP
};

class Instruction {
    private:
        bool executed;
        int value;
        Op op;

    public:
        Instruction();

        Instruction(string s) {
            string op_str = s.substr(0,3);
            
            if (op_str == "acc") {
                op = ACC;
            } else if (op_str == "jmp") {
                op = JMP;
            } else {
                op = NOP;
            }
            
            value = stoi(s.substr(4)); 
        }

        bool execute(int& pc, int &acc) {
            if (executed) return false;

            switch (op) {
                case ACC: acc += value; pc++; break;
                case JMP: pc += value; break; // value will be an offset here
                case NOP: pc++; break;
            }

            executed = true;
            return executed;
        }

        Op getOp() {
            return op;
        }

        void setOp(Op newOp) {
            op = newOp;
        }

        void reset() {
            executed = false;
        }
};

int runProgram(vector<Instruction>& instructions) {
    int pc = 0, acc = 0;
    int n = instructions.size();

    while (pc < n && instructions[pc].execute(pc,acc));
    
    if (pc < n) return -1;
    return acc;
}

void part_1(vector<Instruction>& instructions) {
    int pc = 0, acc = 0;
    while (instructions[pc].execute(pc,acc));
}

void part_2(vector<Instruction>& instructions) {
    Op op;
    int result;
    for (int i = 0; i < instructions.size(); i++) {
        op = instructions[i].getOp();
        if (op == ACC) continue;
        // switch the operation
        instructions[i].setOp(op == NOP ? JMP : NOP);

        result = runProgram(instructions);
        
        if (result != -1) break;
        // revert the switch
        instructions[i].setOp(op);

        // reset program
        for (int i = 0; i < instructions.size(); i++) {
            instructions[i].reset();
        }
    }
    cout << "accumulator: " << result << endl;
}


int main() {
    // read instructions
    vector<Instruction> instructions;
    string line;

    ifstream file("./input.txt");
    while (getline(file,line)) {
        instructions.push_back(Instruction(line));
    }
    
    // part_1(instructions); 
    part_2(instructions);
    
    return 0;
}
