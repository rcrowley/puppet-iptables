define iptables::chain($ensure = "present", $table = "filter") {
    case "$ensure" {
        "present": {

            file { "/etc/iptables.rules.d/${table}-chains-${name}":
                content => ":$name - [0:0]\n",
                ensure => file,
                group => "root",
                mode => 0644,
                notify => Exec["${table}-chains"],
                owner => "root",
            }

        }
        "absent": {

            file { "/etc/sysconfig/${table}-chains-${name}":
                ensure => absent,
                notify => Exec["${table}-chains"],
            }

        }
    }
}
