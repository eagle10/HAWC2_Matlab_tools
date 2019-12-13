%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:     Christos Galinos
% Date:       16-4-2016
% Version:    1.0
%
%
% Input   htc lines start/end and a key name 
%
% line number
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function   [c2_def] = extract_key_name_lines_htc_f1(c2_def_start, c2_def_end,...
                    key_name, mast)


c2_def(1,1) = {[]};

for i = 1:1 
    jj = 0;
        for j = (c2_def_start(i)+1):(c2_def_end(i)-1)
            Str = char( mast(j)); 
            Index = strfind(Str, key_name);
            if isempty(Index) == 0
                dum1 = char( mast(j));
                Index2 = strfind(dum1, ';');
                if isempty(Index2)==0
                    dum1 = dum1(1:Index2(1)-1);
                else
                    disp(['warn:line=',num2str(j),' is not terminated with ;'])
                    pause(1)
                end
                % remove space in the beginning of the line
                Index3 = strfind(dum1, key_name);
                if isempty(Index3) == 0
                    jj = jj+1;
                    dum1 = dum1(Index3(1):end);
                    % remove 'concentrated_mass' from the line
                    dum1 = strrep(dum1, key_name, '');
                    % extract the numbers
                    dum2(jj,:) = sscanf(dum1, '%f'); % numbers
                end
            end
        end
    if jj >0
        c2_def(i,:) = {dum2};
        clear dum2
    end
end