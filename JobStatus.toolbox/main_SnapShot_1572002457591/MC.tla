---- MODULE MC ----
EXTENDS jobstatus, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1572002456580105000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:1P
const_1572002456580106000 == 
3
----

\* INIT definition @modelBehaviorNoSpec:0
init_1572002456580107000 ==
FALSE/\jobModCounts = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_1572002456580108000 ==
FALSE/\jobModCounts' = jobModCounts
----
=============================================================================
\* Modification History
\* Created Fri Oct 25 07:20:56 EDT 2019 by guo
