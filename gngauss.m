%产生高斯白噪声
function [gsrv1,gsrv2]=gngauss(m,sigma)
 if nargin == 0                 %如果没有输入实参，则均值为0，标准差为1
  m=0; sigma=1;
elseif nargin == 1               %如果输入实参为1个参数，则标准差为输入实参，均值为0
  sigma=m; m=0;
end
u=rand;                          
z=sigma*(sqrt(2*log(1/(1-u))));   
u=rand;                          
gsrv1=m+z*cos(2*pi*u);
gsrv2=m+z*sin(2*pi*u);
