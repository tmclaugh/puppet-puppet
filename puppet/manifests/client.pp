
class puppet::client ($host, $port) {

	package { "puppet" :
		ensure => present
	}

	file { "/etc/puppet/puppet.conf" :
		owner => "root",
		group => "root",
		mode => 644,
		require => Package["puppet"],
		source => "puppet:///modules/puppet/puppet.conf"

	}

	# http://projects.puppetlabs.com/projects/1/wiki/Cron_Patterns
	cron { "puppet_apply" :
		command => "puppet agent --server $host --masterport $port -t --logdest /var/log/puppet/agent.log > /dev/null 2>&1",
		user => "root",
		minute => fqdn_rand(10),
		require => File["/etc/puppet/puppet.conf"]
	}
}
