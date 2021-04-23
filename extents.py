import os
from faker import Faker
from sqlalchemy import create_engine, Column, String, Date, Numeric,ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from dotenv import load_dotenv

load_dotenv(verbose=True)

db_link = os.getenv("DB_LINK")
db = create_engine(db_link)
base = declarative_base()

Faker.seed(114)
fake = Faker('zh_CN')



class JS020(base):
    __tablename__ = 'js020'

    sno = Column(String(10), primary_key=True, nullable=False, index=True)
    sname = Column(String(8), nullable=False)
    sex = Column(String(3), nullable=False, default='男')
    bdate = Column(Date, nullable=False, default='1970-01-01')
    height = Column(Numeric(3, 2), nullable=False, default=0)
    dorm = Column(String(15))


class JC020(base):
    __tablename__ = 'jc020'

    cno = Column(String(12), primary_key=True, nullable=False, index=True)
    cname = Column(String(30), nullable=False)
    period = Column(Numeric(4, 1), nullable=False, default=0)
    credit = Column(Numeric(2, 1), nullable=False, default=0)
    teacher = Column(String(10), nullable=False)


class JSC020(base):
    __tablename__ = 'jsc020'

    sno = Column(String(10), ForeignKey('js020.sno'), primary_key=True, nullable=False)
    cno = Column(String(12), ForeignKey('jc020.cno'), primary_key=True, nullable=False)
    grade = Column(Numeric(4, 1), nullable=False, default=None)


class MyFaker():

    def student(self):
        s = {}
        s["sno"] = fake.unique.bothify(text='0#0#####')
        if fake.boolean():
            s["sex"] = '男'
            s["sname"] = fake.name_male()
        else:
            s["sex"] = '女'
            s["sname"] = fake.name_female()

        s["bdate"] = fake.date_between("-23y", "-19y").strftime("%Y-%m-%d")  # 19-23
        s["height"] = "{:.2f}".format(fake.random_int(min=150, max=210) / 100)
        s["dorm"] = fake.bothify(letters='东西南北', text="?") + "{}舍{}{:0>2d}".format(fake.random_int(min=1, max=20),
                                                                                   fake.random_int(min=1, max=7),
                                                                                   fake.random_int(min=1, max=30))
        return s
