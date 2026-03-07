# -------------------------------
# 1. Install Java
# -------------------------------
sudo apt update -y
sudo apt install openjdk-11-jdk -y

java -version


# -------------------------------
# 2. Set JAVA_HOME
# -------------------------------
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc


# -------------------------------
# 3. Install SSH
# -------------------------------
sudo apt install ssh -y

sudo systemctl start ssh
sudo systemctl enable ssh


# -------------------------------
# 4. Setup Passwordless SSH
# -------------------------------
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys


# Test SSH
ssh localhost
exit


# -------------------------------
# 5. Download Hadoop
# -------------------------------
cd ~

wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

tar -xvzf hadoop-3.3.6.tar.gz

cd hadoop-3.3.6


# -------------------------------
# 6. Configure JAVA_HOME in Hadoop
# -------------------------------
nano etc/hadoop/hadoop-env.sh
