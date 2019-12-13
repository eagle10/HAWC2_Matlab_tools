%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       6-4-2017
% Version:    1.0
%
% 
% Does a rainflow counting and statistics

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Fatigue_1file_f1b(ResFileName, NrBin, mvec, chan, f_txt)



FileName = ResFileName;
%-----------------------------------------------------------------
no_chan = length(chan);

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
dsel = dsel(13:end-1); % avoid the first lines of general comments in the sel file
data.dsel = dsel;

TimeLife = 1; % check
no_scans_ch_time = sscanf(no_scans_ch_time, '%f');


%% Statistics
%-----------------------------------------------------------------
MaxVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
MinVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
MeanVec    = zeros(1, no_scans_ch_time(2)); % pre-allocation
StdVec     = zeros(1, no_scans_ch_time(2)); % pre-allocation
RangeVec   = zeros(1, no_scans_ch_time(2)); % pre-allocation

tic

[sig,FreqSim,~,~]  = ReadHawc2(FileName);

TimeSkip =0;
if TimeSkip ~= 0
    sig = sig(TimeSkip*FreqSim:end,:);
end

MaxVec(1,:) = max(sig);
MinVec(1,:) = min(sig);
MeanVec(1,:) = mean(sig);
StdVec(1,:) = std(sig);
RmsVec(1,:) = rms(sig);

RangeVec(1,:) = MaxVec(1,:)-MinVec(1,:);

fprintf(f_txt, 'time to compute stat. for  %s \n %s \n', FileName, num2str(toc));

fsel = fopen([FileName, '.sel']);
mast_l=0;
while ~feof(fsel)
    mast_l=mast_l+1;
    dsel{mast_l,1} = fgetl(fsel);
end
fclose(fsel);
dsel = dsel(13:end-1); % avoid the first lines of general comments in the sel file

dsel_fat = dsel(chan); % save the description only of the analysed fatigue channels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
range = zeros(length(RangeVec(1,:)), NrBin); % pre-allocation
for i=1:length(RangeVec(1,:))
    temp = max(RangeVec(:,i))*linspace(0,1,NrBin+1)';
    range(i,:) = temp(2:end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
disp(' ')

for k=1:length(chan)

   [N(:,k), rf_markov{k,1}] = RainflowCounting_f1b(sig(:,chan(k)),range(chan(k),:)); % extracts also the Markov matrix
   Nlife(:,k) = N(:,k)*TimeRatio(1);  % transform to life time cycles
end
fprintf(f_txt, 'time to handle  %s \n %s \n', FileName, num2str(toc));

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


fat.rf_markov = rf_markov;
fat.S1        = S1;

fat.N         = N; % including the added channels
fat.Nlife     = Nlife; % dt of the HAWC2 simulations
fat.range     = range;
fat.TimeRatio = TimeRatio;

fat.ChVec     = chan; % ch
fat.FileVec   = FileName;
fat.mvec      = mvec;
fat.MaxVec    = MaxVec;
fat.MinVec    = MinVec;
fat.MeanVec   = MeanVec;
fat.StdVec    = StdVec;
fat.RmsVec    = RmsVec;
fat.dsel      = dsel;
fat.dsel_fat  = dsel_fat;
fat.hawc_vers  = hawc_vers;
fat.no_scans_ch_time  = no_scans_ch_time;
fat.name      = [FileName, '_fat'];

save([ResFileName,'_fat'], 'fat')

% fprintf(f_txt,' %s\n', ' ');
fprintf(f_txt, 'Fat analysis done %s \n', '');
% disp(['Fat analysis done'])
fprintf(f_txt,' %s\n', ' ');
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



