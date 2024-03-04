
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clusters XMEANS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('traffic_clusters_xmeans.mat')     % loading pre-saved cluster data
k= 5;     % number of clusters

figure, plot(cluster_5_xmeans_internet(:,1))
hold on
plot(cluster_5_xmeans_internet(:,2))
hold on
plot(cluster_5_xmeans_internet(:,3))
hold on
plot(cluster_5_xmeans_internet(:,4))
hold on
plot(cluster_5_xmeans_internet(:,5))
title('Traffic patterns from XMEANS clustering')
ylabel('Normalized traffic load')
xlabel('Time (hours)')
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5')
grid on
axis tight




