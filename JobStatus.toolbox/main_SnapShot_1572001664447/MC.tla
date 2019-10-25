---- MODULE MC ----
EXTENDS jobstatus, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_157200166028965000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:1P
const_157200166028966000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:2R
const_157200166028967000 == 
2
----

\* INIT definition @modelBehaviorNoSpec:0
init_157200166028968000 ==
FALSE/\jobModCounts = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_157200166028969000 ==
FALSE/\jobModCounts' = jobModCounts
----
=============================================================================
\* Modification History
\* Created Fri Oct 25 07:07:40 EDT 2019 by guo
