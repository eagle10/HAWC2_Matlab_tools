% Function
%
% Input: the ASCII HAWC2 file name result without .sel or .dat
%
% Output   : The result files (dat/sel) in binary format
%
%
% Author   : Christos Galinos
% Date     : 28-02-2015
% Version  : 1.00
% *****************************************************************************

function [fname_hawc_new] = ascii2bin_f1(fname_hawc)
%% HAWC2 ascii to bin

%% clear ******************************************************************
% clc;
% clearvars %clear all
% close all
% p = mfilename('fullpath')

%%
fid = fopen([fname_hawc,'.sel'], 'r');
if fid == -1
        fname_hawc_new = fname_hawc;
%     Flag = 0;
    disp('  ')
    disp('==============================================================')
    disp(['file "',fname_hawc,'" could not be found'])
    disp('--------------------------------------------------------------')
%     sig = [];Freq = 0;Time=0;Binary=[];
    return
end

[data, FreqSim, TimeSim, ~, Binary, ~]  = ReadHawc2(fname_hawc);
fprintf('--- %s\n',   'hawc2 file is loaded ----');%

%%
if Binary==1
    fprintf('--- %s\n',   'hawc2 result file is already in binary format ----');%
    fname_hawc_new = fname_hawc;
else
    fname_hawc_new = [fname_hawc,'_bin'];
    data(:,1) = (1/FreqSim):1/FreqSim:TimeSim; % the time column
    for i=1:length(data(1,:))
        ScaleFactor(i,1) = max([abs(max(data(:,i))),abs(min(data(:,i)))])/32000;
        data_bin(:,i) = data(:,i)/ScaleFactor(i,1);
    end
    % write the binary .dat file
    fid = fopen([fname_hawc_new,'.dat'], 'w');
    fwrite(fid,data_bin,'int16');
    fclose(fid);
    
    %  read the sel file
    fsel = fopen([fname_hawc, '.sel']); % find the sensors
    i=1;
    mast_l=0;
    while ~feof(fsel)
        mast_l=mast_l+1;
        dum00{mast_l,i} = fgetl(fsel);
    end
    fclose(fsel);
%     dum0 = dum00{2,i};
%     hawc_vers{1,i} = dum0(15:end);
%     clear dum0
%     dum1 = dum00{9,i};
%     no_scans_ch_time(:,i) = sscanf(dum1, '%g', 3);
    dsel_all = dum00;
%     for j=1:length(dum00(13:end,i))
%         dsel{j,i} = dum00{12+j,i}; % avoid the first lines of general comments in the sel file
%     end
    clear dum1 dum00
    
    % create the new .sel adding the Scale factors at the end
    dsel_all{9,1} = strrep(dsel_all{9,1},'ASCII','BINARY');
    
    f_txt = fopen([fname_hawc_new,'.sel'],'w');
    for j=1:length(dsel_all)
        fprintf(f_txt,'%s\n',dsel_all{j,1});
    end
    fprintf(f_txt,'%s\n', '________________________________________________________________________________________________________________________');
    fprintf(f_txt,'%s\n', 'Scale factors:');
    
% % %     fprintf(f_txt,'%s\n',num2str(ScaleFactor(1),'%1.5E'));
    for k=1:length(ScaleFactor)
        fprintf(f_txt,'%s\n',num2str(ScaleFactor(k),'%1.5E'));
    end
    fclose(f_txt);
    fprintf('--- %s\n',   'HAWC2 file was converted from ascii to bin ----');
end






















