$user = "tom"

class workstation {
        
        case $::operatingsystem {
                centos, redhat: {
                        $base_packages = [
                                "vim-common",
                                "openssh-server"
                        ]
			# TODO: add GPG check.  See:
			# http://rene.bz/yum-repo-and-package-dependencies-puppet/
			yumrepo { "epel":
				mirrorlist => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch",
				enabled => 1,
				gpgcheck => 0	
			}
                }
                debian, ubuntu: { 
                        $base_packages = [
                                "vim",
                                "openssh-server"
                        ]                       
                }
        }
                
        
        package { $base_packages:
                ensure => installed,
        }

	# need to figure out password
	user { $user:
		ensure => "present"
	}

	file { "/home/$user/.ssh":
		ensure => "directory",
		owner => $user,
		require => User[$user]
	}

	ssh_authorized_key { $user:
  		ensure => present,
  		key => "AAAAB3NzaC1yc2EAAAABJQAAAIBwyfdPUaRNjeoCZmyo/xPeVKevpXRbikmA0KaLRJwp2daI/LL/SGsHBqgeNzrnauALVPUAMh6wx2xgpLOWzLugIykq5vuIgDpcK/jrKfvwMC7O7mh915LqzutKVq9cUFEiXRhTsGOxZEQiwaG0ILLnvyEkxtQwCp7ujviNNSih2w==",
  		name => "$user key",
# 		target => "/home/$user/.ssh/authorized_keys",
  		type => rsa,
  		user => $user,
	}

	file { "/etc/ssh/sshd_config":
		source => "files/sshd_config"
	}
}

