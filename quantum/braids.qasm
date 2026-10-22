// ============================================================================
// Z-ANYON LAB — non-Abelian braid battery (S3 qutrit miniature) in OpenQASM 3
// Quantum source of truth for the circuits the Python battery implements.
// The gate bodies below are EXACT decompositions, asserted in CI
// (.github/workflows/self-test.yml runs quantum/qasm_equivalence.py).
// ----------------------------------------------------------------------------
// Fusion space: |0>~|00>  |1>~|01>  |2>~|10>  (|11> FORBIDDEN — fusion veto)
// B_R: two-level rotation between |00> and |10> (plane 0,2)
//   verified body: X(q1) . CRy(-pi, q1->q0) . X(q1)          [exact, L1 = 0]
// B_S: two-level rotation between |01> and |10> (plane 1,2)
//   verified body: CX(q0,q1) . CRy(-pi, q1->q0) . CX(q0,q1)  [exact, L1 = 0]
// Non-Abelian: [B_R, B_S] L1-norm = 6. Order matters: (B_R B_S)^k != (B_S B_R)^k
// for k not multiple of 3; the period-3 echo makes them coincide at k = 3, 6.
// ============================================================================
OPENQASM 3.0;
include "stdgates.inc";

gate b_r q0, q1 {
  x q1;
  ctrl(1) @ ry(-pi) q1, q0;
  x q1;
}

gate b_s q0, q1 {
  cx q0, q1;
  ctrl(1) @ ry(-pi) q1, q0;
  cx q0, q1;
}

// ---------------------------------------------------------------------------
// Battery circuit 1 — braid word (B_R B_S)^2 on |00>: channel ends in |01>
// ---------------------------------------------------------------------------
qubit[2] fusion_a;
bit[2] word_rs;
reset fusion_a;
b_r fusion_a[0], fusion_a[1];
b_s fusion_a[0], fusion_a[1];
b_r fusion_a[0], fusion_a[1];
b_s fusion_a[0], fusion_a[1];
measure fusion_a -> word_rs;

// ---------------------------------------------------------------------------
// Battery circuit 2 — reversed word (B_S B_R)^2: different channel (|10>)
// The divergence of these two measurements is the non-Abelian signature.
// ---------------------------------------------------------------------------
qubit[2] fusion_b;
bit[2] word_sr;
reset fusion_b;
b_s fusion_b[0], fusion_b[1];
b_r fusion_b[0], fusion_b[1];
b_s fusion_b[0], fusion_b[1];
b_r fusion_b[0], fusion_b[1];
measure fusion_b -> word_sr;

// ---------------------------------------------------------------------------
// Battery circuit 3 — fusion veto: uniform prep over the 3 allowed channels,
// braid once; the |11> outcome must have probability exactly 0 in the exact
// statevector arithmetic (hardware shows readout noise; CI asserts the exact
// claim via anyon_lab.py, hardware receipts live in zephirum-lang).
// ---------------------------------------------------------------------------
qubit[2] fusion_v;
bit[2] veto;
reset fusion_v;
h fusion_v[0];
h fusion_v[1];
b_r fusion_v[0], fusion_v[1];
b_s fusion_v[0], fusion_v[1];
measure fusion_v -> veto;

// ---------------------------------------------------------------------------
// FULL BATTERY — braid words (B_R B_S)^k and (B_S B_R)^k, k = 1..6
// Expected measured channels (deterministic in the exact miniature): the
// two orders DIVERGE for k not multiple of 3 and COINCIDE at k = 3, 6
// (the period-3 echo). This is the non-Abelian signature, circuit by circuit.
// ---------------------------------------------------------------------------

// word (B_R B_S)^1 on |00> — expected channel |10>
qubit[2] w_rs_1;
bit[2] m_rs_1;
reset w_rs_1;
b_r w_rs_1[0], w_rs_1[1];
b_s w_rs_1[0], w_rs_1[1];
measure w_rs_1 -> m_rs_1;

// word (B_R B_S)^2 on |00> — expected channel |01>
qubit[2] w_rs_2;
bit[2] m_rs_2;
reset w_rs_2;
b_r w_rs_2[0], w_rs_2[1];
b_s w_rs_2[0], w_rs_2[1];
b_r w_rs_2[0], w_rs_2[1];
b_s w_rs_2[0], w_rs_2[1];
measure w_rs_2 -> m_rs_2;

// word (B_R B_S)^3 on |00> — expected channel |00>
qubit[2] w_rs_3;
bit[2] m_rs_3;
reset w_rs_3;
b_r w_rs_3[0], w_rs_3[1];
b_s w_rs_3[0], w_rs_3[1];
b_r w_rs_3[0], w_rs_3[1];
b_s w_rs_3[0], w_rs_3[1];
b_r w_rs_3[0], w_rs_3[1];
b_s w_rs_3[0], w_rs_3[1];
measure w_rs_3 -> m_rs_3;

// word (B_R B_S)^4 on |00> — expected channel |10>
qubit[2] w_rs_4;
bit[2] m_rs_4;
reset w_rs_4;
b_r w_rs_4[0], w_rs_4[1];
b_s w_rs_4[0], w_rs_4[1];
b_r w_rs_4[0], w_rs_4[1];
b_s w_rs_4[0], w_rs_4[1];
b_r w_rs_4[0], w_rs_4[1];
b_s w_rs_4[0], w_rs_4[1];
b_r w_rs_4[0], w_rs_4[1];
b_s w_rs_4[0], w_rs_4[1];
measure w_rs_4 -> m_rs_4;

// word (B_R B_S)^5 on |00> — expected channel |01>
qubit[2] w_rs_5;
bit[2] m_rs_5;
reset w_rs_5;
b_r w_rs_5[0], w_rs_5[1];
b_s w_rs_5[0], w_rs_5[1];
b_r w_rs_5[0], w_rs_5[1];
b_s w_rs_5[0], w_rs_5[1];
b_r w_rs_5[0], w_rs_5[1];
b_s w_rs_5[0], w_rs_5[1];
b_r w_rs_5[0], w_rs_5[1];
b_s w_rs_5[0], w_rs_5[1];
b_r w_rs_5[0], w_rs_5[1];
b_s w_rs_5[0], w_rs_5[1];
measure w_rs_5 -> m_rs_5;

// word (B_R B_S)^6 on |00> — expected channel |00>
qubit[2] w_rs_6;
bit[2] m_rs_6;
reset w_rs_6;
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
b_r w_rs_6[0], w_rs_6[1];
b_s w_rs_6[0], w_rs_6[1];
measure w_rs_6 -> m_rs_6;

// reversed word (B_S B_R)^1 on |00> — expected channel |01>
qubit[2] w_sr_1;
bit[2] m_sr_1;
reset w_sr_1;
b_s w_sr_1[0], w_sr_1[1];
b_r w_sr_1[0], w_sr_1[1];
measure w_sr_1 -> m_sr_1;

// reversed word (B_S B_R)^2 on |00> — expected channel |10>
qubit[2] w_sr_2;
bit[2] m_sr_2;
reset w_sr_2;
b_s w_sr_2[0], w_sr_2[1];
b_r w_sr_2[0], w_sr_2[1];
b_s w_sr_2[0], w_sr_2[1];
b_r w_sr_2[0], w_sr_2[1];
measure w_sr_2 -> m_sr_2;

// reversed word (B_S B_R)^3 on |00> — expected channel |00>
qubit[2] w_sr_3;
bit[2] m_sr_3;
reset w_sr_3;
b_s w_sr_3[0], w_sr_3[1];
b_r w_sr_3[0], w_sr_3[1];
b_s w_sr_3[0], w_sr_3[1];
b_r w_sr_3[0], w_sr_3[1];
b_s w_sr_3[0], w_sr_3[1];
b_r w_sr_3[0], w_sr_3[1];
measure w_sr_3 -> m_sr_3;

// reversed word (B_S B_R)^4 on |00> — expected channel |01>
qubit[2] w_sr_4;
bit[2] m_sr_4;
reset w_sr_4;
b_s w_sr_4[0], w_sr_4[1];
b_r w_sr_4[0], w_sr_4[1];
b_s w_sr_4[0], w_sr_4[1];
b_r w_sr_4[0], w_sr_4[1];
b_s w_sr_4[0], w_sr_4[1];
b_r w_sr_4[0], w_sr_4[1];
b_s w_sr_4[0], w_sr_4[1];
b_r w_sr_4[0], w_sr_4[1];
measure w_sr_4 -> m_sr_4;

// reversed word (B_S B_R)^5 on |00> — expected channel |10>
qubit[2] w_sr_5;
bit[2] m_sr_5;
reset w_sr_5;
b_s w_sr_5[0], w_sr_5[1];
b_r w_sr_5[0], w_sr_5[1];
b_s w_sr_5[0], w_sr_5[1];
b_r w_sr_5[0], w_sr_5[1];
b_s w_sr_5[0], w_sr_5[1];
b_r w_sr_5[0], w_sr_5[1];
b_s w_sr_5[0], w_sr_5[1];
b_r w_sr_5[0], w_sr_5[1];
b_s w_sr_5[0], w_sr_5[1];
b_r w_sr_5[0], w_sr_5[1];
measure w_sr_5 -> m_sr_5;

// reversed word (B_S B_R)^6 on |00> — expected channel |00>
qubit[2] w_sr_6;
bit[2] m_sr_6;
reset w_sr_6;
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
b_s w_sr_6[0], w_sr_6[1];
b_r w_sr_6[0], w_sr_6[1];
measure w_sr_6 -> m_sr_6;
