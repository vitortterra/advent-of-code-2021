using LinearAlgebra

struct Line
    x1 :: Int
    y1 :: Int
    x2 :: Int
    y2 :: Int
end

function process_line(acc, line)
    # Adding 1 to positions because arrays in Julia are 1-indexed
    x1, y1, x2, y2 = line .+ 1

    # Horizontal line (or single point)
    if y1 == y2
        x1, x2 = minmax(x1, x2)
        push!(acc[1], Line(x1, y1, x2, y2))

    # Vertical line
    elseif x1 == x2
        y1, y2 = minmax(y1, y2)
        push!(acc[2], Line(x1, y1, x2, y2))

    # Diagonal line
    elseif x2 - x1 == y2 - y1
        (x1, y1), (x2, y2) = minmax((x1, y1), (x2, y2))
        push!(acc[3], Line(x1, y1, x2, y2))

    # Antidiagonal line
    elseif x2 - x1 == y1 - y2
        (x1, y1), (x2, y2) = minmax((x1, y1), (x2, y2))
        push!(acc[4], Line(x1, y1, x2, y2))
    else
        error("Invalid line: $line")
    end

    return acc
end

function diag_cumsum(m)
    N = size(m, 1)

    # Calculate the cumulative sum of each diagonal...
    cumdiags = Dict(i => cumsum(diag(m, i), dims=1) for i = -N:N)

    # ... then put them back together in a matrix
    return diagm(cumdiags...)
end

function antidiag_cumsum(m)
    # Flipping the matrix "turns" antidiagonals into diagonals
    rev = reverse(m, dims=1)
    return reverse(diag_cumsum(rev), dims=1)
end


raw_lines = readlines() 
parse_line(line) = map(n -> parse(Int, n), split(line, r",| -> "))
parsed_lines = map(parse_line, raw_lines)

# Adding 1 because of 1-indexed arrays, 
# then another 1 because one extra position is required
# when computing cumulative sums below (finish + 1)
N = maximum(maximum(parsed_lines)) + 2

hor, vert, diagn, antidiag = reduce(
    process_line, 
    parsed_lines; 
    init=([], [], [], [])
)

# The cumulative sum of these matrices (in the 
# appropriate direction) will give the number
# of lines at each point, for each direction
hor_lines_at = zeros(Int, N, N)
vert_lines_at = zeros(Int, N, N)
diag_lines_at = zeros(Int, N, N)
antidiag_lines_at = zeros(Int, N, N)

for l in hor
    hor_lines_at[l.y1, l.x1] += 1
    hor_lines_at[l.y2, l.x2 + 1] -= 1
end

for l in vert
    vert_lines_at[l.y1, l.x1] += 1
    vert_lines_at[l.y2 + 1, l.x2] -= 1
end

for l in diagn
    diag_lines_at[l.y1, l.x1] += 1
    diag_lines_at[l.y2 + 1, l.x2 + 1] -= 1
end

for l in antidiag
    antidiag_lines_at[l.y1, l.x1] += 1
    if l.y2 > 1
        antidiag_lines_at[l.y2 - 1, l.x2 + 1] -= 1
    end
end

lines_at_p1 = (
    cumsum(hor_lines_at, dims=2) 
    + cumsum(vert_lines_at, dims=1)
)

lines_at_p2 = (
  lines_at_p1 
    + diag_cumsum(diag_lines_at) 
    + antidiag_cumsum(antidiag_lines_at)
)

println("Part 1: ", count(elem -> elem >= 2, lines_at_p1))
println("Part 2: ", count(elem -> elem >= 2, lines_at_p2))
