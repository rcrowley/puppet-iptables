class iptables {

    Exec {
        cwd => "/etc/iptables.rules.d",
        provider => "shell",
        refreshonly => true,
    }
    exec {
        "iptables":
            command => "iptables-restore </etc/iptables.rules";
        "iptables.rules":
            command => "cat nat-prologue nat-chains nat-intermission nat-rules nat-epilogue filter-prologue filter-chain filter-intermission filter-rules filter-epilogue >/etc/iptables.rules",
            notify => Exec["iptables"],
            returns => [0, 1];
        "filter-chains":
            command => "find . -name 'filter-chains-*' | sort | xargs cat >filter-chains",
            notify => Exec["iptables.rules"];
        "filter-rules":
            command => "find . -name 'filter-rules-*' | sort | xargs cat >filter-rules",
            notify => Exec["iptables.rules"];
        "nat-chains":
            command => "find . -name 'nat-chains-*' | sort | xargs cat >nat-chains",
            notify => Exec["iptables.rules"];
        "nat-rules":
            command => "find . -name 'nat-rules-*' | sort | xargs cat >nat-rules",
            notify => Exec["iptables.rules"];
    }

    File {
        ensure => file,
        group => "root",
        mode => 0644,
        notify => Exec["iptables.rules"],
        owner => "root",
    }
    file {
        "/etc/iptables.rules.d":
            ensure => directory,
            mode => 0755;
        "/etc/iptables.rules.d/filter-epilogue":
            content => template("iptables/filter-epilogue.erb");
        "/etc/iptables.rules.d/filter-intermission":
            content => template("iptables/filter-intermission.erb");
        "/etc/iptables.rules.d/filter-prologue":
            content => template("iptables/filter-prologue.erb");
        "/etc/iptables.rules.d/nat-epilogue":
            content => template("iptables/nat-epilogue.erb");
        "/etc/iptables.rules.d/nat-intermission":
            content => template("iptables/nat-intermission.erb");
        "/etc/iptables.rules.d/nat-prologue":
            content => template("iptables/nat-prologue.erb");
        "/etc/network/if-pre-up.d/iptables":
            mode => 0755,
            source => "puppet:///modules/iptables/if-pre-up";
    }

    package { "iptables":
        ensure => latest,
        notify => Exec["iptables"],
    }

}
