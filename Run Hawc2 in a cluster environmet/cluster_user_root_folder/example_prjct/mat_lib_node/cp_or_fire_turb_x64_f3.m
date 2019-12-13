%% turb ************************************
function [run_x64_turb_uvw_in_scratch, run_x64_turb_uvw_in_scratch_dum,...
    turb_path_name_u_dum, turb_path_name_v_dum,...
    turb_path_name_w_dum, turb_path_name_u] = cp_or_fire_turb_x64_f3(htc_file_path, htc_file_name,...
    x64_turb_gen_flag, ijk, dum_file, f_txt)
%%
fprintf(f_txt, '--------------------------------------------------------- %s\n', ' ');
fprintf(f_txt, '\n turb copy or gen x64 %s\n', ' ');
fprintf(f_txt, '\n cp_or_fire_turb_x64_f2() %s\n', ' ');

%% find names
key_name111 = 'filename_u'; % this used to find the line and creates the 1st,2nd columns of  'keep_data'
key_name222 = 'filename_u'; % this creates the 3rd column of  'keep_data'
[turb_path_name_u_dum] = extract_hawc2_file_paths_f3(htc_file_path, htc_file_name, key_name111, key_name222);
if isempty(turb_path_name_u_dum)==0
    for ij=1:length(turb_path_name_u_dum(:,3))
        dum = strsplit(turb_path_name_u_dum{ij,3},'/');
        turb_path_name_u{ij,1} = [strjoin(dum(2:end-1),'/')];
    end
else
    turb_path_name_u{1,1} = 'not_foundORnot_used';
end
clear key_name111 key_name222

[turb_path_name_v_dum] = extract_hawc2_file_paths_f3(htc_file_path, htc_file_name, 'filename_v', 'filename_v');
[turb_path_name_w_dum] = extract_hawc2_file_paths_f3(htc_file_path, htc_file_name, 'filename_w', 'filename_w');

if isempty(turb_path_name_u_dum)==0
    disp('inside fire_turb_x64_f1')
    
    %% stand alone x64 creation of turb filenames and parameters
    
    if x64_turb_gen_flag == 1
        % *****************************************
        % read the .htc ****************************
        % extract the htc file lines    ****************************
        fmaster = fopen([htc_file_path, htc_file_name]);
        mast_l = 0;
        % i1 = 0;
        % i2 = 0;
        while ~feof(fmaster)
            mast_l = mast_l+1;
            mast{mast_l,1} = fgetl(fmaster); % store the htc file lines content
        end
        fclose(fmaster);
        clear fmaster % mast_l

        key_name5 = 'create_turb_parameters';
        [find_turb_L_alpha_gamma_seed_HFcomp(1,1)] = extract_key_name_lines_htc_f1(1, mast_l,key_name5, mast);
        clear key_name5
        [box_dim_u(1,1)] = extract_key_name_lines_htc_f1(1, mast_l,'box_dim_u', mast);
        [box_dim_v(1,1)] = extract_key_name_lines_htc_f1(1, mast_l,'box_dim_v', mast);
        [box_dim_w(1,1)] = extract_key_name_lines_htc_f1(1, mast_l,'box_dim_w', mast);
        %     end
        
        if isempty(turb_path_name_u_dum) ~=1
            % check if the number of turb blocks/params are consistent
            err = 0;
            if length(turb_path_name_u_dum(:,3)) ~= length(turb_path_name_v_dum(:,3))
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: turb_path_name_v_dum ')
                disp(' ')
            end
            if length(turb_path_name_u_dum(:,3)) ~= length(turb_path_name_w_dum(:,3))
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: turb_path_name_w_dum ')
                disp(' ')
            end
            if  length(turb_path_name_u_dum(:,3)) ~= size(find_turb_L_alpha_gamma_seed_HFcomp{1,1},1)
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: find_turb_L_alpha_gamma_seed_HFcomp ')
                disp(' ')
            end
            if length(turb_path_name_u_dum(:,3)) ~= size(box_dim_u{1,1},1)
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: box_dim_u ')
                disp(' ')
            end
            if length(turb_path_name_u_dum(:,3)) ~= size(box_dim_v{1,1},1)
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: box_dim_v ')
                disp(' ')
            end
            if length(turb_path_name_u_dum(:,3)) ~= size(box_dim_w{1,1},1)
                disp(' '); err = 1;
                disp('something is not well defined in turb block(s)')
                disp('check: box_dim_w ')
                disp(' ')
            end
            if err==1
                make_script_to_crash
            end
            clear err
        end
        
        
        if isempty(turb_path_name_u_dum)==0
            for ij=1:length(turb_path_name_u_dum(:,3))
                dum_u = strrep(turb_path_name_u_dum{ij,3},'_u.bin','');
                
                alpha_L_gamma_seed_Nu_Nv_Nw_du_dv_dw_HFcomp_str{ij,1} = [num2str(find_turb_L_alpha_gamma_seed_HFcomp{1,1}(ij,2)),' ',... % alpha
                    num2str(find_turb_L_alpha_gamma_seed_HFcomp{1,1}(ij,1)),' ',...   % L
                    num2str(find_turb_L_alpha_gamma_seed_HFcomp{1,1}(ij,3)),' ',...   % gamma
                    num2str_f1(find_turb_L_alpha_gamma_seed_HFcomp{1,1}(ij,4),0),' ',...   % seed
                    num2str(box_dim_u{1,1}(ij,1)),' ',...  % Nu
                    num2str(box_dim_v{1,1}(ij,1)),' ',...  % Nv
                    num2str(box_dim_w{1,1}(ij,1)),' ',...  % Nw
                    num2str(box_dim_u{1,1}(ij,2)),' ',...  % du
                    num2str(box_dim_v{1,1}(ij,2)),' ',...  % dv
                    num2str(box_dim_w{1,1}(ij,2)),' ',...  % dw
                    num2str_f1(find_turb_L_alpha_gamma_seed_HFcomp{1,1}(ij,5),0)];  % HFcomp
                
                run_x64_turb_uvw_in_scratch_dum{ij,1} = ['WINEARCH=win64 WINEPREFIX=~/.wine wine mann_turb_x64.exe ',dum_u,' ',alpha_L_gamma_seed_Nu_Nv_Nw_du_dv_dw_HFcomp_str{ij,1},' &'];
                clear dum_u
            end
        else
            run_x64_turb_uvw_in_scratch_dum{1,1} = [' ### not_found or not used'];
        end
        clear key_name111 key_name222
        
        % tag
        run_x64_turb_uvw_in_scratch = strjoin(run_x64_turb_uvw_in_scratch_dum,'\n\t');
    else
        run_x64_turb_uvw_in_scratch = ' ';
        run_x64_turb_uvw_in_scratch_dum{1,1} = ' ';
    end
    

    pause(1)
    
    %% fire
    
    if x64_turb_gen_flag == 1
        cd(['./H2_c',num2str(ijk),'/']);
        disp('currentFolder_turb:')
        currentFolder_turb = pwd
        
        
        % make turb sub-directories
        for tu_f=1:length(turb_path_name_u(:,1))
            if exist(turb_path_name_u{tu_f,1},'dir')~=7
                mkdir(turb_path_name_u{tu_f,1});
            end
        end
        
        % run turb_x64
        for i=1:length(run_x64_turb_uvw_in_scratch_dum(:,1))
            %         i
            disp('run turb64---')
            tic
            
            [~, ~] = system([run_x64_turb_uvw_in_scratch_dum{i,1}, ' -echo >> ','.', dum_file]); % ok

            toc
            disp('end run turb64')
           
            fprintf(f_txt,'run_x64_turb_uvw_in_scratch_dum{i,1} %s\n', run_x64_turb_uvw_in_scratch_dum{i,1});
            fprintf('run_x64_turb_uvw_in_scratch_dum{i,1} %s\n', run_x64_turb_uvw_in_scratch_dum{i,1});
           
            pause(25)
            
            
            maxSecondsToWait = 3600*2; % Wait 3600 seconds at most.
            secondsWaitedSoFar  = 0;
            while secondsWaitedSoFar < maxSecondsToWait
                turb_path_name_w_dum{i,2}
                if exist([ turb_path_name_w_dum{i,2}], 'file')
                    break;
                end
                disp('wait extra 20sec')
                pause(20); % Wait 20 seconds.
                secondsWaitedSoFar = secondsWaitedSoFar + 20;
            end
            if exist(turb_path_name_w_dum{i,2}, 'file')
                %   v = fileread('x.log')
            else
                warningMessage = sprintf('Warning: x.log never got created after waiting %d seconds', secondsWaitedSoFar);
                uiwait(warndlg(warningMessage));
            end
            
            listing = ls(turb_path_name_u{i,1}); % ok
            fprintf(f_txt,' %s\n', turb_path_name_u{i,1});
            
            for i1=1:length(listing(:,1))
                
                fprintf(f_txt,' %s\n', listing(i1,:));
            end
            clear listing
        end
    end
    
    %%
    fprintf(f_txt, '\n -----------end turb copy or gen x64-------------- %s\n', ' ');
    pause(3)
    
else
    run_x64_turb_uvw_in_scratch = ' ';
    run_x64_turb_uvw_in_scratch_dum{1,1} = [' ### not_found or not used'];
    fprintf(f_txt, '\n -----------no relevant turb block/params for turbulence box generation -------------- %s\n', ' ');
    cd(['./H2_c',num2str(ijk),'/']);
end






