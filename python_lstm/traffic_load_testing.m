%% SCRIPT FOR TRAFFIC LOAD RESULTS
clc, clear all, close all

load('traffic_dataset_normalized.mat')

file_name = 'Results/results_lb7.mat';
load(file_name)
[~,name,~] = fileparts(file_name);
look_back = str2double(name(11:end));  % traffic load

train_dataset = traffic_dataset_normalized(look_back:length(trainPredict)+look_back-1);
test_dataset = traffic_dataset_normalized(length(train_dataset)+(look_back*2)+1:length(traffic_dataset_normalized)-2);

% Training
rmse_train=sqrt(sum((train_dataset(:)-trainPredict(:)).^2)/numel(train_dataset));
figure, plot(trainPredict(1:50))
hold on
plot(train_dataset(1:50),'x')
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

range = 1:50;

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
% traffic_pred = testPredict(range);
% save('traffic_pred','traffic_pred')
% traffic_data = test_dataset(range);
% save('traffic_data','traffic_data')
