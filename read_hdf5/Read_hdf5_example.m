%% *****************************************************************************
% analysis  script
%
% Input    :  H2 hdf5 file format
%
% https://www.mathworks.com/help/matlab/import_export/importing-hierarchical-data-format-hdf5-files.html
%
% Output   : matlab format
%
%
% Author   : Christos Galinos
% Date     : 14-7-2019
% Version  : 1.00
% *****************************************************************************



%% Clear
clc
close all
clearvars %clear all


%% file path-name
fold = '..\_test_files\DTU_10MW_RWT\res/';
filename = 'dtu_10mw_rwt_wsp8_gtsdf';

%% display info
% h5disp([fold, filename, '.hdf5'])

%% read the hdf5 file
[sel, sig, dt, t_series, Flag, no_data_blocks, h2_vers_date, info] = Read_H2_hdf5_f1([fold, filename]); % whole data

% blk = [-1]; % if blk = -1 will read all available data blocks
% [sel, sig, dt_blk, t_series_blk, Flag_blk,...
%     no_data_blocks_blk, h2_vers_date_blk, info_blk] = Read_H2_hdf5_f1b([fold, filename], blk); % only x block data


%% plot
i_ch = 15;

figure(1);hold on;
addToolbarExplorationButtons(gcf)
plot(sig(:,1), sig(:,i_ch),'-.')
xlabel('Time [s]'); 
ylabel([sel{i_ch,3},'']);
box on;
grid on

% strtrim(sel{11,3})










