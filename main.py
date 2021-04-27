from sqlalchemy.orm import sessionmaker

from extents import MyFaker, logger
from models import db, base, JS020, JC020, JSC020

DEBUG_MODE = 1


def insertFake(my_fake, json_path):
    students_no = []  # 保存学号，添加选课表时会用
    # fake student 1000 名
    for i in range(1000):
        s_info = my_fake.student()
        students_no.append(s_info["sno"])
        if DEBUG_MODE == 1:
            logger.info('student to be inserted: {}'.format(s_info))
        else:
            # 插入虚假学生信息
            student = JS020(**s_info)
            session.add(student)
            session.commit()

    # fake course
    courses_info, courses_no = my_fake.course(json_path)
    # courses_no 保存课程号，添加选课表时会用
    for c_info in courses_info:
        if DEBUG_MODE == 1:
            logger.info('course to be inserted: {}'.format(c_info))
        else:
            # 插入虚假课程信息
            course = JC020(**c_info)
            session.add(course)
            session.commit()

    # fake grade
    for sno in students_no:
        fake_sc = {}
        # 每个学生选1-10门课程
        cnos = my_fake.fake.random_choices(elements=courses_no, length=my_fake.fake.random_int(1, 10))
        for cno in cnos:
            fake_sc["sno"] = sno
            fake_sc["cno"] = cno
            # 成绩在[0,100]之间，step=0.5
            grade = my_fake.fake.random_int(0, 100)
            if grade != 100 and my_fake.fake.boolean():
                grade += 0.5
            fake_sc["grade"] = "{:.1f}".format(grade)

            if DEBUG_MODE == 1:
                logger.info('sc to be inserted: {}'.format(fake_sc))
            else:
                # 插入虚假选课信息
                sc = JSC020(**fake_sc)
                session.add(sc)
                session.commit()


if __name__ == '__main__':
    my_fake = MyFaker()
    Session = sessionmaker(db)
    session = Session()
    base.metadata.create_all(db)

    json_path = 'src/course.json'
    insertFake(my_fake, json_path)
