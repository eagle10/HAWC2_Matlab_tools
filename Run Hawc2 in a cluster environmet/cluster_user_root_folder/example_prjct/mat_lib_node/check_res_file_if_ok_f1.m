%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       11-6-2016
% Version:    1.0 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Flag] = check_res_file_if_ok_f1(fname_string_common, exclude_strings, f_txt)

Flag = -97;
%%  ********************************************************************


fprintf(f_txt, '--------------------------------------------------------------------- %s\n', ' ');
fprintf(f_txt,' check_res_file_if_ok_f1()   %s\n', ' ');

currentFolder = pwd;
folder_res = [currentFolder,'/res'];
[~, fnames2] = find_filenames_f1c(folder_res, ['*',fname_string_common], exclude_strings, 'no_FilePath_save_txt_xls', 'no_FileName_save_txt_xls', 0);

clear fnames folder_res


if strcmp(fnames2{1,3},'empty')==0
    Flag = -98;
    for ii = 1:length(fnames2(:,3))
        fname = strrep(fnames2{ii,3}, '.sel', '');
        [~,~,~,Flag]  = ReadHawc2(fname);
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

fprintf(f_txt,'\n end check_res_file_if_ok_f1 %s\n', ' ');
fprintf(f_txt, '--------------------------------------------------------------------- %s\n', ' ');



