# 数据库系统实验

## Install

以下两种方式选择1种

1. With anaconda

```bash
conda env create -f conda.yml
```

2. Without anaconda

```bash
pip install -r reqs.txt
```

## Usage

```bash
python main.py
```

### 配置项

1. .env

```bash
touch .env
vim .env
```

配置远程连接的环境变量，例如填入
`DB_LINK="postgresql://gaussdb:Secret$123@127.0.0.1:15432/dbname"`

2. main.py 修改参数控制脚本运行模式，具体看源码。

```
PASS_MODE = 0
DROP_ALL = 1
STUDENT_NUM = 1000
```

## Credits

实验报告使用的$\LaTeX$模板：[Plain Template](https://github.com/magicwenli/plain_template)

## License

MIT License