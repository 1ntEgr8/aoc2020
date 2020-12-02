#include<stdio.h>

struct requirements {
    int min;
    int max;
    char ch;
};


// returns 
//  1 if pwd validates against requirements
//  0 otherwise
int validate_pt1(char *pwd, struct requirements *r) {
    size_t i = 0;
    int num_ch = 0;

    while (pwd[i]) {
        if (pwd[i++] == r->ch) num_ch++;
    }

    return num_ch >= r->min && num_ch <= r->max;
}

int validate_pt2(char *pwd, struct requirements *r) {
    return pwd[r->min-1]==r->ch ^ pwd[r->max-1]==r->ch; 
}


int main() {
    char pwd[50];
    struct requirements r;
    int num_valid = 0;
    
    FILE *handle = fopen("input.txt","r"); 
    if (!handle) printf("[error]: failed to read file\n");
    
    while(1) {
        int ok = fscanf(handle,"%d-%d %c: %s", &r.min, &r.max, &r.ch, pwd);
        if (ok == EOF) break;
        // if (validate_pt1(pwd,&r)) num_valid++;
        if (validate_pt2(pwd,&r)) num_valid++;
    }
    
    printf("num of valid passwords = %d\n", num_valid);
    
    return 0;
}
