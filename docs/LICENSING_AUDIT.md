# Licensing and dependency audit for CleanLine GPT-6 Optimized 1.0.0

## CleanLine V2 core

The source is the verified SCCN CleanLine 2.00 archive (SHA-256
`1F319E3C29E79525DB9D2C6EC47BEC4EB91A7D944D472D4C95D600148BEA6D53`).
Its `cleanline.m` and `pop_cleanline.m` expressly permit redistribution and
modification under GPL version 3 or later. `eegplugin_cleanline.m` permits GPL
version 2 or later. `cleanline.m` exposes the `newversion` switch and calls
`cleanLineNoise.m` for that V2 path. On this package-level evidence, we use
GPL-3.0-or-later for the adapted V2 computation. The archive also carries a
top-level GPL v2 license text; it is preserved as
`ORIGINAL_CLEANLINE_LICENSE.txt` and disclosed here, not interpreted as a
GPL-v2-only restriction overriding the explicit program notices. This is the
documented licensing interpretation for this distribution, not a new license
grant. Original source comments, authorship, and copyright notices in the
adapted V2 files are retained. See the
[SCCN source](https://github.com/sccn/cleanline/blob/master/cleanline.m) and
[source provenance](PROVENANCE.md).

## Third-party files in the original CleanLine archive

| Original bundled files | Evidence and compatibility finding | Distribution choice |
| --- | --- | --- |
| `external/chronux_2_modified/spectral_analysis/continuous/mtfftc.m`, `external/chronux_2_modified/spectral_analysis/continuous/createdatamatc.m`, `external/chronux_2_modified/spectral_analysis/helper/change_row_to_column.m`, `external/chronux_2_modified/spectral_analysis/helper/getfgrid.m` | The bundled Chronux `License.txt` is GPL v2 text; the four files have no explicit “or later” statement. The [Chronux release note](https://github.com/jsiegle/chronux/blob/master/release_note.txt) describes the project as GPL v2. GPL-v2-only code would be incompatible with a GPL-v3 work under the [GNU compatibility guidance](https://www.gnu.org/licenses/gpl-faq.en.html#v2v3Compatibility). The exact modified copies therefore lack a demonstrated GPL-v3-compatible grant. | **Excluded.** Four independently written `+clgpt6compat` routines implement the required numeric interfaces and passed sample-exact tests. No Chronux source is in the ZIP. |
| `external/bcilab_partial/arguments/arg_*.m`, `external/bcilab_partial/helpers/hlp_*.m`, and associated environment, utility, and MEX files | This partial copy has no single top-level license manifest identifying every included file. The [BCILAB release notes](https://github.com/sccn/BCILAB/blob/devel/RELEASE%20NOTES.TXT) say helpers, miscellaneous, argument, and parallel functions became BSD licensed, but that does not establish the precise terms and notice requirements for every file in this older partial copy. | **Excluded.** A new wrapper uses MATLAB `inputParser` and a separate EEGLAB dialog. No BCILAB source or binary is in the ZIP. |
| `external/bcilab_partial/dependencies/CStrAinBP-2009-09-13/*` | The included `license.txt` grants redistribution under a two-condition BSD-style license with copyright and disclaimer retention. Those terms are compatible with GPL v3, but the files are unnecessary. | **Excluded.** No CStrAinBP code or binary is in the ZIP. |

The replacement helpers are short, newly written MATLAB implementations of
the needed numerical operations; their provenance and exact parity checks are
documented in the [validation report](VALIDATION_REPORT_20261118.md). Runtime
requirements are EEGLAB and MATLAB's Signal Processing and Statistics
toolboxes; the optional parallel mode also needs Parallel Computing Toolbox.
These products are not bundled.

## Package check

The versioned plugin folder and ZIP contain the adapted V2 core, new wrapper,
new compatibility helpers, GPL v3 license text, retained archive license
text, notices, documentation, and aggregate benchmarks. They contain no
`external/chronux_2_modified`, `external/bcilab_partial`, participant EEG,
`.set`/`.fdt` files, or third-party binaries. Serial mode was tested with no
parallel pool; parallel mode was tested with eight process workers.
