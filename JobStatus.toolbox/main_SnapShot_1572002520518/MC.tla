---- MODULE MC ----
EXTENDS jobstatus, TLC

\* INIT definition @modelBehaviorNoSpec:0
init_1572002519506111000 ==
FALSE/\b = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_1572002519506112000 ==
FALSE/\b' = b
----
=============================================================================
\* Modification History
\* Created Fri Oct 25 07:21:59 EDT 2019 by guo
