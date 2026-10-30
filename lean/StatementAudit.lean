import Mathlib

/-!
# JSP-000632 / Erdős 771: independent statement audit

This file checks the exact quantifier order and elementary divisor construction.
`ExactTarget` is a proposition definition, not a proof of the asymptotic theorem.
The separate pinned public candidate is not claimed as our original work.
-/

open Filter
open scoped BigOperators Topology

namespace JSP000632Audit

/-- Every subset, including the empty subset, has sum different from `m`. -/
def Avoids (m : ℕ) (S : Finset ℕ) : Prop :=
  ∀ A : Finset ℕ, A ⊆ S → (∑ a ∈ A, a) ≠ m

/-- The set may depend on the positive target; its cardinality is fixed. -/
def AdmissibleCard (n k : ℕ) : Prop :=
  ∀ m : ℕ, 0 < m → ∃ S : Finset ℕ,
    S ⊆ Finset.Icc 1 n ∧ S.card = k ∧ Avoids m S

/-- The bound `n` is justified because the host interval has `n` elements. -/
noncomputable def extremal (n : ℕ) : ℕ := by
  classical
  exact Nat.findGreatest (AdmissibleCard n) n

/-- Exact intended asymptotic target. This declaration does not prove it. -/
def ExactTarget : Prop :=
  Tendsto (fun n : ℕ =>
    (extremal n : ℝ) / ((n : ℝ) / Real.log (n : ℝ)))
    atTop (𝓝 (1 / 2 : ℝ))

theorem avoids_iff_not_mem_subsetSum {m : ℕ} {S : Finset ℕ} :
    Avoids m S ↔ m ∉ S.subsetSum := by
  simp [Avoids, Finset.mem_subsetSum_iff]

/-- Equally sized hosts need not have the same target-avoidance behavior. -/
theorem even_pair_avoids_three : Avoids 3 {2, 4} := by
  rw [avoids_iff_not_mem_subsetSum]
  decide

theorem initial_pair_does_not_avoid_three : ¬ Avoids 3 {1, 2} := by
  rw [avoids_iff_not_mem_subsetSum]
  decide

theorem avoids_mono {m : ℕ} {S T : Finset ℕ}
    (hS : Avoids m S) (hTS : T ⊆ S) : Avoids m T := by
  intro A hAT
  exact hS A (hAT.trans hTS)

/-- A mathematical ingredient of the lower-bound construction. -/
theorem avoids_of_common_divisor {m d : ℕ} {S : Finset ℕ}
    (hS : ∀ a ∈ S, d ∣ a) (hm : ¬d ∣ m) : Avoids m S := by
  intro A hAS hsum
  apply hm
  rw [← hsum]
  exact Finset.dvd_sum (fun a ha => hS a (hAS ha))

/-- The actual finite lower-bound construction: a nondivisor gives precisely
`floor(n / q)` distinct positive multiples avoiding the prescribed target.
This elementary construction is classical; no originality is claimed. -/
theorem exists_avoiding_of_nondivisor (n m q : ℕ) (hqm : ¬q ∣ m) :
    ∃ S : Finset ℕ, S ⊆ Finset.Icc 1 n ∧
      S.card = n / q ∧ Avoids m S := by
  let S := (Finset.range (n + 1)).filter (fun a => a ≠ 0 ∧ q ∣ a)
  have hSn : S ⊆ Finset.Icc 1 n := by
    intro a ha
    have ha' := Finset.mem_filter.mp ha
    have harange := Finset.mem_range.mp ha'.1
    have hane := ha'.2.1
    exact Finset.mem_Icc.mpr ⟨by omega, by omega⟩
  have hcard : S.card = n / q := by
    simpa [S, Nat.succ_eq_add_one] using Nat.card_multiples' n q
  refine ⟨S, hSn, hcard, avoids_of_common_divisor ?_ hqm⟩
  intro a ha
  exact (Finset.mem_filter.mp ha).2.2

theorem admissibleCard_zero (n : ℕ) : AdmissibleCard n 0 := by
  intro m hm
  refine ⟨∅, Finset.empty_subset _, by simp, ?_⟩
  intro A hA
  have hA0 : A = ∅ := Finset.subset_empty.mp hA
  subst A
  simpa using hm.ne

theorem admissibleCard_le {n k : ℕ} (hk : AdmissibleCard n k) : k ≤ n := by
  obtain ⟨S, hSn, hSk, _⟩ := hk 1 (by decide)
  have hcard := Finset.card_le_card hSn
  simpa [hSk] using hcard

theorem admissibleCard_mono {n k l : ℕ}
    (hk : AdmissibleCard n k) (hlk : l ≤ k) : AdmissibleCard n l := by
  intro m hm
  obtain ⟨S, hSn, hSk, hSm⟩ := hk m hm
  have hlS : l ≤ S.card := by simpa [hSk] using hlk
  obtain ⟨T, hTS, hTl⟩ := Finset.exists_subset_card_eq hlS
  exact ⟨T, hTS.trans hSn, hTl, avoids_mono hSm hTS⟩

theorem extremal_spec (n : ℕ) : AdmissibleCard n (extremal n) := by
  classical
  exact Nat.findGreatest_spec (m := 0) (Nat.zero_le n) (admissibleCard_zero n)

theorem admissibleCard_iff_le_extremal {n k : ℕ} (hk : k ≤ n) :
    AdmissibleCard n k ↔ k ≤ extremal n := by
  classical
  constructor
  · exact fun h => Nat.le_findGreatest hk h
  · exact fun h => admissibleCard_mono (extremal_spec n) h

/-- A sanity check: swapping the quantifiers to one set for every positive
target would force an entirely different, trivial extremal problem. -/
theorem avoids_every_positive_iff_empty {S : Finset ℕ}
    (hpos : ∀ a ∈ S, 0 < a) :
    (∀ m : ℕ, 0 < m → Avoids m S) ↔ S = ∅ := by
  constructor
  · intro h
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro a ha
    have hbad := h a (hpos a ha) {a} (Finset.singleton_subset_iff.mpr ha)
    simpa using hbad
  · rintro rfl m hm A hA
    have hA0 : A = ∅ := Finset.subset_empty.mp hA
    subst A
    simpa using hm.ne

#check ExactTarget
#print axioms avoids_iff_not_mem_subsetSum
#print axioms even_pair_avoids_three
#print axioms initial_pair_does_not_avoid_three
#print axioms avoids_of_common_divisor
#print axioms exists_avoiding_of_nondivisor
#print axioms admissibleCard_le
#print axioms admissibleCard_mono
#print axioms admissibleCard_iff_le_extremal
#print axioms avoids_every_positive_iff_empty

end JSP000632Audit
