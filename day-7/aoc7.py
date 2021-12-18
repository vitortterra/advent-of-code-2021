from collections import Counter
from statistics import median


def fuel_cost_p1(positions, dest):
    return sum([abs(x - dest) for x in positions])


def get_dest_p2(positions):
    # Inspired by https://math.stackexchange.com/a/1024462
    # Looking for x that has the "derivative" of fuel_cost_p2
    # closer to zero. The "derivative" of c is:
    # c'(x) = nx - sum(p) - 1/2 sum(sign(x - p))
    # for every position p

    n = len(positions)
    s = sum(positions)
    min_cost = float('inf')
    x_min = 0
    count = Counter(positions)
    total_seen = 0

    for x in range(max(positions)):
        # sum(sign(x - p)) is the number of positions smaller than x
        # minus the number of positions greater than x
        # In other words:
        # sum(sign(x-p)) = total_seen - (n - total_seen - count[x])
        # After some algebra, multiplying by 1/2 and adding to nx - s,
        # we get the cost function below

        cost = abs(n * x - s + total_seen + 0.5 * (count[x] - n))
        if cost < min_cost:
            min_cost = cost
            x_min = x
            total_seen += count[x]
        else:
            # Cost function is convex, so we can stop
            # searching when it starts growing
            break

    return x_min


def fuel_cost_p2(positions, dest):
    trig = lambda x: int((x * (x + 1)) / 2)

    return sum([trig(abs(x - dest)) for x in positions])


positions = [int(x) for x in input().split(",")]

dest_p1 = int(median(positions))
dest_p2 = get_dest_p2(positions)

print(f"Part 1: {fuel_cost_p1(positions, dest_p1)}")
print(f"Part 2: {fuel_cost_p2(positions, dest_p2)}")
