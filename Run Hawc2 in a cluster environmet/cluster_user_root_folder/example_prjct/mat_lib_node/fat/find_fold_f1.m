%
% Author   : Christos Galinos
% Date     : 15-2-2017
% Version  : 1.00
% *****************************************************************************

function [foldnames] = find_fold_f1(folder_gen,foldnames1)

%% parameters that may need change **********
sum=0;
for foldr1 = 1:length(foldnames1) % do for each folder i
    listing = dir([folder_gen,'\',foldnames1{foldr1}]);
    isub = [listing(:).isdir]; % # returns logical vector
    nameFolds = {listing(isub).name}';
    foldnames2 = nameFolds(3:end);
    if  isempty(foldnames2)==1
        foldnames2(1) = {''};
        sum = sum+1;
        foldnames{sum,1} = [foldnames1{foldr1}];
    else
        for sub_foldr = 1:length(foldnames2)+1
            sum = sum+1;
            if  sub_foldr==1
                foldnames{sum,1} = [foldnames1{foldr1}];
            else
%                 if  isempty(foldnames1{foldr1}) ~=1
                    foldnames{sum,1} = [foldnames1{foldr1},'\', foldnames2{sub_foldr-1}];
%                 end
            end
        end
    end
    clear isub isub listing nameFolds foldr1 sub_foldr
end
clear sum foldnames1 foldnames2






