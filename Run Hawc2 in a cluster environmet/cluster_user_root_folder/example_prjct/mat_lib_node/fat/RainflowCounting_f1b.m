%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       6-4-2017
% Version:    1.0
%
% 
% Does a rainflow counting and
% extracts the N cycles and the Markov matrix of a signal
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%-----------------------------------------------------------------
function [N, rf_markov_mean_range_centers] = RainflowCounting_f1b(sig,range)
global test1 test2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rain flow functions are downloaded from:
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3026

% extract turningspoints
test1 = sig;
sig =sig2ext(sig);
test2 = sig;

% compute rainflow counting
rf=rainflow(sig);
rf_full_cycl = rf;

% convert to half cycles
[Y,I] = sort(rf(3,:));
I1 = find(Y < 1);
if isempty(I1) == 0
    I1=I1(end);
    rf = [rf rf(:,I(I1:end))];
end
rf_half_cycl = rf;

% bin numbers of half cycles into NrBin bins
N = hist(rf(1,:),[0,range]/2)';
N = N(2:end);

%% calculate the Markov matrix

if length(sig(:,1))==1
    rf_markov_mean_range_centers(1,1)=0; % so when the signal is a constant value
else
    nbins = length(range);
    ranges = [0,range];
    wdth_ranges = (ranges(end)-ranges(1))/(nbins);
    
    min_mean = min(rf_full_cycl(2,:));
    max_mean = max(rf_full_cycl(2,:));
    wdth_means = (max_mean-min_mean)/(nbins);
    means =linspace(min_mean-wdth_means/2,max_mean+wdth_means/2,nbins+1);
    
    rf_markov(nbins,nbins)=0;
    for i=1:nbins
        range1 = ranges(i);
        range2 = ranges(i+1);
        for j=1:nbins
            mean1 = means(j);
            mean2 = means(j+1);
            for k=1:length(rf_full_cycl(1,:))
                if (rf_full_cycl(1,k)>= range1/2) && (rf_full_cycl(1,k)<= range2/2)
                    if (rf_full_cycl(2,k)>= mean1) && (rf_full_cycl(2,k)< mean2)
                        rf_markov(i,j) = rf_markov(i,j)+rf_full_cycl(3,k);
                    end
                end
            end
        end
    end
    means_c = linspace(min_mean+(wdth_means/2),max_mean-(wdth_means/2),nbins);
    ranges_c = range-wdth_ranges/2;
    
    dum1 = [0, ranges_c]';
    dum2 = [means_c; rf_markov];
    rf_markov_mean_range_centers = [dum1, dum2];
end




