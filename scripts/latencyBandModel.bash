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
FirstT=${HeadLine[1]}
LastT=${TailLine[1]}

# Calcolo banda (Band) e latenza (Latency)
#bc -l serve per i calcoli con virgola mobile
d1=$(echo "$FirstN / $FirstT" | bc -l)
d2=$(echo "$LastN / $LastT" | bc -l)

Band=$(echo "($LastN - $FirstN) / ($d2 - $d1)" | bc -l)
Latency=$(echo "($d1 * $LastN - $d2 * $FirstN) / ($LastN - $FirstN)" | bc -l)
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
  Latency = $Latency
  Band = $Band
# TO BE DONE END

  clear

eNDgNUPLOTcOMMAND
