clc
clear;
close all;

%��ȡ����
x = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','B:D');       
y = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','E:E');
[m,n] = size(x);         %��ȡ�������Ⱥ�ά��

%ʹ��k�۽�����֤������������ְ�
indices = crossvalind('Kfold',x(1:m,n),4);

k = randi(3) + 1;              %������֤k=4,4�������ѡ��һ����Ϊ���Լ�
test = (indices == k);         %��ȡ���Լ�Ԫ�������ݼ��ж�Ӧ�ĵ�Ԫ���
train = ~test;                 %ѵ����Ԫ�ر��Ϊ�ǲ��Լ�Ԫ�صı��
train_x = x(train,:);          %�����ݼ��л��ֳ�ѵ������������
train_y = y(train,:);          %��ȡѵ�����ķ����ǩ
test_x = x(test,:);            %�����ݼ��л��ֳ���������������
test_y = y(test,:);            %��ȡ���Լ��ķ����ǩ
[mtest,ntest] = size(test_y);  %��ȡ�������������ǩ�ĳ��Ⱥ�ά��
model = svmtrain(train_x,train_y,'Kernel_Function','rbf', ... 
        'boxconstraint',1);    %����svmѵ��ģ��
%ʹ��RBF�˺�����boxconstraint������SVM�ĳͷ�ϵ��
Y = svmclassify(model, test_x);%ͨ��ѵ��ģ����Ԥ���������
accuracy = sum(Y == test_y) / mtest;%ͳ�Ʋ���������Ԥ�⾫ȷ��
fprintf('accuracy = %2.3f%%\n',accuracy*100);

%����Ԥ�����
pos = find(Y == 1);            %����Ԥ�����Ϊ1�����ݶ�Ӧ���
neg = find(Y == 0);            %����Ԥ�����Ϊ1�����ݶ�Ӧ���
plot3(test_x(pos,1),test_x(pos,2),test_x(pos,3),'b+');
hold on
plot3(test_x(neg,1),test_x(neg,2),test_x(neg,3),'g*');
hold on

%����ʵ�ʷ���
ps = find(test_y == 1);         %����ʵ�ʷ���Ϊ1�����ݶ�Ӧ���
ng = find(test_y == 0);         %����ʮ������Ϊ0�����ݶ�Ӧ���
plot3(test_x(ps,1),test_x(ps,2),test_x(ps,3),'ro');
hold on
plot3(test_x(ng,1),test_x(ng,2),test_x(ng,3),'yo');
xlabel('R')
ylabel('F')
zlabel('M')
legend('predicted 1','predicted 0','real 1','real 0');