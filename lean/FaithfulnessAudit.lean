import ErdosProblems.Erdos771

/-!
# Faithfulness audit of the previously published proof

The final result below is a transparent restatement of the pinned public theorem,
not an original proof. It makes the subset quantifier explicit and checks that
the bounded maximum and complete limit agree with that published development.
-/

open Filter
open scoped BigOperators Topology

namespace JSP000632Faithfulness

def OriginalPredicate (n k : ℕ) : Prop :=
  ∀ m : ℕ, 0 < m → ∃ S : Finset ℕ,
    S ⊆ Finset.Icc 1 n ∧ S.card = k ∧
      ∀ A : Finset ℕ, A ⊆ S → (∑ a ∈ A, a) ≠ m

noncomputable def originalF (n : ℕ) : ℕ := by
  classical
  exact Nat.findGreatest (OriginalPredicate n) n

theorem originalPredicate_eq (n : ℕ) :
    OriginalPredicate n = Erdos771.AdmissibleCard n := by
  funext k
  apply propext
  simp [OriginalPredicate, Erdos771.AdmissibleCard,
    Erdos771.AvoidsSubsetSum, Finset.mem_subsetSum_iff]

theorem originalF_eq (n : ℕ) : originalF n = Erdos771.erdosF n := by
  classical
  unfold originalF Erdos771.erdosF
  simp only [originalPredicate_eq]

/-- The exact original interval formulation, derived from the earlier public
proof. This wrapper does not establish new formalization priority. -/
theorem original_statement_from_prior_proof :
    Tendsto (fun n : ℕ =>
      (originalF n : ℝ) / ((n : ℝ) / Real.log (n : ℝ)))
      atTop (𝓝 (1 / 2 : ℝ)) := by
  simpa only [originalF_eq] using Erdos771.erdos_771

#print original_statement_from_prior_proof
#print axioms originalPredicate_eq
#print axioms originalF_eq
#print axioms original_statement_from_prior_proof

end JSP000632Faithfulness
