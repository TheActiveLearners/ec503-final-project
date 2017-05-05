function [ area_diff, diff_samples ] = getAreaAndMin( m_1, m_2, lastp )
%GETAREAANDMIN Summary of this function goes here
%   Detailed explanation goes here

mlen = length(m_1);
x = 2.^(5:5+mlen-2);
x(end+1) = lastp;
area_1 = trapz(x,m_1);
area_2 = trapz(x,m_2);

area_diff = area_2 - area_1;
samples_1 = x(m_1 == max(m_1));
samples_2 = min(x(m_2 >= max(m_1)));
if isempty(samples_2) || logical(samples_1 < samples_2)
    diff_samples = NaN;
else
    diff_samples = samples_1 - samples_2;
end


end

