
# XXX: class still needs to require an apache restart and that
# mod_passenger is installed. 
class puppet::rack {
	file { "/etc/puppet/rack" :
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => '0755'
	}
	
	file { "/etc/puppet/rack/public" :
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => '0755',
		require => File["/etc/puppet/rack"]
	}
	
	file { "/etc/puppet/rack/tmp" :
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => '0755',
		require => File["/etc/puppet/rack"]
	}
	
	file { "/etc/puppet/rack/config.ru" :
		owner => "puppet",
		group => "puppet",
		mode => '0644',
		source => "/usr/share/puppet/ext/rack/files/config.ru",
		require => File["/etc/puppet/rack"]
	}
	
	file { "/etc/httpd/conf.d/rack.conf" :
		owner => "root",
		group => "root",
		mode => '0644',
		# XXX: At some point we should manage the CA related stuff but
		# we don't right now.  start/stop puppetmaster and CA info will
		# be generated and files will exist.
		content => template("puppet/rack.conf.erb")
	}
}