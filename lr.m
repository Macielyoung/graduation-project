close all;
clear;
clc

%��ȡ��������
x = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','B:D');
y = xlsread('D:\matlab\matlab\logistics regression\ͳ��1.xlsx','E:E');
[m,n] = size(x);     %mΪ�����¼��������������Ⱥ��nΪ�������ԣ���RFM������
x = [ones(m,1),x];   %��һ������m��1
figure;

%�ֳ�����������Ⱥ�ͷǶ���������Ⱥ
pos = find(y==1);
neg = find(y==0);
plot3(x(pos,2),x(pos,3),x(pos,4),'+')
hold on
plot3(x(neg,2),x(neg,3),x(neg,4),'o')
xlabel('R')
ylabel('F')
zlabel('M')
itera_num = 500;     %��������
g = inline('1.0./(1.0+exp(-z))');    %����һ������g��z��=1.0 ./ (1.0 + exp(-z))
plotstyle = {'b','r','g','k','b--','r--'};
figure;

%ʹ���ݶ��½�������logistics�ع�
alpha = [ 0.0009,0.001,0.0011,0.0012,0.0013,0.0014 ]; %ѧϰ����
for alpha_i = 1:length(alpha)
    theta = zeros(n+1,1);      %��ʾ������������Ȩ��
    J = zeros(itera_num,1);    %J�Ǹ�100*1����������n��Ԫ�ش����n�ε���cost function��ֵ
    for i = 1:itera_num
        z = x * theta;         %��ʾÿһ�����������Ե���
        h = g(z);              %��ʾ����Xi��Ӧ��Yi=1ʱ��ӳ��ĸ��ʣ���Yi=0ʱӳ�����Ϊ1-h
        J(i) = (1/m).*sum(-y.*log(h) - (1-y).*log(1-h));   %��ʧ������������ʧ��������ʸ����ʾ��
        grad = (1/m).*x'*(h-y);           %�����ݶ�gradj=1/m*����Y��Xi��-yi��Xij 
        theta = theta - alpha(alpha_i).*grad;   %�ݶ��½����ĵ�����ʽ
    end
    plot(0:itera_num-1,J(1:itera_num),char(plotstyle(alpha_i)),'LineWidth',2)
    hold on
    if(1 == alpha(alpha_i))
        theta_best = theta;       %����õ�thetaֵ
    end
end
prob = g(x*theta);       
%���ÿһ����¼��Ԥ����ʣ�������>0.5��Ԥ��Ϊ1����������ѣ�,����Ϊ0������������ѣ�
for i = 1:m
    if prob(i)>0.5  result(i,1)=1;
    else result(i,1)=0;
    end
end
%ͳ��Ԥ��׼ȷ��
count = 0;
for i = 1:m
    if(result(i,1)==y(i,1)) count = count + 1;
    end
end
accuracy = count / m;
legend('0.0009','0.001','0.0011','0.0012','0.0013','0.0014');
xlabel( 'Number of iterations')
ylabel('Cost Function')

figure;
plot3(x(pos,2),x(pos,3),x(pos,4),'b+')     %���������������
hold on
plot3(x(neg,2),x(neg,3),x(neg,4),'ro')     %�����������������
hold on 
xlabel('R')
ylabel('F')
zlabel('M')

[X, Y] = meshgrid(0:2:200, 0:10);
Z = (-1./theta(4)).*(theta(3)*Y+theta(2)*X+theta(1));  %��÷ֽ��淽��
mesh(X,Y,Z)              %�����ֽ���
legend('Purchase','NoPurchase','Boundary')
hold off

%����߼��ع鷽�̺�Ԥ��׼ȷ��
fprintf('Logistic Regression is:\n y = 1/(1+exp(-(%.4f+%.4f*x1+%.4f*x2+%.4f*x3)))\n',theta(1),theta(2),theta(3),theta(4));
fprintf('Predicted Accuracy is:\n %2.3f%%\n',accuracy*100); 