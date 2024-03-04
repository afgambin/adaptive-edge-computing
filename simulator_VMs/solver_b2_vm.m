function [struct_b1] = solver_b2_vm(N, M, H, m_all, struct_ind)

% debug
% S = 3; % Number of operators
% N = 10;  % Number of BSs
% M = 20; %Number of VMs
% H = 24; % Horizon
% m_all = randi(5,N,H);
% indexes_1 = 1:2;
% indexes_2 = 3:5;
% indexes_3 = 6:10;

m = zeros(N,H);

for i=1:size(m_all,2)  
    aux = m_all(:,i)/sum(m_all(:,i));
    m(:,i) = aux*M;
end

% Outputs
struct_b1.gamma = sum(m)/M;
struct_b1.m = m;
struct_b1.m_all = m_all;

end