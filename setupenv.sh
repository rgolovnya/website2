printf '===========================Install the Components from the Ubuntu Repositories============================== \n'
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev nginx

sudo pip3 install virtualenv

printf '===========================Checkout the project from GitHub============================== \n'
git clone https://github.com/rgolovnya/website2
cd website2

printf '===========================Create a Python Virtual Environment============================== \n'
virtualenv env
source env/bin/activate

printf '===========================Set Up a Flask Application============================== \n'
pip install gunicorn flask

deactivate

printf '===========================Create a systemd Unit File============================== \n'
sudo bash -c 'cat > /etc/systemd/system/datascience-club.service <<EOF
[Unit]
Description=Gunicorn instance to serve datascience-club
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/website2
Environment="PATH=/home/ubuntu/website2/env/bin"
ExecStart=/home/ubuntu/website2/env/bin/gunicorn --workers 3 --bind unix:datascience-club.sock -m 007 wsgi:application

[Install]
WantedBy=multi-user.target
'

sudo systemctl start datascience-club
sudo systemctl enable datascience-club

printf '===========================Configuring Nginx to Proxy Requests============================== \n'
sudo bash -c 'cat > /etc/nginx/sites-available/datascience-club.service <<EOF
server {
    listen 80;
    server_name server_domain_or_IP;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/ubuntu/website2/datascience-club.sock;
    }
}
'
sudo ln -s /etc/nginx/sites-available/datascience-club.service /etc/nginx/sites-enabled

sudo nginx -t
sudo systemctl restart nginx

sudo ufw allow 'Nginx Full'
