"""Z-Anyon Lab battery test."""
import importlib.util, os
spec=importlib.util.spec_from_file_location("al", os.path.join(os.path.dirname(__file__),"..","anyon_lab.py"))
m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

def test_non_abelian():
    r=m.battery()
    assert r["verdict"]=="NAO_ABELIANO_VERIFICADO"
    assert r["commutator_L1"]!=0
    assert r["forbidden_channel_p"]<1e-12

