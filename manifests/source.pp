define iptables::source($chain = "INPUT",
                        $comment = false,
                        $dport = false,
                        $ensure,
                        $icmp_type = false,
                        $iface = false,
                        $jump = "ACCEPT",
                        $proto = false,
                        $source = false,
                        $table = "filter") {}