# From AMI
mkdir workspace
sudo mkfs -t xfs /dev/nvme1n1
sudo mount /dev/nvme1n1 workspace -o umask=000
sudo chown -R ec2-user workspace/
cd workspace
tmux 

aws s3 cp "s3://osemosys-playground/hauke/Commit2_edHH.txt" Commit2_edHH.txt
aws s3 cp "s3://osemosys-playground/hauke/OSeMBE_V2_C1T0E1_data.txt" OSeMBE_V2_C1T0E1_data.txt
glpsol -m Commit2_edHH.txt -d OSeMBE_V2_C0T0E0_data_190617.txt --wlp input.lp --check


# Monitioring:
sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https perl-Digest-SHA.x86_64
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip && \
rm CloudWatchMonitoringScripts-1.2.2.zip && \
cd aws-scripts-mon
crontab -e 
# */1 * * * * ~/workspace/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --from-cron


# Writing and uploading
gzip output.sol -f output.sol.gz
gzip input.lp -f input.lp
aws s3 cp output.sol.gz "s3://osemosys-playground/hauke/OSeMBE_V2_C1T0E1.sol.gz" 
aws s3 cp input.lp.gz "s3://osemosys-playground/hauke/OSeMBE_V2_C1T0E1.lp.gz" 
