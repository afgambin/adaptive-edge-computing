function [] = scenario(N, n, eta_EB, array_BS_HE, array_power_demand_BS, store, pathFolder, alpha_he, prob, battery_max_level)

%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

plotting = 0; 

% Main loop
days_simulation = 10;
hours_simulation = 24;

% SG energy prices
load('sg_prices_20.mat')

% Battery model
%initial_batteryLevel = randi(battery_max_level, N, 1); %[W]
initial_batteryLevel = (0.5*battery_max_level)*ones(N,1); %[W]
refThreshold = 1*n*battery_max_level;  % [%]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating features profiles for each simulated day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

av_harvested_energy = zeros(24, 1);
av_load = zeros(24,1);

if exist('dataProfiles.mat', 'file') % If the file exists, it is loaded
    fprintf('Loading pre-saved data profiles...\n');
    load('dataProfiles');
else
    fprintf('Creating new data profiles...\n');
    for day=1:days_simulation
        
        % Renewable energy pattern for each BS and each day       
        harvestedEnergy.(['day' num2str(day)]) = array_BS_HE;
        
        % Traffic profile for each BS and each day
        trafficProfile.(['day' num2str(day)]) = array_power_demand_BS;
        
        % SG energy prices for each day
        energy_prices.(['day' num2str(day)]) = array_prices(day,:); % 5 days ahead right now

        % stats
        av_harvested_energy = av_harvested_energy + mean(array_BS_HE,2);
        av_load = av_load + mean(array_power_demand_BS,2);
        
    end
    
    av_harvested_energy_profile = av_harvested_energy / days_simulation;
    av_load = av_load / days_simulation;
    %save('dataProfiles','harvestedEnergy','trafficProfile', 'energy_prices','initial_batteryLevel','av_harvested_energy_profile');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calling optimization framework
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Benchmark 1 - No EH but foresgihted optimization
% [struct_b1] = simulation_loop_b1(n, eta_EB, initial_batteryLevel, harvestedEnergy, trafficProfile, energy_prices, battery_max_level, refThreshold, days_simulation, hours_simulation, plotting);
% 
% % Storing data
% if store == 1 
%     save([pathFolder '/b1_' num2str(N) '_load' num2str(prob*100) '_shad' num2str(alpha_he*100) '_eta' num2str(eta_EB*100) '_panels' num2str(n)],'struct_b1', 'av_harvested_energy_profile', 'initial_batteryLevel', 'av_load');
%     fprintf('B1 data stored. \n');
% end

% Benchmark 2 - Purchase to cover demand 
[struct_b2] = simulation_loop_b2(n, eta_EB, initial_batteryLevel, harvestedEnergy, trafficProfile, energy_prices, battery_max_level, days_simulation, hours_simulation, plotting, refThreshold);

% Storing data
if store == 1 
    save([pathFolder '/b2_' num2str(N) '_load' num2str(prob*100) '_shad' num2str(alpha_he*100) '_eta' num2str(eta_EB*100) '_panels' num2str(n)],'struct_b2', 'av_harvested_energy_profile', 'initial_batteryLevel', 'av_load');
    fprintf('B2 data stored. \n');
end

% MPC trading scheme
% [struct_mpc] = simulation_loop_mpc(n, eta_EB, initial_batteryLevel, harvestedEnergy, trafficProfile, energy_prices, battery_max_level, days_simulation, hours_simulation, plotting);
% 
% % Storing data
% if store == 1 
%     save([pathFolder '/mpc_' num2str(N) '_load' num2str(prob*100) '_shad' num2str(alpha_he*100) '_eta' num2str(eta_EB*100) '_panels' num2str(n)],'struct_mpc', 'av_harvested_energy_profile', 'initial_batteryLevel', 'av_load');
%     fprintf('MPC data stored. \n');
% end


end
