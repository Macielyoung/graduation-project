clc
clear;
close all;

%读取样本
x = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','B:D');       
y = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','E:E');
[m,n] = size(x);         %读取样本长度和维度

%使用k折交叉验证法将样本随机分包
indices = crossvalind('Kfold',x(1:m,n),4);

k = randi(3) + 1;              %交叉验证k=4,4个包随机选择一个作为测试集
test = (indices == k);         %获取测试集元素在数据集中对应的单元编号
train = ~test;                 %训练集元素编号为非测试集元素的编号
train_x = x(train,:);          %从数据集中划分出训练样本的数据
train_y = y(train,:);          %获取训练集的分类标签
test_x = x(test,:);            %从数据集中划分出测试样本的数据
test_y = y(test,:);            %获取测试集的分类标签
[mtest,ntest] = size(test_y);  %获取测试样本分类标签的长度和维度
model = svmtrain(train_x,train_y,'Kernel_Function','rbf', ... 
        'boxconstraint',1);    %构建svm训练模型
%使用RBF核函数，boxconstraint参数是SVM的惩罚系数
Y = svmclassify(model, test_x);%通过训练模型来预测测试样本
accuracy = sum(Y == test_y) / mtest;%统计测试样本的预测精确率
fprintf('accuracy = %2.3f%%\n',accuracy*100);

%画出预测分类
pos = find(Y == 1);            %查找预测分类为1的数据对应编号
neg = find(Y == 0);            %查找预测分类为1的数据对应编号
plot3(test_x(pos,1),test_x(pos,2),test_x(pos,3),'b+');
hold on
plot3(test_x(neg,1),test_x(neg,2),test_x(neg,3),'g*');
hold on

%画出实际分类
ps = find(test_y == 1);         %查找实际分类为1的数据对应编号
ng = find(test_y == 0);         %查找十级分类为0的数据对应编号
plot3(test_x(ps,1),test_x(ps,2),test_x(ps,3),'ro');
hold on
plot3(test_x(ng,1),test_x(ng,2),test_x(ng,3),'yo');
xlabel('R')
ylabel('F')
zlabel('M')
legend('predicted 1','predicted 0','real 1','real 0');