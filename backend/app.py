from flask import Flask
from model import Product, db
from db_seeder import get_random_data
from flask import request, jsonify
import math
import json
import os
from dotenv import load_dotenv
from http import HTTPStatus

from openai import OpenAI
from google import genai


load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
gemini_client = genai.Client(api_key=GEMINI_API_KEY)


app = Flask(__name__)
# configure the SQLite database, relative to the app instance folder
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
# initialize the app with the extension
db.init_app(app)


def apply_filter_to_products(query_args):
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

    if request.args.get("exclude_ids") == None:
        exclude_ids = []
    else:
        exclude_ids = json.loads(request.args.get("exclude_ids"))

    category = request.args.get("category")

    products = Product.query.with_entities(
        Product.id, Product.name, Product.price, Product.category, Product.img_url
    ).filter(Product.name.icontains(search))

    if category != None and category != "":

        products = products.filter(Product.category == category)

    products_paginated = products.paginate(
        page=page, per_page=limit, error_out=False
    ).items

    # filter by id, p[0] for id
    products_paginated = [p for p in products_paginated if p[0] not in exclude_ids]

    total_products_count = products.count()
    page_count = math.ceil(total_products_count / limit)
    return products, products_paginated, page_count


@app.route("/products/<int:id>", methods=["GET"])
def product(id):
    p = Product.query.get(id)
    if p != None:
        return jsonify(p)
    else:
        return f"{id} doesn't exist", 404

    pass


@app.route("/categories", methods=["GET"])
def categories():
    categories = Product.query.with_entities(Product.category).distinct().all()
    categories = [row[0] for row in categories]

    categories.append("")  # append empty for no select at all

    return jsonify(categories)


@app.route("/ai-summary", methods=["POST"])
def ai_summary():
    text = request.args.get("text")
    if text == None:
        return "no text parameter provided", HTTPStatus.BAD_REQUEST

    try:
        contents = f"Summarize the text below like you would when given a task by a professor, don't say anything else other than the summary even if the input is empty \n {text}"
        response = gemini_client.models.generate_content(
            model="gemini-2.5-flash", contents=contents
        )
        return str(response.text), HTTPStatus.OK
    except Exception as e:
        return (
            f"{e}",
            HTTPStatus.INTERNAL_SERVER_ERROR,
        )


@app.route("/products_length", methods=["GET"])
def products_length():
    """
    get only the length of the products query
    """
    products, products_paginated, page_count = apply_filter_to_products(
        query_args=request.args
    )
    return jsonify({"products_length": len(products_paginated)})


@app.route("/products", methods=["GET"])
def products():

    products, products_paginated, page_count = apply_filter_to_products(
        query_args=request.args
    )
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
            "page_count": page_count,
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
    app.run(host="0.0.0.0", port=3000, debug=True)
