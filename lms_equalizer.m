%LSM�㷨����Ӧ�˲���ʵ��-1��epoch
function [z, e_end, estimated_c]=lms_equalizer(y,info,delta,L)
% ���������
% y:�����ź�����
% info:��ʵ����
% delta:����ʱ�Ĳ���(ͬ�������ѧϰ�е�ѧϰ��-learning rate)
% L:�˲�������


K=(L-1)/2;                         %�˲����İ볤 
estimated_c=zeros(1,L);            %�˲����ĳ�ʼ��ͷϵ��
for k=1:size(y,2)-2* K                    
     y_k=y(k+2*K:-1:k);                      %��ȡ��Ԫ��һ��11��,ע������������ȡ��
    z_k=estimated_c * y_k';                  %����ͷϵ������Ԫ��˺����
    e_k=info(k) - z_k;                       %������
    estimated_c = estimated_c + delta * e_k * y_k;   %����У����ͷϵ��
    z(k) = z_k;                             %������������Ԫ����
    e(k) = e_k;                             %��¼ÿһ�ε����
end
e_end = e(end);