# Apache Kafka [Kraft]
![Kafka Kraft](https://raw.githubusercontent.com/zakery1369/pics/master/Kafka.png)

## Install Java JDK version 11

1.Install Java JDK version 11 :
```bash
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt-get update; sudo apt-get install -y java-11-amazon-corretto-jdk
```

If see `add-apt-repository: command not found error` :
```bash
sudo apt-get install software-properties-common
```
2.Upon completion, you should get a similar output when doing `java -version` :
```bash
openjdk version "11.0.10" 2021-01-19 LTS
OpenJDK Runtime Environment Corretto-11.0.10.9.1 (build 11.0.10+9-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.10.9.1 (build 11.0.10+9-LTS, mixed mode)shell
```
## Install Kafka on Debian

1.Download the latest version of Apache Kafka. For example : `Scala 2.13  - kafka_2.13-3.5.1.tgz (asc, sha512)` :
```bash
https://kafka.apache.org/downloads
```
```bash
wget https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz
```
2.Extract kafka :
```bash
tar xvfz kafka_2.13-3.5.1.tgz
mv kafka_2.13-3.5.1 kafka
mv kafka /usr/local/bin
```
3.Create kafka usre :
```bash
useradd kafka -s /sbin/nologin
```
4.Change owner kafka directory in `/usr/local/bin` :
```bash
cd /usr/local/bin
chown -R kafka:kafka kafka
```

## Start Kafka

1.Generate a new ID for your cluster :
```bash
kafka/bin/kafka-storage.sh random-uuid
```
This returns a UUID, for example 69BLMI7rP_ql1KjfKs8L9Z
2.Format your storage directory (replace `<uuid>` by your UUID) :
```bash
kafka/bin/kafka-storage.sh format -t <uuid> -c kafka/config/kraft/server.properties
```
3.Move Kraft config to `/etc` :
```bash
mv kafka/config/kraft /etc/
```
4.Change owner kraft directory in `/etc` :
```bash
cd /etc
chown -R kafka:kafka kraft
```
5.Change owner kraft logs directory in `/tmp/kraft-combined-logs/` :
```bash
cd /tmp
chown -R kafka:kafka kraft-combined-logs
```
## Create Kafka service

1.Edit `/usr/lib/systemd/system/kafka.service` :
```bash
[Unit]
Description=Apache Kafka server [kraft]
Documentation=https://zakops.com

[Service]
Type=simple
User=kafka
Group=kafka
Environment=JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
ExecStart=/usr/local/bin/kafka/bin/kafka-server-start.sh /etc/kraft/server.properties
ExecStop=/usr/local/bin/kafka/bin/kafka-server-stop.sh /etc/kraft/server.properties

[Install]
WantedBy=multi-user.target
```
2.Reload and start the systemd services :
```bash
systemctl daemon-reload
systemctl start kafka.service
```
