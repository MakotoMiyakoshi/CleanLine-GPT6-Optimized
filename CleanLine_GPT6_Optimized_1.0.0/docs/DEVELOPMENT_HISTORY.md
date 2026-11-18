# CleanLine development history and attribution

The original [CleanLine EEGLAB plugin](https://github.com/sccn/cleanline)
was developed by **Tim Mullen**. It applies multitaper estimation and
subtraction of sinusoidal interference, drawing on methods described by
Mitra and Bokil in *Observed Brain Dynamics* (2007, §7.3.4). **Kay A.
Robbins** later undertook a substantial reimplementation for the
[PREP pipeline](https://github.com/VisLab/EEG-Clean-Tools), which was
integrated into the official CleanLine plugin by **Arnaud Delorme**.
**Makoto Miyakoshi** initiated and coordinated the 2020 integration and
validated the resulting plugin. The [official SCCN version history](https://github.com/sccn/cleanline/blob/master/Readme.md#cleanline-versions)
identifies Tim's V1 and Kay's V2 rewrite, with Arnaud's integration and
Makoto's testing.

## Chronology

The dated account below summarizes historical correspondence reviewed by
the project maintainer. The private messages, quotations, addresses, and
links are not published. Public repository evidence is linked where
available.

| Period | Development |
| --- | --- |
| 2014–2015 | Kay developed the PREP implementation. Her [October 7, 2014 initial commit](https://github.com/VisLab/EEG-Clean-Tools/commit/a37f73be8675b6670df9c749ba1a9eeeaa4b0b96) already contains channel-level `parfor`. In March 2015 she reported comparing its behavior against Tim's code line by line and obtaining matching results. Her work examined sliding windows, iteration, frequency scanning, FFT padding, and parameter propagation, including a possible original GUI padding issue. The [PREP repository](https://github.com/VisLab/EEG-Clean-Tools) and [PREP paper](https://doi.org/10.3389/fninf.2015.00016) give public context. |
| April 2020 | Kay confirmed that her work was a reimplementation and described substantial effort resolving suspected issues in the earlier implementation. |
| July 18, 2020 | Makoto proposed incorporating Kay's PREP `cleanLineNoise()` implementation into official EEGLAB CleanLine while retaining existing functionality and proper attribution. |
| July 19, 2020 | Kay approved use of her implementation and described a parameter-structure issue. Arnaud integrated Kay's rewrite into the official plugin as V2 with a legacy option. His [public integration commit](https://github.com/sccn/cleanline/commit/294a6178157cd77fec25fcbb7e7ad2175076a60f) records the addition of Kay's version as the default. |
| July 20–25, 2020 | Tim welcomed the correction and improvement of CleanLine. Makoto subsequently reported that the integrated plugin passed his validation test. |
| July 31, 2021 | Kay's [PREP maintenance commit](https://github.com/VisLab/EEG-Clean-Tools/commit/45e553b81e457bb883aad67288df8d2cc4b90901) fixed a `parfor` issue with non-consecutive channels. This documents her continued maintenance of PREP's parallel code; it does not establish that this later PREP fix entered SCCN CleanLine. |

## Existing parallel execution

Channel-level `parfor` is present in Kay's public PREP
[`cleanLineNoise.m` at its October 2014 initial commit](https://github.com/VisLab/EEG-Clean-Tools/blob/a37f73be8675b6670df9c749ba1a9eeeaa4b0b96/StandardLevel2/utilities/cleanLineNoise.m).
That commit identifies Kay as author and committer. Arnaud's July 2020
integration brought Kay's implementation, including its existing parallel
loop, into official CleanLine V2. This establishes Kay's documented
**parallel-capable PREP implementation** and Arnaud's integration of it;
it does not claim that Kay invented channel-level parallelization generally
or prove who first typed the specific `parfor` statement.

The present plugin retains that capability, makes **Serial** the explicit
default and **Parallel** optional, and optimizes the per-channel
computation. The [README](../README.md) reports matched Serial and
matched Parallel improvements separately from the overall
Original-Serial-to-Optimized-Parallel acceleration. This project does not
claim to have invented CleanLine, its scientific method, or channel-level
parallel processing.

## Contributions in this lineage

| Contributor | Documented contribution |
| --- | --- |
| **Tim Mullen** | Original CleanLine algorithm and EEGLAB plugin. |
| **Kay A. Robbins** | Substantial PREP rewrite, numerical and parameter-handling work, and a publicly documented channel-level parallel implementation. |
| **Arnaud Delorme** | Integration of Kay's rewrite into the official EEGLAB CleanLine plugin as V2. |
| **Makoto Miyakoshi** | Initiated and coordinated V2 integration, validated it, and led development and evaluation of this optimized derivative. |
| **OpenAI GPT-6** | Programming, benchmarking, and optimization assistance for this derivative. |
