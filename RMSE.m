function [ erro ] = RMSE(X,Y)
%UNTITLED2 �˺���Ϊһ��ģ�����ۺ�����Ϊ���������
%   XΪ���Խ����ֵ��YΪ����ԭ��ֵ
N = min(length(X),length(Y));
     erro = 0;
     for i = 1:N
         erro = abs(X(i)-Y(i))^2+erro;
     end
     erro = sqrt(erro/N);
end

