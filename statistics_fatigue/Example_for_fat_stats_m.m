%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       4-2017
%
% EXAMPLE OF Function: Fatigue_1file_f1d.m
% 
% Does a rainflow counting, compute equivalent loads/Markov matrix and
% statistics of HAWC2 results file
% also keeps the values of other sensors when a channel is max/min (see: MaxVec_and_other, MinVec_and_other)
%
% Saves to a Matlab file the post-processed results
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars
close all
clc
addpath('../')  

%% Inputs

FileName = '..\DTU_10MW_RWT_example_files\res/DTU_10MW_RWT_wsp8';

% rainflow setttings ************************************************************
NrBin = 46;             % number of bins to split the loads (usually 30 to 50)
mvec = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; % material parameter, e.g. normal steel m = 3, glassfiber m = 12

f_txt = 1; % show logs in screen
% f_txt = fopen('logfile.txt', 'a'); % write logs in file

chan = [17:19, 26:29];

%% Compute

Fatigue_1file_f1d(FileName, NrBin, mvec, chan, f_txt)

% fclose(f_txt);
