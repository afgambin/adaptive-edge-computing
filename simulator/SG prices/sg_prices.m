clc, close all, clear all

% Data from National Grid website of New York state for central region (Syracuse, Fulton, Oswego, Pulaski, Cortland)
% Dates: 1/01/2015 - 30/08/2017
% Prices are in $/MWh
% Website: https://www9.nationalgridus.com/niagaramohawk/business/rates/5_hour_charge.asp
full_data = xlsread('01012015_30082017.xlsx');

% Conversion to cent/Wh
conv = 10^-4;
full_data_converted = full_data*conv;
%random_day = randi(size(full_data,1));
random_day = 468;

days_ahead = 20;
array_prices = full_data_converted(random_day:random_day+days_ahead,:);
save(['sg_prices_' num2str(days_ahead)],'array_prices')

figure,
title('NY state electrical grid prices')
for i=1:size(array_prices,1)
    hold on
    plot(array_prices(i,:))
    axis tight
    grid on
end
xlabel('Hour of the day [h]')
ylabel('Energy price [cents/Wh]')