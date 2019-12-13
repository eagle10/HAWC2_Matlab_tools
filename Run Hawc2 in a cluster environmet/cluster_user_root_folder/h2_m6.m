%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       28-02-2016
% Version:    1.0
%
%
% script: Run in the cluster Hawc2 simulations
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear ******************************************************************
clc
clearvars %clear all
close all

disp('-')
disp('------------------------------------------')
disp('you are in main matlab script, enjoy!!!')
disp('ticc')
fprintf('\n--------- the matlab file and its full path = ------------ \n%s\n\n', mfilename('fullpath'));
fprintf('\n you are here (expected in schratch/mn_fold) fullpath = \n%s\n\n', pwd);
tic

%% params

% h2_exe_name = 'h2_12p6';  %(without the extension .exe)
h2_exe_name = 'h2_12p7p15';  

run_h2_flag = 1; % run H2
x64_turb_gen_flag = 1; % create or not the turb files
stat_fat_flag = 1; % do or not the stats/fat analysis
save_turb_flag = 1; % save or not the turb files
save_cpulog_flag = 1; % save or not the cpu_log files

folder_htc = './htc';
fname_string_common1 = '.htc';
exclude_strings1 = {'_dummy1.sel','__dummy2.sel'};
dum_fold = strsplit(pwd,'/');
mn_fold = dum_fold{end};
clear dum_fold

%% mkdir 
fprintf('\n you are here (expected in schratch/mn_fold) fullpath = \n%s\n\n', pwd);

schratch_fldrs = {'H2', 'mat_lib_node', 'logfiles', 'res', 'turb', 'log_cpus', 'eig_sys','fail_par_pool'}';

for i = 1:length(schratch_fldrs) 
    mkdir(schratch_fldrs{i,1});
end 
cd(['..'])  
fprintf('\n you are here (expected in schratch/.) fullpath == \n%s\n\n', pwd);
system(['cp -R $PBS_O_WORKDIR/../', mn_fold, '/mat_lib_node/* ./',mn_fold, '/mat_lib_node/.']);
system(['cp -R $PBS_O_WORKDIR/../', mn_fold, '/H2/* ./',mn_fold, '/H2/.']);
home_fldrs = {'res', 'logfiles', 'turb', 'log_cpus', 'fail_par_pool'}';
for i = 1:length(home_fldrs)
    system(['mkdir $PBS_O_WORKDIR/../',mn_fold, '/',home_fldrs{i,1}]);
end
cd(mn_fold)
fprintf('\n you are here (expected in schratch/mn_fold) fullpath = \n%s\n\n', pwd);
addpath('./mat_lib_node');

%% find the names of .htc files

[fnames, fnames2] = find_filenames_f1c(folder_htc, ['*',fname_string_common1], exclude_strings1, 'no_FilePath_save_txt_xls', 'no_FileName_save_txt_xls', 0);

fprintf(' %s\n',   '---------------------------------------');%
fprintf('--- %s\n',   ['total cases = ',num2str(length(fnames2(:,1))),' ---']);%
fprintf(' %s\n',   '---------------------------------------');%

fprintf('\n fnames2(:,3) = \n%s\n\n', [strjoin(fnames2(:,3),'\n')]);


%% ----------------------------------

parpool(20, 'IdleTimeout', 240);

poolobj = gcp('nocreate'); 

if isempty(poolobj) 
    fprintf('\n --------------try once again to set a parallel pool-------------- \n%s\n\n', ' ')
    pause(3)
    parpool(20, 'IdleTimeout', 240);
end

fprintf('\n --------------parallel pool prop-------------- \n%s\n\n', ' ');
poolobj = gcp('nocreate')
if isempty(poolobj)
    poolsize = 0
else
    poolsize = poolobj.NumWorkers
end
fprintf('\n --------------end parallel pool prop-------------- \n%s\n\n', ' ');

if poolsize == 0
    fprintf('\n -------------- poolsize = 0 -------------- \n%s\n\n', ' ');
    fprintf('\n -------------- I will terminate the mtb script -------------- \n%s\n\n', ' ');
    % try to move back the htcs!!!
    for ii=1:length(fnames2(:,1))
        copyfile([fnames2{ii,3}], ['./fail_par_pool/',fnames2{ii,1}]);  % copy the specific htc file
    end
    disp('Error occurred!!! (poolsize = 0)');
    exit
end

%%
parfor ii=1:length(fnames2(:,1))
    h2un_f6(mn_fold, h2_exe_name, fnames2(ii,:), ii, run_h2_flag, x64_turb_gen_flag, stat_fat_flag,...
         save_turb_flag,...
        save_cpulog_flag)

end
delete(poolobj); 
fprintf('\n --------------parallel pool is shutting down-------------- \n%s\n\n', ' ');


%% following files are on the node after run
system('cd /scratch/$USER/$PBS_JOBID');
system('echo ""');
system('"following files are on the node after run (find .):"');
unix('find .');
system('echo ""');

%%  delete all the files from the scratch node
fprintf('\n --------------- delete all the files from the scratch node --------------- %s\n\n', ' ');

system('cd /scratch/$USER/$PBS_JOBID');
system(['rm -r /scratch/$USER/$PBS_JOBID/', mn_fold]);
 
%% following files are on the node after cleaning
cd(['..'])
system('echo ""');
system('"following files are on the node after cleaning (find .):"');
unix('find .');
system('echo ""');

disp('tocc')
toc   
disp('pause-4')
pause(3)

return






