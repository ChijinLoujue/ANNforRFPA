function [ erro ] = RMSE(X,Y)
%UNTITLED2 此函数为一个模型评价函数，为均方根误差
%   X为测试结果数值，Y为样本原数值
N = min(length(X),length(Y));
     erro = 0;
     for i = 1:N
         erro = abs(X(i)-Y(i))^2+erro;
     end
     erro = sqrt(erro/N);
end

