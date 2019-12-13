%% *****************************************************************************
%
% Input    :
%  read HAWC2 htc format file
%
%
%
% Author   : Christos Galinos
% Date     : 15-4-2017
% Version  : 1.01
%
%
% identifies the name and path of e.g. the 'logfile' command line inside the htc file
%
% *****************************************************************************

function   [keep_data] = extract_hawc2_file_paths_f3(htc_file_path, htc_file_name, key_name1, key_name2)


%% extract the htc file lines    ****************************
% read the .htc ****************************
fmaster = fopen([htc_file_path, htc_file_name]);
mast_l = 0;
% i1 = 0;
% i2 = 0;
while ~feof(fmaster)
    mast_l = mast_l+1;
    mast{mast_l,1} = fgetl(fmaster); % store the htc file lines content
end
fclose(fmaster);
clear fmaster mast_l

%% find any key_name1 ('logfile' or 'xxxxxx') commands

i1 = 0;
for i = 1:length(mast)
    dum1 = strfind(mast{i,1},key_name1);
    if  isempty(dum1)==0
        Str = mast{i,1};
        Index = strfind(Str,';');
        Index = Index(1);
        dum2 = strfind(Str(Index(1):end), key_name1);
        if isempty(dum2)==1
            i1 = i1+1;
            key_name1_line_no(i1,1) = i;
            clear dum1 Index dum2 Str
        end
    end
end
clear i1 i Str dum1 Index dum2

% use key_name1--------------------------------------------
% find the file names if key_name1_line_no commands exist
if exist('key_name1_line_no','var') ~= 0
    for i = 1:length(key_name1_line_no)
        Str = char( mast(key_name1_line_no(i)));
        keep_data{i,1} = Str;
        Index = strfind(Str, key_name1);
        if isempty(Index) == 0
            dum1 = sscanf(Str(Index(1) + length(key_name1):end), '%s');
            %             keep_data{i,2} = dum1;
            Index2 = strfind(dum1, ';');
            dum1 = dum1(1:Index2-1);
            keep_data{i,2} = dum1;
        end

    end
    clear key_name1 Index Index2 dum1 Str i
end


% use key_name2--------------------------------------------
% find the file names if key_name1_line_no commands exist
if exist('key_name1_line_no','var') ~= 0
    for i = 1:length(key_name1_line_no)
        Str = char( mast(key_name1_line_no(i)));
%         keep_data{i,1} = Str;
        Index = strfind(Str, key_name2);
        if isempty(Index) == 0
            dum1 = sscanf(Str(Index(1) + length(key_name2):end), '%s');
            %             keep_data{i,2} = dum1;
            Index2 = strfind(dum1, ';');
            dum1 = dum1(1:Index2-1);
            keep_data{i,3} = dum1;
        end

    end
    clear key_name1 Index Index2 dum1 Str i
end

%% check if 'keep_data' exists otherwise create an empty cell

if exist('keep_data','var') == 0

      keep_data = {};
end






