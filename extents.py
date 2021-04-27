import json
import logging.handlers
import re

from faker import Faker


class MyFaker():
    Faker.seed(114)
    fake = Faker('zh_CN')

    def student(self):
        fake_stu = {"sno": self.fake.unique.bothify(text='0#0#####')}
        if self.fake.boolean():
            fake_stu["sex"] = '男'  # sex
            fake_stu["sname"] = self.fake.name_male()  # sname
        else:
            fake_stu["sex"] = '女'  # sex
            fake_stu["sname"] = self.fake.name_female()  # sname
        fake_stu["bdate"] = self.fake.date_between("-23y", "-19y").strftime("%Y-%m-%d")  # bdate 年龄在19-23之间
        fake_stu["height"] = "{:.2f}".format(self.fake.random_int(min=150, max=210) / 100)
        fake_stu["dorm"] = self.fake.bothify(letters='东西南北', text="?") + "{}舍{}{:0>2d}".format(
            self.fake.random_int(min=1, max=20),
            self.fake.random_int(min=1, max=7),
            self.fake.random_int(min=1, max=30))  # dorm
        return fake_stu

    def course(self, filepath):
        with open(filepath, 'r') as f:
            json_text = json.load(f)
            fake_cuss = []
            cus_nos = []
            cus_names = []
            for a in json_text["datas"]["qxfbkccx"]["rows"]:
                fake_cus = {}
                # 部分课程名带有英文后缀，此处将其删去
                cus_name = re.sub("\b?[A-Za-z].*$", "", a['KCM'])
                # 每个课程只取一个，且排除课程名为空的记录
                if a['KCH'] not in cus_nos and cus_name not in cus_names and cus_name != "":
                    fake_cus["cno"] = a['KCH']  # cno
                    fake_cus["cname"] = cus_name  # cname
                    fake_cus["period"] = a['XS']  # period
                    fake_cus["credit"] = a['XF']  # credit
                    fake_cus["teacher"] = re.sub("[, ].*$", "", a['SKJS'])  # 有多个老师的课程，只取第一个老师
                    fake_cuss.append(fake_cus)
                    cus_nos.append(a['KCH'])
                    cus_names.append(cus_name)
        return fake_cuss, cus_nos


# set logger
LOG_FILENAME = 'running.log'
logger = logging.getLogger()

logger.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')
console_handler = logging.StreamHandler()
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)
file_handler = logging.handlers.RotatingFileHandler(
    LOG_FILENAME, maxBytes=10485760, backupCount=5, encoding="utf-8")
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)
