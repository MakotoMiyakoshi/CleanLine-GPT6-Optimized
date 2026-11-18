function segments = createdatamatc(data,E,Fs,win)
%CREATEDATAMATC Return columns of event-aligned signal windows.
% Independent compatibility implementation for CleanLine V2.
left=round(win(1)*Fs);
right=round(win(2)*Fs);
lengthSamples=left+right;
starts=floor(E(:)'*Fs)+1-left;
indices=(0:lengthSamples-1)' + starts;
segments=data(indices);
end
