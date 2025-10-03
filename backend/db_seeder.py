from faker import Faker
from model import Product
import random

book_categories = [
    "Literary Fiction",
    "Action/Adventure",
    "Mystery/Thriller/Crime",
    "Science Fiction (Sci-Fi)",
    "Fantasy",
    "Romance",
    "Horror",
    "Historical Fiction",
    "Biography/Memoir",
    "Self-Help/Personal Development",
    "History",
    "Science/Nature",
]

book_desc = """
A generation ship hurtles through the void, carrying the last vestiges of humanity toward a promised new world. But after centuries in transit, the mission is failing. Resources are dwindling, the automated systems are breaking down, and a rigid, caste-based society enforced by the enigmatic 'Engineers' is starting to fracture.

Elara, a brilliant but rebellious 'Fixer' from the lowest deck, discovers a hidden log detailing the ship's true, terrifying history and the original purpose of their voyage, a truth deliberately concealed from the passengers. This knowledge forces her into an uneasy alliance with Kael, a disillusioned 'Guard' from the upper echelons who questions the Engineers' absolute authority.

As the ship nears the end of its journey, they must race against time to repair the failing life support and expose the conspiracy that holds the entire population hostage. They soon realize the threat isn't just the failing technology or the oppressive regime; it’s the unsettling possibility that the 'new world' they are traveling toward might be a destination far more dangerous than the one they left behind.

*The Voyage of the Arbiters* is a thrilling blend of sci-fi mystery and dystopian action, exploring themes of hidden histories, social stratification, and the cost of survival when the truth is the most lethal weapon of all.
"""


def get_random_data(length):
    fake = Faker(["en_US"])
    fake.seed_instance(42)
    random.seed(42)

    products = []
    for i in range(length):
        # TODO: ensure 200-500 words
        products.append(
            Product(
                name=fake.name(),
                description=book_desc,
                price=fake.pyint(),
                category=random.choice(book_categories),
                img_url=fake.image_url(height=400, width=400),
            )
        )
    return products
