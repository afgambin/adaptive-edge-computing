clc, clear all, close all

S = 3; % Number of operators
N = 10;  % Number of BSs
M = 20; %Number of VMs
H = 24; % Horizon
m_all = randi(5,N,H);
%m_all = 3*ones(N,H);

indexes_1 = 1:2;
indexes_2 = 3:5;
indexes_3 = 6:10;

% Constraints
m0 = m_all(:,1);
m_max_0 = M - m0; 
m_max = [m_max_0 M*ones(N,H-1)]; 
m_min = zeros(N,H); 
a = 0.5;

%cvx_solver
cvx_begin quiet

    variable m(N,H)
    
    %maximize( a*(sum(sum(m)/M))  ) 
    
    minimize( a*(sum(sum(m)/M)) + (1-a)*sum(sum(abs(m-m_all))) )
        
    subject to   
    
        sum(m(indexes_1, 1:end)) == sum(m(indexes_2, 1:end)) == sum(m(indexes_3, 1:end));
        
        % Actuator limits
        m_min <= m <= m_max;
        sum(m) <= M;
               
cvx_end

% graphs

for i=[1]
    figure, plot(m(i,:), '-*b')
    hold on
%     plot(g(i,:), '-xr')
%     hold on     
    xlabel('Time (hours)')
    grid on
    legend('VM')
    axis tight;
    title('VM allocation')
end




