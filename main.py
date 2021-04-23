from faker import Faker
from sqlalchemy.orm import sessionmaker

from extents import db, base, JS020, JC020, JSC020, MyFaker
from src.getInfo import courseInfo



def insertFake():
    students_no = []
    counter=0
    # fake student
    for i in range(1000):
        my_fake = MyFaker()
        s_info = my_fake.student()
        students_no.append(s_info["sno"])
        print(s_info)
        student = JS020(**s_info)
        session.add(student)
        session.commit()

        print(counter)
        counter+=1

    # fake course
    courses_info, courses_no = courseInfo()
    for c_info in courses_info:
        # print(c_info)
        course = JC020(**c_info)
        session.add(course)
        session.commit()

        print(counter)
        counter+=1

    # fake grade
    # counter=0
    for sno in students_no:
        tmp = {}
        cnos = fake.random_choices(elements=courses_no, length=fake.random_int(1, 10))
        for cno in cnos:
            tmp["sno"] = sno;
            tmp["cno"] = cno;
            grade = fake.random_int(0, 100)
            if grade != 100 and fake.boolean():
                grade += 0.5
            tmp["grade"] = "{:.1f}".format(grade)

            sc = JSC020(**tmp)
            session.add(sc)
            session.commit()

            print(tmp)
            print(counter)
            counter+=1



Faker(114)
fake = Faker('zh_CN')

Session = sessionmaker(db)
session = Session()



base.metadata.create_all(db)

insertFake()


# # Create
# test={"sno":"1234567","sname":"peter"}
# doctor_strange = Test(**test)
# session.add(doctor_strange)
# session.commit()

# Read
# tests = session.query(JS020)
# for t in tests:
#     print(t.sname)
#
# # Update
# doctor_strange.title = "Some2016Film"
# session.commit()
#
# # Delete
# session.delete(doctor_strange)
# session.commit()





