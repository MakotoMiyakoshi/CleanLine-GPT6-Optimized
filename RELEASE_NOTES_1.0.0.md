# CleanLine GPT-6 Optimized 1.0.0

Installation archive: [`CleanLine_GPT6_Optimized_1.0.0.zip`](CleanLine_GPT6_Optimized_1.0.0.zip)

SHA-256: `3C05FDE0C323B2AF185D8CB45D2B131AF2F9629E7D87E7C6DD4E64B13286CD6E`

The ZIP has 39 entries under one EEGLAB plugin folder. Its CRC check passed.
It includes the complete Original and Optimized CleanLine V2 engines, the
Serial/Parallel selector (Serial default), GUI/API entry points, GPL v3
license text and retained original notices, validation report, benchmark
logs, and tests. It excludes the original Chronux and BCILAB files and all
participant EEG data.

A fresh extraction of this exact archive passed the 30-second reference,
single-precision, command-history, EEGLAB Tools menu, and 33-channel
parallel checks. The complete plugin source also passed direct 5- and
30-minute, 33-channel parity against public CleanLine V2 for both Original
and Optimized modes. See the [validation report](docs/VALIDATION_REPORT_20261118.md)
and [licensing audit](docs/LICENSING_AUDIT.md).

Headline measured medians: **5 min 51.47 → 13.69 s (3.76×)** and
**30 min 289.94 → 69.94 s (4.15×)**, comparing Original serial with
Optimized eight-worker parallel. Source-only matched parallel improvements
are 1.12× and 1.15× at those durations. Original CleanLine V2 already used
`parfor`; its parallelism is preserved rather than claimed as a new source
optimization. The [README](README.md) gives every duration, variability,
parameters, and numerical error.
