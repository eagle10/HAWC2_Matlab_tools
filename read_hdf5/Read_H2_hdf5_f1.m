%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       14-5-2019
% Version:    1.00
%
% Read HAWC2 .hdf5 result file (read all the data blocks)
%
% input:
% filename: e.g. filename = '.\res\dtu_10mw_8ms' (filename without extension)
%
% outputs:
% sel:            'equivalent sel file' : names/units/description
% sig:            all data in file
% dt:             time step
% t_series:       time series with actual time start stamp
% Flag:           0 if file do not exist, 1 if reading scucceed 
% no_data_blocks: number of data blocks
% h2_vers_date:   HAWC2 version and date
% info:           info of the hdf5 file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [sel, sig, dt, t_series, Flag, no_data_blocks, h2_vers_date, info] = Read_H2_hdf5_f1(filename)

filename = strrep(filename,'.hdf5','');

%% check if exists *.hdf5 file

if exist([filename,'.hdf5'],'file') ~= 2
    Flag = 0;
    disp('  ')
    disp('==============================================================')
    disp(['file "',filename,'" could not be found'])
    disp('--------------------------------------------------------------')
    sel = []; sig = []; dt = 0; t_series=0;
    no_data_blocks = 0; h2_vers_date = 0; info = 0;
    return
end

info = h5info([filename, '.hdf5']);
no_data_blocks = info.Attributes(2).Value;
h2_vers_date = info.Attributes(4).Value;
h2_vers_date = strsplit(h2_vers_date, ' ');

% dt_name = info.Groups(1).Attributes(1).Name
dt = info.Groups(1).Attributes(1).Value;

% t_start_name = info.Groups(1).Attributes(2).Name
t_start_frst_blk = info.Groups(1).Attributes(2).Value;
t_start_last_blk = info.Groups(no_data_blocks).Attributes(2).Value;

% load last group
grp = info.Groups(no_data_blocks).Name;
dset = 'data';
datasetname = [grp, '/', dset];
data = h5read([filename, '.hdf5'],datasetname);
t_end_last_blk = t_start_last_blk+dt*(size(data,2)-1);
no_sensors = size(data,1);

t_series = (t_start_frst_blk:dt:t_end_last_blk)'; % time series, with actual time start stamp

%% equivalent sel file data-----------------------------

% the usual column of time is not included with this format explicitly!!!

grp = '/';
% dset = 'attribute_descriptions'
% dset = 'attribute_names'
dset = 'attribute_units'; datasetname = [grp, '/', dset];
data_units = h5read([filename, '.hdf5'],datasetname); % 3rd column on .sel file

dset = 'attribute_descriptions'; datasetname = [grp, '/', dset];
data_descriptions = h5read([filename, '.hdf5'],datasetname); % 4th column on .sel file

dset = 'attribute_names'; datasetname = [grp, '/', dset];
data_names = h5read([filename, '.hdf5'],datasetname); % 2nd column on .sel file

sel = [data_names, data_units, data_descriptions];

tim = {'Time','s','Time'};        
sel = [tim; sel];

sel = strtrim(sel); % remove LE,TE spaces

%% load actual data
% dat = zeros(length(t_series), no_sensors+1);
dat = zeros(1, no_sensors);

% read all blocks
for i=1:no_data_blocks
    grp_name = info.Groups(i).Name;
    % load group data
    dset = 'data';    datasetname = [grp_name, '/', dset]; data = h5read([filename, '.hdf5'],datasetname);
    % load group offsets
    dset = 'offsets'; datasetname = [grp_name, '/', dset]; data_offsets = h5read([filename, '.hdf5'],datasetname);
    % load group gains
    dset = 'gains';   datasetname = [grp_name, '/', dset]; data_gains = h5read([filename, '.hdf5'],datasetname);
    % compute
    data = double(data);
    data = (data.*data_gains(:,1)+data_offsets(:,1))';
    if i==1
        sig = data;
    else
        sig = [sig;data];
    end  
end

sig = [t_series,sig];


%% success
Flag = 1;










