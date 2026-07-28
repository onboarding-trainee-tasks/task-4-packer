chmod 600 /home/ubuntu/.ssh/terraform-ssh-key.pem
chmod 700 /home/ubuntu/.ssh

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

cd /home/ubuntu
git clone https://github.com/onboarding-trainee-tasks/task-4-ansible
cd task-4-ansible
git checkout onb-4-ansible
git fetch
git pull