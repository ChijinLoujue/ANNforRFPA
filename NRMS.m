function [ erro ] = NRMS( X,Y )
%此函数为一个模型评价函数，为归一化均方根误差
%X为测试结果数值，Y为样本原数值

N = min(length(X),length(Y));
     erro_mole = 0;
     erro_deno = 0;
     for i = 1:N
         erro_mole = abs(X(i)-Y(i))^2+erro_mole;
         erro_deno = abs(X(i))^2+erro_deno;
     end
     erro = 10*log10(erro_mole/erro_deno);
end

