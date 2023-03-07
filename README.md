先进行需求分析

再进行需要执行的目标

然后进行任务的划分和规整。

先前端，先确定页面数，再确定每个页面干啥，最后确定分工。



每个人在制作时需要写文档去记录。

​	记录的内容：修改的内容，修改的目的，遇到的bug

使用git进行版本控制，会分为不同的阶段，每人每个阶段会有任务。



# 第一次会议

##  目的

确定需求，也就是我们最终要做的是什么东西

明确前端的页面，每个页面的布局，应当有的功能，具体的分工。

后端可能的实现

## 具体内容

### 需求

```

	首先必须支持文件上传到服务器，由服务器来进行文件的分享。P2P局域网。有用户的注册登录。分享文件。分享文件可以是单个或者文件夹，可以设置标签。有搜索功能，根据名称搜索。分享文件标注文件的查看权限。
	根据标签去推荐


	用户类别：未登录  登录 会员 管理员 1111 0111 0011 0001
	可下载 
	查看 
		消息 
		删除自己发的
							编辑 控制 查看 重置 （增删改查） 
							
	局域网下数据传输 未登录
		TCP,
		C/S B/S  有一台机器作为服务器. 当 服务器退出的时候,直接告诉下载失败. 令牌根据连接到当前推出服务器的时间先后吗,做一个服务器. 新服务器进行广播.其他主机可以选择是否连接.
		共享文件 
		主机的管理 IP端口号 维护一个表 当前网络内 多久更新一下 怎么更新.
		加速传输 (怎么加速 广域网情况下如何加速传播)
		假如需要传输时,可以先查看是否可以直接在局域网下进行传播 如果可以,就直接利用局域网去进行传播,不走广域网.
		
		在线文件分享
			服务器中转
			
		局域网下传输可选 P2P(更加私密) C/S B/S(多主机连接)
		
		广域网(C/S B/S)
		
		
		文件的分类怎么去分
		
		文件的类别
		 程序
		 
		按用途分类(手动添加)
		后缀名分类
		大小分类
		付费与免费
		
		后缀
			.zip .c
		用途
			程序 脚本
		大小
		付费与免费 (预留)
		
		可选的推荐功能
		
		猜你喜欢的推荐(可折叠)
		
		
		右边空白
		
		
		[文件名 分享者 分享时间 文件大小 标签 付费内容(预留) 评价(预留)]
		 
		 文件名 大小 
		 
		 
		 可选多种视图(预留)
		 
		 
		 文件详情
		 
		 简介 作者 评价(预留) 弹窗
		 
		 
		 
		 登录做页面 开一个新页面
		 
		 
		 
		 
		 管理员页面
		 增删改查
		 
```











