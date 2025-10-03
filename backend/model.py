
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import Integer, String
from dataclasses import dataclass
class Base(DeclarativeBase):
    pass

db = SQLAlchemy(model_class=Base)


@dataclass
class Product(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column()
    price: Mapped[int] = mapped_column()
    description: Mapped[str] = mapped_column()
    category: Mapped[str] = mapped_column()
    img_url: Mapped[str] = mapped_column()