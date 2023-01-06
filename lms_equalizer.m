%LSM算法自适应滤波器实现-1个epoch
function [z, e_end, estimated_c]=lms_equalizer(y,info,delta,L)
% 输入参数：
% y:接收信号序列
% info:真实序列
% delta:迭代时的步长(同义于深度学习中的学习率-learning rate)
% L:滤波器长度


K=(L-1)/2;                         %滤波器的半长 
estimated_c=zeros(1,L);            %滤波器的初始抽头系数
for k=1:size(y,2)-2* K                    
     y_k=y(k+2*K:-1:k);                      %获取码元，一次11个,注意这里是逆序取的
    z_k=estimated_c * y_k';                  %各抽头系数与码元相乘后求和
    e_k=info(k) - z_k;                       %误差估计
    estimated_c = estimated_c + delta * e_k * y_k;   %计算校正抽头系数
    z(k) = z_k;                             %均衡后输出的码元序列
    e(k) = e_k;                             %记录每一次的误差
end
e_end = e(end);