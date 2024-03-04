function [struct_mpc] = solver_mpc_vm(N, M, H, m_all, struct_ind)

% debug
% S = 3; % Number of operators
% N = 10;  % Number of BSs
% M = 20; %Number of VMs
% H = 24; % Horizon
% m_all = randi(5,N,H);
% indexes_1 = 1:2;
% indexes_2 = 3:5;
% indexes_3 = 6:10;

% weights operators - for weighted distribution
s1 = length(struct_ind.indexes_1);
s2 = length(struct_ind.indexes_2);
s3 = length(struct_ind.indexes_3);

aux1 = 1-(s1/N);
aux2 = 1-(s2/N);
aux3 = 1-(s3/N);

% Constraints
m0 = m_all(:,1);
m_max_0 = M - m0; 
m_max = [m_max_0 M*ones(N,H-1)]; 
m_min = zeros(N,H); 

%cvx_solver
cvx_begin quiet

    variable m(N,H)
    
    minimize(  sum(sum((m-m_all).^2)) )    
    %minimize(  sum(sum(abs(m-m_all))) )
        
    subject to   
    
        % normal distribution
        %sum(m(struct_ind.indexes_1, 1:end)) == sum(m(struct_ind.indexes_2, 1:end)) == sum(m(struct_ind.indexes_3, 1:end));
        
         % weighted distribution
        aux1*sum(m(struct_ind.indexes_1, 1:end)) == aux2*sum(m(struct_ind.indexes_2, 1:end)) == aux3*sum(m(struct_ind.indexes_3, 1:end));
        
        % Actuator limits
        m_min <= m <= m_max;
        sum(m) <= M;
               
cvx_end

% Outputs
struct_mpc.gamma = sum(m)/M;
struct_mpc.m = m;
struct_mpc.m_all = m_all;

end