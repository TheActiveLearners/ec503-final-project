function [X,gmix] = UMGRN(mus,vars,N,varargin)
% UMGRN = univariate multimodal Gaussian random number generator. The
% function generates random variables from a mixture of N Gaussian
% distribution.
%
%   [X,gmix] = UMGRN(mus,vars,N,'opt1','val1',...)
%
% Input: - mus = 1xN vector of means,
%        - vars = 1xN vector of variances,
%        - N = the number of random numbers,
%
% Output: - X = 1xN vector of random numbers with its probability density function is gmix.
%         - gmix = the probability density function, i.e.:
%             gmix(X) = 1/N * (G(X,mu(1),vars(1)) + G(X,mu(2),vars(2)) + ... +
%                       G(X,mu(N),vars(N)))
%           where G(X,mu,s) is the Gaussian function with mean=mu and variance=s.
%
% Optional arguments:
%   - 'limit', [a b]. Defines data range of the output X.
%     Default is computed optimally to cover 99% of the p.d.f. gmix.
%   - 'with_plot', 0 | 1. Plot also the p.d.f. and the generated random numbers.
%     Default is 1.
%
% Author: Avan Suinesiaputra (avan.sp@gmail.com)
%         Fadillah Tala (fadil.tala@gmail.com)

% default values
lim = [];
with_plot = 1;

% get optional arguments
for i=1:2:length(varargin)
    if( strcmpi(varargin{i},'limit') ) lim = varargin{i+1};
    elseif( strcmpi(varargin{i},'with_plot') ) with_plot = varargin{i+1};
    else error('Unknown plot.'); end
end

% calculate the optimal limit if lim is emtpy
if( isempty(lim) )
    lim = [min(mus-3*vars) max(3*vars+mus)];
else
    % check the limit
    if( lim(1)>=lim(b) ) error('Error in the data_range argument.'); end
end

% [a,b] = lim
a = lim(1);
b = lim(2);

% check length of mus and vars
if( length(mus)~=length(vars) ) error('Inequal length of mus and vars arguments.'); end

% NOTE: Since the output is a sum of p.d.f, we must make sure that the output gmix must be
% a density (integrates to one). Thus each individual Gaussian function is weighted by
% 1/M, where M = the number of Gaussian function.

% build the mixture of Gaussian function
gstr = 'exp(-(x-(%f)).^2 / (2*(%f)^2)) / ((%f)*sqrt(2*pi))';
gmix = sprintf('1/%d * (0',length(mus));
for i=1:length(mus) 
    gmix = strcat(gmix,'+',sprintf(gstr,mus(i),vars(i),vars(i)));
end
gmix = inline(strcat(gmix,')'),'x');


% THE REJECTION METHOD

% the inequality to be hold: f(x) <= c*g(x) forall x.
% we can determine c = maximum of gmix, i.e. 1/(min(vars)*length(mus)*sqrt(2*pi)),
%                  g(x) = the uniform p.d.f., i.e. g(x) = 1 forall x, and
%                  f(x) is the gmix(x), the mixture of gaussian p.d.f.

% calculate the constant c:
c = 1/(min(vars)*length(mus)*sqrt(2*pi));

X = [];
for i=1:N
    
    % generate xi until it is not rejected
    ok = 0;
    while( ~ok )
    
        xi = a + (b-a)*rand;  % 1. Generate a random number X from uniform dist.
        r = c / gmix(xi);     % 2. Calculate ratio: r = c*g(x) / f(x)
        u = rand;             % 3. Generate a uniform randon number
        
        ok = (u*r) < 1;       % 4. Accept if (u*r) < 1
        
    end
    
    % put xi in the output array X
    X(i) = xi;
    
end

% PLOT if with_plot=1
if( with_plot )
	figure;
	hold on;
	set(gca,'ColorOrder',circshift(get(gca,'ColorOrder'),-1));
	xi = a:0.01:b;
    g = inline(sprintf('exp(-(x-mu).^2 / (2*s^2)) / ((%d)*s*sqrt(2*pi))',length(mus)),'x','mu','s');
	for i=1:length(mus) Gx(i,:) = g(xi,mus(i),vars(i)); end
	plot(xi,Gx','LineStyle',':');
	plot(xi,gmix(xi),'b');
	plot(X,zeros(size(X)),'b.');
end