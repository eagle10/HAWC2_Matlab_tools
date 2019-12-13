%% run HAWC2 ************************************
function h2un_f6(mn_fold, h2_exe_name, filename, ijk,...
    run_h2_flag,...
    x64_turb_gen_flag,...
    stat_fat_flag,...
    save_turb_flag,...
    save_cpulog_flag)

fprintf(' %s\n', ' ');
fprintf('%s\n', ' ');
fprintf(' %s\n', ' ');
Flag = 0;

%%
disp(' ');
disp('copy H2 folder ');
copyfile(['./H2'], ['./H2_c',num2str(ijk)]); % copy H2 core files in a local folder
pause(5)
if exist(['./H2_c',num2str(ijk),'/htc'], 'dir')~=7
    mkdir(['./H2_c',num2str(ijk),'/htc']);
end

copyfile([filename{1,3}], ['./H2_c',num2str(ijk),'/htc/',filename{1,1}]); 
copyfile(['./mat_lib_node/fat'], ['./H2_c',num2str(ijk)]); 
copyfile(['./mat_lib_node/*m'], ['./H2_c',num2str(ijk)]);
pause(3)

if exist(['./H2_c',num2str(ijk),'/log_cpus'], 'dir')~=7
    mkdir(['./H2_c',num2str(ijk),'/log_cpus']);
end
dum_file = ['./H2_c',num2str(ijk),'/log_cpus/','cpu_',filename{1,6}, '.txt'];
f_txt = fopen(dum_file, 'a');


%%
cd(['./H2_c',num2str(ijk),'/']);
disp('currentFolder:')
pwd

fprintf(f_txt,'\n---------FLAGS-------------------- %s\n', ' ');
fprintf(f_txt,'run_h2_flag= %s\n', num2str(run_h2_flag));
fprintf(f_txt,'x64_turb_gen_flag= %s\n', num2str(x64_turb_gen_flag));
fprintf(f_txt,'stat_fat_flag= %s\n', num2str(stat_fat_flag));
fprintf(f_txt,'save_turb_flag= %s\n', num2str(save_turb_flag));
fprintf(f_txt,'save_cpulog_flag= %s\n', num2str(save_cpulog_flag));
fprintf(f_txt,'\n----------------------------------------- %s\n', ' ');    

%% turb 

if x64_turb_gen_flag==1
    disp('filename{1,1}')
    cd(['..'])
    [~,~,~,~,~,~] = cp_or_fire_turb_x64_f3(filename{1,2}, filename{1,1}, x64_turb_gen_flag,...
        ijk,dum_file, f_txt);
end

%% run H2

pause(12)
tic
if run_h2_flag ==1
    fprintf(f_txt,'----------------------------------------- %s\n', ' ');
    fprintf(f_txt,'\n run H2  %s\n', ' ');
    [~, ~] = system(['wine ./',h2_exe_name,' ./htc/', filename{1,1}, ' -echo >> ','.', dum_file]);  % ok
    fprintf(f_txt, '\n time to run H2 Matlab  = %s\n', num2str(toc));
    fprintf(f_txt,'----------------------------------------- %s\n', ' ');
end

%% check if res sel/dat file is ok
if run_h2_flag ==1
    fname_string_common = '.sel';
    exclude_strings = {'_extra_dum1.sel','_extra_dum2.sel'};
    [Flag] = check_res_file_if_ok_f1(fname_string_common, exclude_strings, f_txt);
    Flag;
    clear fname_string_common exclude_strings
end

%% do stats/fat


if stat_fat_flag==1 && run_h2_flag ==1 
    if Flag==1
        Marcov_flg = 1; % 
        fname_string_common = '.sel';
        exclude_strings = {'_extra_dum1.sel','_extra_dum2.sel'};
        fatigue_1file_m2_all_channel_node(fname_string_common, exclude_strings, Marcov_flg, f_txt);
        clear fname_string_common exclude_strings Marcov_flg
    else
        fprintf(f_txt,'The stats/fat analysis is skipped because the sed/dat files are wrong %s\n', ' ');
    end
end

%%
system('echo ""');
system('"following files are on the node (find .):"');
unix('find .');
system('echo ""');

%%

fname_string_common = '*' ;
exclude_strings = {'not_any'};
[~, follow_files_exist2] = find_filenames_f1c('./', fname_string_common, exclude_strings, 'no_FilePath_save_txt_xls', 'no_FileName_save_txt_xls', 0);
clear fname_string_common listing exclude_strings

fprintf(f_txt, '----------------------------------------- %s\n', ' ');
fprintf(f_txt, '\n you are here (expected in /scratch/cgal/xxxxxxx.jess.dtu.dk/mn_f/H2_cX) fullpath = \n%s\n\n', pwd);
fprintf(f_txt, '----------------------------------------- %s\n', ' ');
fprintf(f_txt, 'following files exist here: %s\n', ' ');
fprintf(f_txt, ' %s\n', [strjoin(follow_files_exist2(:,3),' \n')]);
clear follow_files_exist1 follow_files_exist2
fprintf(f_txt, '----------------------------------------- %s\n', ' ');
fprintf(f_txt, ' finish processes, copy result/files back %s\n', ' ');
fprintf(f_txt, '----------------------------------------- %s\n', ' ');
fclose(f_txt);

cd(['..'])
if exist(['./H2_c',num2str(ijk),'/res/'], 'dir' ) == 7 && Flag==1
    dum_com = ['cp -R ./H2_c',num2str(ijk),'/res/* $PBS_O_WORKDIR/../',mn_fold,'/res/.'];
    system(dum_com); clear dum_com
end

if exist(['./H2_c',num2str(ijk),'/logfiles/'], 'dir' ) == 7
    dum_com = ['cp -R ./H2_c',num2str(ijk),'/logfiles/* $PBS_O_WORKDIR/../',mn_fold,'/logfiles/.'];
    system(dum_com); clear dum_com
end

if save_turb_flag == 1
    if exist(['./H2_c',num2str(ijk),'/turb/'], 'dir' ) == 7
        %     copyfile( ['./H2_c',num2str(ijk),'/turb/'], ['./turb'],'f');
        dum_com = ['cp -R ./H2_c',num2str(ijk),'/turb/* $PBS_O_WORKDIR/../',mn_fold,'/turb/.'];
        system(dum_com); clear dum_com
    end
end

if exist(['./H2_c',num2str(ijk),'/log_cpus/','cpu_',filename{1,6}, '.txt'], 'file' ) == 2 && save_cpulog_flag ==1
    dum_com = ['cp -R ./H2_c',num2str(ijk),'/log_cpus/* $PBS_O_WORKDIR/../',mn_fold,'/log_cpus/.'];
    system(dum_com); clear dum_com
end


f_txt = fopen(dum_file, 'a');
fprintf(f_txt, 'DONE !!!  The h2un_fX script was executed succefully %s\n', ' ');
fclose(f_txt);


fprintf('\n you are here (expected in cccc) fullpath = \n%s\n\n', pwd);
if exist(['./H2_c',num2str(ijk),'/'], 'dir' ) == 7
    rmdir(['./H2_c',num2str(ijk),''], 's'); % remove the local folder
end


disp('pause 12sec')
pause(12)

