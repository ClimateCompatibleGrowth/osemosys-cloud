# From AMI
aws s3 cp "s3://osemosys-playground/hauke/Commit2_edHH.txt" Commit2_edHH.txt
aws s3 cp "s3://osemosys-playground/hauke/OSeMBE_V2_C0T0E0_data_190617.txt" OSeMBE_V2_C0T0E0_data_190617.txt
glpsol -m Commit2_edHH.txt -d OSeMBE_V2_C0T0E0_data_190617.txt --wlp input.lp --check


# Monitioring:
sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \
cd aws-scripts-mon
crontab -e 
# */1 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --from-cron
