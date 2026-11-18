% Export aggregate timing/error logs from p2000; never exports EEG samples.
inputFile=getenv('CLEANLINE_P2000_RESULTS');
outputDir=getenv('CLEANLINE_PUBLIC_BENCHMARK_DIR');
assert(isfile(inputFile) && isfolder(outputDir), ...
    'Set CLEANLINE_P2000_RESULTS and CLEANLINE_PUBLIC_BENCHMARK_DIR.');
d=load(inputFile);
durationMinutes=[];
mode={};
repetition=[];
originalSeconds=[];
optimizedSeconds=[];
cleanMaxAbs=[];
cleanRelativeL2=[];
removedMaxAbs=[];
removedRelativeL2=[];
for kind=1:2
    if kind==1
        data=d.raw;
        kindName='parallel';
    else
        data=d.serialRaw;
        kindName='serial';
    end
    for k=1:numel(d.durations)
        for rep=1:size(data,2)
            if ~all(isfinite(data(k,rep,1:2)),'all'), continue; end
            durationMinutes(end+1,1)=d.durations(k); %#ok<SAGROW>
            mode{end+1,1}=kindName; %#ok<SAGROW>
            repetition(end+1,1)=rep; %#ok<SAGROW>
            originalSeconds(end+1,1)=data(k,rep,1); %#ok<SAGROW>
            optimizedSeconds(end+1,1)=data(k,rep,2); %#ok<SAGROW>
            cleanMaxAbs(end+1,1)=data(k,rep,3); %#ok<SAGROW>
            cleanRelativeL2(end+1,1)=data(k,rep,4); %#ok<SAGROW>
            removedMaxAbs(end+1,1)=data(k,rep,5); %#ok<SAGROW>
            removedRelativeL2(end+1,1)=data(k,rep,6); %#ok<SAGROW>
        end
    end
end
publicLog=table(durationMinutes,mode,repetition,originalSeconds, ...
    optimizedSeconds,cleanMaxAbs,cleanRelativeL2,removedMaxAbs, ...
    removedRelativeL2);
writetable(publicLog,fullfile(outputDir,'raw_runs.csv'));
writetable(d.fullSummary,fullfile(outputDir,'timing.csv'));
fid=fopen(fullfile(outputDir,'pool_startup.txt'),'w');
assert(fid>0);
fprintf(fid,'Process pool workers: 8\n');
fprintf(fid,'Pool startup seconds: %.6f\n',d.poolStartupSeconds);
fprintf(fid,'Pool startup excluded from all timed calls.\n');
fclose(fid);
fprintf('Exported %d aggregate paired runs.\n',height(publicLog));
