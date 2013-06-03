# TODO -d
# TODO --to-port
# TODO -m multiport --destination-ports
define iptables::rule($chain = "INPUT",
                      $comment = false,
                      $dport = false,
                      $ensure,
                      $icmp_type = false,
                      $iface = false,
                      $jump = "ACCEPT",
                      $proto = false,
                      $source = false,
                      $table = "filter") {
    case "$ensure" {
        "present": {

            $_comment = $comment ? {
                false => " -m comment --comment \"$name\"",
                default => " -m comment --comment \"$name: $comment\"",
            }

            $_icmp_type = $icmp_type ? {
                false => "",
                default => " --icmp-type \"$icmp_type\"",
            }

            $_iface = $iface ? {
                false => "",
                default => " -i \"$iface\"",
            }

            $_dport = $dport ? {
                false => "",
                default => " --dport \"$dport\"",
            }

            $_source = $source ? {
                false => "",
                default => " -s \"$source\"",
            }

            file { "/etc/iptables.rules.d/${table}-rules-${name}":
                content => $proto ? {
                    false => "-A \"${chain}\"${_iface}${_source}${_dport}${_comment} -j \"${jump}\"\n",
                    "icmp" => "-A \"${chain}\"${_iface} -m ${proto} -p ${proto}${_source}${_dport}${_icmp_type}${_comment} -j \"${jump}\"\n",
                    "tcp" => "-A \"${chain}\"${_iface} -m state --state NEW -m ${proto} -p ${proto}${_source}${_dport}${_comment} -j \"${jump}\"\n",
                    "udp" => "-A \"${chain}\"${_iface} -m ${proto} -p ${proto}${_source}${_dport}${_comment} -j \"${jump}\"\n",
                },
                ensure => file,
                group => "root",
                mode => 0644,
                notify => Exec["${table}-rules"],
                owner => "root",
            }

        }
        "absent": {

            file { "/etc/iptables.rules.d/${table}-rules-${name}":
                ensure => absent,
                notify => Exec["${table}-rules"],
            }

        }
    }
}
