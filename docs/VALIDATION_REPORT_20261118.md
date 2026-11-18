# CleanLine V2 plugin validation — 2026-11-18

## Status

The optimized computational source is validated on the stated 33-channel
benchmark. Both modes of the self-contained EEGLAB plugin passed the
reference parity checks described below. The [license audit](LICENSING_AUDIT.md)
documents the SCCN V2 redistribution interpretation and excluded third-party
files.

## Reproducible source and settings

- Original: CleanLine 2.00 `newversion=1`, verified against the local ZIP
  with SHA-256 `1F319E3C29E79525DB9D2C6EC47BEC4EB91A7D944D472D4C95D600148BEA6D53`.
- Optimized: the same V2 computation with cached F-test cutoff, frequency
  grid, frequency-bin indices, and taper sums. No signal-processing threshold
  or convergence criterion changed.
- Dataset: 33 channels, 256 Hz, 968,418 total samples; 5:5:30-minute
  prefixes. The 1,572 original events include ten boundary events. Reference
  V2 does not segment at boundaries.
- Processing: 60 Hz requested, automatically expanded to 60/120 Hz;
  4 s windows, 1 s step, 2 Hz scan and taper bandwidth, p = 0.01,
  padding factor 2, smoothing tau 100, ten-iteration maximum, NFFT 4096.
- Host: Windows 11, Intel Core i9-10900K, approximately 96 GB RAM;
  MATLAB R2024b Update 3 and EEGLAB 2024.0.

## Measured performance and errors

The [full aggregate table](../benchmarks/timing.csv) contains every duration,
and [all 28 paired timings](../benchmarks/raw_runs.csv) make the medians and
ranges independently checkable. The headline measurements are:

| Duration | Original serial | Optimized serial | Optimized parallel (8 workers) | Original/optimized parallel source-only |
| --- | ---: | ---: | ---: | ---: |
| 5 min | 51.47 s | 40.00 s | 13.69 s | 15.28 → 13.69 s (1.12×) |
| 30 min | 289.94 s | 226.85 s | 69.94 s | 80.43 → 69.94 s (1.15×) |

Parallel runs have three paired repeats at every duration. Serial runs have
three repeats at 5 and 30 min and one at each intermediate duration. The
eight-worker process pool took 12.080947 s to start in the measured session;
startup, loading, and saving are excluded from the processing times.

Across every tested duration and repetition, cleaned EEG and removed noise
have **maximum absolute error 0** and **relative L2 error 0** against Original
V2. This is exact equality of the compared numeric arrays, not merely
equivalence within the 1e-12 target.

## Synthetic and plugin checks

Five deterministic one-channel synthetic cases covered noise-only, weak and
strong 60-Hz interference, varying frequency, and a short 60-Hz burst.
Cleaned/removed samples, F-test statistics and decisions, detected
frequencies/amplitudes, and a fitted sinusoid were exactly equal in the
tested comparisons. The isolated 5-minute one-channel optimization screen
has [three rotated-order timing rows](../benchmarks/incremental_times.csv).

The plugin passed a 30-second public-reference
comparison for double-precision EEG, single-precision original/optimized
parity, command-history replay, input/event preservation, and separate Tools
menu registration. A 33-channel, 30-second parallel call ran with the
original CleanLine plugin removed from the MATLAB path and remained exactly
equal to its reference output. A development ZIP was extracted and the same
checks passed from the extracted location. The final 1.0.0 installation ZIP
is tested separately as part of the release gate.
In a separate full-duration check, public CleanLine V2 and both plugin
modes processed the same 33-channel 5- and 30-minute inputs with eight
workers. Cleaned samples, removed samples, and event metadata were exactly
equal in both comparisons. The portable
[`test_cleanline_gpt6_full_parity.m`](../tests/test_cleanline_gpt6_full_parity.m)
records this check; it requires separately supplied licensed test data.
Interactive GUI layout and all option combinations have not been exhaustively
tested.

## Limits

These findings apply to the stated data and settings. Reference V2 ignores
boundary events, and the equivalent mode retains that behavior. The
historical V1 engine and ICA component cleaning are outside this package.
See the [license audit](LICENSING_AUDIT.md) for excluded dependencies.
