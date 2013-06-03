`puppet-iptables`
=================

Install and configure `iptables`.  The basic scaffolding in place is a first rule that accepts open connections, one that accepts all traffic on the loopback interface, and a final rule that rejects all other traffic.

Each `iptables::rule` resource manages a single rule which is assumed to be orthogonal to all others.  **No guarantees are made about the order in which rules appear in `/etc/iptables.rules`.**  If for some reason order becomes important, manage an `/etc/iptables.rules.d/filter-rules-*` file and notify `Exec["iptables-rules"]`.
