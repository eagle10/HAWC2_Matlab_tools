%% clear ******************************************************************
clc;
clear all
close all

%%
fprintf(' %s\n', ' ');
fprintf('---------check_if_file_run_m1.m------------ %s\n', ' ');
fprintf(' %s\n', ' ');

%% find the name of the htc file
fname_string_common = '*.htc';
listing = dir( [fname_string_common]);
fname(:,1) = {listing.name};
for i = 1:length(fname)
    delete(fname{i});
end
fprintf('%s\n', ' ');
fprintf('%s\n', '---htc file was deleted --- ');
fprintf('%s\n', ' ');
    
clear listing fname_string_common

    
    







