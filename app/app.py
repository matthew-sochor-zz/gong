import os

from flask import Flask, redirect, render_template, request, url_for
from flask_bootstrap import Bootstrap
from werkzeug.utils import secure_filename

# Flask extensions
bootstrap = Bootstrap()

app = Flask(__name__)

# Initialize flask extensions
bootstrap.init_app(app)

# env vars for tmp purposes
class Config(object):
    # DEBUG = False
    # TESTING = False
    SECRET_KEY = os.environ.get('SECRET_KEY',
                                'superSecretDoNotUseOnOpenWeb')

# init config
app.config.from_object(Config)

@app.route('/')
def index():
    art_url = url_for('static',
                      filename='images/gong.png')
    audio_url = url_for('static',
                      filename='audio/gong.mp3')

    return render_template('gong.html', art_url = art_url, audio_url = audio_url)
