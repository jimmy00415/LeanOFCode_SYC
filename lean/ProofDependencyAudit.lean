import Lean

/-!
# Transitive proof dependency audit

This executable audit follows the constants in both declaration types and
bodies. It is supplementary evidence about proof reuse, not a proof of
historical originality or a replacement for Lean's kernel/axiom checks.
Missing constants cause failure rather than silently truncating the graph.
-/

open Lean Elab Command

namespace JSP000632DependencyAudit

partial def closure (env : Environment) (todo : List Name)
    (seen : NameSet := {}) : Except String NameSet :=
  match todo with
  | [] => .ok seen
  | n :: rest =>
    if seen.contains n then closure env rest seen
    else
      match env.find? n with
      | none => .error s!"Missing constant while traversing dependencies: {n}"
      | some ci =>
        closure env (ci.getUsedConstantsAsSet.toList ++ rest) (seen.insert n)

def excluded : List Name := [
  `Erdos771.erdos_771,
  `Erdos771.erdosF_asymptotic,
  `Erdos771.afTarget_mem_subsetSum,
  `Erdos771.exists_subset_sum_mod_primePower,
  `Erdos771.leastNondivisor_isPrimePow,
  `Erdos771.af_target_margin,
  `Erdos771.eventually_erdosF_lt_afCardThreshold,
  `Erdos771.eventually_erdosF_ratio_le_afCardThreshold]

elab "#audit_progression_dependencies " target:ident : command => do
  let env ← getEnv
  let n := target.getId
  for forbidden in excluded do
    unless (env.find? forbidden).isSome do
      throwError "Audit configuration error: excluded declaration {forbidden} does not exist"
  let visited ← match closure env [n] with
    | .ok s => pure s
    | .error e => throwError e
  let found := excluded.filter visited.contains
  unless found.isEmpty do
    throwError "Forbidden original target-proof dependencies: {found}"
  let upstream := visited.toArray.filter (fun x => (`Erdos771).isPrefixOf x)
    |>.qsort Name.lt
  logInfo m!"DEPENDENCY AUDIT PASS: {n}; visited {visited.size} constants"
  logInfo m!"Excluded original target-proof declarations: {excluded}"
  logInfo m!"Reused Erdos771 declarations ({upstream.size}): {upstream.toList}"

end JSP000632DependencyAudit
