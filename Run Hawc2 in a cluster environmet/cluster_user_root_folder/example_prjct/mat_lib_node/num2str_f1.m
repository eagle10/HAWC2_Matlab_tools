%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       11-4-2017
% Version:    1.0
%
%  
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str_no = num2str_f1(numb,decimals)


%%

if numb<0
    if decimals==0
        decimals=1; % in order to add 'm' if the numbeer is negative
    end
    dum = [num2str(numb,['%1.',num2str(decimals),'f'])];
    str_no = strrep(dum,'-','');     % replace . with m for minus
    str_no = strrep(str_no,'.','m'); % replace . with m for minus
elseif numb>=0
    dum = [num2str(numb,['%1.',num2str(decimals),'f'])];
    str_no = strrep(dum,'.','p');    % replace . with p
end




