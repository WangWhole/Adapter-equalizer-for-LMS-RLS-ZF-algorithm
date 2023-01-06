function[z,e,w] = rls_equalizer(lamda, M, x, info, delta)
% % % �ݹ���С���ˣ�RLS
% % ���������
% lamda:ȡֵΪ(0,1]�ĳ���
% M:filter���ȣ�����
% x:�����ź�����
% info:��ʵ�ź�����
% delta:����P�ĳ�ʼ���ĳ���

% % ���������
% z:����ź�����
% e:�������
% w:���յľ�������ͷϵ��

% % 1.��ʼ��
w = zeros(M,1);
P = eye(M)/delta;
x = x(:); 
% x = x(:end-M+1);
info = info(:);

% �����ź�
N = length(x);
% N = length(info); %������info�ĳ��ȣ���Ϊx��ʱ������conv��������ģ����info���г������³���info������Χ
% �������
e = info.';

% % 2.����
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

