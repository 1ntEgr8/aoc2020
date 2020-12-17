import java.io.File

fun part_1(earliest: Int, buses: List<Int>) {
    var waitTime: Int
    var id = 0
    var min = Int.MAX_VALUE

    // compute result 
    for (bus in buses) {
        if (bus == 0) continue

        waitTime = ((earliest/bus)+1)*bus-earliest
        
        if (waitTime < min) {
            min = waitTime
            id = bus
        }
    }
    
    println(id*min)
}

fun part_2(buses: List<Int>) {
    val rems = buses.indices
        .filter { i -> buses[i] != 0 }
        .map { i -> 
            if (i > buses[i]) {
                buses[i] - (i % buses[i])
            } else {
                buses[i] - i
            }
        }
        .map{ it.toLong() }
    val nums = buses.filter { it != 0 }.map{it.toLong()}
    
    println(chineseRemainder(nums, rems))
}

fun chineseRemainder(nums: List<Long>, rems: List<Long>): Long {
    val N = nums.reduce { acc,n -> acc * n }
    var result = 0L
    
    for (i in nums.indices) {
        val ai = rems[i]
        val ni = nums[i]
        val bi = N / nums[i]
        val (_, si, _) = extendedEuclid(bi, ni)
        result += (ai * bi * si)
    }
    
    if (result < 0) {
        return (-result + N) % N
    }

    return (result%N)
}

data class ExtendedEuclidResult(val gcd: Long, val x: Long, val y: Long)
fun extendedEuclid(a: Long, b: Long): ExtendedEuclidResult {
    if (a == 0L) {
        return ExtendedEuclidResult(b, 0, 1)
    }

    val (gcd, x, y) = extendedEuclid(b%a, a)

    return ExtendedEuclidResult(gcd, y-(b/a)*x, x)
}

fun main() {
    // grab input
    val lines = File("input.txt").readLines()
    val earliest = lines[0].toInt()
    val buses = lines[1]
        .split(",")
        .map { if (it == "x") 0 else it.toInt() }
    
    // part_1(earliest, buses)
    part_2(buses)
}
