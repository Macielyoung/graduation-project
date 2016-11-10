clear;
close all;
clc

%��ȡѵ������
train_x = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','B1:D601');       
train_y = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','E1:E601'); 
%������ת��
train_x = train_x';                              
train_y = train_y';                              

%��һ���ݶ��½����������粢����ѵ���ͷ���
net = newff(train_x,train_y,[3,1],{'tansig','purelin'},'traingd');  
%�����������磬��һ�㴫�ݺ���ʹ��˫��������S�������ڶ���ʹ�����Ժ���

%����ѵ������
net.trainParam.show = 80;            %��ʾѵ����������Ϊ80��
net.trainParam.lr = 0.08;            %ѧϰ��Ϊ0.08
net.trainParam.epochs = 500;         %���ѵ������Ϊ500
net.trainParam.goal = 1e-2;          %ѵ������Ҫ��Ϊ0.01
[net,tr] = train(net,train_x,train_y);      %���������ѵ��

%��ȡ��������
test_x = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','B602:D801');     
test_y = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','E602:E801');     
%������װ��
test_x = test_x';                  
test_y = test_y';

y = sim(net,test_x);         %��������з���
[m,n] = size(y);
num = 0;
%ͳ��ʶ��Ԥ����ȷ��
for i = 1 : n
    [m , index] = max(y(: , i));
    if(index == test_y(i))
        num = num + 1;
    end
end
sprintf('׼ȷ��Ϊ%3.3f%%',100*num/n)
