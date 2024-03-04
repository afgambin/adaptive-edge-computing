%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VMs ALLOCATION - Automatic Simulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear all, close all
%addpath('/home/afgambin/cvx/functions/vec_')

%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

days_simulation = 10;

S = 3; % Number of operators
N = 10;  % Number of BSs
store = 0;
M = 10:2:50; %Number of VMs - sweep
m_max = 5; % Max number of VMs per BS and time slot t
prob = 1;%0:0.05:1;    % comp load sweep - about cluster 1 (max load)
H = 24; %1:1:24; % Horizon   - sweep

struct_ind.indexes_1 = 1:2;
struct_ind.indexes_2 = 3:5;
struct_ind.indexes_3 = 6:10;

pathFolder = [pwd '/results/weighted_2'];

for m = 1:length(M)
    
    fprintf('M: %d \n', M(m));
    
    for h = 1:length(H)
        
        fprintf('H: %d \n', H(h));
        
        %%%% Stats %%%%%
        av_load = zeros(1,H(h));
        
        %MPC
        av_gamma_mpc = zeros(1,H(h));
        av_m_mpc = zeros(N,H(h));
        av_m_all_mpc = zeros(N,H(h));
        
        %B1
        av_gamma_b1 = zeros(1,H(h));
        av_m_b1 = zeros(N,H(h));
        av_m_all_b1 = zeros(N,H(h));
        
        %B2
        av_gamma_b2 = zeros(1,H(h));
        av_m_b2 = zeros(N,H(h));
        av_m_all_b2 = zeros(N,H(h));
        
        %%%%%%% MAIN LOOP %%%%%%%%
        for day=1:days_simulation
            
            fprintf('Simulation day: %d \n', day);
            
            % Computation load profiles
            array_comp_demand_BS = generate_comp_load_profile(N, m_max, H(h));
            av_load = av_load + mean(array_comp_demand_BS);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Calling optimization framework
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % MPC trading scheme
            [struct_mpc] = solver_mpc_vm(N, M(m), H(h), array_comp_demand_BS, struct_ind);
            av_gamma_mpc = av_gamma_mpc + struct_mpc.gamma;
            av_m_mpc = av_m_mpc + struct_mpc.m;
            av_m_all_mpc = av_m_all_mpc + struct_mpc.m_all;
            
            % B1 scheme - each operator gets a fixed portion of the MEC resources
            [struct_b1] = solver_b1_vm(N, M(m), H(h), array_comp_demand_BS, struct_ind);
            av_gamma_b1 = av_gamma_b1 + struct_b1.gamma;
            av_m_b1 = av_m_b1 + struct_b1.m;
            av_m_all_b1 = av_m_all_b1 + struct_b1.m_all;
            
            % B2 scheme - No fairness among operators - the higher the BS load, the higher VMs allocated
            [struct_b2] = solver_b2_vm(N, M(m), H(h), array_comp_demand_BS, struct_ind);
            av_gamma_b2 = av_gamma_b2 + struct_b2.gamma;
            av_m_b2 = av_m_b2 + struct_b2.m;
            av_m_all_b2 = av_m_all_b2 + struct_b2.m_all;
            
        end
        
        % MPC
        av_gamma_mpc_f = av_gamma_mpc / days_simulation;
        av_m_mpc_f = av_m_mpc / days_simulation;
        av_m_all_mpc_f = av_m_all_mpc / days_simulation;
        
        % Storing data
        if store == 1
            save([pathFolder '/mpc_M_' num2str(M(m)) '_H' num2str(H(h))],'av_gamma_mpc_f', 'av_m_mpc_f', 'av_m_all_mpc_f', 'av_load');
            fprintf('MPC data stored. \n');
        end
        
        % B1
        av_gamma_b1_f = av_gamma_b1 / days_simulation;
        av_m_b1_f = av_m_b1 / days_simulation;
        av_m_all_b1_f = av_m_all_b1 / days_simulation;
        
        % Storing data
        if store == 1
            save([pathFolder '/b1_M_' num2str(M(m)) '_H' num2str(H(h))],'av_gamma_b1_f', 'av_m_b1_f', 'av_m_all_b1_f', 'av_load');
            fprintf('B1 data stored. \n');
        end
        
        % B2
        av_gamma_b2_f = av_gamma_b2 / days_simulation;
        av_m_b2_f = av_m_b2 / days_simulation;
        av_m_all_b2_f = av_m_all_b2 / days_simulation;
        
        % Storing data
        if store == 1
            save([pathFolder '/b2_M_' num2str(M(m)) '_H' num2str(H(h))],'av_gamma_b2_f', 'av_m_b2_f', 'av_m_all_b2_f', 'av_load');
            fprintf('B2 data stored. \n');
        end
        
    end
    
end





