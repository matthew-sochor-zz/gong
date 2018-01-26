#!/bin/bash

if [[ "$2" == "--start" ]]; then
    echo "Starting App"

    if [[ "$1" == "--prod" ]]; then
        source activate app

        mkdir -p logs/nginx

        # there has to be a better way to do this with ENV vs sudo
        sudo service nginx start
        sudo rm -f /etc/nginx/sites-enabled/default
        sudo rm -f /etc/nginx/sites-enabled/default
        sudo touch /etc/nginx/sites-available/app
        sudo cp /home/ubuntu/gong/app/nginx/app.conf /etc/nginx/sites-available/app
        sudo rm -f /etc/nginx/sites-enabled/app
        sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
        sudo service nginx restart

        gunicorn app:app -b 127.0.0.1 --threads=2 > logs/app/app.log 2>&1 &
    fi

    if [[ "$1" == "--dev" ]]; then
        export FLASK_APP=app/__init__.py
        export FLASK_DEBUG=1
        flask run &&
        echo "App killed"
    fi
fi


if [[ "$2" == "--kill" ]]; then
    echo "Killing App"

    if [[ "$1" == "--prod" ]]; then
        sudo service nginx stop
        pgrep "gunicorn" | xargs kill
    fi

    if [[ "$1" == "--dev" ]]; then
        pgrep "flask" | xargs kill
    fi

fi
