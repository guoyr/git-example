---- MODULE MC ----
EXTENDS jobstatus, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_1572002411786101000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:1P
const_1572002411786102000 == 
3
----

\* INIT definition @modelBehaviorNoSpec:0
init_1572002411786103000 ==
FALSE/\jobModCounts = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_1572002411786104000 ==
FALSE/\jobModCounts' = jobModCounts
----
=============================================================================
\* Modification History
\* Created Fri Oct 25 07:20:11 EDT 2019 by guo
