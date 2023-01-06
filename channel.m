%ģ��������������и�˹���������ŵ�
function [y,len]=channel(x,snr_in_dB)
% SNR=exp(snr_in_dB*log(10)/10);    %�������ֵת��
SNR=10^(snr_in_dB*log10(10)/10);    %�������ֵת��

sigma=1/sqrt(2*SNR);              %��˹�������ı�׼��
%ָ���ŵ���ISI���������Կ������ŵ��������ǱȽϲ��
actual_isi=[0.05 -0.063 0.088 -0.126 -0.25 1 0.25 0 0.126 0.038 0.088]; % light_ISI
% actual_isi=[0.5 -0.63 0.88 -0.126 -0.25 1 0.25 0 0.126 0.38 0.88]; % severe_ISI
len_actual_isi=(length(actual_isi)-1)/2;
len=len_actual_isi;
y=conv(actual_isi,x);               %�ź�ͨ���ŵ����൱���ź��������ŵ�ģ�����������
%��Ҫָ������ʱ��Ԫ���г��ȱ�ΪN+len-1������ʱ���Ǵӵ�len����Ԫ��ʼ��N+len������
for i=1:2:size(y,2)       
    [noise(i) noise(i+1)]=gngauss(sigma);   %��������
end
y=y+noise;                            %��������
