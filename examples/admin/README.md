## 管理后台模板

## 配置
- 修改 include/web.hrl 文件 web_port 宏定义，比如 1111
- 修改 include/common.hrl 文件 mysql_username、mysql_password、mysql_database 宏定义
- MySQL 导入 admin.sql 文件

## 项目编译及启动
编译(开发版)
```shell
sh dev.sh dev
```

编译(正式版)
```shell
sh dev.sh rel
```

启动
```shell
sh dev.sh start
```

浏览器输入 http://localhost:1111/adm/ 并输入账号 admin，密码 admin 登录管理后台
