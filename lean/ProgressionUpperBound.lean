import ErdosProblems.Erdos771

/-!
# Erdős 771: an LCM-cutoff upper-bound assembly

This module implements the local LCM-cutoff upper bound and complete-limit
assembly developed by Jimmy (`jimmy00415`) and Codex on 30 October 2026.
Its analytic and additive-combinatorial inputs are supplied by the pinned
`plby/lean-proofs` library, especially `Erdos771.af_uniform_representation`,
the PNT-based cutoff asymptotics, and the Erdős--Graham lower bound.

Set `r = lcmCutoff (afUpperEndpoint n)` and use the representation theorem with
`s = r`. Every returned modulus `q ≤ r` then divides the
target `lcmUpto r`. A direct endpoint estimate suffices; no residue correction
or prime-power argument is needed in this assembly.

Direct upstream inputs used below: `af_uniform_representation`, `dvd_lcmUpto`,
`lcmUpto_cutoff_le`, `cutoff_next_lcm_gt`, `lcmUpto_succ_le_mul`,
`afCutoff_tendsto_atTop`, `eventually_afTargetNondivisor_le_three_binaryScale`,
`eventually_binaryScale_ge`, `eventually_one_le_afUpperEndpoint`,
`afTargetNondivisor_ratio_tendsto_two`,
`natDiv_afTargetNondivisor_ratio_tendsto_half`,
`afThreshold_seed_error_tendsto_zero`, `afThreshold_modulus_error_tendsto_zero`,
`erdosF_lt_of_all_large_represent`, `exists_gt_two_inv_gt`, and
`eventually_lt_erdosF_ratio_of_lt_inv`, together with the displayed definitions
and standard Mathlib limit/order lemmas. The eventual scale estimate is
`Erdos387.eventually_binaryLogScale_pow_le_half`.
-/

open Filter Erdos771
open scoped Topology

namespace JSP000632Progression

noncomputable section

def cutoff (n : ℕ) : ℕ := lcmCutoff (afUpperEndpoint n)

def cutoffTarget (n : ℕ) : ℕ := Nat.lcmUpto (cutoff n)

def cutoffThreshold (n : ℕ) : ℕ := afCardThreshold n (cutoff n)

/-- The endpoint estimate needed by this assembly has no residue-loss term. -/
theorem lowerEndpoint_mul_le_upper {n s : ℕ}
    (hs : s ≤ 3 * binaryScale n) :
    afLowerEndpoint n * s ≤ afUpperEndpoint n := by
  have hB : 0 < binaryScale n := binaryScale_pos n
  unfold afUpperEndpoint
  apply (Nat.le_div_iff_mul_le (mul_pos (by omega) (pow_pos hB 2))).2
  calc
    (afLowerEndpoint n * s) * (1000 * binaryScale n ^ 2) ≤
        (afLowerEndpoint n * (3 * binaryScale n)) *
          (1000 * binaryScale n ^ 2) :=
      Nat.mul_le_mul_right _ (Nat.mul_le_mul_left _ hs)
    _ = 3000 * (afLowerEndpoint n * binaryScale n ^ 3) := by ring
    _ ≤ 10000 * (afLowerEndpoint n * binaryScale n ^ 3) :=
      Nat.mul_le_mul_right _ (by omega)
    _ = afLowerEndpoint n * (10000 * binaryScale n ^ 3) := by ring
    _ ≤ n ^ 2 := Nat.div_mul_le_self _ _

/-- LCM maximality places the target inside the covered interval. -/
theorem lowerEndpoint_lt_cutoffTarget {n : ℕ}
    (hs : afTargetNondivisor n ≤ 3 * binaryScale n) :
    afLowerEndpoint n < cutoffTarget n := by
  have hlow : afLowerEndpoint n * (cutoff n + 1) ≤ afUpperEndpoint n :=
    lowerEndpoint_mul_le_upper (by simpa [afTargetNondivisor, cutoff] using hs)
  have hnext : afUpperEndpoint n < Nat.lcmUpto (cutoff n + 1) :=
    cutoff_next_lcm_gt
  have hstep : Nat.lcmUpto (cutoff n + 1) ≤
      (cutoff n + 1) * cutoffTarget n := lcmUpto_succ_le_mul _
  have hmul : afLowerEndpoint n * (cutoff n + 1) <
      cutoffTarget n * (cutoff n + 1) := by
    calc
      _ ≤ afUpperEndpoint n := hlow
      _ < Nat.lcmUpto (cutoff n + 1) := hnext
      _ ≤ (cutoff n + 1) * cutoffTarget n := hstep
      _ = cutoffTarget n * (cutoff n + 1) := Nat.mul_comm _ _
  exact Nat.lt_of_mul_lt_mul_right hmul

/-- Choosing the cutoff itself as modulus cap makes divisibility automatic. -/
theorem cutoffTarget_mem_subsetSum {n : ℕ} {A : Finset ℕ}
    (hn : 10000000 < n)
    (hB : 256 * (512 * 1001) ^ 2 < binaryScale n)
    (hpow : binaryScale n ^ 38 ≤ n / 2)
    (hX : 1 ≤ afUpperEndpoint n) (hr : 0 < cutoff n)
    (hs : afTargetNondivisor n ≤ 3 * binaryScale n)
    (hA : A ⊆ Finset.Icc 1 n) (hcard : cutoffThreshold n ≤ A.card) :
    cutoffTarget n ∈ A.subsetSum := by
  have hrB : cutoff n ≤ 3 * binaryScale n := by
    have hsucc : cutoff n + 1 ≤ 3 * binaryScale n := by
      simpa [afTargetNondivisor, cutoff] using hs
    omega
  obtain ⟨q, G, hq, hqr, hG, hcover⟩ :=
    af_uniform_representation hn hB hpow hr hrB hA hcard
  have hdiv : q ∣ cutoffTarget n := dvd_lcmUpto hq hqr
  have hlow : afLowerEndpoint n ≤ cutoffTarget n :=
    (lowerEndpoint_lt_cutoffTarget hs).le
  have hupp : cutoffTarget n ≤ afUpperEndpoint n := lcmUpto_cutoff_le hX
  have hGA : G ⊆ A := by
    rw [hG]
    exact Finset.filter_subset _ _
  exact Finset.subsetSum_mono hGA (hcover _ hlow hupp hdiv)

theorem eventually_erdosF_lt_cutoffThreshold :
    ∀ᶠ n : ℕ in atTop, erdosF n < cutoffThreshold n := by
  filter_upwards [eventually_gt_atTop 10000000,
    eventually_binaryScale_ge (256 * (512 * 1001) ^ 2 + 1),
    Erdos387.eventually_binaryLogScale_pow_le_half 38,
    eventually_one_le_afUpperEndpoint,
    eventually_afTargetNondivisor_le_three_binaryScale,
    afCutoff_tendsto_atTop.eventually (eventually_gt_atTop 0)]
    with n hn hB hpow hX hs hr
  change binaryScale n ^ 38 ≤ n / 2 at hpow
  change 0 < cutoff n at hr
  apply erdosF_lt_of_all_large_represent (m := cutoffTarget n) (Nat.lcmUpto_pos _)
  intro A hA hcard
  exact cutoffTarget_mem_subsetSum hn (by omega) hpow hX hr hs hA hcard

theorem cutoff_ratio_tendsto_two :
    Tendsto (fun n : ℕ => (cutoff n : ℝ) / Real.log (n : ℝ))
      atTop (𝓝 2) := by
  have hone : Tendsto (fun n : ℕ => (1 : ℝ) / Real.log (n : ℝ))
      atTop (𝓝 0) := tendsto_const_nhds.div_atTop tendsto_log_coe_at_top
  simpa [afTargetNondivisor, cutoff, Nat.cast_add, Nat.cast_one, add_div] using
    afTargetNondivisor_ratio_tendsto_two.sub hone

/-- Squeeze the integral quotient between the successor-cutoff quotient and
the real quotient. This avoids a separate floor-error calculation. -/
theorem natDiv_cutoff_ratio_tendsto_half :
    Tendsto (fun n : ℕ => ((n / cutoff n : ℕ) : ℝ) /
      ((n : ℝ) / Real.log (n : ℝ))) atTop (𝓝 (1 / 2 : ℝ)) := by
  have hupp : Tendsto (fun n : ℕ => Real.log (n : ℝ) / cutoff n)
      atTop (𝓝 (1 / 2 : ℝ)) := by
    simpa only [inv_div, one_div] using
      cutoff_ratio_tendsto_two.inv₀ (by norm_num : (2 : ℝ) ≠ 0)
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le'
    natDiv_afTargetNondivisor_ratio_tendsto_half hupp
  · filter_upwards [eventually_gt_atTop 1,
      afCutoff_tendsto_atTop.eventually (eventually_gt_atTop 0)] with n hn hr
    change 0 < cutoff n at hr
    have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by exact_mod_cast hn)
    have hnorm : 0 ≤ (n : ℝ) / Real.log (n : ℝ) := by positivity
    have hdiv : n / afTargetNondivisor n ≤ n / cutoff n :=
      Nat.div_le_div_left (by simp [afTargetNondivisor, cutoff]) hr
    exact div_le_div_of_nonneg_right (by exact_mod_cast hdiv) hnorm
  · filter_upwards [eventually_gt_atTop 1,
      afCutoff_tendsto_atTop.eventually (eventually_gt_atTop 0)] with n hn hr
    change 0 < cutoff n at hr
    have hnR : (0 : ℝ) < n := by positivity
    have hrR : (0 : ℝ) < cutoff n := by exact_mod_cast hr
    have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by exact_mod_cast hn)
    have hnorm : 0 ≤ (n : ℝ) / Real.log (n : ℝ) := by positivity
    calc
      ((n / cutoff n : ℕ) : ℝ) / ((n : ℝ) / Real.log (n : ℝ)) ≤
          ((n : ℝ) / cutoff n) / ((n : ℝ) / Real.log (n : ℝ)) :=
        div_le_div_of_nonneg_right Nat.cast_div_le hnorm
      _ = Real.log (n : ℝ) / cutoff n := by
        field_simp [hnR.ne', hrR.ne', hlog.ne']

theorem cutoff_error_tendsto_zero :
    Tendsto (fun n : ℕ => (cutoff n : ℝ) /
      ((n : ℝ) / Real.log (n : ℝ))) atTop (𝓝 0) := by
  apply squeeze_zero' _ _ afThreshold_modulus_error_tendsto_zero
  · filter_upwards [eventually_gt_atTop 1] with n hn
    have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by exact_mod_cast hn)
    positivity
  · filter_upwards [eventually_gt_atTop 1] with n hn
    have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by exact_mod_cast hn)
    apply div_le_div_of_nonneg_right _ (by positivity)
    exact_mod_cast (show cutoff n ≤ afTargetNondivisor n by
      simp [cutoff, afTargetNondivisor])

theorem cutoffThreshold_ratio_tendsto_half :
    Tendsto (fun n : ℕ => (cutoffThreshold n : ℝ) /
      ((n : ℝ) / Real.log (n : ℝ))) atTop (𝓝 (1 / 2 : ℝ)) := by
  have h := (natDiv_cutoff_ratio_tendsto_half.add
    afThreshold_seed_error_tendsto_zero).add cutoff_error_tendsto_zero
  simpa only [cutoffThreshold, afCardThreshold, Nat.cast_add, add_div, add_zero] using h

theorem eventually_erdosF_ratio_le_cutoffThreshold :
    ∀ᶠ n : ℕ in atTop,
      (erdosF n : ℝ) / ((n : ℝ) / Real.log (n : ℝ)) ≤
      (cutoffThreshold n : ℝ) / ((n : ℝ) / Real.log (n : ℝ)) := by
  filter_upwards [eventually_erdosF_lt_cutoffThreshold, eventually_gt_atTop 1]
    with n hbound hn
  have hlog : 0 < Real.log (n : ℝ) := Real.log_pos (by exact_mod_cast hn)
  exact div_le_div_of_nonneg_right (by exact_mod_cast hbound.le) (by positivity)

/-- Complete limit obtained from this upper-bound assembly and the library's
Erdős--Graham lower bound. -/
theorem erdosF_asymptotic_via_progression :
    Tendsto (fun n : ℕ => (erdosF n : ℝ) /
      ((n : ℝ) / Real.log (n : ℝ))) atTop (𝓝 (1 / 2 : ℝ)) := by
  apply tendsto_order.2
  constructor
  · intro a ha
    obtain ⟨c, hc, hac⟩ := exists_gt_two_inv_gt ha
    exact eventually_lt_erdosF_ratio_of_lt_inv hc hac
  · intro b hb
    filter_upwards [eventually_erdosF_ratio_le_cutoffThreshold,
      (tendsto_order.1 cutoffThreshold_ratio_tendsto_half).2 b hb]
      with n hupper hthreshold
    exact hupper.trans_lt hthreshold

#print axioms lowerEndpoint_mul_le_upper
#print axioms lowerEndpoint_lt_cutoffTarget
#print axioms cutoffTarget_mem_subsetSum
#print axioms eventually_erdosF_lt_cutoffThreshold
#print axioms cutoff_ratio_tendsto_two
#print axioms natDiv_cutoff_ratio_tendsto_half
#print axioms cutoff_error_tendsto_zero
#print axioms cutoffThreshold_ratio_tendsto_half
#print axioms eventually_erdosF_ratio_le_cutoffThreshold
#print axioms erdosF_asymptotic_via_progression

end

end JSP000632Progression
