% Full-duration parity of both local plugin modes against public CleanLine V2.
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
[setDir,setName,setExt]=fileparts(setFile);
EEG=pop_loadset('filename',[setName setExt],'filepath',setDir);
pool=gcp('nocreate');
if isempty(pool), pool=parpool('Processes',8); end
assert(pool.NumWorkers==8);
args={'newversion',1,'linefreqs',60,'winsize',4,'winstep',1, ...
    'bandwidth',2,'taperbandwidth',2,'p',0.01,'pad',2, ...
    'tau',100,'sigtype','Channels','chanlist',1:33, ...
    'computepower',false,'verb',false};
for minutes=[5 30]
    input=EEG;
    input.pnts=minutes*60*EEG.srate;
    input.data=EEG.data(:,1:input.pnts);
    input.xmax=input.xmin+(input.pnts-1)/input.srate;
    input.event=EEG.event([EEG.event.latency]<=input.pnts);
    ref=pop_cleanline(input,args{:});
    [original,~,originalReport]=pop_cleanline_gpt6(input,args{:}, ...
        'Implementation','original','ExecutionMode','parallel');
    [optimized,~,optimizedReport]=pop_cleanline_gpt6(input,args{:}, ...
        'Implementation','optimized','ExecutionMode','parallel');
    assert(isequal(ref.data,original.data) && ...
        isequal(ref.data,optimized.data));
    removedRef=double(input.data)-double(ref.data);
    removedOriginal=double(input.data)-double(original.data);
    removedOptimized=double(input.data)-double(optimized.data);
    assert(isequal(removedRef,removedOriginal) && ...
        isequal(removedRef,removedOptimized));
    assert(isequal(input.event,original.event) && ...
        isequal(input.event,optimized.event));
    assert(isequal(originalReport.effectiveLineFrequencies,[60 120]) && ...
        isequal(optimizedReport.effectiveLineFrequencies,[60 120]));
    fprintf('%d min, 33 channels: public V2, plugin Original, plugin Optimized exact.\n',minutes);
    clear ref original optimized removedRef removedOriginal removedOptimized
end
