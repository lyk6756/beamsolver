function [integralval]=simpson245(y,dx)
% Numerical integration subroutine
% This the simpson's 2/45 rule ------ 7 32 12 32 7 rule. 
% Input: 
%       y:  the y=f(x), where x is a uniformly descrete grid with spacing dx
%           vector in real of size 4N+1, 4N is the number of spacings of x
%           N must be an integer
%       dx: the spacing as mentioned above
% 
% Output: integralval, the integral of y=f(x) from the x-range embedded in y.
%         
% Example:
%        x=(0:0.01:10); 
%        y=x.^2; 
%        val=simpson245(y,0.01);
%       
%   Note: this example gives integral of x^2 from 0 to 10
%         code gives: 3.333333333333333e+02    (theoretical value is 1000/3)
%
N=length(y);
if(mod(N,4) ~=1 )
disp('Using simpson 2/45 rule should have 4N+1 points!');
return;
end
integralval=(7*(y(1)+y(end))+32*sum(y(2:4:end-1))+12*sum(y(3:4:end-1))+32*sum(y(4:4:end-1))+14*sum(y(5:4:end-1)) )*2/45*dx;

