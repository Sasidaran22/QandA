from flask import Flask, render_template
from flask import Flask, render_template, redirect, url_for, request
import sqlite3

# create the application object
app = Flask(__name__)

# use decorators to link the function to a url
@app.route('/')
def home():
    return render_template('home.html')  # render a template

user_id=dict()
user_id['admin']='admin'
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    error = None
    if request.method == 'POST':
        user=request.form['username']
        pwd=request.form['password']
        cpwd=request.form['confirm_password']
        if pwd!=cpwd:
            error='Passwords do not match'
        else:       
            connection = sqlite3.connect('database.db')
            cur = connection.cursor()
            cur.execute("INSERT INTO credentials (user,pwd) VALUES (?, ?)",(user,pwd))
            connection.commit()
            connection.close()
            return redirect(url_for('login'))
    return render_template('signup.html', error=error)


@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        user=request.form['username']
        pwd=request.form['password']
        if user not in user_id.keys():
            error = 'Invalid Credentials. Please try again.'
        elif user_id[user]!=pwd:
            error = 'Wrong Passwrod or Username'
        else:
            return redirect(url_for('home'))
    return render_template('login.html', error=error)


# start the server with the 'run()' method
if __name__ == '__main__':
    app.run(debug=True)
