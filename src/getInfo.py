import json
import re

def courseInfo():

    with open("src/course.json", 'r') as f:
        text = json.load(f)
        tmp = []
        c_no = []
        c_name = []
        for a in text["datas"]["qxfbkccx"]["rows"]:
            c = {}
            course_name = re.sub("\b?[A-Za-z].*$", "", a['KCM'])
            if a['KCH'] not in c_no and course_name not in c_name and course_name != "":
                c["cno"] = a['KCH']
                c["cname"] = course_name
                c["period"] = a['XS']
                c["credit"] = a['XF']
                c["teacher"] = re.sub("[, ].*$", "", a['SKJS'])
                tmp.append(c)
                c_no.append(a['KCH'])
                c_name.append(course_name)
    return tmp,c_no
