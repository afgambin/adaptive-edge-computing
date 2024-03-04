%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BS ENERGY TRADING - Automatic Simulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear all, close all
%addpath('/home/afgambin/cvx/functions/vec_')

%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

N = 10;     % number of BSs (all of them are ongrid)
n_array = 10;%10:1:20; % number of solar panels, it depends on e_max, ie, n*e_max
eta_EB_array = 0.15;%0:0.05:0.5; % loss factor for the EB
store = 1;      % save results  
alpha_HE_array = [1]; % controls amplitude in the harvested energy profile

% Battery model
e_max = 100;   %[W]         % energy buffer capacity
load_adjust_array = e_max*0.6; % controls amplitude in the traffic load profile

% Clusters to be tested
clusters = [1,2,3,4,5];   % 1 max - 2 min
prob = 1;%0:0.05:1;    % traffic load sweep - about cluster 1 (max load)

pathFolder = [pwd '/results/cluster_all_load'];

% HE randomness
shadowing_factor = 0.1; % uniform distribution between [-value, value]


for n=1:length(n_array)
    for j=1:length(prob)
        
        % Traffic load profiles
        array_power_demand_BS = generate_traffic_profile(N, e_max, load_adjust_array, clusters, prob(j));
        
        for i=1:length(alpha_HE_array)
            % harvested energy profile
            array_BS_HE = generate_harvested_profile(n_array(n), shadowing_factor, e_max, alpha_HE_array(i));
            
            for k=1:length(eta_EB_array)
                               
                % call the main simulator function
                scenario(N, n_array(n), eta_EB_array(k), array_BS_HE, array_power_demand_BS, store, pathFolder, alpha_HE_array(i), prob(j), e_max)
                
                % delete dataProfiles.mat
                
            end
        end
    end
end



