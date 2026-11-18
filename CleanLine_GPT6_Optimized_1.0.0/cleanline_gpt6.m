function [EEGclean, removed, report] = cleanline_gpt6(EEG, varargin)
%CLEANLINE_GPT6 Scriptable CleanLine 2.00 V2 processing with two engines.
% Development build. Original and optimized use the same V2 algorithm.
assert(mod(numel(varargin),2)==0,'Options must be name/value pairs.');
for k=1:2:numel(varargin)
    key=lower(char(varargin{k}));
    switch key
        case 'linefreqs', varargin{k}='LineFrequencies';
        case 'p', varargin{k}='LineAlpha';
        case 'sigtype', varargin{k}='SignalType';
        case 'chanlist', varargin{k}='ChanCompIndices';
        case 'winsize', varargin{k}='SlidingWinLength';
        case 'winstep', varargin{k}='SlidingWinStep';
        case 'tau', varargin{k}='SmoothingFactor';
        case 'pad', varargin{k}='PaddingFactor';
        case 'computepower', varargin{k}='ComputeSpectralPower';
        case 'normspectrum', varargin{k}='NormalizeSpectrum';
        case 'plotfigures', varargin{k}='PlotFigures';
        case 'verb', varargin{k}='VerboseOutput';
    end
end
parser = inputParser;
parser.addParameter('Implementation','optimized',@(x)ischar(x)||isstring(x));
parser.addParameter('ExecutionMode','serial',@(x)ischar(x)||isstring(x));
parser.addParameter('LineFrequencies',60,@(x)isnumeric(x)&&isvector(x)&&~isempty(x));
parser.addParameter('ScanForLines',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('LineAlpha',0.01,@(x)isnumeric(x)&&isscalar(x)&&x>0&&x<1);
parser.addParameter('Bandwidth',2,@(x)isnumeric(x)&&isscalar(x)&&x>0);
parser.addParameter('TaperBandWidth',2,@(x)isnumeric(x)&&isscalar(x)&&x>0);
parser.addParameter('SignalType','Channels',@(x)ischar(x)||isstring(x));
parser.addParameter('ChanCompIndices',[],@(x)isnumeric(x)&&isvector(x));
parser.addParameter('SlidingWinLength',4,@(x)isnumeric(x)&&isscalar(x)&&x>0);
parser.addParameter('SlidingWinStep',1,@(x)isnumeric(x)&&isscalar(x)&&x>0);
parser.addParameter('SmoothingFactor',100,@(x)isnumeric(x)&&isscalar(x)&&x>=1);
parser.addParameter('PaddingFactor',2,@(x)isnumeric(x)&&isscalar(x)&&x>=-1);
parser.addParameter('ComputeSpectralPower',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('NormalizeSpectrum',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('PlotFigures',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('VerboseOutput',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('ShowProgress',false,@(x)islogical(x)||isnumeric(x));
parser.addParameter('Newversion',1,@(x)islogical(x)||isnumeric(x));
parser.parse(varargin{:});
g=parser.Results;
implementation=lower(char(g.Implementation));
executionMode=lower(char(g.ExecutionMode));
assert(ismember(implementation,{'original','optimized'}), ...
    'Implementation must be original or optimized.');
assert(ismember(executionMode,{'serial','parallel'}), ...
    'ExecutionMode must be serial or parallel.');
assert(g.Newversion==1,'Only CleanLine 2.00 newversion=1 is supported.');
assert(strcmpi(g.SignalType,'Channels'), ...
    'CleanLine 2.00 V2 supports Channels; Components require historical V1.');
assert(isstruct(EEG) && isfield(EEG,'data') && isnumeric(EEG.data) && ...
    isfield(EEG,'srate') && isfield(EEG,'nbchan') && ...
    size(EEG.data,1)==EEG.nbchan,'A loaded EEGLAB EEG dataset is required.');
assert(EEG.trials==1,'CleanLine V2 requires continuous EEG.');
assert(g.SlidingWinStep<=g.SlidingWinLength, ...
    'SlidingWinStep cannot exceed SlidingWinLength.');
if strcmp(executionMode,'parallel')
    assert(license('test','Distrib_Computing_Toolbox'), ...
        'Parallel mode requires Parallel Computing Toolbox.');
end
if g.ScanForLines || g.NormalizeSpectrum || g.PlotFigures
    warning('CleanLineGPT6:IgnoredV2Option', ...
        'CleanLine 2.00 V2 ignores ScanForLines, NormalizeSpectrum and PlotFigures.');
end
channels=g.ChanCompIndices;
if isempty(channels), channels=1:EEG.nbchan; end
assert(all(channels>=1 & channels<=EEG.nbchan & fix(channels)==channels));
linefreqs=double(g.LineFrequencies(:)');
if numel(linefreqs)==1
    linefreqs=linefreqs*(1:4);
end
linefreqs(linefreqs>EEG.srate/2)=[];
lineNoise=struct('lineNoiseMethod','clean', ...
    'lineNoiseChannels',channels,'Fs',double(EEG.srate), ...
    'lineFrequencies',linefreqs,'p',g.LineAlpha, ...
    'fScanBandWidth',g.Bandwidth,'taperBandWidth',g.TaperBandWidth, ...
    'taperWindowSize',g.SlidingWinLength, ...
    'taperWindowStep',g.SlidingWinStep, ...
    'tau',g.SmoothingFactor,'pad',g.PaddingFactor, ...
    'fPassBand',[0 double(EEG.srate)/2], ...
    'maximumIterations',10,'executionMode',executionMode, ...
    'showProgress',logical(g.ShowProgress));
clock=tic;
if strcmp(implementation,'original')
    [EEGclean,effective]=clgpt6original.cleanLineNoise(EEG,lineNoise);
else
    [EEGclean,effective]=clgpt6optimized.cleanLineNoise(EEG,lineNoise);
end
elapsed=toc(clock);
removed=double(EEG.data)-double(EEGclean.data);
report=struct('pluginVersion','1.0.0', ...
    'implementation',implementation,'executionMode',executionMode, ...
    'requestedLineFrequencies',double(g.LineFrequencies(:)'), ...
    'effectiveLineFrequencies',effective.lineFrequencies, ...
    'channels',channels,'srate',double(EEG.srate), ...
    'windowSamples',round(double(EEG.srate)*g.SlidingWinLength), ...
    'elapsedCoreSeconds',elapsed,'parameters',g, ...
    'boundaryPolicy','Reference V2 ignores boundary events');
end
