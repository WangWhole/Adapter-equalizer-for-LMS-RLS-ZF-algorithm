%������˹������
function [gsrv1,gsrv2]=gngauss(m,sigma)
 if nargin == 0                 %���û������ʵ�Σ����ֵΪ0����׼��Ϊ1
  m=0; sigma=1;
elseif nargin == 1               %�������ʵ��Ϊ1�����������׼��Ϊ����ʵ�Σ���ֵΪ0
  sigma=m; m=0;
end
u=rand;                          
z=sigma*(sqrt(2*log(1/(1-u))));   
u=rand;                          
gsrv1=m+z*cos(2*pi*u);
gsrv2=m+z*sin(2*pi*u);
