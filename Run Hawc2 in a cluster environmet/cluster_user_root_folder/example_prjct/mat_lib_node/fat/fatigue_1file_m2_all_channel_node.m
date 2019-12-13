%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       11-6-2016
% Version:    1.0 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fatigue_1file_m2_all_channel_node(fname_string_common, exclude_strings, Marcov_flg, f_txt)


fprintf(f_txt, '--------------------------------------------------------------------- %s\n', ' ');
fprintf(f_txt,' fatigue_1file_m2_all_channel_node()   %s\n', ' ');
fprintf(f_txt,'\n calculate statistics and fatigue for norm. channels %s\n', ' ');
fprintf(f_txt,'\n change bin_width,NrBin, mvec, chan, fname_string_common, exclude_strings !  %s\n', ' ');
fprintf(f_txt,'\n you can select to save or not the Markov matrix as well %s\n', ' ');

%% parameters *********************************************************************

% rainflow setttings ************************************************************
NrBin = 46;             % number of bins we split the loads (usually 30 to 50)
mvec = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; % material parameter, steel m = 3, glasfiber m = 12


%% find the name of the file

currentFolder = pwd;
folder_res = [currentFolder,'/res'];
[~, fnames2] = find_filenames_f1c(folder_res, ['*',fname_string_common], exclude_strings, 'no_FilePath_save_txt_xls', 'no_FileName_save_txt_xls', 0);

clear fnames folder_res


if strcmp(fnames2{1,3},'empty')==0
    for ii = 1:length(fnames2(:,3))
        fname = strrep(fnames2{ii,3}, '.sel', '');
        fatigue_1file_m1_all_channel_f2b(fname, NrBin, mvec, Marcov_flg, f_txt);
    end
    clear listing
else

    fprintf(f_txt,'%s\n', ' ');
    fprintf(f_txt,'No dat file (simulation crashed or killed by Jess) %s\n', ' ');
    fprintf(f_txt,'%s\n', ' ');
    fprintf(f_txt,'??? maybe crashed or not run H2 htc was copied in ...cluster\\output\\crash  %s\n', ' ');
    fprintf(f_txt,'%s\n', ' ');
    fprintf(f_txt,'%s\n', ' ');
    
end

fprintf(f_txt,'\n end calculate statistics and fatigue for norm. channels %s\n', ' ');
fprintf(f_txt, '--------------------------------------------------------------------- %s\n', ' ');



