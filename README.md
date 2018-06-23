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
$ pip install Flask
```

# Run application locally (http://flask.pocoo.org/docs/1.0/quickstart/)
```{bash}
$ export FLASK_APP=main.py
$ flask run
 * Running on http://127.0.0.1:5000/
```
