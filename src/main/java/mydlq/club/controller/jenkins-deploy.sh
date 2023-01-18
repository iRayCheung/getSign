#!/bin/bash
set -e
echo "##############################start build and package##############################"


remote_host_addr[0]=192.168.0.138
remote_host_addr[1]=192.168.0.87
# remote_host_addr[2]=192.168.1.3
# remote_host_addr[3]=192.168.1.4
# remote_host_addr[4]=192.168.1.5
# remote_host_addr[5]=192.168.1.6
# remote_host_addr[6]=192.168.1.7
# remote_host_addr[7]=192.168.1.8
# remote_host_addr[8]=192.168.1.9
# remote_host_addr[9]=192.168.1.10


host_addr="140.210.222.155"
host_name="ecs-def0"
host_password="HP20220801."

proxy_addr="gac2wx_ftp@sftp-v-proxy.szh.internet.bosch.com"
proxy_port="1080"
proxy_password="3EWrTKf@!"

project_name="RBHPoC-CalculateServer"
project_env_name=${project_name}"-dev"
project_dependencies_name=${project_name}"-Backend"
project_full_name=${project_name}"-dev-Backend"
project_jar_name="calculateserver-0.0.1-SNAPSHOT.jar"

docker run -i --rm --name ${project_full_name} \
-v "$(pwd)":/usr/src/mymaven -v ${project_dependencies_name}:/root/.m2 \
-w /usr/src/mymaven szhvm00524.apac.bosch.com/common/maven:3.8.4-openjdk-8 \
bash -c "mvn clean package -DskipTests -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.valid"


echo "##############################start deploy on remote##############################"

ssh-keygen -R ${host_addr}
/usr/bin/expect <<-END
spawn ssh -o "ProxyCommand connect-proxy -S ${proxy_addr}:${proxy_port} %h %p" root@${host_addr}
expect {
	   "Enter SOCKS5 password for ${proxy_addr}:" {send "${proxy_password}\r"; exp_continue}
       "yes/no" {send "yes\r";exp_continue}
	   "root@${host_addr}'s password:" {send "${host_password}\r"};
}
expect "root@${host_name}"
send "mkdir -p /usr/local/${project_name}/${project_env_name}-tmp\r"
expect "root@${host_name}"
send "mkdir -p /usr/local/${project_name}/${project_env_name}\r"
expect "root@${host_name}"
send "exit\r"
expect eof

set timeout -1
spawn scp -r -o "ProxyCommand connect-proxy -S ${proxy_addr}:${proxy_port} %h %p" \
/net/wx8vm00005/fs0/jenkins_workspace/workspace/${project_env_name}/${project_full_name}/target/${project_jar_name} \
root@${host_addr}:/usr/local/${project_name}/${project_env_name}-tmp/
expect {
	   "Enter SOCKS5 password for ${proxy_addr}:" {send "${proxy_password}\r"; exp_continue}
	   "root@${host_addr}'s password:" {send "${host_password}\r"};
}
expect eof

set timeout -1
spawn scp -r -o "ProxyCommand connect-proxy -S ${proxy_addr}:${proxy_port} %h %p" \
/net/wx8vm00005/fs0/jenkins_workspace/workspace/${project_env_name}/${project_full_name}/jenkins/deploy-${project_full_name}.sh \
root@${host_addr}:/usr/local/${project_name}/${project_env_name}-tmp/
expect {
	   "Enter SOCKS5 password for ${proxy_addr}:" {send "${proxy_password}\r"; exp_continue}
	   "root@${host_addr}'s password:" {send "${host_password}\r"};
}
expect eof

set timeout -1
spawn scp -r -o "ProxyCommand connect-proxy -S ${proxy_addr}:${proxy_port} %h %p" \
/net/wx8vm00005/fs0/jenkins_workspace/workspace/${project_env_name}/${project_full_name}/jenkins/deploy-${project_full_name}-remote.sh \
root@${host_addr}:/usr/local/${project_name}/${project_env_name}-tmp/
expect {
	   "Enter SOCKS5 password for ${proxy_addr}:" {send "${proxy_password}\r"; exp_continue}
	   "root@${host_addr}'s password:" {send "${host_password}\r"};
}
expect eof

spawn ssh -o "ProxyCommand connect-proxy -S ${proxy_addr}:${proxy_port} %h %p" root@${host_addr}
expect {
	   "Enter SOCKS5 password for ${proxy_addr}:" {send "${proxy_password}\r"; exp_continue}
	   "root@${host_addr}'s password:" {send "${host_password}\r"};
}
expect "root@${host_name}"
send "/bin/bash /usr/local/${project_name}/${project_env_name}-tmp/deploy-${project_full_name}-remote.sh > /usr/local/${project_name}/${project_env_name}/deploy-${project_full_name}-remote.log 2>&1\r"
expect "root@${host_name}"
send "/bin/bash /usr/local/${project_name}/${project_env_name}-tmp/deploy-${project_full_name}.sh > /usr/local/${project_name}/${project_env_name}/deploy-${project_full_name}.log 2>&1\r"
expect "root@${host_name}"
send "exit\r"
expect eof
END


echo "##############################点我检查backend##############################"

echo "http://${host_addr}:33201"


for i in {0..1}; do

  echo "##############################点我检查backend##############################"

  echo "http://${remote_host_addr[$i]}:33201"

done