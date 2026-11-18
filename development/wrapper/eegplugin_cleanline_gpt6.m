function versionstr = eegplugin_cleanline_gpt6(fig,trystrs,catchstrs)
%EEGPLUGIN_CLEANLINE_GPT6 Add a distinct CleanLine entry to EEGLAB Tools.
versionstr='0.1.0-dev';
if nargin~=3
    error('CleanLineGPT6:EEGLAB','EEGLAB must call with three arguments.');
end
toolsMenu=findobj(fig,'tag','tools');
assert(~isempty(toolsMenu),'Could not find EEGLAB Tools menu.');
callback=[trystrs.no_check, ...
    '[EEG, LASTCOM] = pop_cleanline_gpt6(EEG);', ...
    catchstrs.store_and_hist];
uimenu(toolsMenu(1),'Label','CleanLine GPT-6 Optimized', ...
    'Separator','on','Callback',callback);
end
