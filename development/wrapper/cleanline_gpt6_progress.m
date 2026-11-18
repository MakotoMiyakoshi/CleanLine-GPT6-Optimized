function cleanline_gpt6_progress(~,progressWindow,total)
%CLEANLINE_GPT6_PROGRESS Update the client-side parallel progress window.
if ~isgraphics(progressWindow), return; end
completed=getappdata(progressWindow,'completed');
if isempty(completed), completed=0; end
completed=completed+1;
setappdata(progressWindow,'completed',completed);
waitbar(min(1,completed/total),progressWindow, ...
    sprintf('CleanLine channels: %d / %d',completed,total));
end
