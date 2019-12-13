% Author   : Christos Galinos
% Date     : 15-3-2017
% Version  : 1.00
% *****************************************************************************

function [foldnames] = find_sub_fold_f1(folder_gen,foldnames1)

[foldnames] = find_fold_f1b(folder_gen,foldnames1);

%% find sub-sub-folders ******************************************************

for sub_foldr = 1:length(foldnames)
    [foldnames] = find_fold_f1b(folder_gen,foldnames);
end

foldnames = unique(foldnames);





