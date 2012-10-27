
# XXX: A puppet server also shares /etc/puppet via NFS for use in
# automated installs.  That setup needs to be added.

# XXX: We need to create an ssh key for root so that it can checkout
# the repo.

class puppet::server {
	file { "/etc/puppet/puppet.conf" :
		owner => "root",
		group => "root",
		mode => 644,
		require => Package["puppet"],
		source => "puppet:///modules/puppet/puppet.conf-server"
	}

	package { "puppet-server" :
		ensure => "present",	
	}

	file { "/etc/puppet/auth.conf" :
		owner => "root",
		group => "root",
		mode => 644,
		require => Package["puppet"],
		source => "puppet:///modules/puppet/auth.conf"
	}
	
	file { "/etc/puppet/autosign.conf" :
		owner => "root",
		group => "root",
		mode => 644,
		require => Package["puppet"],
		source => "puppet:///modules/puppet/autosign.conf"
	}

	file { "/etc/puppet/fileserver.conf" :
		owner => "root",
		group => "root",
		mode => 644,
		require => Package["puppet"],
		source => "puppet:///modules/puppet/fileserver.conf"
	}

	# XXX: Not enabled because on prod it's a ruby on rails app
	# while on dev it's run in two separate instances.  We should
	# probably migrate the stage env. on dev to ruby on rails and
	# and do the apache setup here while just leaving the trunk env
	# as a non-puppet controlled enviornment.
	# service { "puppetmaster" :}

	cron { "puppet_update_nodes" :
		command => "svn up /etc/puppet/manifests/nodes",
		minute => "*/5",
	}

	cron { "puppet_update" :
		command => "svn up /etc/puppet",
		# Update every ten minutes but off by one so we don't
		# collide with node update.
		minute => [1, 11, 21, 31, 41, 51],
	}
	
	include puppet::rack
}
