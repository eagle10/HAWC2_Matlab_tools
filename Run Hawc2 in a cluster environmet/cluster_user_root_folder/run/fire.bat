### Standard Output
#PBS -N fire
#PBS -o ./fire.out
### Standard Error
#PBS -e ./fire.err
### Maximum wallclock time format HOURS:MINUTES:SECONDS
#PBS -l walltime=01:30:00
### #PBS -l nodes=1:ppn=20
#PBS -l nodes=1:ppn=20
### Queue name
###  #PBS -q workq   #PBS -q xpresq  
#PBS -q workq


cd
cd $PBS_O_WORKDIR ### i.e. you go/are in the 'run' folder 
winefix
echo "current working dir (pwd):"
pwd 
echo ""
echo "Execute commands on scratch node"
cd /scratch/$USER/$PBS_JOBID
mkdir example_prjct
mkdir example_prjct/htc


cp $PBS_O_WORKDIR/../example_prjct/h2_m6.m ./example_prjct/.

echo ""
echo "following files are on the node before run (find .):"
find .
echo ""

echo "current working dir (pwd):"
pwd 

cd $PBS_O_WORKDIR  ### it is the 'run' folder 
cd
echo "current working dir (pwd):"
pwd 
cd example_prjct/htc

echo "--------------current time-launched bat file---------"
date +"%d-%m-%Y---%H-%M"
date +"%T"
echo "----------------------------------"
DIFF=$((30-12+1))
R=$(($(($RANDOM%$DIFF))+3))
echo "wait random seconds"
echo $R
sleep $R

echo "now will copy or move the htcs"
echo "--------------current time-start moving/copying htc files---------"
date +"%d-%m-%Y---%H-%M"
date +"%T"
echo "----------------------------------"

mv $(ls | head -n 200) /scratch/$USER/$PBS_JOBID/example_prjct/htc/
echo "current working dir (pwd):"
pwd 
cd /scratch/$USER/$PBS_JOBID
echo ""
echo "following files are on the node before run (find .):"
find .
echo ""


module load matlab/2016a

cd /scratch/$USER/$PBS_JOBID
cd example_prjct
echo "current working dir before matlab run (pwd):"
pwd
echo ""
matlab < h2_m6.m
wait

cd /scratch/$USER/$PBS_JOBID
cp -R ./example_prjct/fail_par_pool/*.htc $PBS_O_WORKDIR/../example_prjct/fail_par_pool/.
	
exit