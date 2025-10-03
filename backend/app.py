from flask import Flask
from model import Product, db
from db_seeder import get_random_data

app = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
# initialize the app with the extension
db.init_app(app)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


with app.app_context():
    db.create_all()
    items = db.session.query(Product).all()
    if len(items) == 0:
        print("database has no data, seeding database ...")
        # --------- initialize data ----------------
        products = get_random_data(500)
        for p in products:
            db.session.add(p)
        db.session.commit()
        # ------------------------------------------
    else:
        print("database has been initialized, no need to seed it")

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=3000, debug=True)
