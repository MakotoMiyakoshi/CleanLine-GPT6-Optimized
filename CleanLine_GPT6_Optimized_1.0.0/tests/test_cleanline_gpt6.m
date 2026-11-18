% Development ZIP content and public API smoke/parity tests.
rng(20261117,'twister');
eeglabRoot=getenv('CLEANLINE_EEGLAB_ROOT');
reference=getenv('CLEANLINE_REFERENCE_ROOT');
setFile=getenv('CLEANLINE_TEST_SET');
pluginRoot=getenv('CLEANLINE_COMPLETE_PLUGIN_ROOT');
assert(isfolder(eeglabRoot) && isfolder(reference) && isfile(setFile) && ...
    isfolder(pluginRoot), ...
    'Set CLEANLINE_EEGLAB_ROOT, CLEANLINE_REFERENCE_ROOT, CLEANLINE_TEST_SET, and CLEANLINE_COMPLETE_PLUGIN_ROOT.');
addpath(eeglabRoot); eeglab('nogui');
addpath(genpath(reference));
addpath(pluginRoot,'-begin');
assert(strcmp(which('pop_cleanline_gpt6'), ...
    fullfile(pluginRoot,'pop_cleanline_gpt6.m')));
assert(contains(which('pop_cleanline'),'Cleanline2.00'));
[setDir,setName,setExt]=fileparts(setFile);
EEG=pop_loadset('filename',[setName setExt],'filepath',setDir);
EEG33=EEG;
EEG33.data=EEG33.data(:,1:30*EEG33.srate);
EEG33.pnts=size(EEG33.data,2);
EEG33.xmax=EEG33.xmin+(EEG33.pnts-1)/EEG33.srate;
EEG33.event=EEG33.event([EEG33.event.latency]<=EEG33.pnts);
EEG.data=EEG.data(1,1:30*EEG.srate);
EEG.chanlocs=EEG.chanlocs(1);
EEG.nbchan=1;
EEG.pnts=size(EEG.data,2);
EEG.xmax=EEG.xmin+(EEG.pnts-1)/EEG.srate;
EEG.event=EEG.event([EEG.event.latency]<=EEG.pnts);
originalInput=EEG;
args={'newversion',1,'linefreqs',60,'winsize',4,'winstep',1, ...
    'bandwidth',2,'taperbandwidth',2,'p',0.01,'pad',2, ...
    'tau',100,'sigtype','Channels','chanlist',1, ...
    'computepower',false,'verb',false};
[ref,~,g]=pop_cleanline(EEG,args{:});
assert(g.newversion==1);
[ori,comOri,reportOri]=pop_cleanline_gpt6(EEG, ...
    'Implementation','original','ExecutionMode','serial', ...
    'LineFrequencies',60,'ChanCompIndices',1);
[opt,comOpt,reportOpt]=pop_cleanline_gpt6(EEG, ...
    'Implementation','optimized','ExecutionMode','serial', ...
    'LineFrequencies',60,'ChanCompIndices',1);
[aliasOutput,~,~]=pop_cleanline_gpt6(EEG,args{:}, ...
    'Implementation','optimized','ExecutionMode','serial');
assert(isequal(ref.data,ori.data) && isequal(ref.data,opt.data));
assert(isequal(ref.data,aliasOutput.data));
assert(isequal(EEG,originalInput));
assert(isequal(ori.event,EEG.event) && isequal(opt.event,EEG.event));
assert(isequal(reportOri.effectiveLineFrequencies,[60 120]) && ...
    isequal(reportOpt.effectiveLineFrequencies,[60 120]));
assert(strcmp(reportOpt.implementation,'optimized') && ...
    strcmp(reportOri.implementation,'original'));
assert(contains(comOri,'original') && contains(comOpt,'optimized'));
replayInput=EEG;
EEG=replayInput;
eval(comOpt);
assert(isequal(EEG.data,opt.data));
fprintf('Double input, 30 s: public reference, original, optimized, replay exact.\n');

EEG=originalInput;
EEG.data=single(EEG.data);
[oriSingle,~,~]=pop_cleanline_gpt6(EEG, ...
    'Implementation','original','ExecutionMode','serial');
[optSingle,~,~]=pop_cleanline_gpt6(EEG, ...
    'Implementation','optimized','ExecutionMode','serial');
assert(isequal(oriSingle.data,optSingle.data));
fprintf('Single input, 30 s: original and optimized exact.\n');

fig=figure('Visible','off');
toolsMenu=uimenu(fig,'Label','Tools','tag','tools');
trystrs=struct('no_check','');
catchstrs=struct('store_and_hist','');
vers=eegplugin_cleanline_gpt6(fig,trystrs,catchstrs);
labels=get(findobj(toolsMenu,'Type','uimenu'),'Label');
assert(strcmp(vers,'1.0.0') && ...
    any(strcmp(labels,'CleanLine GPT-6 Optimized')));
close(fig);
fprintf('Distinct EEGLAB Tools entry registered.\n');

reference33=pop_cleanline(EEG33,'newversion',1,'linefreqs',60, ...
    'winsize',4,'winstep',1,'bandwidth',2,'taperbandwidth',2, ...
    'p',0.01,'pad',2,'tau',100,'sigtype','Channels', ...
    'chanlist',1:33,'computepower',false,'verb',false);
rmpath(genpath(reference));
assert(isempty(which('pop_cleanline')));
pool=gcp('nocreate');
if isempty(pool), pool=parpool('Processes',8); end
[opt33,~,report33]=pop_cleanline_gpt6(EEG33, ...
    'Implementation','optimized','ExecutionMode','parallel', ...
    'LineFrequencies',60,'ChanCompIndices',1:33);
assert(pool.NumWorkers==8 && isequal(reference33.data,opt33.data));
assert(isequal(EEG33.event,opt33.event) && ...
    strcmp(report33.executionMode,'parallel'));
fprintf('Parallel 33-channel/30-s run: no original plugin on path; exact.\n');
