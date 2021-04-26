from faker import Faker
from sqlalchemy.orm import sessionmaker

from extents import MyFaker
from models import db, base, JS020, JC020, JSC020


def insertFake(my_fake, json_path):
    students_no = []  # 保存学号，添加选课表时会用
    # fake student 1000 名
    for i in range(1000):
        s_info = my_fake.student()
        students_no.append(s_info["sno"])

        # 插入虚假学生信息
        student = JS020(**s_info)
        session.add(student)
        session.commit()

    # fake course
    courses_info, courses_no = my_fake.course(json_path)
    for c_info in courses_info:
        # 插入虚假课程信息
        course = JC020(**c_info)
        session.add(course)
        session.commit()

    # fake grade
    for sno in students_no:
        fake_sc = {}
        cnos = fake.random_choices(elements=courses_no, length=fake.random_int(1, 10))
        for cno in cnos:
            fake_sc["sno"] = sno
            fake_sc["cno"] = cno
            grade = fake.random_int(0, 100)
            if grade != 100 and fake.boolean():
                grade += 0.5
            fake_sc["grade"] = "{:.1f}".format(grade)

            sc = JSC020(**fake_sc)
            session.add(sc)
            session.commit()

            print(fake_sc)


Faker(114)
fake = Faker('zh_CN')

Session = sessionmaker(db)
session = Session()

base.metadata.create_all(db)

my_fake = MyFaker()
json_path = 'src/course.json'
insertFake(my_fake, json_path)

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
