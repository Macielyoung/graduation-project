clear;
close all;
clc

%读取训练样本
train_x = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','B1:D601');       
train_y = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','E1:E601'); 
%将样本转置
train_x = train_x';                              
train_y = train_y';                              

%用一般梯度下降法建立网络并进行训练和仿真
net = newff(train_x,train_y,[3,1],{'tansig','purelin'},'traingd');  
%建立两层网络，第一层传递函数使用双曲正切型S函数，第二层使用线性函数

%设置训练参数
net.trainParam.show = 80;            %显示训练迭代过程为80步
net.trainParam.lr = 0.08;            %学习率为0.08
net.trainParam.epochs = 500;         %最大训练次数为500
net.trainParam.goal = 1e-2;          %训练精度要求为0.01
[net,tr] = train(net,train_x,train_y);      %对网络进行训练

%读取测试样本
test_x = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','B602:D801');     
test_y = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','E602:E801');     
%将样本装置
test_x = test_x';                  
test_y = test_y';

y = sim(net,test_x);         %对网络进行仿真
[m,n] = size(y);
num = 0;
%统计识别预测正确率
for i = 1 : n
    [m , index] = max(y(: , i));
    if(index == test_y(i))
        num = num + 1;
    end
end
sprintf('准确率为%3.3f%%',100*num/n)
