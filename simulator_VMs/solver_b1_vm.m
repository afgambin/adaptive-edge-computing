function [struct_b1] = solver_b1_vm(N, M, H, m_all, struct_ind)

% debug
% S = 3; % Number of operators
% N = 10;  % Number of BSs
% M = 20; %Number of VMs
% H = 24; % Horizon
% m_all = randi(5,N,H);
% indexes_1 = 1:2;
% indexes_2 = 3:5;
% indexes_3 = 6:10;

S = 3; % number of operators

m_all_s1 = m_all(struct_ind.indexes_1, 1:end);
m_all_s2 = m_all(struct_ind.indexes_2, 1:end);
m_all_s3 = m_all(struct_ind.indexes_3, 1:end);

m_s1 = m_all_s1*0;
m_s1(:) = ((M/S)/length(struct_ind.indexes_1));

m_s2 = m_all_s2*0;
m_s2(:) = ((M/S)/length(struct_ind.indexes_2));

m_s3 = m_all_s3*0;
m_s3(:) = ((M/S)/length(struct_ind.indexes_3));

m = [m_s1; m_s2; m_s3];

% Outputs
struct_b1.gamma = sum(m)/M;
struct_b1.m = m;
struct_b1.m_all = m_all;

end