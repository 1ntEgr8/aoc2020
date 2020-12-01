def part1(data):
    n = len(data)
    for i in range(n):
        for j in range(i,n):
            if data[i] + data[j] == 2020:
                return data[i]*data[j]

def part2(data):
    n = len(data)
    for i in range(n):
        for j in range(i,n):
            for k in range(j,n):
                if data[i] + data[j] + data[k] == 2020:
                    return data[i]*data[j]*data[k]

if __name__ == "__main__":
    with open('input') as f:
        data = [int(line.strip()) for line in f.readlines()]

    # ans = part1(data)
    ans = part2(data)
    print(ans)
