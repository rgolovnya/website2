from flask import Flask, url_for
from flask import request
from flask import render_template
application = Flask(__name__)

@application.route('/')
@application.route('/index/')
def index():
    return render_template('index.html')

if __name__ == "__main__":
    application.run(host='0.0.0.0')
