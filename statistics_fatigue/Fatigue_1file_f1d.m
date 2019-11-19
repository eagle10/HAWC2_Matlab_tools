%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       4-2017
% Version:    1.0
%
%
% Does a rainflow counting and statistics
% also keeps the values of other sensors when a channel is max/min (see: MaxVec_and_other, MinVec_and_other)
%
% rf_markov_mean_range_centers: e.g. for 10bins matrix will be 11x11
%                                    1st row keeps the center of means
%                                    1st column keeps the center of ranges
%
% use 'RainflowCounting_f1b.m' extracts N and Markov matrix
% or  'RainflowCounting_f1.m' extracts only N
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Fatigue_1file_f1d(FileName, NrBin, mvec, chan, f_txt)
% outputs
% S1 = S1(mvec,files,channels):
% Equiv. load range for damage exponents m and F-ref = 1.000 Hz, for each channel

% % rainflow setttings
% NrBin = 46; % number of bins
% mvec = [12]; % material parameter, e.g. steel m=3,4, glasfiber m=12

% f_txt = 1; % show logs in screen
% f_txt = fopen('logfile.txt', 'a'); % write logs in file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------------------------------------------
% no_chan = length(chan);

%% read sel file
fsel = fopen([FileName, '.sel']);

mast_l=0;
while ~feof(fsel)
    mast_l=mast_l+1;
    dsel{mast_l,1} = fgetl(fsel);
end
fclose(fsel);

hawc_vers = dsel{2};
no_scans_ch_time = dsel{9};
% no_scans_ch_time = sscanf(dsel{9}, '%g', 3);
dsel = dsel(13:end-1); % avoid the first lines of general comments in the sel file
% data.dsel = dsel;

% select channels according to their description ***************************
% i_Vhub = ind_channel_f1(data.dsel,i_chan1);

TimeLife = 1; %
no_scans_ch_time = sscanf(no_scans_ch_time, '%f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% key_name1 = 'wt'; % for wt identification
% key_name2 = '_wsp';  % same part in all file names before numbers for wind speed identification
% key_name3 = '_wdir';  % same part in all file names before numbers for wind direction identification
% Index1 = strfind(FileName, key_name1);
% dum_wt = sscanf(FileName(Index1(1) + length(key_name1):end), '%g', 3);
% Index2 = strfind(FileName, key_name2);
% Vhub = sscanf(FileName(Index2(1) + length(key_name2):end), '%g', 3);
% Index3 = strfind(FileName, key_name3);
% dum_wdir = sscanf(FileName(Index3(1) + length(key_name3):end), '%g', 3);
% clear Index1 Index2 Index3 key_name2 key_name3


%% Statistics
%-----------------------------------------------------------------
MaxVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
MinVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
MeanVec    = zeros(1, no_scans_ch_time(2)); % pre-allocation
StdVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
RangeVec   = zeros(1, no_scans_ch_time(2)); % pre-allocation
% MaxVec_and_other  = zeros(no_scans_ch_time(2), no_scans_ch_time(2)); % pre-allocation
% MinVec_and_other  = zeros(no_scans_ch_time(2), no_scans_ch_time(2)); % pre-allocation

% for i=1:length(FileVec(:,1))
tic
% loading HAWC2 data file
% temp = strfind(FileName,' ');  % temp = findstr(FileVec(i,:),' ');
%     [sig,FreqSim,TimeSim(i,1),Binary]  = ReadHawc2(FileVec(i,1:temp-5));
[sig,FreqSim,~,~]  = ReadHawc2(FileName);
%     dum_const = ind_channel_f1(data.dsel, '91      Constant                       -          Constant value');
%     dum_Vhub = sig(1, dum_const)
%     wt*10^7+wspd(j,1)*10^4+ wind_rose(i,1)+9*10^6+9*10^3;
% wt*10^5+wspd(j,1)*10^3+ wind_rose(i,1);
%     dum_Vhub2 = floor(dum_Vhub/10^4);
%     Vhub = rem(dum_Vhub2, 100);
%     wt = floor(dum_Vhub/10^7)

TimeSkip =0;
if TimeSkip ~= 0
    sig = sig(TimeSkip*FreqSim:end,:);
end
%     dumm = sqrt(sig(:,11).*sig(:,11)+sig(:,12).*sig(:,12)); % NM80
% dumm = sqrt(sig(:,26).*sig(:,26)+sig(:,27).*sig(:,27)); % V80
% Vxymean = mean(dumm);
% Vxystd = std(dumm);

% % it keeps only the max/min,... of each sensor
% MaxVec(1,:) = max(sig);
% MinVec(1,:) = min(sig);
MeanVec(1,:) = mean(sig);
StdVec(1,:) = std(sig);
RmsVec(1,:) = rms(sig);

% it keeps the max/min,... of each sensor and the values of the other
% sensors at that time instance!!! (are written on the same row)
% the diagonal of Vec_and_other corresponds to the usual MaxVec, MinVec
[MaxVec(1,:),ind_i(1,:)] = max(sig);   MaxVec_and_other = sig(ind_i(1,:),:); clear ind_i
[MinVec(1,:),ind_i(1,:)] = min(sig);   MinVec_and_other = sig(ind_i(1,:),:); clear ind_i


% check!! (should be zero!!)
% dgnal = MaxVec_and_other(sub2ind(size(MaxVec_and_other),1:size(MaxVec_and_other,1),1:size(MaxVec_and_other,2)));
% MaxVec(1,:)- dgnal


RangeVec(1,:) = MaxVec(1,:)-MinVec(1,:);
% if f_txt~=-1
fprintf(f_txt, 'time to compute stat. for  %s \n %s \n', FileName, num2str(toc));
% else
%     disp(['time to compute stat. for ',FileName,' = ',num2str(toc)])
%     fprintf('----------------------------------------- %s\n', ' ');
% end

% extract sel file description       ****************************
% read the .sel description of signals ****************************
fsel = fopen([FileName, '.sel']);
mast_l=0;
while ~feof(fsel)
    mast_l=mast_l+1;
    dsel{mast_l,1} = fgetl(fsel);
end
fclose(fsel);
dsel = dsel(13:end-1); % save the description (avoid the first lines of general comments in the sel file)

dsel_fat = dsel(chan); % save only of the analysed fatigue channels


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
range = zeros(length(RangeVec(1,:)), NrBin); % pre-allocation
for i=1:length(RangeVec(1,:))
    temp = max(RangeVec(:,i))*linspace(0,1,NrBin+1)';
    range(i,:) = temp(2:end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fatigue Rainflow counting
%-----------------------------------------------------------------
N     = zeros(NrBin, length(chan)); % pre-allocation
Nlife = zeros(NrBin, length(chan)); % pre-allocation
TimeRatio = zeros(1,1); % pre-allocation
TimeSim = zeros(1, 1); % pre-allocation


tic

[sig,FreqSim,TimeSim(1,1)]  = ReadHawc2(FileName);
if TimeSkip ~= 0
    sig = sig(TimeSkip*FreqSim:end,:);
    TimeSim(1,1) = TimeSim(1,1)-TimeSkip;  % sec
end

TimeRatio(1) = TimeLife(1,1)/(TimeSim(1,1)/60/60);  % sec/sec
% compute rain flow counting for each channel

rf_markov{length(chan),1} = []; % pre-allocation
for k=1:length(chan)
    %     chan(k)
    %     N(:,1,k) = RainflowCounting(sig(:,chan(k)),range(chan(k),:));
    % N(:,k) = RainflowCounting_f1(sig(:,chan(k)),range(chan(k),:));
    [N(:,k), rf_markov{k,1}] = RainflowCounting_f1b(sig(:,chan(k)),range(chan(k),:)); % extracts also the Markov matrix
    Nlife(:,k) = N(:,k)*TimeRatio(1);  % transform to life time cycles
end
% if f_txt~=-1
fprintf(f_txt, 'time to handle  %s \n %s \n', FileName, num2str(toc));
% else
%     disp(['time of RainflowCounting ',FileName,' = ',num2str(toc)])
%     fprintf('----------------------------------------- %s\n', ' ');
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% equivilant load for f-ref = 1 Hz and for each file
%-----------------------------------------------------------------
S1 = zeros(length(mvec),length(chan));
for k=1:length(chan)
    for j=1:length(mvec)
        neq = TimeLife*60*60; % sec
        S1(j,k) = (sum(0.5*Nlife(:,k).*range(chan(k),:)'.^mvec(j))/neq)^(1/mvec(j));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S1_mean = zeros(length(mvec), length(chan)); % pre-allocation
for k=1:length(mvec) % Wolher exponent
    for i=1:length(chan) % channels
        S1_mean(k,i) = mean(S1(k,i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% saving results (1-way)
% -----------------------------------------------------------------
% range = range(ChVec(:,1),:)';
% save(ResFileName,'S1','S2','N','Nlife','range','TimeRatio','TimeLife',...
%     'neqVec','ChVec','FileVec','WsVec','mvec',...
%     'MaxVec','MinVec','MeanVec','StdVec')

% saving results (2-way)
% fat.rf_full_cycl        = rf_full_cycl;
% fat.rf_half_cycl        = rf_half_cycl;
fat.rf_markov = rf_markov;
fat.S1        = S1;
% fat.S2        = S2;
fat.N         = N; % including the added channels
fat.Nlife     = Nlife; % dt of the HAWC2 simulations
fat.range     = range;
fat.TimeRatio = TimeRatio;
% fat.TimeLife  = TimeLife;
% fat.neqVec    = neqVec;
fat.ChVec     = chan; % channels where the fatigue analysis is performed (read from inp file)
fat.FileVec   = FileName;
% fat.WsVec     = WsVec;
fat.mvec      = mvec;
fat.MaxVec    = MaxVec;
fat.MinVec    = MinVec;
fat.MeanVec   = MeanVec;
fat.StdVec    = StdVec;
fat.RmsVec    = RmsVec;

fat.MaxVec_and_other    = MaxVec_and_other;
fat.MinVec_and_other    = MinVec_and_other;

% fat.Vxymean   = Vxymean;
% fat.Vxystd    = Vxystd;
% fat.Vhub      = Vhub;
% fat.seeds     = seeds;
fat.dsel      = dsel;
fat.dsel_fat  = dsel_fat;
% fat.S1_mean   = S1_mean;
fat.hawc_vers  = hawc_vers;
fat.no_scans_ch_time  = no_scans_ch_time;
fat.name      = [FileName, '_fat'];

save([FileName,'_fat'], 'fat')

% if f_txt~=-1
fprintf(f_txt, 'Fat analysis done %s \n', '');
fprintf(f_txt,' %s\n', ' ');
% else
%     disp('Fat analysis done')
%     fprintf('----------------------------------------- %s\n', ' ');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% functions
%-----------------------------------------------------------------
% % function N = RainflowCounting(sig,range)
% % global test1 test2
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % rain flow functions are downloaded from:
% % % http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3026
% %
% % % extract turningspoints
% % test1 = sig;
% % sig =sig2ext(sig);
% % test2 = sig;
% %
% % % compute rainflow counting
% % rf=rainflow(sig);
% %
% % % convert to half cycles
% % [Y,I] = sort(rf(3,:));
% % I1 = find(Y < 1);
% % if isempty(I1) == 0
% %     I1=I1(end);
% %     rf = [rf rf(:,I(I1:end))];
% % end
% %
% % % bin numbers of half cycles into NrBin bins
% % N = hist(rf(1,:),[0,range]/2)';
% % N = N(2:end);

% pause



