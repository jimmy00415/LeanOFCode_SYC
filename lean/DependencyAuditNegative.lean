import ErdosProblems.Erdos771
import ProofDependencyAudit

/-! Intentional negative check: this command must fail because it audits the
old complete theorem itself. It is not a candidate proof or accepted build. -/
#audit_progression_dependencies Erdos771.erdos_771
