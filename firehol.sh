	#Install firehol and enable some block lists
  #By Poli Systems
  
  apt install firehol firehol-tools -y
  echo "        server all accept" >> /etc/firehol/firehol.conf
	update-ipsets enable  dshield spamhaus_drop spamhaus_edrop blocklist_de firehol_level1 firehol_level2 firehol_level3 dshield_top_1000 bruteforceblocker malc0de greensnow myip fullbogons
	update-ipsets -s
	
	crontab -l > /tmp/tmpcron
	echo "*/13 * * * * root update-ipsets -s >/dev/null 2>&1" >> /tmp/tmpcron
	crontab /tmp/tmpcron
	rm /tmp/tmpcron
  	
	update-rc.d firehol defaults
	firehol start
	
  echo "firehol has been installed and the crontab is running every 13 minutes" 
  echo "We recommand you to close this session and to open a new one to prevent issues with the backspace"
  echo "Thanks for using it, by Poli Systems"
