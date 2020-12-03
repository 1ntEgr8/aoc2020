const fs = require("fs");

let currentLocation = 0; // which column?

const trees = fs.readFileSync("./input.txt","utf-8").split("\n");
const slopes = [[1,1],[3,1],[5,1],[7,1],[1,2]]

function findNumTreesEncountered(slope) {
    const [dx,dy] = slope; 
    let currentLocation = 0;
    let numEncountered = 0;

    for (let i = 0; i < trees.length; i += dy) {
        if (trees[i][currentLocation] == "#") numEncountered++;
        currentLocation = (currentLocation + dx) % trees[i].length;
    }
    
    return numEncountered;
}

// findNumTreesEncountered([3,1])
console.log(slopes.map(findNumTreesEncountered).reduce((acc,val)=>acc*val,1));
