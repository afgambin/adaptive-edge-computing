function [array_power_demand_BS] = generate_traffic_profile(N, e_max, load_adjust, clusters, prob)

array_power_demand_BS = zeros(24, N);
%load('traffic_clusters.mat')    % traffic load clusters (5) -> DBSCAN
load('traffic_clusters_xmeans.mat')    % traffic load clusters (5) -> XMEANS

for i=1:N    
    selected_cluster = clusters(randi(length(clusters)));
    %selected_cluster = randsample([1 2],1, true, [prob 1-prob]);
    %array_power_demand_BS(:,i) = (e_max-load_adjust)*cluster_k_5(:,selected_cluster);   % DBSCAN adjust the load with % of e_max
    array_power_demand_BS(:,i) = (e_max-load_adjust)*cluster_5_xmeans_internet(:,selected_cluster);   % XMEANS
end

% debug
% for i=1:N
%    figure, plot(array_power_demand_BS(:,i)) 
%    axis tight
%    grid on
%    title(['max: ' num2str(max(array_power_demand_BS(:,i)))])
% end


end