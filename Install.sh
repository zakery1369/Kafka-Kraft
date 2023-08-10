wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
sudo apt-get update; sudo apt-get install -y java-11-amazon-corretto-jdk

wget https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz
tar xvfz kafka_2.13-3.5.1.tgz
mv kafka_2.13-3.5.1 kafka
mv kafka /usr/local/bin

useradd kafka -s /sbin/nologin
chown -R kafka:kafka kafka

kafka/bin/kafka-storage.sh random-uuid
kafka/bin/kafka-storage.sh format -t <uuid> -c kafka/config/kraft/server.properties

mv kafka/config/kraft /etc/
cd /etc
chown -R kafka:kafka kraft

cd /tmp
chown -R kafka:kafka kraft-combined-logs
