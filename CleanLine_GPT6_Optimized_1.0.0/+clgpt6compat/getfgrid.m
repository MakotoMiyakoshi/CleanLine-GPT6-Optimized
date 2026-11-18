function [f,index] = getfgrid(Fs,nfft,fpass)
%GETFGRID Frequencies and FFT indices for the requested passband.
% Independent compatibility implementation for CleanLine V2.
delta=Fs/nfft;
allFrequencies=0:delta:Fs;
allFrequencies=allFrequencies(1:nfft);
if isscalar(fpass)
    [~,index]=min(abs(allFrequencies-fpass));
else
    index=find(allFrequencies>=fpass(1) & ...
        allFrequencies<=fpass(end));
end
f=allFrequencies(index);
end
