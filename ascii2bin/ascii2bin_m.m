%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       28-02-2015
% Version:    1.0
% 
% Convert HAWC2 ascii format files to binary equivalent
%
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear ******************************************************************
clc
clearvars
close all
% addpath('../')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder = '..\DTU_10MW_RWT_example_files\res/';

fname_string_common = '*DTU*.dat'; % common part in all files for files selection !!!!

% addpath('C:\Users\cgal\VAWT\DLLs\test_dll\hawc')

%% find the names of .dat files
% fname_string_common = '*_28_ds1*.dat';
listing = dir( [folder fname_string_common] );
% % for i=1:length(listing)
% %     ans = listing(i);
% %     fnames{i,1} = ans.name
% % end
fnames = {listing.name}';

for i=1:length(fnames)
    fprintf(' %s\n',   '---------------------------------------');%
    fprintf('--- %s\n',   ['i=',num2str(i),':',fnames{i},' ---']);%
    fprintf(' %s\n',   '--------------------------------------- ');%
    % remove .dat from the end of the file name
    dum = strrep(fnames{i}, '.dat', '');
    ascii2bin_f1( [folder, dum] );
    clear dum
end
fprintf('  \n');
fprintf('Conversions from ascii2bin finished !!!\n');
fprintf('  \n');

















