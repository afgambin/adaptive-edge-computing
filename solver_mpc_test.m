%clc, clear all %, close all

% L -> number of BSs
% E_max -> battery_max_level
% E0 -> battery Level array of L
% alpha -> weighting factor
% array_BS_HE -> harvested energy for L
% array_power_demand_BS -> traffic load for L
% hour -> current time slot

L = 1;  
E0 = 0; %randi(100,L,1); % Initial state 
E_max = 100;
load('mpc_test')
load('sg_prices_5.mat')
hour = 1;
N = 24; % horizon
p = repmat(array_prices(2,:),L,1);    % SG energy prices -> cent/Wh
E_max_matrix = E_max*ones(L,N);

%safety_th = 0.1*E_max;

% debug
%u = rand(L,N);

% Constraints
u_max_0 = E_max - E0;
u_max = [u_max_0 E_max*ones(L,N-1)]; % max Power
u_min = zeros(L,N); % min Power

aux = array_BS_HE(:,1:L)' - array_power_demand_BS(:,1:L)';    % disturbance considering daily profile (from hour 1)
disturbance = [aux(:, hour:end) aux(:, 1:(hour-1))];    % disturbance starting from current time slot
aux(aux >0) = 0;
E_min_matrix = abs(aux); 

% Weighting factors
a = 1;
b = 1;
c = 1;
d = 0.3;

%cvx_solver gurobi
cvx_begin quiet

    variables u(L,N) E(L,N)
    
    minimize( sum(sum(p.*u)))
    
    subject to   
    
        E(:, 1:end) == a*[E0 E(:, 1:end-1)] + b * u(:,1:end) + c * disturbance(:,1:end) - d*[E0 E(:, 1:end-1)];

        % Energy buffer constraints:
        E_min_matrix <= E <= E_max_matrix;
        %E_min <= E <= E_max;
        
        % Actuator limits
        u_min <= u <= u_max;
               
cvx_end

% graphs

if d > 0
    display('With loss constraint: d*E')
    fprintf('Purchased energy: %d \n', sum(u));
    fprintf('Av En buffer: %d \n', mean(E));
    
    for i=[1]
    figure, plot(u(i,:), '-*b')
    hold on 
    plot(E(i,:), '-xr')
    hold on
    plot(p*10000, '-ok')
    hold on
    plot(disturbance,'-+g')
    xlabel('Time (hours)')
    grid on
    legend('Purchased energy', 'Energy buffer level', 'Energy price (cents/Wh)', 'Disturbance')
    axis tight;
    title('With loss constraint')
end
    
else
    display('Without loss constraint')
    fprintf('Purchased energy: %d \n', sum(u));
    fprintf('Av En buffer: %d \n', mean(E));
    
    for i=[1]
    figure, plot(u(i,:), '-*b')
    hold on 
    plot(E(i,:), '-xr')
    hold on
    plot(p*10000, '-ok')
    hold on
    plot(disturbance,'-+g')
    xlabel('Time (hours)')
    grid on
    legend('Purchased energy', 'Energy buffer level', 'Energy price (cents/Wh)', 'Disturbance')
    axis tight;
    title('Without loss constraint')
    end
end

