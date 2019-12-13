%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       13-4-2017
% Version:    1.0
%
%
% Output   : a list with file names 

% e.g. column1= 'swt23_d93_WF_der1_wtA1_wak1_wspd10_wdiry0_wav0_ti0p0700_sd10001.htc'
% column2= 'P:\concert\project_x\htc\lillgrund_C8wt_here_A1/'
% column3= 'P:\concert\project_x\htc\lillgrund_C8wt_here_A1/swt23_d93_WF_der1_wtA1_wak1_wspd10_wdiry0_wav0_ti0p0700_sd10001.htc'
% column4= 'lillgrund_C8wt_here_A1/'
% column5= ''
% column6= 'swt23_d93_WF_der1_wtA1_wak1_wspd10_wdiry0_wav0_ti0p0700_sd10001'
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function   [fnames_all, fnames2_all] = find_filenames_f1d(folder_fls, fname_string_common_all, exclude_string, FilePath_save, FileName_save, write_flag)



%%
sum1 = 0;
for i=1:length(fname_string_common_all)
        [fnames_dum, fnames2_dum] = find_filenames_f1c(folder_fls, ['*',fname_string_common_all{i}], exclude_string, 'no_FilePath_save_txt_xls', 'no_FileName_save_txt_xls', 0);
        if strcmp(fnames2_dum{1,1},'empty')==0
            sum1 = sum1+1;
            fnames_dum2{sum1,1} = fnames_dum;
            fnames2_dum2{sum1,1} = fnames2_dum;
        end
        clear fnames_dum fnames2_dum
end

if exist('fnames_dum2','var')==0
    fnames_all(1,1)={'empty'};
else
    fnames_all = fnames_dum2;
end

if exist('fnames2_dum2','var')==0
    fnames2_all(1,1:6)={'empty'};
else
   fnames2_all = cat(1, fnames2_dum2{:});
end







 

