%%%一、迫零均衡前的眼图

%%1.随机产生双极性序列
n=1500; %取样点数
M=150; %码元数目
A=n/M; %一个码元的取样点数，即过采样率为10
P=0.5; %发送1码的概率,这里是等概发送
x=2*round(rand(1,M)+P-0.5)-1;  %产生一列长度为M的0-1码；round进行四舍五入,最终产生±1双极性序列；

%%2.发送信号序列与一个多抽头的滤波器卷积（相当于经过一个多径信道）,产生码间串扰
h=[0.02 0.05 0.1 -0.2 1 -0.2 0.1 0.06 0.01]; % 9
x1=conv(x,h); %离散卷积，输出为长度为158的序列

%%3.成型滤波
%一种简单的方法生成过采样信号
temp=[1;zeros(A-1,1)];  %代表A*1的矩阵：第一个元素为1 其余为0
x2=temp*x1;  %矩阵相乘 temp的列数=x1的行数=1 (10*158 double)
x2=x2(1:end); %过采样信号  10*158 reshape为 1*1580
%通过升余弦滤波器,成型滤波
N_T=4;   %控制滤波器长度，滤波器的阶数为2*N_T+1。
alpha = 1; % 滚降系数，影响带宽
r=rcosdesign(alpha,N_T,A); % 产生升余弦滤波器系数 (1*41 double)
x3=conv(r,x2);  %信号通过升余弦滚降滤波器  (1*1620 double)
%fix()：向零方向取整
x3=x3(fix(A*N_T)+1:end-fix(A*N_T)); %删去由于卷积产生的拖尾的0 (1*1540 double)

%%4.将不同码元周期内的图形平移至一个周期(T=21)内画出眼图。（眼图的长度为21）.
figure(1);
for ii=0:(M-3)/2
    plot(x3([1:2*A+1]+ii*2*A));
    hold on;
end
xlim([0 22]);
title('迫零均衡前的眼图');

%%5.用matlab画眼图函数直接画眼图
eyediagram(x1,2);
% eyediagram(x3,2);
title('迫零均衡前的眼图');


%%%二、迫零均衡
N=5; %抽头系数有 2*5+1 = 11个
C=force_zero(h,N); %可以在局部形成无码间干扰的抽头系数
y=conv(x1,C); 


%%%三、迫零均衡后的眼图
%%1.成型滤波
%一种简单的方法生成过采样信号
temp=[1;zeros(A-1,1)];
y1=temp*y;
y1=y1(1:end); %过采样信号
%通过升余弦滤波器,成型滤波
N_T=4;   %控制滤波器长度，滤波器的阶数为2*N_T+1。
alpha = 1; % 滚降系数，影响带宽
r=rcosfir(alpha,N_T,A,1); % 产生升余弦滤波器系数
y2=conv(r,y1);
y2=y2(fix(A*N_T)+1:end-fix(A*N_T)); %删去由于卷积产生的拖尾的0

%%2.将不同码元周期内的图形平移至一个周期内画出眼图。
figure(3);
for ii=0:(M-3)/2
    plot(y2([1:2*A+1]+ii*2*A));
    hold on;
end
xlim([0 22]);
title('迫零均衡后的眼图');
%%3.用matlab画眼图函数直接画眼图
eyediagram(y,2);
% eyediagram(y2,2);
title('迫零均衡后的眼图');
  
%四、计算ISI信号叠加不同信噪比的信道加性噪声后
%用不同阶数的迫零均衡器均衡后的误码率，并与理想误码率曲线比较。
SNRdB=[4:13];  %信噪比(dB)的范围
N=[1 2 3]; %用3、5、7阶横向滤波器迫零
err_rate=zeros(length(N),length(SNRdB));  %误码率统计
for ii=1:length(N)
    C=force_zero(h,N(ii));
    for jj=1:length(SNRdB)
        SNR=10^(SNRdB(jj)/10);  %计算比值形式的信噪比
        err=0;  %误码数清零
        for kk=1:10^3  %循环多次以达到足够的精确度
            x=2*round(rand(1,M)+P-0.5)-1;   %产生双极性码
            x1=awgn(x,SNR,'measured','linear'); %加入高斯白噪声
            x1=conv(x1,h);  %通过多径信道
            y=conv(x1,C);      
            L=(length(y)-M)/2;
            y=y(L+1:L+M); %除去由于卷积产生的拖尾信号  %误码率比较都是只比较码元长度M
            y=sign(y);  %抽样判决，判决分界为0 sign()返回1或-1或0
            err=err+sum(abs(x-y))/2;  %误码数累加
        end
        err_rate(ii,jj)=err/(M*10^3);  %误码率计算
    end
end
figure(5);
semilogy(SNRdB,0.5*erfc(sqrt(0.5*10.^(SNRdB/10))));
hold on;
semilogy(SNRdB,err_rate(1,:),'bo-');
hold on;
semilogy(SNRdB,err_rate(2,:),'go-');
hold on;
semilogy(SNRdB,err_rate(3,:),'ro-');
title('迫零均衡后的误码率');
legend('理想误码率特性','三阶迫零均衡误码率','五阶迫零均衡误码率','七阶迫零均衡误码率');
xlabel('SNR');

figure(6);
subplot(211),plot(x3,'b-'),title("迫零均衡前的信号波形");
subplot(212),plot(y2,'g-'),title("迫零均衡后的信号波形");