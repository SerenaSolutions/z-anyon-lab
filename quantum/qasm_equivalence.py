#!/usr/bin/env python3
"""Assert the OpenQASM gate bodies (quantum/braids.qasm) reproduce the exact
braid matrices B_R and B_S of the S3 qutrit miniature — declared vs. verified.
Exit 0 = both decompositions exact; 1 = mismatch (fail loudly, never silent)."""
import sys, math
import numpy as np

def RY(t): return np.array([[math.cos(t/2), -math.sin(t/2)], [math.sin(t/2), math.cos(t/2)]])
def op1(u, q): return np.kron(u, np.eye(2)) if q == 0 else np.kron(np.eye(2), u)
X = np.array([[0, 1], [1, 0]], float)

def CX(c, t):
    U = np.zeros((4, 4))
    for x in range(4):
        b = [x >> 1, x & 1]
        if b[c] == 1: b[t] ^= 1
        U[(b[0] << 1) | b[1], x] = 1
    return U

def CRy(c, t, th):
    U = np.zeros((4, 4))
    for x in range(4):
        b = [x >> 1, x & 1]
        if b[c] == 0:
            U[x, x] = 1
        else:
            col = RY(th)[:, b[t]]
            for j in range(2):
                nb = b[:]; nb[t] = j
                U[(nb[0] << 1) | nb[1], x] = col[j]
    return U

def lift(U3):
    U4 = np.eye(4); U4[:3, :3] = U3; return U4

B_R = np.array([[0, 0, 1], [0, 1, 0], [-1, 0, 0]], float)
B_S = np.array([[1, 0, 0], [0, 0, 1], [0, -1, 0]], float)

# gate b_r q0, q1 { x q1; ctrl(1) @ ry(-pi) q1, q0; x q1; }
r = op1(X, 1) @ CRy(1, 0, -math.pi) @ op1(X, 1)
# gate b_s q0, q1 { cx q0, q1; ctrl(1) @ ry(-pi) q1, q0; cx q0, q1; }
s = CX(0, 1) @ CRy(1, 0, -math.pi) @ CX(0, 1)

ok_r = np.allclose(r, lift(B_R)); ok_s = np.allclose(s, lift(B_S))
print("b_r decomposition exact:", ok_r, "| L1 dev:", round(float(np.abs(r - lift(B_R)).sum()), 12))
print("b_s decomposition exact:", ok_s, "| L1 dev:", round(float(np.abs(s - lift(B_S)).sum()), 12))
sys.exit(0 if (ok_r and ok_s) else 1)
