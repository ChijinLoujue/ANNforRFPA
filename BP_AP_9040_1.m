%% 第一种神经网络：BP神经网络--幅度/相位模型
%% 清空环境变量
clc
clear
set(0,'defaultfigurecolor','w');
%% 训练数据预测数据提取
%下载输入输出数据
load('AMAM9040_1.txt')
load('PMPM9040_1.txt')
%将数据分类存储
A = AMAM9040_1(:,2);
P = PMPM9040_1(:,2);
T = AMAM9040_1(:,1);
T0 = T(1:300)';
Ain = A(1:300);
Aout = A(301:600);
Pin = P(1:300);
Pout = P(301:600);

%显示原始数据图形
plot(T0,Ain);
hold on
plot(T0,Aout);
title('9040\_原始时域输入输出幅度')
xlabel('时间/S');
ylabel('幅度/V');

grid on 
figure
plot(T0,Pin);
hold on
plot(T0,Pout);
title('9040\_原始时域输入输出相位')
xlabel('时间/S');
ylabel('相位/角度');
grid on 

Pin = Pin*pi/180;
Pout = Pout*pi/180;
for i = 1:300
    if Pout(i)<-0.81
        Pout(i)=Pout(i)+2*pi;
    end
end

figure
plot(Ain,Aout,'r.');
title('9040\_原始输入输出幅度关系')
xlabel('输入幅度/V');
ylabel('输出幅度/V');
legend('原数据','预测数据');
grid on 
figure
plot(Pin,Pout,'r.');
title('9040\_原始输入输出相位关系')
xlabel('输入相位/弧度');
ylabel('输入相位/弧度');
legend('输入相位','输出相位');
grid on 

Ain_train = Ain(1:200)';
Pin_train = Pin(1:200)';
Aout_train = Aout(1:200)';
Pout_train = Pout(1:200)';
Vinput_train = [Ain_train;Pin_train];
Voutput_train = [Aout_train;Pout_train];

Ain_test = Ain(201:300)';
Pin_test = Pin(201:300)';
Aout_test = Aout(201:300)';
Pout_test = Pout(201:300)';
Vinput_test = [Ain_test;Pin_test];
Voutput_test = [Aout_test;Pout_test];


%% BP网络训练
% %初始化网络结构
net=newff(Vinput_train,Voutput_train,5);

net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00004;

%网络训练
net=train(net,Vinput_train,Voutput_train);
%netBPAP780_5挺好的
save('D:\Study\Graduation_project\Code\Mycode\netBPAP9040_1.mat','net');
%load   netBPAP9040   %net为已保存的网络
%% BP网络预测

%网络验证输出
BPoutput_train = sim(net,Vinput_train);

%网络预测输出
BPoutput_test = sim(net,Vinput_test);
% 预测输出整理
A_BPoutput_train = BPoutput_train(1,:);
P_BPoutput_train = BPoutput_train(2,:);
A_BPoutput_test = BPoutput_test(1,:);
P_BPoutput_test = BPoutput_test(2,:);
%% 结果分析
% 我们使用图像来看网络对非线性函数的拟合效果

figure
plot(Ain_train,Aout_train,'r.');
hold on
plot(Ain_train,A_BPoutput_train,'bo');
title('9040\_BP网络验证输出幅度')
xlabel('Ainput')
ylabel('Aoutput')
grid on 

figure
plot(Pin_train,Pout_train,'r.');
hold on
plot(Pin_train,P_BPoutput_train,'bo');
title('9040\_BP网络验证输出相位')
xlabel('Pinput')
ylabel('Poutput')
grid on 

figure
plot(Ain_test,Aout_test,'r.');
hold on
plot(Ain_test,A_BPoutput_test,'bo');
title('9040\_BP网络预测输出幅度')
xlabel('Ainput/V')
ylabel('Aoutput/V')
legend('原数据','预测数据');
grid on 

figure
plot(Pin_test,Pout_test,'r.');
hold on
plot(Pin_test,P_BPoutput_test,'bo');
title('9040\_BP网络预测输出相位')
xlabel('Pinput/rad')
ylabel('Poutput/rad')
legend('原数据','预测数据');
grid on 

%% 观察误差
A_BPerroproportion = abs((A_BPoutput_test-Aout_test)./Aout_test);
P_BPerroproportion = abs((P_BPoutput_test-Pout_test)./Pout_test);
A_BPnum1_10 =0;
P_BPnum1_10 =0;
for i = 1:100
    if A_BPerroproportion(i) <= 0.1
        A_BPnum1_10=A_BPnum1_10+1;
    end 
    if P_BPerroproportion(i) <= 0.1
        P_BPnum1_10=P_BPnum1_10+1;
    end 
end


figure

plot(Aout_test,A_BPerroproportion,'r.');
title('9040\_BP网络测试输出相对误差')
xlabel('Aoutput/V')
ylabel('erro')
grid on 


figure
plot(Pout_test,P_BPerroproportion,'r.');
title('9040\_BP网络测试输出相对误差')
xlabel('Poutput/V')
ylabel('erro')
grid on 

A_NRMSerro = NRMS(A_BPoutput_test,Aout_test);
A_RMSEerro = RMSE(A_BPoutput_test,Aout_test);
P_NRMSerro = NRMS(P_BPoutput_test,Pout_test);
P_RMSEerro = RMSE(P_BPoutput_test,Pout_test);
disp(['A_NRMSerro=',num2str(A_NRMSerro),'dB  .P_NRMSerro=',num2str(P_NRMSerro),'dB.']);
disp(['A_RMSEerro=',num2str(A_RMSEerro),'  .P_NRMSerro=',num2str(P_RMSEerro)]);
disp(['A_BPnum1_10=',num2str(A_BPnum1_10),'  .P_BPnum1_10=',num2str(P_BPnum1_10)]);
