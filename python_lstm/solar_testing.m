%% SCRIPT FOR SOLAR DATA
clc, clear all, close all

load('solar_dataset_normalized_reduced.mat')

file_name = 'Results/solar_lb1.mat';
load(file_name)
[~,name,~] = fileparts(file_name);
look_back = str2double(name(9:end));   

train_dataset = solar_dataset_normalized_reduced(look_back:length(trainPredict)+look_back-1);
test_dataset = solar_dataset_normalized_reduced(length(train_dataset)+(look_back*2)+1:length(solar_dataset_normalized_reduced)-2);

% Training
rmse_train=sqrt(sum((train_dataset(:)-trainPredict(:)).^2)/numel(train_dataset));
figure, plot(trainPredict(1:100))
hold on
plot(train_dataset(1:100),'x')
legend('prediction', 'train dataset')
title(['Training. RMSE: ',num2str(round(rmse_train,4))])
axis tight
grid on

figure, plot(trainPredict)
hold on
plot(train_dataset)
legend('prediction', 'train dataset')
title(['Training. RMSE: ',num2str(round(rmse_train,4))])
axis tight
grid on

% Testing
rmse_test=sqrt(sum((test_dataset(:)-testPredict(:)).^2)/numel(test_dataset));
testPredict(testPredict<0) = 0; 

range = 35:84;

figure, plot(testPredict(range))
hold on
plot(test_dataset(range),'x')
legend('prediction', 'test dataset')
title(['Testing. RMSE: ',num2str(round(rmse_test,4))])
axis tight
grid on

figure, plot(testPredict)
hold on
plot(test_dataset)
legend('prediction', 'test dataset')
title(['Testing. RMSE: ',num2str(round(rmse_test,4))])
axis tight
grid on


% for graphs paper
solar_pred = testPredict(range);
save('solar_pred','solar_pred')
solar_data = test_dataset(range);
save('solar_data','solar_data')
