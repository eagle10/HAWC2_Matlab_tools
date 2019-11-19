function [sig,Freq,Time,Flag,Binary,t] = ReadHawc2(FileName)
% Reads HAWC2 binary and ascii results file
% ------------------------------------------------------------------------
% [sig,Freq,Time,Flag,Binary] = ReadHAWC2(FileName);
% filename should be without extension
% e.g. FileName = '..\res\test'
% output:
% sig:      all data in file
% Freq:     sampling frequency
% Time:     total simulation time in file
% Flag:     0 if file do not exist, 1 if reading scucceed, 
%           2 if some data but not for full time span
% Binary:   1 if fils is in binary format, 0 if ascii
% t:        a vector with the time
% ------------------------------------------------------------------------
% 24/9-2008 Made by Bjarne Skovmose Kallesøe (DTU) 
% modified 18/12-2008: file error handelig added
% modified 26/2-2009: error msg for empty date file
% modified by Christos Galinos 15-2-2017: add output time 't' which was problematic for binary files with long simulation time
% ------------------------------------------------------------------------
%% reading scale factors from *.sel file
fid = fopen([FileName,'.sel'], 'r');
if fid == -1
    Flag = 0;
    disp('  ')
    disp('==============================================================')
    disp(['file "',FileName,'" could not be found'])
    disp('--------------------------------------------------------------')
    sig = [];Freq = 0;Time=0;Binary=[];
    return
end
fgets(fid); fgets(fid); fgets(fid); % skip 3 lines
fgets(fid); fgets(fid); fgets(fid); % skip 3 lines
fgets(fid); fgets(fid); % skip 2 lines
tline = fscanf(fid,'%f'); % read line number 9
N = tline(1);
Nch = tline(2);
Time = tline(3);
FileType = fscanf(fid,'%s');
fclose(fid);
Freq = N/Time;
t = [1/Freq:1/Freq:Time]';

%% Binary data
if strcmpi(FileType(1:6),'BINARY')
    Binary = 1;
    fid = fopen([FileName,'.dat'], 'r');
    if fid==-1
        disp(['file:: '])
        disp([FileName,'.dat'])
        disp([' not found'])
%         disp(['return'])
        disp(['pause'])
        pause(4)
        %         msg = 'Error occurred.';
%         msg = 'file not found';
%         error(msg)
    end
    sig = fread(fid,[N,Nch],'int16');
    if isempty(sig) 
        Flag = 0;
        disp('  ')
        disp('==============================================================')
        disp(['no data in file "',FileName,'.dat"'])
        disp('--------------------------------------------------------------')
        sig = [];Freq = 0;Time=0;Binary=[];
        fclose(fid);
        return
    end
    ScaleFactor = dlmread([FileName,'.sel'],'',[9+Nch+5 0 9+2*Nch+4 0]);
    sig = sig*diag(ScaleFactor);
    t_start = sig(end,1)-Time;
    % sig(:,1) = t+t_start-1/Freq; clear t_start
    sig(:,1) = t+t_start; clear t_start
    fclose(fid);
    Flag = 1;

%% ascii data
elseif strcmpi(FileType(1:5),'ASCII')
    Binary = 0;
    sig = dlmread([FileName,'.dat']);
    if isempty(sig) 
        Flag = 0;
        disp('  ')
        disp('==============================================================')
        disp(['no data in file "',FileName,'.dat"'])
        disp('--------------------------------------------------------------')
        sig = [];Freq = 0;Time=0;Binary=[];
        return
    end
   if length(sig(:,1)) < N
       Time = length(sig(:,1))/Freq;
        Flag = 2;
        disp('  ')
        disp('==============================================================')
        disp(['not full data in file "',FileName,'.dat"'])
        disp('--------------------------------------------------------------')
        return
    end
    Flag = 1;

%% error
else
    disp('unknown file type')
    Flag = 0;
end
