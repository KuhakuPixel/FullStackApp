from flask import Flask
from model import Product, db
from db_seeder import get_random_data
from flask import request, jsonify


app = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
# initialize the app with the extension
db.init_app(app)


@app.route("/products", methods=["GET"])
def products():

    if request.args.get("page") == None:
        page = 1
    else:
        page = int(request.args.get("page")) 

    if request.args.get("limit") == None:
        limit = 50
    else:
        limit = int(request.args.get("limit")) 

    products = Product.query.paginate(page=page, per_page=limit, error_out=False).items
    return jsonify(products)


with app.app_context():
    db.create_all()
    items = db.session.query(Product).all()
    if len(items) == 0:
        print("database has no data, seeding database ...")
        # --------- initialize data ----------------
        products = get_random_data(700)
        for p in products:
            db.session.add(p)
        db.session.commit()
        # ------------------------------------------
    else:
        print("database has been initialized, no need to seed it")

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=3000, debug=True)
