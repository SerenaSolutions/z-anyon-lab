# Z-Anyon Lab

![anyons](https://img.shields.io/badge/anyons-S3%20qutrit%20miniature-blue) ![license](https://img.shields.io/badge/license-MIT-blue)

**Run the non-Abelian anyon braid battery in CI.** `NAO_ABELIANO_VERIFICADO` passes the job; anything else fails it. *Nothing executes silently.*

Exact statevector arithmetic (numpy), sealed with Z-QEA (SHA3-256). Checks:

- **Non-Abelian signature:** commutator `[B_R, B_S]` L1-norm = 6 (order of braids matters)
- **Fusion veto:** forbidden channel `|11>` keeps probability exactly 0 (fusion space has dimension 3)
- **Braid words:** `(B_R B_S)^k` vs `(B_S B_R)^k` diverge for k not multiple of 3
- **Period-3 echo:** the two orders coincide at k = 3, 6 (topological periodicity, documented in [ZEPHIRUM](https://github.com/SerenaSolutions/zephirum-lang) round 3)

Declared honestly: this is the S3 qutrit miniature — the logical primitive
(3-channel fusion + non-commuting braids), not a full 54-qubit quantum double.

## Usage

```yaml
- name: Non-Abelian anyon battery
  uses: SerenaSolutions/z-anyon-lab@v1
```

### Outputs

| Output | Description |
|--------|-------------|
| `verdict` | `NAO_ABELIANO_VERIFICADO` or `REFUSED` |
| `seal` | SHA3-256 seal of the sealed receipt |

Exit code: `0` = verdict verified, `1` = REFUSED (job fails).

Free forever, MIT. Part of the ZEPHIRUM product line: [zqea-verify](https://github.com/marketplace/actions/z-qea-receipt-verifier) (Marketplace), [zq-gate](https://github.com/SerenaSolutions/zq-gate), [zqea-seal](https://github.com/SerenaSolutions/zqea-seal).
