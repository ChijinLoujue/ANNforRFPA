%% ������������ģ�ͣ�Elman������ģ��
%% ��ջ�������

clc;
clear
close
nntwarn off;
set(0,'defaultfigurecolor','w');
tic
%% ��������
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
Pin = Pin+pi;
figure
plot(Ain,Aout,'r.');
title('9040\_ԭʼ����������ȹ�ϵ')
xlabel('�������/V');
ylabel('�������/V');
grid on 
figure
plot(Pin,Pout,'r.');
title('ԭʼ���������λ��ϵ')
xlabel('������λ/����');
ylabel('������λ/����');
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


%% ����Ľ�����ѵ��
%��ʼ������
    threshold=[0 6;-pi pi]; %��������
    Hidden = 14;
    
    % ����Elman������ ���ز�Ϊnn(i)����Ԫ
    net=newelm(threshold,[Hidden,2],{'tansig','purelin'});
    % ��������ѵ������
    net.trainparam.epochs=1000;
    net.trainparam.show=20;
    % ��ʼ������
    net=init(net);
    % Elman����ѵ��
    net=train(net,Vinput_train,Voutput_train);
    % Ԥ������
    y=sim(net,Vinput_test);
    % �������
    
    error=y-Voutput_test;
    A_ELoutput_test = y(1,:);
    P_ELoutput_test = y(2,:);

    
    
%% ͨ����ͼ �۲첻ͬ���ز���Ԫ����ʱ�������Ԥ��Ч��

figure
subplot(1,2,1)
plot(Ain_test,Aout_test,'r.');
hold on
plot(Ain_test,A_ELoutput_test,'bo');
title('9040\_EL����Ԥ���������')
xlabel('Ainput/V')
ylabel('Aoutput/V')
legend('ԭ����','Ԥ������');
grid on 
subplot(1,2,2)
plot(Pin_test,Pout_test,'r.');
hold on
plot(Pin_test,P_ELoutput_test,'bo');
title('9040\_EL����Ԥ�������λ')
xlabel('Pinput/rad')
ylabel('Poutput/rad')
legend('ԭ����','Ԥ������');
grid on 
%% �۲����
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
title('9040\_EL��������������������')
xlabel('Aoutput/V')
ylabel('erro')
grid on 

subplot(1,2,2)
plot(Pout_test,P_ELerroproportion,'r.');
title('9040\_EL����Ԥ�������λ������')
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
