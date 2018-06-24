#!/usr/bin/env bash

# Setup python3.6 as the default for python3
setupEnvrionment () {
    printf '===========================Setup the environment============================== \n'

    sudo apt-get update
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update

    printf '================== Set python3.6 as the default for python3 ================== \n'
    sudo apt-get install -y python3.6 python3-pip nginx python3.6-gdbm
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 10
    sudo update-alternatives --config -y python3
    pip3 install virtualenv
}


setupApp () {
    printf '===========================Setup the Application ============================== \n'
    pwd
    virtualenv -p python3 env
    source env/bin/activate
    sudo git clone https://github.com/rgolovnya/website2.git
    cd website2
    pip3 install -r requirements.txt
}

configureNginx () {
    printf '================================= Configure nginx ============================== \n'

    # Create the nginx configurations
     sudo bash -c 'cat > /etc/nginx/sites-available/datascience-club <<EOF
    server {
    listen 80;
        location / {
            proxy_pass http://127.0.0.1:8000/;
            proxy_set_header Host \$host;
            proxy_set_header X-Forwarded-Proto \$scheme;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
    '

    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    sudo ln -s /etc/nginx/sites-available/datascience-club /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
}

setupStartScript () {
    printf '=========================== Create a startup script =========================== \n'

    # create a .env file for the environment variables
     sudo bash -c 'cat > /home/ubuntu/website2/\.env <<EOF
    export FLASK_CONFIG=development
    '

    # create a startup script to start the virtual environment,
    # load the environment variables and start the app
     sudo bash -c 'cat > /home/ubuntu/website2/startenv.sh <<EOF
    #!/bin/bash

    cd /home/ubuntu
    ls
    source env/bin/activate
    cd website2

    source .env
    gunicorn manage:app
    '
}

setupStartService () {
    printf '=========================== Configure startup service =========================== \n'

    # Create service that starts the app from the startup script
     sudo bash -c 'cat > /etc/systemd/system/datascience-club.service <<EOF
    [Unit]
    Description=datascience-club startup service
    After=network.target

    [Service]
    User=ubuntu
    ExecStart=/bin/bash /home/ubuntu/website2/startenv.sh
    Restart=always

    [Install]
    WantedBy=multi-user.target
    '

    sudo chmod 744 /home/ubuntu/website2/startenv.sh
    sudo chmod 664 /etc/systemd/system/datascience-club.service
    sudo systemctl daemon-reload
    sudo systemctl enable datascience-club.service
    sudo systemctl start datascience-club.service

}

run () {
  setupEnvrionment
  setupApp
  configureNginx
  setupStartScript
  setupStartService
}

run
