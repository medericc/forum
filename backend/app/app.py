# backend/app/app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello, World!"
# date_heure = datetime.datetime.now()
# h = date_heure.hour
# m = date_heure.minute
# return render_template(";;;.html", heure=h, minute=m)
# sur template <p>{{heure}}</P>

if __name__ == '__main__':
    app.run(debug=True)
