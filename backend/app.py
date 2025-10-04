from flask import Flask
from model import Product, db
from db_seeder import get_random_data
from flask import request, jsonify
import math


app = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
# initialize the app with the extension
db.init_app(app)


@app.route("/products/<int:id>", methods=["GET"])
def product(id):
    p = Product.query.get(id)
    if p != None:
        return jsonify(p)
    else:
        return f"{id} doesn't exist", 404

    pass


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

    if request.args.get("search") == None:
        search = ""
    else:
        search = request.args.get("search")


    products =Product.query.with_entities(
        Product.id, Product.name, Product.price, Product.category, Product.img_url
    ).filter(Product.name.icontains(search))
    
    products_paginated = products.paginate(page=page, per_page=limit, error_out=False).items
    total_products_count = products.count()

    products_paginated = [
        {
            "id": row[0],
            "name": row[1],
            "price": row[2],
            "category": row[3],
            "img_url": row[4],
        }
        for row in products_paginated
    ]

    return jsonify(
        {
            "products": products_paginated,
            "page_count": math.ceil(total_products_count / limit),
        }
    )


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
