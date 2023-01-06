function [c]= force_zero(h, N)
%%迫零算法的实现
%h: 归一化的多径信道系数h
%N: 均衡器的抽头个数 2N+1
%c: 返回的迫零均衡器的系数

H = length(h);
MID = find(h==1); %找到h的时间原点
%若原点两侧的值个数不等，补零使之相等
if(MID-1 < H-MID)
    for i=1:(H-MID)-(MID-1)
        h=[0,h];
    end
else
    for i = 1:(MID-1)-(H-MID)
        h=[h,0]
    end
end
L = max(H-MID,MID-1)
%根据给定抽头数确定冲击序列x
%x=[h(-2N) h(-2N+1) ... h(0) ... h(2N-1) h(2N)]
x=zeros(1,4*N+1);
if 2*N>=L
    x([2*N+1-L:2*N+1+L])=h
else
    x=h([MID-2*N:MID+2*N]);
end
%根据x构造矩阵方程系数X  （Topliz矩阵）
%X=[ x(0)     x(-1)    ...    x(-2N) ;
%    x(1)     x(0)     ...    x(-2N+1);
%    ..............................
%    x(2N)    x(2N-1)  ...    x(0)]
X=[];
for i=1:2*N+1
    X=[X;fliplr(x(i:2*N+i))]; %fliplr函数用来翻转矩阵
end
% 不考虑噪声，输出信号的形式可以表示为:d = Xc
%d为只有中间值为1的矩阵，表示我们希望输出的信号在采样点附近区间内(-2N,2N)内没有ISI
d=zeros(2*N+1,1);
d(N+1)=1;
%利用解方程的形式求解出均衡器的抽头系数
%c=X^(-1)*d;
c=pinv(X)*d;
 
end