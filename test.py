from sqlalchemy import create_engine, Column, String, Date, Numeric, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

DB_LINK = 'postgresql://gaussdb:Secret$123@1t3.xyz:15432/test'

db_link = DB_LINK
db = create_engine(db_link)
base = declarative_base()


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


Session = sessionmaker(db)
session = Session()

base.metadata.create_all(db)

# Create
# test = {"sno": "1234567", "sname": "peter"}
# stu = JS020(**test)
# session.add(stu)
# session.commit()

# Read
print("Read all students' name from table js020:")
tests = session.query(JS020)
for s in tests:
    print(s.sname)

# Update
# stu.sname = "张三"
# session.commit()

# # Delete
# session.delete(stu)
# session.commit()
