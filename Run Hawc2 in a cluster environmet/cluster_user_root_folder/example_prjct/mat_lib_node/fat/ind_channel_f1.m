% created by Christos Galinos 6-12-2014

% returns the index of the channel that has the given name
% searches the sel file

function [ind_ch] = ind_channel_f1(dsel,uniquevalue)

del = strfind(dsel, uniquevalue);
ind_ch=find(~cellfun(@isempty,del));

if length(ind_ch)>1
    fprintf('------------------------------------------\r');  %Result to screen
    disp('Error more than one signal has this name')
    fprintf('------------------------------------------\r\r');  
    ind_ch=-1;
elseif isempty(ind_ch)==1
    fprintf('------------------------------------------\r');  %Result to screen
    disp('Error non of the signals has this name')
    fprintf('------------------------------------------\r\r');  
    ind_ch=-1;
end










