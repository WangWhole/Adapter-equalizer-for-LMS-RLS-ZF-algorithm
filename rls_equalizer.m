function[z,e,w] = rls_equalizer(lamda, M, x, info, delta)
% % % 递归最小二乘，RLS
% % 输入参数：
% lamda:取值为(0,1]的常数
% M:filter长度，标量
% x:输入信号序列
% info:真实信号序列
% delta:控制P的初始化的常数

% % 输出参数：
% z:输出信号序列
% e:估计误差
% w:最终的均衡器抽头系数

% % 1.初始化
w = zeros(M,1);
P = eye(M)/delta;
x = x(:); 
% x = x(:end-M+1);
info = info(:);

% 输入信号
N = length(x);
% N = length(info); %来计算info的长度，因为x有时候是由conv计算得来的，会比info序列长，导致超出info索引范围
% 误差向量
e = info.';

% % 2.迭代
% for n=M:N
%     x_vec = x(n:-1:n-M+1);
%     z_n = w'*x_vec;
%     E = info(n) - w'*x_vec;
% %     k = lamda^(-1)*P*x_vec/(1 + lamda^(-1)*x_vec'*P*x_vec);
%     k = (P*x_vec)/(lamda + x_vec'*P*x_vec);
%     P = (P/lamda) - (k*x_vec'*P/lamda);
%     w = w+k*conj(E);
%     e(n-M+1) = E;
%     z(n-M+1) = z_n;
% end

for n=1:N-M+1
    x_vec = x(n+M-1:-1:n);
    z_n = w'*x_vec;
    E = info(n) - w'*x_vec;
%     k = lamda^(-1)*P*x_vec/(1 + lamda^(-1)*x_vec'*P*x_vec);
    k = (P*x_vec)/(lamda + x_vec'*P*x_vec);
    P = (P/lamda) - (k*x_vec'*P/lamda);
    w = w+k*conj(E);
    e(n) = E;
    z(n) = z_n;
end

