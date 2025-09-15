#!/usr/bin/perl -w

#This program is a generalized method for computing a multiple nanosecond MD trajectory 

##########################################################################################
#THE FOUR VARIABLES BELOW WILL NEED TO BE CHANGED TO REFLECT THE DETAILS OF THE SIMULATION

$probase = "md_prod1";                     # Output basename for production MD period

$prodin = "prod1.in";		        # Name of sander.in file for production MD
$prodstart = "prod1.in.start";		# Name of sander.in file for production MD

$nstart = 1;                          # MD block to start with; 
                                       #   if 1, starts a new run
                                       #   if some other number, starts a at that block
                                       #   NOTE: assumes previous restart file is present
                                       

$nend = 10;                  # Number of production MD runs ($max * 100 = ns)
#$number_of_runs = 15;                  # Number of production MD runs ($max * 100 = ns)
                                       #   runs are performed in 100 ns blocks
                                       #   so for $max = 10, (10 * 100 = 1000 ns total)


##########################################################################################
#INPUT FILES; relative paths to minimized files
$start = "../Minimization/step9.rst7"; # CHANGE TO YOUR PATH
$top = "../Minimization/prepinHMR.prmtop"; # CHANGE TO YOUR PATH

#PATH TO THE pmemd.cuda PROGRAM
$pmemd = "pmemd.cuda";


##########################################################################################
#Perform production dynamics with conditions set by input file

for ($i=$nstart; $i<=$nend; $i++) {
        $num = number($i);
        #$num = $i;

        if ($i == 1) {
	        $xyzin = $start;
	        $produse = $prodstart;
	    } else {
	    	$tempnum = number($i-1);
	    	$xyzin = "${probase}_${tempnum}.rst";
	    	$produse = $prodin;
	    } 
	    
        $out = "PTR_${num}.out";
        $crd = "${probase}_${num}.nc";
        $xyz = "${probase}_${num}.rst";

        $command = "$pmemd -O -i $produse -c $xyzin -p $top -o $out -x $crd -r $xyz -inf md_prod1.mdinfo";
	print("$command \n");
        system($command);
}



##########################################################################################
#a routine to fill in 0's in numbers

sub number {
        my($i) = @_;
        my($num);

        if ($i < 10) {
            $num = "00$i";
        } elsif($i < 100) {
            $num = "0$i";
        } else {
            $num = $i;
        }

        return($num);
}

