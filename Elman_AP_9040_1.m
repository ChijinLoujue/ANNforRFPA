%% 第三种神经网络模型：Elman神经网络模型
%% 清空环境变量

clc;
clear
close
nntwarn off;
set(0,'defaultfigurecolor','w');
tic
%% 数据载入
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
Pin = Pin+pi;
figure
plot(Ain,Aout,'r.');
title('9040\_原始输入输出幅度关系')
xlabel('输入幅度/V');
ylabel('输出幅度/V');
grid on 
figure
plot(Pin,Pout,'r.');
title('原始输入输出相位关系')
xlabel('输入相位/弧度');
ylabel('输入相位/弧度');
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


%% 网络的建立和训练
%初始化参数
    threshold=[0 6;-pi pi]; %输入限制
    Hidden = 14;
    
    % 建立Elman神经网络 隐藏层为nn(i)个神经元
    net=newelm(threshold,[Hidden,2],{'tansig','purelin'});
    % 设置网络训练参数
    net.trainparam.epochs=1000;
    net.trainparam.show=20;
    % 初始化网络
    net=init(net);
    % Elman网络训练
    net=train(net,Vinput_train,Voutput_train);
    % 预测数据
    y=sim(net,Vinput_test);
    % 计算误差
    
    error=y-Voutput_test;
    A_ELoutput_test = y(1,:);
    P_ELoutput_test = y(2,:);

    
    
%% 通过作图 观察不同隐藏层神经元个数时，网络的预测效果

figure
subplot(1,2,1)
plot(Ain_test,Aout_test,'r.');
hold on
plot(Ain_test,A_ELoutput_test,'bo');
title('9040\_EL网络预测输出幅度')
xlabel('Ainput/V')
ylabel('Aoutput/V')
legend('原数据','预测数据');
grid on 
subplot(1,2,2)
plot(Pin_test,Pout_test,'r.');
hold on
plot(Pin_test,P_ELoutput_test,'bo');
title('9040\_EL网络预测输出相位')
xlabel('Pinput/rad')
ylabel('Poutput/rad')
legend('原数据','预测数据');
grid on 
%% 观察误差
A_ELerroproportion = abs((A_ELoutput_test-Aout_test)./Aout_test);
P_ELerroproportion = abs((P_ELoutput_test-Pout_test)./Pout_test);


A_ELnum1_10 =0;
P_ELnum1_10 =0;
for i = 1:100
    if A_ELerroproportion(i) <= 0.1
        A_ELnum1_10=A_ELnum1_10+1;
    end 
    if P_ELerroproportion(i) <= 0.1
        P_ELnum1_10=P_ELnum1_10+1;
    end 
end


figure
subplot(1,2,1)
plot(Ain_test,A_ELerroproportion,'r.');
title('9040\_EL网络测试输出幅度相对误差')
xlabel('Aoutput/V')
ylabel('erro')
grid on 

subplot(1,2,2)
plot(Pout_test,P_ELerroproportion,'r.');
title('9040\_EL网络预测输出相位相对误差')
xlabel('Pinput/rad')
ylabel('erro')
grid on 

A_NRMSerro = NRMS(A_ELoutput_test,Aout_test);
A_RMSEerro = RMSE(A_ELoutput_test,Aout_test);
P_NRMSerro = NRMS(P_ELoutput_test,Pout_test);
P_RMSEerro = RMSE(P_ELoutput_test,Pout_test);
disp(['A_NRMSerro=',num2str(A_NRMSerro),'dB  .P_NRMSerro=',num2str(P_NRMSerro),'dB.']);
disp(['A_RMSEerro=',num2str(A_RMSEerro),'  .P_NRMSerro=',num2str(P_RMSEerro)]);

disp(['A_ELnum1_10=',num2str(A_ELnum1_10),'   P_ELnum1_10=',num2str(P_ELnum1_10)]);
