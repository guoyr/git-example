----------------------------- MODULE jobstatus -----------------------------
EXTENDS Naturals, Sequences, TLC

CONSTANT N, P

(*
--algorithm jobstatus {

variables jobModCounts = {0 : x \in 1..N}, savedModCounts = {0 : x \in 1..N}, availableJobs = 0;

macro lock(job) {
    jobModCounts[job] := jobModCounts[job] + 1;
};

macro save(job) {
    assert savedModCounts[job] \in <<jobModCounts[job], jobModCounts[job] - 1>>;
    savedModCounts[job] := jobModCounts[job];
};

macro put(job) {
    savedModCounts[job] := 0;
    jobModCounts[job] := 0;
}

process (producer \in 1..P) {
p1:
  print << "here" >>;
p2:
  while (TRUE) {
    await availableJobs < N;
p3:    
    put(self);
p4:    
    availableJobs := availableJobs - 1;
  }
}

process (receiver \in P..N) {
r0:
  print << "here3" >>;
r1:
  while (TRUE) {
    \* wait for jobs that need to be run
    await availableJobs > 0;
    lock(self);
    save(self);
    
p2:
    availableJobs := availableJobs + 1;
    
  }
}

} \* end algorithm
*)


\* BEGIN TRANSLATION
\* Label p2 of process producer at line 29 col 3 changed to p2_
VARIABLES jobModCounts, savedModCounts, availableJobs, pc

vars == << jobModCounts, savedModCounts, availableJobs, pc >>

ProcSet == (1..P) \cup (P..N)

Init == (* Global variables *)
        /\ jobModCounts = {0 : x \in 1..N}
        /\ savedModCounts = {0 : x \in 1..N}
        /\ availableJobs = 0
        /\ pc = [self \in ProcSet |-> CASE self \in 1..P -> "p1"
                                        [] self \in P..N -> "r0"]

p1(self) == /\ pc[self] = "p1"
            /\ PrintT(<< "here" >>)
            /\ pc' = [pc EXCEPT ![self] = "p2_"]
            /\ UNCHANGED << jobModCounts, savedModCounts, availableJobs >>

p2_(self) == /\ pc[self] = "p2_"
             /\ availableJobs < N
             /\ pc' = [pc EXCEPT ![self] = "p3"]
             /\ UNCHANGED << jobModCounts, savedModCounts, availableJobs >>

p3(self) == /\ pc[self] = "p3"
            /\ savedModCounts' = [savedModCounts EXCEPT ![self] = 0]
            /\ jobModCounts' = [jobModCounts EXCEPT ![self] = 0]
            /\ pc' = [pc EXCEPT ![self] = "p4"]
            /\ UNCHANGED availableJobs

p4(self) == /\ pc[self] = "p4"
            /\ availableJobs' = availableJobs - 1
            /\ pc' = [pc EXCEPT ![self] = "p2_"]
            /\ UNCHANGED << jobModCounts, savedModCounts >>

producer(self) == p1(self) \/ p2_(self) \/ p3(self) \/ p4(self)

r0(self) == /\ pc[self] = "r0"
            /\ PrintT(<< "here3" >>)
            /\ pc' = [pc EXCEPT ![self] = "r1"]
            /\ UNCHANGED << jobModCounts, savedModCounts, availableJobs >>

r1(self) == /\ pc[self] = "r1"
            /\ availableJobs > 0
            /\ jobModCounts' = [jobModCounts EXCEPT ![self] = jobModCounts[self] + 1]
            /\ Assert(savedModCounts[self] \in <<jobModCounts'[self], jobModCounts'[self] - 1>>, 
                      "Failure of assertion at line 16, column 5 of macro called at line 46, column 5.")
            /\ savedModCounts' = [savedModCounts EXCEPT ![self] = jobModCounts'[self]]
            /\ pc' = [pc EXCEPT ![self] = "p2"]
            /\ UNCHANGED availableJobs

p2(self) == /\ pc[self] = "p2"
            /\ availableJobs' = availableJobs + 1
            /\ pc' = [pc EXCEPT ![self] = "r1"]
            /\ UNCHANGED << jobModCounts, savedModCounts >>

receiver(self) == r0(self) \/ r1(self) \/ p2(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in 1..P: producer(self))
           \/ (\E self \in P..N: receiver(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION
=============================================================================
\* Modification History
\* Last modified Fri Oct 25 07:30:48 EDT 2019 by guo
\* Created Fri Oct 25 03:25:07 EDT 2019 by guo
