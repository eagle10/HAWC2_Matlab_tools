How to run HAWC2 and many htcs in a cluster guide

It requires that a Matlab is installed in the cluster. You do not need to have Matlab installed locally in your laptop

The setup has as example a simulation of DTU 10MW rwt (http://www.hawc2.dk/Download/HAWC2-Model/DTU-10-MW-Reference-Wind-Turbine)

1) Copy the content of 'cluster_user_root_folder' under './cluster/yourUserName' directory
2) Put inside the 'H2' folder all the necessary HAWC2 program files (hawc2 executable, dlls, etc, http://www.hawc2.dk/download) and the turbulence x64 generator files (mann_turb_x64.exe,mann_x64.dll,resourse_x64.dat, http://www.hawc2.dk/download/pre-processing-tools) since the x64 turbulence generator is used to generate the boxes in the cluster
3) Put also inside the 'H2' folder the turbine folders like 'data', 'control', 'hydro' etc but not the htc folder !
4) In the htc folder put your htc files you want to run. (htc files are deleted when they are launched, so keep a copy in your local laptop if necessary)
5) In order to launch the  'fire.bat' script: Open a putty terminal, login in the cluster navigate to folder 'run' (command: cd run) and execute command: qsub fire.bat
6) You are done. When the simulation finishes the HAWC2 results will put in 'res' and the logfiles in logfiles folders respectively


Optional
1) Edit with a txt editor the 'h2_m6.m' file, put the name of your hawc2 executable in variable 'h2_exe_name' (e.g. h2_exe_name = 'h2_12p6';). This should be the same with the name of your hawc2 executable name!!! You can also change flag arguments such as: save_turb_flag = 0; if is set to 1 it will copy back the generated turbulence boxes, otherwise they are deleted after the simulation is finished
2) If you want to change the 'example_prjct' folder text. Then modify the 'fire.bat' with a text editor  and put the name of your project folder everywhere in the file. You can also modify the lines 7 (walltime) and 12 (Queue name) based on your needs. With the commands inside the 'fire.bat' file you occupy a node and for each cpu (e.g. 20 cpus in one node) within the node an instance of hawc2 will run. When the simulation in any cpu ends, the results and logfiles are copied back and automatically a new simulation will start in that cpu. The whole script will terminate when all htc files are run. Finally you can change in line 59 the number of htcs that you want to run in one node (default 200)
3) You can check if the file is launched by command: qstat -u yourUserName
4) After 2-3 minutes you can launch again command ./nrun '*.bat' and you will occupy a new node where 200 htc files will be lauched too. (If there are any remaining htc files inside folder 'htc')
5) For debbuging purposes inside the project folder a 'log_cpus' subfolder is created. It contains txt files with some info for each launched htc file. It is also created a 'fail_par_pool' folder where htcs are copied back in case the procedure in the cluster crashes, not if a Hawc2 simulation crashes due to e.g. convergence issues. 
