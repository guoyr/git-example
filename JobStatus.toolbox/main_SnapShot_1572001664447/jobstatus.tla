----------------------------- MODULE jobstatus -----------------------------
EXTENDS Naturals, Sequences, TLC

CONSTANT N, P, R

(*
--algorithm jobstatus {

variables jobModCounts = [1..N -> 0], savedModCounts = [1..N -> 0], availableJobs = 0;

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

process (producer \in <<1, 2, 3>>) {
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

process (receiver \in <<4, 5>>) {
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
\* Label p2 of process producer at line 30 col 3 changed to p2_
VARIABLES jobModCounts, savedModCounts, availableJobs, pc

vars == << jobModCounts, savedModCounts, availableJobs, pc >>

ProcSet == (<<1, 2, 3>>) \cup (<<4, 5>>)

Init == (* Global variables *)
        /\ jobModCounts = [1..N -> 0]
        /\ savedModCounts = [1..N -> 0]
        /\ availableJobs = 0
        /\ pc = [self \in ProcSet |-> CASE self \in <<1, 2, 3>> -> "p1"
                                        [] self \in <<4, 5>> -> "r1"]

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

r1(self) == /\ pc[self] = "r1"
            /\ availableJobs > 0
            /\ jobModCounts' = [jobModCounts EXCEPT ![self] = jobModCounts[self] + 1]
            /\ Assert(savedModCounts[self] \in <<jobModCounts'[self], jobModCounts'[self] - 1>>, 
                      "Failure of assertion at line 16, column 5 of macro called at line 45, column 5.")
            /\ savedModCounts' = [savedModCounts EXCEPT ![self] = jobModCounts'[self]]
            /\ pc' = [pc EXCEPT ![self] = "p2"]
            /\ UNCHANGED availableJobs

p2(self) == /\ pc[self] = "p2"
            /\ availableJobs' = availableJobs + 1
            /\ pc' = [pc EXCEPT ![self] = "r1"]
            /\ UNCHANGED << jobModCounts, savedModCounts >>

receiver(self) == r1(self) \/ p2(self)

Next == (\E self \in <<1, 2, 3>>: producer(self))
           \/ (\E self \in <<4, 5>>: receiver(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION
=============================================================================
\* Modification History
\* Last modified Fri Oct 25 07:07:38 EDT 2019 by guo
\* Created Fri Oct 25 03:25:07 EDT 2019 by guo
