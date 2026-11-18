# CleanLine GPT-6 Optimized 1.0.0

Installation archive: [`CleanLine_GPT6_Optimized_1.0.0.zip`](CleanLine_GPT6_Optimized_1.0.0.zip)

SHA-256 (documentation revision): `D9234165B92DB0014C9F8268AC2FE9E346D65A5D6D7B86771359624CADBAE265`

The ZIP has 40 entries under one EEGLAB plugin folder. Its CRC check passed.
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
Optimized eight-worker parallel. The [README](README.md) separates that
overall acceleration from matched-mode source changes:

| Comparison | 5 min | 30 min |
| --- | ---: | ---: |
| Original Serial → Optimized Serial | 51.47 → 40.00 s (1.29×) | 289.94 → 226.85 s (1.28×) |
| Original Parallel → Optimized Parallel | 15.28 → 13.69 s (1.12×) | 80.43 → 69.94 s (1.15×) |
| Original Serial → Optimized Parallel | 51.47 → 13.69 s (3.76×) | 289.94 → 69.94 s (4.15×) |

The first CleanLine implementation was developed by **Tim Mullen**.
**Kay A. Robbins'** [2014 PREP implementation](https://github.com/VisLab/EEG-Clean-Tools/commit/a37f73be8675b6670df9c749ba1a9eeeaa4b0b96)
already contained channel-level `parfor`; **Arnaud Delorme**
[integrated Kay's rewrite](https://github.com/sccn/cleanline/commit/294a6178157cd77fec25fcbb7e7ad2175076a60f)
into official CleanLine V2 in 2020, following an initiative coordinated
and validated by **Makoto Miyakoshi**. The present project did not
introduce that parallel architecture. It adds per-channel computation
optimizations, an explicit execution-mode selector, testing, and packaging.
See the [development history](docs/DEVELOPMENT_HISTORY.md) for the
chronology and attribution.

This documentation revision changes no validated MATLAB algorithm or
benchmark measurement.
