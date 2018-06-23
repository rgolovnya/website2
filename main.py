from flask import Flask, url_for
from flask import request
from flask import render_template
app = Flask(__name__)

@app.route('/')
@app.route('/index/')
def index():
    return render_template('index.html')
