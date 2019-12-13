%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       13-4-2017
% Version:    1.0 (run with matlab R2015b)
%
% Input    : file with names (checks present folder and all-sub-folders)
%
%
% Output   : a list with file names is written to a txt and to  an excel sheet!
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function   [fnames, fnames2] = find_filenames_f1b(folder_gen, fname_string_common, exclude_string, FilePath_save, FileName_save, write_flag)


%% Clear ********************************************************************
% clc
% close all
% clearvars %clear all

%% parameters


%% find the sub-sub-folders  if any

% [foldnames] = find_fold_f1(folder_gen,{''}); % looks only in sub-folders

[foldnames] = find_sub_fold_f1(folder_gen,{''}); % looks in any sub-folder that exists


%% find files ======================================================
% foldr1 = 1;
% fnames = cell(length(listing),1); % pre-allocation of cells
for foldr1 = 1:length(foldnames) % do for each folder i
    folder{foldr1} = [folder_gen, foldnames{foldr1}];
    fnames{1,foldr1} = folder{foldr1};
    listing = dir( [folder{foldr1},'/', fname_string_common]);
    ind0=1;
    for i=2:length(listing)+1
        ans0 = listing(i-1);
        temp = strfind(ans0.name, [exclude_string,'']);
        if isempty(temp)==1
            ind0=ind0+1;
            fnames{ind0,foldr1}=ans0.name;
        end
    end
end

%% create fnames2 variable


dum0 = 0;
for nfoldr1 = 1:size(fnames,2)
    for nfile = 2:size(fnames,1)
        if isempty(fnames{nfile, nfoldr1})==0
            dum0 = dum0+1;
            fnames2{dum0,1} = [fnames{nfile, nfoldr1}];
            fnames2{dum0,2} = [folder{nfoldr1},'/'];
            fnames2{dum0,3} = [folder{nfoldr1},'/',fnames{nfile, nfoldr1}];
        end
    end
end

% add 1 more column with the relative path after the htc/.... (if 'htc' exists in the path name)
for i = 1:size(fnames2,1)
    dum = strsplit(fnames2{i,2},'htc');
    if size(dum,2)>1 % (if 'htc' exists in the path name)
        fnames2{i,4} = dum{2}(2:end);
    end
end
clear dum

% add 1 more column with the relative path after the main folder
dum00 = strsplit(folder_gen,'\'); % main folder
for i = 1:size(fnames2,1)
    dum = strsplit(fnames2{i,2},dum00{end});
    if size(dum,2)>1 % (if 'htc' exists in the path name)
        fnames2{i,5} = dum{2}(2:end);
    end
%     fnames2{i,5} = dum{2}(2:end);
end

% add 1 more column with the filename excluding any extension e.g. .dat or .sel
for i = 1:size(fnames2,1)
    dum = strsplit(fnames2{i,1},'.');
    if size(dum,2)>1 % (if files exists in the path name)
        fnames2{i,6} = dum{1}(1:end);
    elseif size(dum,2)== 1;
        fnames2{i,6} = '';
    end
end

%% write variable names-paths to a txt
if write_flag==1
    fileID = fopen([FilePath_save, FileName_save,'.txt'],'w');
    for nfoldr1 = 1:size(fnames,2)
        for nfile = 2:size(fnames,1)
            if isempty(fnames{nfile, nfoldr1})==0
                %             fprintf(fileID,'%s\n',  fnames{nfile, nfoldr1});
                fprintf(fileID,'%s\n',  [folder{nfoldr1},'/',fnames{nfile, nfoldr1}]);
            end
        end
    end
    fclose(fileID);
end


%% write names-paths to an excel file (if exists it is deleted 1st) reference ******************

if write_flag==1
    delete([FilePath_save, FileName_save,'.xlsx']);
    % write new
    xlswrite([FilePath_save, FileName_save,'.xlsx'],fnames2,'fnames_hawc')
    xlswrite([FilePath_save, FileName_save,'.xlsx'],fnames,'fnames_hawc_info')
    
    fprintf('--- %s\n',   ['excel file was created   = ', ' ----']);%
    % fprintf('--- %s\n',   ['plt_timseries = ',num2str(plt_timseries), ' ----']);%
    % fprintf('--- %s\n',   ['plt_psds      = ',num2str(plt_psds), ' ----']);%
    fprintf(' %s\n',   ' ');%
end


%%  delete default excel sheets 1/2/3
if write_flag==1
    excelFileName = [FileName_save,'.xlsx'];
    excelFilePath = FilePath_save; % Current working directory.
    del_default_excel_sheets_f1(excelFilePath, excelFileName)
end

%% extra-command   open the excel file

if write_flag==1
    fprintf('--------------------------------- %s\n', ' ');
    %     fprintf('--- %s\n',   ['hawc2 file is loaded ----']);%
    fprintf('--------------------------------- %s\n', ' ');
    fprintf('fname_path:: %s\n', [FilePath_save,' ']);
    fprintf('fname_save:: %s\n', [FileName_save,'.xlsx']);
    fprintf('--------------------------------- %s\n', ' ');
    % disp('---return---')
    % return
end





