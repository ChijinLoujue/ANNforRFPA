function [ erro ] = NRMS( X,Y )
%�˺���Ϊһ��ģ�����ۺ�����Ϊ��һ�����������
%XΪ���Խ����ֵ��YΪ����ԭ��ֵ

N = min(length(X),length(Y));
     erro_mole = 0;
     erro_deno = 0;
     for i = 1:N
         erro_mole = abs(X(i)-Y(i))^2+erro_mole;
         erro_deno = abs(X(i))^2+erro_deno;
     end
     erro = 10*log10(erro_mole/erro_deno);
end

