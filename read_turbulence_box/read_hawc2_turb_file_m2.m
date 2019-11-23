%% *****************************************************************************
% analysis  script
%
% Input    : HAWC2 turbulence file of any wind component (u or v or w)
%
%
% Output   :  read the bin file
%
%
%
% Author   : Christos Galinos
% Date     : 21-11-2016
% Version  : 1.00
% *****************************************************************************
%% Clear
clc
close all
clearvars %clear all
%% format
% format loose
format compact
%% parameters *****************************************************************

no_u = 8192;  no_v = 16; no_w = 16;
%*******************************

fold = '..\_test_files\DTU_10MW_RWT\turb\mann/';
f_name = 'man_s8001_lamd29p4_wsp8_ti0p07_u.bin';
%**************************************************************************

%% read the file-binary 

% Read Binary data
clear sig
fid = fopen([fold, f_name], 'r');
sig = fread(fid,'real*4');
fclose(fid);

%% convert the data to a box style **************************************
B = reshape(sig,[no_w no_v no_u]);
B = permute(B,[3,2,1]);

u_turb = B;


%% plot ****************************************************************
font_size = 11;
% choose a a grid point (v,w) i.e. (y,z point)
% (1,1) corresponds to the lower right corner of the box
% (1,no_w) corresponds to the upper right corner of the box
% (no_v,1) corresponds to the lower left corner of the box
% (no_v,no_w) corresponds to the upper right corner of the box
index_v = 1;
index_w = 1;

u_turb_time_ser(:,1) = u_turb(:,index_v,index_w);

figure(1); %subplot(2,2,1)
p1 = plot(u_turb_time_ser, 'r','Markersize',5,'LineWidth',1);
grid on; box on; 
xlabel('[#]', 'FontSize',font_size);
ylabel('u fluct. [m/s]', 'FontSize',font_size);
title('Time series at (v,w)=(index_v, index_w)', 'FontSize',font_size);


