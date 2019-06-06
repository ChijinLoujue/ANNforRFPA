%% 第二种神经网络模型：RBF网络-exact径向基网络
%% 清空环境变量
clc
clear
set(0,'defaultfigurecolor','w');
%% 产生输入 输出数据 
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
grid on 
figure
plot(Pin,Pout,'r.');
title('9040\_原始输入输出相位关系')
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


%% 网络建立和训练
% 网络建立 输入为输入信号的幅度Ain,输出为Aout。Spread使用默认。
net=newrb(Vinput_train,Voutput_train);

%% 网络的效果验证

% 我们将数据带入，测试网络效果：
RBFoutput_test=sim(net,Vinput_test);
A_RBFoutput_test = RBFoutput_test(1,:);
P_RBFoutput_test = RBFoutput_test(2,:);
% 我们使用图像来看网络对非线性函数的拟合效果

figure
plot(Ain_test,Aout_test,'r.');
hold on
plot(Ain_test,A_RBFoutput_test,'bo');
title('9040\_RBF网络测试输出幅度')
xlabel('Ainput')
ylabel('Aoutput')
legend('原数据','预测数据');
grid on 

figure
plot(Pin_test,Pout_test,'r.');
hold on
plot(Pin_test,P_RBFoutput_test,'bo');
title('9040\_RBF网络测试输出相位')
xlabel('Pinput')
ylabel('Poutput')
legend('原数据','预测数据');
grid on 
%% 观察误差
A_RBFerroproportion = abs((A_RBFoutput_test-Aout_test)./Aout_test);
P_RBFerroproportion = abs((P_RBFoutput_test-Pout_test)./Pout_test);
A_RBFnum1_10 =0;
P_RBFnum1_10 =0;
for i = 1:100
    if A_RBFerroproportion(i) <= 0.1
        A_RBFnum1_10=A_RBFnum1_10+1;
    end 
    if P_RBFerroproportion(i) <= 0.1
        P_RBFnum1_10=P_RBFnum1_10+1;
    end 
end


figure
subplot(1,2,1)
plot(Aout_test,A_RBFerroproportion,'r.');
title('9040\_RBF网络测试输出误差比')
xlabel('Aoutput')
ylabel('erro')
grid on 

subplot(1,2,2)
plot(Pout_test,P_RBFerroproportion,'r.');
title('9040\_RBF网络测试输出误差比')
xlabel('Poutput')
ylabel('erro')
grid on 


A_NRMSerro = NRMS(A_RBFoutput_test,Aout_test);
A_RMSEerro = RMSE(A_RBFoutput_test,Aout_test);
P_NRMSerro = NRMS(P_RBFoutput_test,Pout_test);
P_RMSEerro = RMSE(P_RBFoutput_test,Pout_test);
disp(['A_NRMSerro=',num2str(A_NRMSerro),'dB  .P_NRMSerro=',num2str(P_NRMSerro),'dB.']);
disp(['A_RMSEerro=',num2str(A_RMSEerro),'  .P_NRMSerro=',num2str(P_RMSEerro)]);
disp(['A_RBFnum1_10=',num2str(A_RBFnum1_10),'   P_RBFnum1_10=',num2str(P_RBFnum1_10)]);

%%
