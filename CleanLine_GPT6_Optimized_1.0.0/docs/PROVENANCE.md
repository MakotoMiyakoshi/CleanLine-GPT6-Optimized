# Source provenance and changes

Reference: locally verified EEGLAB `Cleanline2.00.zip`, SHA-256 `1F319E3C29E79525DB9D2C6EC47BEC4EB91A7D944D472D4C95D600148BEA6D53`.

The installed `pop_cleanline.m`, `cleanline.m`, `cleanLineNoise.m`, `removeLinesMovingWindow.m`, `fitSignificantFrequencies.m`, `testSignificantFrequencies.m`, and `calculateSegmentSpectrum.m` were compared byte for byte with the ZIP and matched. MATLAB `which pop_cleanline -all` resolved the installed reference. The current upstream `sccn/cleanline` master revision is newer and is not asserted to match this ZIP.

`+clgpt6original` copies the V2 computational functions with mechanical package-qualified calls and a serial/parallel dispatch around its unchanged per-channel computation. `+clgpt6optimized` additionally computes the F-test critical value, frequency grid, taper sum, and squared taper sum once per invocation and reuses them for every sliding window. These are included in the versioned plugin folder. The original reference already exits iterations when no target frequencies remain; that behavior was not introduced by this project.

`+clgpt6compat` contains newly written compatibility implementations of the four helper interfaces used by V2. They reproduce the same numerical operations on the tested inputs and remove the need to bundle Chronux. The plugin contains no BCILAB files; a new EEGLAB wrapper parses settings. The [licensing audit](LICENSING_AUDIT.md) documents the GPL-3.0-or-later interpretation for the SCCN V2 core and the exclusion of the original third-party dependencies.

The local benchmark uses 33 channels sampled at 256 Hz, 60 Hz requested (CleanLine expands to 60 and 120 Hz), 4-second windows, 1-second step, scan bandwidth 2 Hz, taper bandwidth 2 Hz, F-test p 0.01, FFT pad 2, smoothing tau 100, and the V2 hardcoded ten-iteration maximum. The original V2 algorithm does not inspect EEGLAB boundary events. The wrapper preserves event metadata and does not introduce segmentation.
