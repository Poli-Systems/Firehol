#Install firehol and enable some block lists
#By Poli Systems
  
  apt update
  apt install firehol firehol-tools -y
  echo '
# FireHOL configuration file
#
# See firehol.conf(5) manual page and FireHOL Manual for details.
#
# This configuration file will allow all requests originating from the
# local machine to be send through all network interfaces.
#
# No requests are allowed to come from the network. The host will be
# completely stealthed! It will not respond to anything, and it will
# not be pingable, although it will be able to originate anything
# (even pings to other hosts).
#

version 6

        ipset4 create whitelist hash:net
        ipset4 add whitelist 127.0.0.1/32

        # subnets - netsets
        for x in fullbogons dshield spamhaus_drop spamhaus_edrop firehol_level1 firehol_level2 firehol_level3 dshield_1d dshield_30d dshield_7d
        do
                ipset4 create  ${x} hash:net
                ipset4 addfile ${x} ipsets/${x}.netset
                blacklist4 full inface any log "BLACKLIST ${x^^}" ipset:${x} \
                        except src ipset:whitelist
        done

        # individual IPs - ipsets
        for x in blocklist_de bruteforceblocker malc0de myip greensnow dshield_top_1000
        do
                ipset4 create  ${x} hash:ip
                ipset4 addfile ${x} ipsets/${x}.ipset
                blacklist4 full inface any log "BLACKLIST ${x^^}" ipset:${x} \
                        except src ipset:whitelist
        done


# Accept all client traffic on any interface
interface any world
        client all accept
        server all accept
        client ipv6neigh accept
        server ipv6neigh accept

' > /etc/firehol/firehol.conf

	update-ipsets enable  dshield spamhaus_drop spamhaus_edrop blocklist_de firehol_level1 firehol_level2 firehol_level3 dshield_top_1000 bruteforceblocker malc0de greensnow myip fullbogons
	update-ipsets -s
	
	crontab -l > /tmp/tmpcron
	echo "*/13 * * * * root update-ipsets -s >/dev/null 2>&1" >> /tmp/tmpcron
	crontab /tmp/tmpcron
	rm /tmp/tmpcron
  	
	update-rc.d firehol defaults
	firehol restart
	
  echo "firehol has been installed and the crontab is running every 13 minutes" 
  echo "We recommand you to close this session and to open a new one to prevent issues with the backspace"
  echo "Thanks for using it, by Poli Systems"
