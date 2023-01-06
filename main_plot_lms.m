clear; 
clc;
echo off;
close all;
N=10000;                             %指定信号序列长度
info=random_binary(N);                  %产生二进制信号序列
SNR_in_dB=8:1:18;                     %AWGN信道信噪比
for j=1:length(SNR_in_dB)            
    numoferr=0;                       %初始误码统计数
    for k = 1:100                        %循环计算多次以保障准确
        [y, len ]=channel(info, SNR_in_dB(j));   %通过既有码间干扰又有白噪声信道
        for i=len+1:N+len                  %从第len个码元开始为真实信号码元
            if (y(i)<0)                    %判决译码
                decis=-1;          
            else
                decis=1;          
            end
            if (decis~=info(i-5))             %判断是否误码，统计误码码元个数  
                numoferr=numoferr+1; 
            end
        end
    end
    Pe(j)=numoferr/(N*100);                   % 未经均衡器均衡，得到的误码率
end
semilogy(SNR_in_dB,Pe,'red*-');           %未经均衡器，误码率结果图
hold on; 

delta_1=0.11;                           %指定自适应均衡器的步长
delta_2=0.09;                           %指定自适应均衡器的步长
L = 11;                                 %指定自适应均衡器的抽头个数
for j=1:length(SNR_in_dB)
    numoferr=0;
    for k= 1:100
        y=channel(info,SNR_in_dB(j));         %通过信道 
        z=lms_equalizer(y,info,delta_1,L);        %通过自适应均衡器，并设置步长为0.11
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
    Pe(j)=numoferr/(N*100);                  % 经自适应均衡器均衡后，得到的误码率
end
semilogy(SNR_in_dB, Pe ,'blacko-');        %自适应均衡器均衡之后，误码率结果图
hold on;

for j=1:length(SNR_in_dB)
    numoferr=0;
    for k = 1:100
        y=channel(info,SNR_in_dB(j));        %通过信道 
        z=lms_equalizer(y,info,delta_2,L);        %通过自适应均衡器，并设置步长为0.09
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
    Pe(j)=numoferr/(N*100);                   % 经自适应均衡器均衡后，得到的误码率
end
semilogy(SNR_in_dB,Pe,'blue.-');           %自适应均衡器均衡之后，误码率结果图
hold on;

xlabel('SNR in dB'); 
ylabel('Pe');
title('ISI信道有码间干扰信号经lms自适应均衡器处理后的误码率');
legend('未经均衡器均衡','经自适应均衡器均衡，步长delta=0.11',...
'经自适应均衡器均衡，步长delta=0.09');

%%在信噪比为12dB下，查看波形以及用delta=0.08的自适应均衡器进行信道均衡的效果
M = 150; %码元数目
m = 1500; %取样点数目
A = m/M; %一个码元的采样点数

s = random_binary(M); %产生随机的150个±1双极性序列

%产生过采样信号
temp = [1; zeros(A-1,1)];
x = temp * s;
x = x(1:end); 
%通过升余弦滤波器，成型滤波
N_T = 4;
alpha = 1;
r = rcosdesign(alpha, N_T, A);
x_shaped = filter(r,1,x);
% x_shaped = conv(r, x);
% x_shaped = x_shaped(fix(N_T*A)+1:end-fix(N_T*A));

%信号通过有多径干扰并施加了awgn的信道
SNR_dB_test = 12;
y0 = channel(x_shaped, SNR_dB_test);
% y0 = y0(1:end-10); %除去由离散卷积造成的额外10个拖尾，便于后续计算误差
delta_test = 0.08;
L_test = 11;
y_equalized = lms_equalizer(y0, x_shaped, delta_test, L_test);% lms计算会除去多径带来的10个拖尾(译码从第10个码元开始)
% y_equalized_multi_iteration = lms_equalizer_multi_iteration(y0, x_shaped, delta_test,L_test,100); %选用一个多epoch版本的lms算法以放大它的均衡作用，绘制更清晰的眼图
error = x_shaped - y_equalized;

%绘图
figure(2);
subplot(511),plot(x),title("原始信息序列")
subplot(512),plot(x_shaped),title("原始信息经过成型滤波后的波形");
subplot(513),plot(y0),title("从存在多径干扰的高斯噪声信道中接收的信号");
subplot(514),plot(y_equalized),title("经delta=0.08的LMS均衡器处理后的信号");
subplot(515),plot(error),title("均衡器处理后的误差");

%绘制信道均衡前的眼图
figure(3);
for k=0:(M-3)/2
%     plot(y0([11:2*A+11]+k*2*A));% 均衡器从第10个码元开始做均衡，故这里从11开始选起
%     plot(y0([1:2*A+1]+k*2*A));
%     %最后的结果显示，无论是选择从1开始选起还是从6,11开始选起，都不影响眼图的对齐问题
    plot(y0([7:2*A+7]+k*2*A)); %这里从7开始选取，以使眼图张开最大的时刻居于眼图中央
    hold on;
end
xlim([0 22]);
title('进行信道均衡前的眼图');

%绘制信道均衡后的眼图
figure(4);
for k=0:(M-3)/2
%     plot(y_equalized_multi_iteration([1:2*A+1]+k*2*A));
    plot(y_equalized([1:2*A+1]+k*2*A));
    hold on;
end
xlim([0 22]);
title('进行信道均衡后的眼图');