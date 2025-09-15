#!/bin/bash

# Minimization for explicit solvent

# Program to run
SANDER="pmemd.cuda"


# ========================================================= change these names ==============================
# Topology file
TOP=../prepin.prmtop
# Starting coordiantes
CRD=../prepin.inpcrd
# ===========================================================================================================

# Number of solute residues (assumes start at 1)
# Change last residue number based on 'prepin.pdb'
S=1
B=276
# Solute backbone mask
BACKBONEMASK=":$B-$S@H,N,CA,HA,C,O" # Protein
#BACKBONEMASK=":1-$S@P,O5',C5',C4',C3',O3'" # DNA
# Temperature
T="310.0"
# 1K step Steepest Descent Minimization with strong restraints on heavy atoms, no shake
cat > step1.in <<EOF
Min explicit solvent heavy atom rest no shake
&cntrl
  imin = 1, ntmin = 2, maxcyc = 2000,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  ntc = 1, ntf = 1, ntb = 1, cut = 8.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 5.0,
&end
EOF

# NTV MD with strong restraints on heavy atoms, shake, dt=.001, 15 ps
cat > step2.in <<EOF
MD explicit solvent heavy atom rest shake dt 0.001
&cntrl
  imin = 0, nstlim = 30000, dt=0.001,
  ntx = 1, irest = 0, ig = -1,
  ntwx = 1500, ioutfm = 1, ntpr = 50, ntwr = 500,
  iwrap = 1, nscm = 0,
  ntc = 2, ntf = 1, ntb = 1, cut = 8.0,
  ntt = 1, tautp = 0.5, temp0 = $T, tempi = $T,
  ntp = 0, taup = 0.5,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 5.0,
&end
EOF

# Steepest Descent Minimization with relaxed restraints on heavy atoms, no shake
cat > step3.in <<EOF
Min explicit solvent relaxed heavy atom rest no shake
&cntrl
  imin = 1, ntmin = 2, maxcyc = 2000,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  ntc = 1, ntf = 1, ntb = 1, cut = 8.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 2.0,
&end
EOF

# Steepest Descent Minimization with minimal restraints on heavy atoms, no shake
cat > step4.in <<EOF
Min explicit solvent minimal heavy atom rest no shake
&cntrl
  imin = 1, ntmin = 2, maxcyc = 2000,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  ntc = 1, ntf = 1, ntb = 1, cut = 8.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 0.1,
&end
EOF

# Steepest Descent Minimization with no restraints, no shake
cat > step5.in <<EOF
Min explicit solvent no heavy atom res no shake
&cntrl
  imin = 1, ntmin = 2, maxcyc = 2000,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  ntc = 1, ntf = 1, ntb = 1, cut = 8.0,
  igb = 0, saltcon = 0.0,
  ntr = 0,
&end
EOF

# NTP MD with shake and low restraints on heavy atoms, 5 ps dt=.001
cat > step6.in <<EOF
MD explicit solvent heavy atom low rest shake dt 0.001
&cntrl
  imin = 0, nstlim = 10000, dt=0.001,
  ntx = 1, irest = 0, ig = -1,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  iwrap = 1, nscm = 0,
  ntc = 2, ntf = 1, ntb = 2, cut = 8.0,
  ntt = 1, tautp = 1.0, temp0 = $T, tempi = $T,
  ntp = 1, taup = 1.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 1.0,
&end
EOF

# NTP MD with shake and minimal restraints on heavy atoms
cat > step7.in <<EOF
MD explicit solvent heavy atom minimal rest shake dt 0.001, 10 ps, dt=.001
&cntrl
  imin = 0, nstlim = 10000, dt=0.001,
  ntx = 5, irest = 1,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  iwrap = 1, nscm = 0,
  ntc = 2, ntf = 1, ntb = 2, cut = 8.0,
  ntt = 1, tautp = 1.0, temp0 = $T, tempi = $T,
  ntp = 1, taup = 1.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = ':$B-$S & !@H=', restraint_wt = 0.5,
&end
EOF

# NTP MD with shake and minimal restraints on backbone atoms, dt=0.001, 10 ps
cat > step8.in <<EOF
MD explicit solvent heavy atom minimal BB rest shake dt 0.001
&cntrl
  imin = 0, nstlim = 20000, dt=0.001,
  ntx = 5, irest = 1,
  ntwx = 1000, ioutfm = 1, ntpr = 50, ntwr = 500,
  iwrap = 1, nscm = 0,
  ntc = 2, ntf = 1, ntb = 2, cut = 8.0,
  ntt = 1, tautp = 1.0, temp0 = $T, tempi = $T,
  ntp = 1, taup = 1.0,
  igb = 0, saltcon = 0.0,
  ntr = 1, restraintmask = "$BACKBONEMASK", restraint_wt = 0.5,
&end
EOF

# NTP MD with shake and no restraints, dt=0.002, 200 ps
cat > step9.in <<EOF
MD explicit solvent heavy atom no rest shake dt 0.002
&cntrl
  imin = 0, nstlim = 100000, dt=0.002,
  ntx = 5, irest = 1,
  ntwx = 5000, ioutfm = 1, ntpr = 10000, ntwr = 10000,
  iwrap = 1, nscm = 1000,
  ntc = 2, ntf = 1, ntb = 2, cut = 8.0,
  ntt = 1, tautp = 1.0, temp0 = $T, tempi = $T,
  ntp = 1, taup = 1.0,
  igb = 0, saltcon = 0.0,
  ntr = 0,
&end
EOF

START="`date +%s.%N`"

# Minimization Phase
for RUN in step1 step2 step3 step4 step5 ; do
 echo "------------------------"
 echo "Minimization phase: $RUN"
 echo "------------------------"
 if [[ ! -f $RUN.rst7 ]]; then
     echo "File -- $RUN.rst7 -- does not exists. Running job..."
     $SANDER -O -i $RUN.in -p $TOP -c $CRD -ref $CRD -o $RUN.out -x $RUN.nc -r $RUN.rst7 -inf $RUN.mdinfo
 else
     echo "File -- $RUN.rst7 -- exists.  Checking the next step."
 fi
 echo ""
 CRD="$RUN.rst7"
done

# Equilibration phase - reference coords are last coords from minimize phase
REF=$CRD
for RUN in step6 step7 step8 step9 ; do

 echo "------------------------"
 echo "Equilibration phase: $RUN"
 echo "------------------------"
 if [[ ! -f $RUN.rst7 ]]; then
     echo "File -- $RUN.rst7 -- does not exists. Running job..."
     $SANDER -O -i $RUN.in -p $TOP -c $CRD -ref $REF -o $RUN.out -x $RUN.nc -r $RUN.rst7 -inf $RUN.mdinfo
 else
     echo "File -- $RUN.rst7 -- exists.  Checking the next step."
 fi
  echo ""
  CRD="$RUN.rst7"

done

sed -i 's/0.3000000E+02/0.0000000E+00/g' step9.rst7

STOP="`date +%s.%N`"
TIMING=`echo "scale=4; $STOP - $START;" | bc`
echo "$TIMING seconds."
echo ""

exit 0
