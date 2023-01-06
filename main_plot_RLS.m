clear; 
clc;
echo off;
close all;
L = 5;                                %�˲����ĳ���Ϊ(2*L+1)
N=10000;                              %ָ���ź����г���
info=random_binary(N);                %�����������ź�����
SNR_in_dB=8:1:24;                     %AWGN�ŵ������

% {
for j=1:length(SNR_in_dB)             
    numoferr=0;                       %��ʼ����ͳ����
    for k = 1:100                     %ѭ���������Ա���׼ȷ
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

lamda_1=0.6;                           
lamda_2=0.8; 
lamda_3=0.9;
lamda_4=0.95;
delta = 0.1;
% delta = 1e-7;
for j=1:length(SNR_in_dB)
    numoferr=0;
    for k= 1:100
        y=channel(info,SNR_in_dB(j));         %ͨ���ŵ� 
        z = rls_equalizer(lamda_1, 2*L+1, y, info, delta);
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
        z = rls_equalizer(lamda_2, 2*L+1, y, info, delta);
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
semilogy(SNR_in_dB,Pe,'green.-');           %����Ӧ����������֮�������ʽ��ͼ
hold on;

for j=1:length(SNR_in_dB)
    numoferr=0;
    for k = 1:100
        y=channel(info,SNR_in_dB(j));        %ͨ���ŵ� 
        z = rls_equalizer(lamda_3, 2*L+1, y, info, delta);
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
semilogy(SNR_in_dB,Pe,'cyano-');           %����Ӧ����������֮�������ʽ��ͼ
hold on;

for j=1:length(SNR_in_dB)
    numoferr=0;
    for k = 1:100
        y=channel(info,SNR_in_dB(j));        %ͨ���ŵ� 
        z = rls_equalizer(lamda_4, 2*L+1, y, info, delta);
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
title('ISI�ŵ����������źž�rls����Ӧ������������������');
legend('δ������������','������Ӧ���������⣬ָ����Ȩ����lamda=0.6',...
'������Ӧ���������⣬ָ����Ȩ����lamda=0.8',...
'������Ӧ���������⣬ָ����Ȩ����lamda=0.9',...
'������Ӧ���������⣬ָ����Ȩ����lamda=0.95');
% }

%�������Ϊ14dB�£��鿴�����Լ���lamda=0.9������Ӧ�����������ŵ������Ч��
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
% SNR_dB_test = 12;
SNR_dB_test = 14;
y0 = channel(x_shaped, SNR_dB_test);
% y0 = y0(1:end-10); %��ȥ����ɢ�����ɵĶ���10����β�����ں����������
lamda_test = 0.9;
delta_test = 0.1;
y_equalized = rls_equalizer(lamda_test, 2*L+1, y0, x_shaped, delta_test);
% y_equalized_multi_iteration = rls_equalizer_multi_iteration(lamda_test, 2*L+1, y0, x_shaped, delta_test, 100);
error = x_shaped - y_equalized;

%��ͼ
figure(2);
subplot(511),plot(x),title("ԭʼ��Ϣ����")
subplot(512),plot(x_shaped),title("ԭʼ��Ϣ���������˲���Ĳ���");
subplot(513),plot(y0),title("�Ӵ��ڶྶ���ŵĸ�˹�����ŵ��н��յ��ź�");
subplot(514),plot(y_equalized),title("��lamda=0.9��RLS�������������ź�");
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