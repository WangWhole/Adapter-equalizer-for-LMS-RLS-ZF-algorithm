clear; 
clc;
echo off;
close all;
N=10000;                             %ָ���ź����г���
info=random_binary(N);                  %�����������ź�����
SNR_in_dB=8:1:18;                     %AWGN�ŵ������
for j=1:length(SNR_in_dB)            
    numoferr=0;                       %��ʼ����ͳ����
    for k = 1:100                        %ѭ���������Ա���׼ȷ
        [y, len ]=channel(info, SNR_in_dB(j));   %ͨ���������������а������ŵ�
        for i=len+1:N+len                  %�ӵ�len����Ԫ��ʼΪ��ʵ�ź���Ԫ
            if (y(i)<0)                    %�о�����
                decis=-1;          
            else
                decis=1;          
            end
            if (decis~=info(i-5))             %�ж��Ƿ����룬ͳ��������Ԫ����  
                numoferr=numoferr+1; 
            end
        end
    end
    Pe(j)=numoferr/(N*100);                   % δ�����������⣬�õ���������
end
semilogy(SNR_in_dB,Pe,'red*-');           %δ���������������ʽ��ͼ
hold on; 

delta_1=0.11;                           %ָ������Ӧ�������Ĳ���
delta_2=0.09;                           %ָ������Ӧ�������Ĳ���
L = 11;                                 %ָ������Ӧ�������ĳ�ͷ����
for j=1:length(SNR_in_dB)
    numoferr=0;
    for k= 1:100
        y=channel(info,SNR_in_dB(j));         %ͨ���ŵ� 
        z=lms_equalizer(y,info,delta_1,L);        %ͨ������Ӧ�������������ò���Ϊ0.11
        for i=1:N
            if (z(i)<0)
              decis=-1;          
            else
              decis=1;          
            end
            if (decis~=info(i))     
               numoferr=numoferr+1;
            end
        end
    end
    Pe(j)=numoferr/(N*100);                  % ������Ӧ����������󣬵õ���������
end
semilogy(SNR_in_dB, Pe ,'blacko-');        %����Ӧ����������֮�������ʽ��ͼ
hold on;

for j=1:length(SNR_in_dB)
    numoferr=0;
    for k = 1:100
        y=channel(info,SNR_in_dB(j));        %ͨ���ŵ� 
        z=lms_equalizer(y,info,delta_2,L);        %ͨ������Ӧ�������������ò���Ϊ0.09
        for i=1:N
            if (z(i)<0)
              decis=-1;          
            else
              decis=1;          
            end
            if (decis~=info(i))     
               numoferr=numoferr+1;
            end
        end
    end
    Pe(j)=numoferr/(N*100);                   % ������Ӧ����������󣬵õ���������
end
semilogy(SNR_in_dB,Pe,'blue.-');           %����Ӧ����������֮�������ʽ��ͼ
hold on;

xlabel('SNR in dB'); 
ylabel('Pe');
title('ISI�ŵ����������źž�lms����Ӧ������������������');
legend('δ������������','������Ӧ���������⣬����delta=0.11',...
'������Ӧ���������⣬����delta=0.09');

%%�������Ϊ12dB�£��鿴�����Լ���delta=0.08������Ӧ�����������ŵ������Ч��
M = 150; %��Ԫ��Ŀ
m = 1500; %ȡ������Ŀ
A = m/M; %һ����Ԫ�Ĳ�������

s = random_binary(M); %���������150����1˫��������

%�����������ź�
temp = [1; zeros(A-1,1)];
x = temp * s;
x = x(1:end); 
%ͨ���������˲����������˲�
N_T = 4;
alpha = 1;
r = rcosdesign(alpha, N_T, A);
x_shaped = filter(r,1,x);
% x_shaped = conv(r, x);
% x_shaped = x_shaped(fix(N_T*A)+1:end-fix(N_T*A));

%�ź�ͨ���жྶ���Ų�ʩ����awgn���ŵ�
SNR_dB_test = 12;
y0 = channel(x_shaped, SNR_dB_test);
% y0 = y0(1:end-10); %��ȥ����ɢ�����ɵĶ���10����β�����ں����������
delta_test = 0.08;
L_test = 11;
y_equalized = lms_equalizer(y0, x_shaped, delta_test, L_test);% lms������ȥ�ྶ������10����β(����ӵ�10����Ԫ��ʼ)
% y_equalized_multi_iteration = lms_equalizer_multi_iteration(y0, x_shaped, delta_test,L_test,100); %ѡ��һ����epoch�汾��lms�㷨�ԷŴ����ľ������ã����Ƹ���������ͼ
error = x_shaped - y_equalized;

%��ͼ
figure(2);
subplot(511),plot(x),title("ԭʼ��Ϣ����")
subplot(512),plot(x_shaped),title("ԭʼ��Ϣ���������˲���Ĳ���");
subplot(513),plot(y0),title("�Ӵ��ڶྶ���ŵĸ�˹�����ŵ��н��յ��ź�");
subplot(514),plot(y_equalized),title("��delta=0.08��LMS�������������ź�");
subplot(515),plot(error),title("���������������");

%�����ŵ�����ǰ����ͼ
figure(3);
for k=0:(M-3)/2
%     plot(y0([11:2*A+11]+k*2*A));% �������ӵ�10����Ԫ��ʼ�����⣬�������11��ʼѡ��
%     plot(y0([1:2*A+1]+k*2*A));
%     %���Ľ����ʾ��������ѡ���1��ʼѡ���Ǵ�6,11��ʼѡ�𣬶���Ӱ����ͼ�Ķ�������
    plot(y0([7:2*A+7]+k*2*A)); %�����7��ʼѡȡ����ʹ��ͼ�ſ�����ʱ�̾�����ͼ����
    hold on;
end
xlim([0 22]);
title('�����ŵ�����ǰ����ͼ');

%�����ŵ���������ͼ
figure(4);
for k=0:(M-3)/2
%     plot(y_equalized_multi_iteration([1:2*A+1]+k*2*A));
    plot(y_equalized([1:2*A+1]+k*2*A));
    hold on;
end
xlim([0 22]);
title('�����ŵ���������ͼ');