---- MODULE MC ----
EXTENDS jobstatus, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_157200205348474000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:1P
const_157200205348475000 == 
3
----

\* INIT definition @modelBehaviorNoSpec:0
init_157200205348476000 ==
FALSE/\jobModCounts = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_157200205348477000 ==
FALSE/\jobModCounts' = jobModCounts
----
=============================================================================
\* Modification History
\* Created Fri Oct 25 07:14:13 EDT 2019 by guo
