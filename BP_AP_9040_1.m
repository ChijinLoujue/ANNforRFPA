%% ��һ�������磺BP������--����/��λģ��
%% ��ջ�������
clc
clear
set(0,'defaultfigurecolor','w');
%% ѵ������Ԥ��������ȡ
%���������������
load('AMAM9040_1.txt')
load('PMPM9040_1.txt')
%�����ݷ���洢
A = AMAM9040_1(:,2);
P = PMPM9040_1(:,2);
T = AMAM9040_1(:,1);
T0 = T(1:300)';
Ain = A(1:300);
Aout = A(301:600);
Pin = P(1:300);
Pout = P(301:600);

%��ʾԭʼ����ͼ��
plot(T0,Ain);
hold on
plot(T0,Aout);
title('9040\_ԭʼʱ�������������')
xlabel('ʱ��/S');
ylabel('����/V');

grid on 
figure
plot(T0,Pin);
hold on
plot(T0,Pout);
title('9040\_ԭʼʱ�����������λ')
xlabel('ʱ��/S');
ylabel('��λ/�Ƕ�');
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
title('9040\_ԭʼ����������ȹ�ϵ')
xlabel('�������/V');
ylabel('�������/V');
legend('ԭ����','Ԥ������');
grid on 
figure
plot(Pin,Pout,'r.');
title('9040\_ԭʼ���������λ��ϵ')
xlabel('������λ/����');
ylabel('������λ/����');
legend('������λ','�����λ');
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


%% BP����ѵ��
% %��ʼ������ṹ
net=newff(Vinput_train,Voutput_train,5);

net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00004;

%����ѵ��
net=train(net,Vinput_train,Voutput_train);
%netBPAP780_5ͦ�õ�
save('D:\Study\Graduation_project\Code\Mycode\netBPAP9040_1.mat','net');
%load   netBPAP9040   %netΪ�ѱ��������
%% BP����Ԥ��

%������֤���
BPoutput_train = sim(net,Vinput_train);

%����Ԥ�����
BPoutput_test = sim(net,Vinput_test);
% Ԥ���������
A_BPoutput_train = BPoutput_train(1,:);
P_BPoutput_train = BPoutput_train(2,:);
A_BPoutput_test = BPoutput_test(1,:);
P_BPoutput_test = BPoutput_test(2,:);
%% �������
% ����ʹ��ͼ����������Է����Ժ��������Ч��

figure
plot(Ain_train,Aout_train,'r.');
hold on
plot(Ain_train,A_BPoutput_train,'bo');
title('9040\_BP������֤�������')
xlabel('Ainput')
ylabel('Aoutput')
grid on 

figure
plot(Pin_train,Pout_train,'r.');
hold on
plot(Pin_train,P_BPoutput_train,'bo');
title('9040\_BP������֤�����λ')
xlabel('Pinput')
ylabel('Poutput')
grid on 

figure
plot(Ain_test,Aout_test,'r.');
hold on
plot(Ain_test,A_BPoutput_test,'bo');
title('9040\_BP����Ԥ���������')
xlabel('Ainput/V')
ylabel('Aoutput/V')
legend('ԭ����','Ԥ������');
grid on 

figure
plot(Pin_test,Pout_test,'r.');
hold on
plot(Pin_test,P_BPoutput_test,'bo');
title('9040\_BP����Ԥ�������λ')
xlabel('Pinput/rad')
ylabel('Poutput/rad')
legend('ԭ����','Ԥ������');
grid on 

%% �۲����
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
title('9040\_BP����������������')
xlabel('Aoutput/V')
ylabel('erro')
grid on 


figure
plot(Pout_test,P_BPerroproportion,'r.');
title('9040\_BP����������������')
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
