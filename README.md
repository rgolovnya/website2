# Data Science Engineering Club
Repository containing the code of the website

# Set-up development environment

```{bash}
$ sudo pip install virtualenv
$ git clone https://github.com/rgolovnya/website2.git  
$ cd website2
$ virtualenv venv
New python executable in venv/bin/python
Installing setuptools, pip............done.
$ . venv/bin/activate # deactivate for leave the virtual environment
$ pip install Flask gunicorn
```

# Run application locally
## Flask Web server
```{bash}
# More info: http://flask.pocoo.org/docs/1.0/quickstart/
$ export FLASK_APP=main.py
$ flask run
 * Serving Flask app "main"
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
# Test application
curl localhost:5000
```

## Gunicorn
```{bash}
# More info: http://flask.pocoo.org/docs/1.0/quickstart/
$ export FLASK_APP=main.py
$ gunicorn wsgi:application
[2018-06-24 18:58:19 +0100] [87940] [INFO] Starting gunicorn 19.8.1
[2018-06-24 18:58:19 +0100] [87940] [INFO] Listening at: http://127.0.0.1:8000 (87940)
[2018-06-24 18:58:19 +0100] [87940] [INFO] Using worker: sync
[2018-06-24 18:58:19 +0100] [87943] [INFO] Booting worker with pid: 87943
# Test application
curl localhost:8000
```

# Deploy application
```{bash}
# more info https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-16-04
git clone https://github.com/rgolovnya/website2.git
cp website2/setupenv.sh .
. setupenv.sh
# Test application
curl public-ip-address
```
