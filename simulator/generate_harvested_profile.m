function [array_BS_HE] = generate_harvested_profile(N, shadowing_factor, battery_max_level, alpha_HE)

% debug
% clc, clear all, close all
% N = 5;    % number of solar panels, ie, N*battery_max_level
% battery_max_level = 100;
% shadowing_factor = 0;
% alpha_HE = 0.5;

load('selected_HE_24_samples.mat')  % selected profile from SolarStat: Los Angeles city
array_BS_HE = zeros(length(selected_HE_24_samples), N);
a = -shadowing_factor;
b = shadowing_factor;

for i=1:N
    r = a + (b-a).*rand(1,1);  % random number between [a,b]
    array_BS_HE(:,i) = array_BS_HE(:,i) + alpha_HE*(r+1)*selected_HE_24_samples;
    
    % check battery level limits
    indexes_max = array_BS_HE(:,i) > battery_max_level;
    indexes_min = array_BS_HE(:,i) < 0;
    array_BS_HE(indexes_max,i)= battery_max_level; 
    array_BS_HE(indexes_min,i)= 0;  
    
end

% debug
% for i=1:N
%    figure, plot(array_BS_HE(:,i)) 
%    axis tight
%    grid on
%    title(['max: ' num2str(max(array_BS_HE(:,i)))])
% end

end