library(expm)

# Disable scientific notation - needed for part 2
options(scipen = 999)

# Lanternfish take this amount of days to reproduce
time_to_repro <- 7

# Newborn lanternfish need to wait an extra amount of days
newborn_wait_time <- 2

# For part 1: 80
# For part 2: 256
days_elapsed <- 256

# Size of timer counts array/transition matrix
N <- time_to_repro + newborn_wait_time

# Range of possible timer values
time_range <- 0:(N - 1)

initial_timers <- scan(file = "stdin", sep = ",")

timer_counts <- table(factor(initial_timers, levels = time_range))

# Build transition matrix:
# Multiplying the counts array by this matrix provides
# the new timer counts after 1 day
transition <- matrix(0, N, N)

# After 1 day, every positive timer decrements
for (i in 1:(N-1)) {
  transition[i, i + 1] <- 1
}

# When timer reaches 0, the timer resets...
transition[time_to_repro, 1] <- 1

#... and a new lanternfish is born
transition[N, 1] <- 1

# Use matrix exponentiation to get a transition
# matrix for all days elapsed
total_transition <- transition %^% days_elapsed

sum(total_transition %*% timer_counts)
