	#Install firehol and enable some block lists
  #By Poli Systems
  
  apt install firehol firehol-tools -y
  echo "        server all accept" >> /etc/firehol/firehol.conf
	update-ipsets enable feodo palevo sslbl zeus_badips dshield spamhaus_drop spamhaus_edrop openbl blocklist_de bi_ssh-ddos_0_1d bi_ssh-ddos_2_30d bi_ssh_0_1d bi_ssh_1_7d bi_ssh_2_30d bi_sshd_0_1d bi_wordpress_0_1d bi_wordpress_1_7d bi_wordpress_2_30d firehol_level1 firehol_level2 firehol_level3 dshield_top_1000 bruteforceblocker malc0de ransomware_rw greensnow myip fullbogons
	update-ipsets -s
	
	crontab -l > /tmp/tmpcron
	echo "*/13 * * * * root update-ipsets -s >/dev/null 2>&1" >> /tmp/tmpcron
	crontab /tmp/tmpcron
	rm /tmp/tmpcron
  
  echo "firehol has been installed and the crontab is running every 13 minutes" 
  echo "Thanks for using it, by Poli Systems"
