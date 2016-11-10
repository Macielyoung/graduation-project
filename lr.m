close all;
clear;
clc

%读取消费数据
x = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','B:D');
y = xlsread('D:\matlab\matlab\logistics regression\统计1.xlsx','E:E');
[m,n] = size(x);     %m为总体记录条数，即消费人群；n为消费属性，即RFM三属性
x = [ones(m,1),x];   %第一列增添m个1
figure;

%分出二次消费人群和非二次消费人群
pos = find(y==1);
neg = find(y==0);
plot3(x(pos,2),x(pos,3),x(pos,4),'+')
hold on
plot3(x(neg,2),x(neg,3),x(neg,4),'o')
xlabel('R')
ylabel('F')
zlabel('M')
itera_num = 500;     %迭代次数
g = inline('1.0./(1.0+exp(-z))');    %制造一个函数g（z）=1.0 ./ (1.0 + exp(-z))
plotstyle = {'b','r','g','k','b--','r--'};
figure;

%使用梯度下降法来求logistics回归
alpha = [ 0.0009,0.001,0.0011,0.0012,0.0013,0.0014 ]; %学习速率
for alpha_i = 1:length(alpha)
    theta = zeros(n+1,1);      %表示样本各个属性权重
    J = zeros(itera_num,1);    %J是个100*1的向量，第n个元素代表第n次迭代cost function的值
    for i = 1:itera_num
        z = x * theta;         %表示每一个样本的线性叠加
        h = g(z);              %表示样本Xi对应的Yi=1时所映射的概率，当Yi=0时映射概率为1-h
        J(i) = (1/m).*sum(-y.*log(h) - (1-y).*log(1-h));   %损失函数（对数损失函数）的矢量表示法
        grad = (1/m).*x'*(h-y);           %代表梯度gradj=1/m*Σ（Y（Xi）-yi）Xij 
        theta = theta - alpha(alpha_i).*grad;   %梯度下降法的迭代公式
    end
    plot(0:itera_num-1,J(1:itera_num),char(plotstyle(alpha_i)),'LineWidth',2)
    hold on
    if(1 == alpha(alpha_i))
        theta_best = theta;       %求最好的theta值
    end
end
prob = g(x*theta);       
%求出每一条记录的预测概率，当概率>0.5，预测为1（会二次消费）,否则为0（不会二次消费）
for i = 1:m
    if prob(i)>0.5  result(i,1)=1;
    else result(i,1)=0;
    end
end
%统计预测准确率
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
plot3(x(pos,2),x(pos,3),x(pos,4),'b+')     %代表二次消费样本
hold on
plot3(x(neg,2),x(neg,3),x(neg,4),'ro')     %代表不会二次消费样本
hold on 
xlabel('R')
ylabel('F')
zlabel('M')

[X, Y] = meshgrid(0:2:200, 0:10);
Z = (-1./theta(4)).*(theta(3)*Y+theta(2)*X+theta(1));  %求得分界面方程
mesh(X,Y,Z)              %画出分界面
legend('Purchase','NoPurchase','Boundary')
hold off

%输出逻辑回归方程和预测准确率
fprintf('Logistic Regression is:\n y = 1/(1+exp(-(%.4f+%.4f*x1+%.4f*x2+%.4f*x3)))\n',theta(1),theta(2),theta(3),theta(4));
fprintf('Predicted Accuracy is:\n %2.3f%%\n',accuracy*100); 