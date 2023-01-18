#!/bin/bash
set -e


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

remote_host_name[0]=ecs-def0
remote_host_name[1]=ecs-def0
# remote_host_name[2]=ecs-def0
# remote_host_name[3]=ecs-def0
# remote_host_name[4]=ecs-def0
# remote_host_name[5]=ecs-def0
# remote_host_name[6]=ecs-def0
# remote_host_name[7]=ecs-def0
# remote_host_name[8]=ecs-def0
# remote_host_name[9]=ecs-def0

remote_host_pass[0]=HP20220801.
remote_host_pass[1]=HP20220801.
# remote_host_pass[2]=pass3
# remote_host_pass[3]=pass4
# remote_host_pass[4]=pass5
# remote_host_pass[5]=pass6
# remote_host_pass[6]=pass7
# remote_host_pass[7]=pass8
# remote_host_pass[8]=pass9
# remote_host_pass[9]=pass10

project_name="RBHPoC-CalculateServer"
project_env_name=${project_name}"-dev"
project_dependencies_name=${project_name}"-Backend"
project_full_name=${project_name}"-dev-Backend"
project_jar_name="calculateserver-0.0.1-SNAPSHOT.jar"
ssh_user="root"



echo "##############################start copy on remote##############################"

for i in {0..1}; do


  ssh-keygen -R ${remote_host_addr[$i]}
  /usr/bin/expect <<-END
spawn ssh ${ssh_user}@${remote_host_addr[$i]}
expect {
       "yes/no" {send "yes\r";exp_continue}
       "${ssh_user}@${remote_host_addr[$i]}'s password:" {send "${remote_host_pass[$i]}\r";exp_continue};
}
expect "${ssh_user}@${remote_host_name[$i]}"
send "mkdir -p /usr/local/${project_name}/${project_env_name}-tmp\r"
expect "${ssh_user}@${remote_host_name[$i]}"
send "sudo chmod 777 /usr/local/${project_name}/${project_env_name}-tmp\r"
expect "${ssh_user}@${remote_host_name[$i]}"
send "mkdir -p /usr/local/${project_name}/${project_env_name}\r"
expect "${ssh_user}@${remote_host_name[$i]}"
send "sudo chmod 777 /usr/local/${project_name}/${project_env_name}\r"
expect "${ssh_user}@${remote_host_name[$i]}"
send "exit\r"
expect eof

set timeout -1
spawn scp -r \
/usr/local/${project_name}/${project_env_name}-tmp/${project_jar_name} \
${ssh_user}@${remote_host_addr[$i]}:/usr/local/${project_name}/${project_env_name}-tmp/
expect {
       "${ssh_user}@${remote_host_addr[$i]}'s password:" {send "${remote_host_pass[$i]}\r"};
}
expect eof

set timeout -1
spawn scp -r \
/usr/local/${project_name}/${project_env_name}-tmp/deploy-${project_full_name}.sh \
${ssh_user}@${remote_host_addr[$i]}:/usr/local/${project_name}/${project_env_name}-tmp/
expect {
       "${ssh_user}@${remote_host_addr[$i]}'s password:" {send "${remote_host_pass[$i]}\r"};
}
expect eof

END

echo "##############################${remote_host_addr[$i]} 拷贝完成##############################"

done

echo "##############################start run jars on remote##############################"

for i in {0..1}; do

  ssh-keygen -R ${remote_host_addr[$i]}
  /usr/bin/expect <<-ENDJARS
spawn ssh ${ssh_user}@${remote_host_addr[$i]}
expect {
       "yes/no" {send "yes\r";exp_continue}
       "${ssh_user}@${remote_host_addr[$i]}'s password:" {send "${remote_host_pass[$i]}\r";exp_continue};
}
expect "${ssh_user}@${remote_host_name[$i]}"
send "/bin/bash /usr/local/${project_name}/${project_env_name}-tmp/deploy-${project_full_name}.sh > /usr/local/${project_name}/${project_env_name}/deploy-${project_full_name}.log 2>&1\r"
expect "${ssh_user}@${remote_host_name[$i]}"
send "exit\r"
expect eof

ENDJARS

echo "##############################${remote_host_addr[$i]} 启动完成##############################"

done


echo "远程机器服务已全部启动完成"