#! /bin/bash
# Expect protocol name as first parameter (tcp or udp)

# Define input and output file names
ThroughFile="../data/$1_throughput.dat";
PngName="../data/LB$1.png";

#getting the first and the last line of the file
HeadLine=($(head $ThroughFile --lines=1))
TailLine=($(tail $ThroughFile --lines=1))

#getting the information from the first and the last line
FirstN=${HeadLine[0]}
LastN=${TailLine[0]}

# TO BE DONE START

# Extract throughput values for first and last message sizes
FirstT=${HeadLine[1]}
LastT=${TailLine[1]}

# Calculate bandwidth and latency parameters using bc
# Using the system: T(N1) = N1/(L + N1/B) and T(N2) = N2/(L + N2/B)
# We can solve for B and L

# T(N) * D(N) = N --> D(N) = N / T(N)

d1=$(echo "scale=9; d1=(($N1) / ($TN1)); d1" | bc)
d2=$(echo "scale=9; d2=(($N2) / ($TN2)); d2" | bc)
b=$(echo "scale=9; b=((($N2) - ($N1)) / ($d2 - $d1)); b" | bc)
l0=$(echo "scale=9; l0=(($d1 * ($N2) - $d2 * ($N1)) / (($N2) - ($N1))); l0" | bc)
)

echo "Calculated parameters: Latency=$Latency, Bandwidth=$Band"
# TO BE DONE END


# Plotting the results
gnuplot <<-eNDgNUPLOTcOMMAND
  set term png size 900, 700
  set output "${PngName}"
  set logscale x 2
  set logscale y 10
  set xlabel "msg size (B)"
  set ylabel "throughput (KB/s)"
  set xrange[$FirstN:$LastN]
  lbmodel(x)= x / ($Latency + (x/$Band))

# TO BE DONE START
  set title "Throughput vs Message Size for $1 Protocol"
  set grid
  set key bottom right

# Plot the actual data points
  plot "$ThroughFile" using 1:2 title "Measured throughput" with linespoints pt 7, \
      lbmodel(x) title "LB model (L=$Latency, B=$Band KB/s)" with linespoints lt 1
# TO BE DONE END

  clear

eNDgNUPLOTcOMMAND
