# CleanLine V2 development validation — 2026-11-18

## Status

The optimized computational source is validated on the stated 33-channel
benchmark. The complete EEGLAB plugin remains a local development build
because the copied V2 core's redistribution permission needs confirmation.
No installation ZIP is published by this branch.

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

The complete local plugin prototype passed a 30-second public-reference
comparison for double-precision EEG, single-precision original/optimized
parity, command-history replay, input/event preservation, and separate Tools
menu registration. A 33-channel, 30-second parallel call ran with the
original CleanLine plugin removed from the MATLAB path and remained exactly
equal to its reference output. A rebuilt local ZIP (28 files, SHA-256
`A0794673378EDC7EE1DA40F4330B56F6F6E738BFD50DFE1E2748B0D1D352E4B4`)
was extracted and the same checks passed from the extracted location.
In a separate full-duration check, public CleanLine V2 and both local plugin
modes processed the same 33-channel 5- and 30-minute inputs with eight
workers. Cleaned samples, removed samples, and event metadata were exactly
equal in both comparisons. The portable
[`test_cleanline_gpt6_full_parity.m`](../development/test_cleanline_gpt6_full_parity.m)
records this check; it requires a locally complete plugin and licensed test
data and is not runnable from this partial development branch alone.
Interactive GUI layout and all option combinations have not been exhaustively
tested.

## Limits

These findings apply to the stated data and settings. Reference V2 ignores
boundary events, and the equivalent mode retains that behavior. The public
development branch excludes the copied V2 core and therefore is not an
installable plugin. See the [license audit](LICENSING_AUDIT.md).
