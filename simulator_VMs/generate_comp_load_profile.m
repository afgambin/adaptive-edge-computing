function [array_comp_demand_BS] = generate_comp_load_profile(N, m_max, H)

array_comp_demand_BS = zeros(N, H);
load('traffic_clusters_xmeans.mat')    % traffic load clusters (5) -> XMEANS

for i=1:N    
    selected_cluster = randi(size(cluster_5_xmeans_internet,2));
    %selected_cluster = randsample([1 2],1, true, [prob 1-prob]);
    
    array_comp_demand_BS(i,:) = m_max*cluster_5_xmeans_internet(1:H,selected_cluster)';   % XMEANS
    %array_comp_demand_BS(i,:) = round(m_max*cluster_5_xmeans_internet(:,selected_cluster)');
end

% debug
% for i=1:N
%    figure, plot(array_comp_demand_BS(:,i)) 
%    axis tight
%    grid on
%    title(['max: ' num2str(max(array_comp_demand_BS(:,i)))])
% end

end