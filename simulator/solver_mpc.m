function [current_action] = solver_mpc(n, eta_EB, E_max, E0, array_BS_HE, array_power_demand_BS, hour, array_SG_prices)

% E_max -> battery_max_level
% E0 -> battery Level array of L
% array_BS_HE -> harvested energy for L
% array_power_demand_BS -> traffic load for L
% hour -> current time slot
% array_prices -> SG energy prices


% debug
% clc, clear all, close all
% E_max = 100;
% E0 = 0;
% load('mpc_test')
% hour = 24;
%%%

E_max = n*E_max;
M = 24; % horizon
p = array_SG_prices; % SG energy prices -> cent/Wh
E_max_matrix = E_max*ones(1,M);

% Constraints
u_max_0 = E_max - E0;
u_max = [u_max_0 E_max*ones(1,M-1)]; % max Power
u_min = zeros(1,M); % min Power

aux = array_BS_HE' - array_power_demand_BS';    % disturbance considering daily profile (from hour 1)
disturbance = [aux(:, hour:end) aux(:, 1:(hour-1))];    % disturbance starting from current time slot
aux(aux >0) = 0;
E_min_matrix = abs(aux); 

%cvx_solver gurobi
cvx_begin quiet

    variables u(1,M) E(1,M)
    
    minimize( sum(sum(p.*u)))
    
    subject to   
    
        E == [E0 E(1:(M-1))] + u + disturbance - eta_EB*[E0 E(1:(M-1))];

        % Energy buffer constraints:
        E_min_matrix <= E <= E_max_matrix;
        %E_min <= E <= E_max;
        
        % Actuator limits
        u_min <= u <= u_max;
     
cvx_end

% graphs

% if eta_EB > 0
%     display('With loss constraint: d*E')
%     fprintf('Purchased energy: %d \n', sum(u));
%     fprintf('Av En buffer: %d \n', mean(E));
%     
%     for i=[1]
%     figure, plot(1000*u(i,:), '-*b')
%     hold on 
%     plot(1000*E(i,:), '-xr')
%     hold on
%     plot(p*10000, '-ok')
%     hold on
%     plot(1000*disturbance,'-+g')
%     xlabel('Time (hours)')
%     grid on
%     legend('Purchased energy', 'Energy buffer level', 'Energy price (cents/Wh)', 'Disturbance')
%     axis tight;
%     title('With loss constraint')
% end
%     
% else
%     display('Without loss constraint')
%     fprintf('Purchased energy: %d \n', sum(u));
%     fprintf('Av En buffer: %d \n', mean(E));
%     
%     for i=[1]
%     figure, plot(1000*u(i,:), '-*b')
%     hold on 
%     plot(1000*E(i,:), '-xr')
%     hold on
%     plot(p*10000, '-ok')
%     hold on
%     plot(1000*disturbance,'-+g')
%     xlabel('Time (hours)')
%     grid on
%     legend('Purchased energy', 'Energy buffer level', 'Energy price (cents/Wh)', 'Disturbance')
%     axis tight;
%     title('Without loss constraint')
%     end
% end

current_action = u(1); % MPC strategy performs the first control decision every step

end