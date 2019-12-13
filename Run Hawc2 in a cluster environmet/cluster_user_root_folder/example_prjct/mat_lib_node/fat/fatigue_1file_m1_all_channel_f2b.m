%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       22-5-2017
% Version:    1.0
%
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fatigue_1file_m1_all_channel_f2b(fname, NrBin, mvec, Marcov_flg, f_txt)

%%

txt_with_channels = 'all_channels.txt';


%% read the .sel file
fsel = fopen([fname, '.sel']);

mast_l=0;
while ~feof(fsel)
    mast_l=mast_l+1;
    dsel{mast_l,1} = fgetl(fsel);
end
fclose(fsel);


no_scans_ch_time = dsel{9};
no_scans_ch_time = sscanf(dsel{9}, '%g', 3);


dsel = dsel(13:end-1); % avoid the first lines of general comments in the sel file

file_fat = fopen(txt_with_channels);

if file_fat==-1
%     fprintf(f_txt, '------------------------------- %s\n', '----------');
    fprintf(f_txt, 'the txt file with the selected channels ');
    fprintf(f_txt, 'for fatigue analysis was not found txt_file: %s\n', '');
    fprintf(f_txt, ':: %s\n', txt_with_channels);
    fprintf(f_txt, 'all channels will be analyzed %s\n', '');
    chan = 1:no_scans_ch_time(2);
    
else
    fprintf(f_txt, 'fatigue analysis found txt_file:: %s\n', '');
    fprintf(f_txt, ':: %s\n', txt_with_channels);
    sum1=0;
    while ~feof(file_fat)
        sum1=sum1+1;
        fatigue_ch_descr{sum1,1} = fgetl(file_fat);
    end
    fclose(file_fat);
    clear sum1
    
    for i = 1:length(fatigue_ch_descr)
        chan(i) = ind_channel_f1(dsel,fatigue_ch_descr{i});
    end
end
%-----------------------------------------------------------------

% FatigueFun analysis ==========================================================

if Marcov_flg == 0
    Fatigue_1file_f1(fname, NrBin, mvec, chan, f_txt);
elseif Marcov_flg == 1
    Fatigue_1file_f1b(fname, NrBin, mvec, chan, f_txt); % this saves the Marcov matrix per channel as well
end

fprintf(f_txt, '%s\n', ' ');
fprintf(f_txt, 'Statistics and fatigue analysis done %s\n', ' ');

