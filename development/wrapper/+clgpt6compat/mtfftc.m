function J = mtfftc(data,tapers,nfft,Fs)
%MTFFTC Tapered FFT for sample-by-channel data.
% Independent compatibility implementation for CleanLine V2.
data=clgpt6compat.change_row_to_column(data);
[nSamples,nChannels]=size(data);
[taperSamples,nTapers]=size(tapers);
assert(nSamples==taperSamples,'Taper and data sample counts differ.');
projected=bsxfun(@times,reshape(data,[nSamples 1 nChannels]), ...
    reshape(tapers,[taperSamples nTapers 1]));
J=fft(projected,nfft,1)/Fs;
end
