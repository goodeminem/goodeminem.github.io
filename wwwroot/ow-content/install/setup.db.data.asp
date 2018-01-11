<%
'**
'安装OpenWBS
'**
class SetupDBData_Class
	
	public canDoNext,sql,table,tableData,table2,table3,cresult,aresult
	public tplImageFolder
	public siteDomain2,siteDomain3,username,password,email
	private oRs,iI,iNum,sString
	
	private sub class_initialize()
		canDoNext = true
	end sub
	
	private sub class_terminate()
	end sub
	
	public sub init()
		OW.DB.auxSQLValid = false
		if OS.versionType="x" then
			tplImageFolder  = "ow.x4.default"
		else
			tplImageFolder  = "ow.v4.default"
		end if
		'****
		call OW.Cache.clearRamCache("ow.config.1")
		call OW.Cache.clearRamCache("ow.config.2")
		call OW.Cache.clearRamCache("ow.config.3")
		'**
		call sites("正在安装站点数据 ... ")
		call site_config("正在安装配置数据 ... ")
		call site_domains("正在安装站点数据 ... ")
		call member("正在安装用户数据 ... ")
		'**
		call model("正在安装内容模型数据 ... ")
		call model_field("正在安装模型字段数据 ... ")
		'**
		call action("正在安装系统权限信息 ... ")
		call ad("正在安装广告信息 ... ")
		'**
		call category("正在安装栏目数据 ... ")
		call content("正在安装内容体验数据 ... ")
		call type_case("正在安装内容类型数据 ... ")
		call form("正在安装表单数据 ... ")
		call label("正在安装自定义标签数据 ... ")
		call links("正在安装友情链接数据 ... ")
		call keywords("正在安装内链关键词数据 ... ")
		call tags("正在安装tags数据 ... ")
		call mailTpl("正在安装邮件模板数据 ... ")
		'**
		call navigator("正在安装网站导航数据 ... ")
		'**
		call plugins("正在安装应用数据 ... ")
		call position("正在安装推荐位数据 ... ")
		call position_data("正在安装推荐位内容数据 ... ")
		'**
		call admin_action("正在配置管理员权限 ... ")
		'**
		call OW.Cache.clearRamCache("ow.config.1")
		call OW.Cache.clearRamCache("ow.config.2")
		call OW.Cache.clearRamCache("ow.config.3")
	end sub
	
	private function success(byval s)
		echo s &" 安装成功<br>"
	end function
	
	function failed(byval s)
		echo s &" <font style=""color:#f00;"">安装失败</font><br>"
	end function
	
	'**创建表单[在线留言]表，若表存在则会被删除重新创建
	private function createFormFeedbackTable(byval table)
		dim sql,cresult,aresult
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case db_type
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[ip] text (64) NOT NULL,"
			sql = sql & "[post_time] date NOT NULL,"
			sql = sql & "[nickname] text (32) NULL,"
			sql = sql & "[tel] text (30) NULL,"
			sql = sql & "[email] text (64) NULL,"
			sql = sql & "[website] text (255) NULL,"
			sql = sql & "[content] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL,"
			sql = sql & "[post_time] [datetime] NOT NULL,"
			sql = sql & "[nickname] [nvarchar] (32) NULL,"
			sql = sql & "[tel] [nvarchar] (30) NULL,"
			sql = sql & "[email] [nvarchar] (64) NULL,"
			sql = sql & "[website] [nvarchar] (255) NULL,"
			sql = sql & "[content] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then createFormFeedbackTable=true else createFormFeedbackTable=false
	end function
	
	public function insertAction(sys_id,ctl_id,act_id,ctl,act,ctl_name,act_name,site_id)
		call OW.DB.addRecord(DB_PRE &"action",array("sys_id:"& sys_id,"ctl_id:"& ctl_id,"act_id:"& act_id,"ctl:"& ctl,"act:"& act,"ctl_name:"& ctl_name,"act_name:"& act_name,"site_id:"& site_id))
	end function
	
	'写入权限信息
	public function action(byval tip)
		if tip<>"" then print tip
		dim siteId
		siteId = 1
		
		'**系统管理类
		call insertAction(1,1,1,"index","view_all","系统界面","全功能主界面使用",siteId)
		call insertAction(1,1,2,"index","view_simple","系统界面","简洁版界面使用",siteId)
		call insertAction(1,1,3,"index","destop","系统界面","系统桌面",siteId)
		call insertAction(1,1,4,"index","edit_theme","系统界面","换肤",siteId)
		
		call insertAction(1,2,1,"setting","edit","设置","系统设置",siteId)
		call insertAction(1,2,2,"setting","edit_site_info","设置","网站信息设置",siteId)
		call insertAction(1,2,3,"setting","edit_my_info","设置","个人资料设置",siteId)
		call insertAction(1,2,4,"setting","edit_my_password","设置","修改登陆密码",siteId)
		
		if IS_MULTI_SITES then
			call insertAction(1,3,1,"sites","list","站群","站点列表",siteId)
			call insertAction(1,3,2,"sites","add","站群","添加站点",siteId)
			call insertAction(1,3,3,"sites","edit","站群","编辑站点",siteId)
			call insertAction(1,3,4,"sites","delete","站群","删除站点",siteId)
		end if
		
		call insertAction(1,4,1,"system_check","infomation","系统检测","系统信息",siteId)
		call insertAction(1,4,2,"system_check","com_check","系统检测","组件检测",siteId)
		call insertAction(1,4,3,"system_check","writeable_check","系统检测","读写权限检测",siteId)
		
		call insertAction(1,5,1,"backup","list","系统备份","备份列表",siteId)
		call insertAction(1,5,2,"backup","backup","系统备份","备份",siteId)
		call insertAction(1,5,2,"backup","restore","系统备份","还原",siteId)
		call insertAction(1,5,3,"backup","delete","系统备份","删除备份",siteId)
		
		call insertAction(1,6,1,"system_log","list","系统操作日志","日志列表",siteId)
		call insertAction(1,6,2,"system_log","delete","系统操作日志","删除日志",siteId)
		
		call insertAction(1,7,1,"system_error","list","系统错误日志","日志列表",siteId)
		call insertAction(1,7,2,"system_error","detail","系统错误日志","日志详细",siteId)
		call insertAction(1,7,3,"system_error","delete","系统错误日志","删除记录",siteId)
		
		call insertAction(1,8,1,"update","update","系统升级","升级",siteId)
		
		call insertAction(1,9,1,"smslog","list","短信记录","记录列表",siteId)
		call insertAction(1,9,2,"smslog","detail","短信记录","记录详细",siteId)
		call insertAction(1,9,3,"smslog","delete","短信记录","删除记录",siteId)
		
		'**用户管理类
		call insertAction(2,1,1,"admin_group","list","管理员组","管理员组列表",siteId)
		call insertAction(2,1,2,"admin_group","add","管理员组","添加管理员组",siteId)
		call insertAction(2,1,3,"admin_group","edit","管理员组","编辑管理员组",siteId)
		call insertAction(2,1,4,"admin_group","edit_admin_action","管理员组","系统权限设置",siteId)
		call insertAction(2,1,5,"admin_group","edit_category_auth","管理员组","栏目权限设置",siteId)
		call insertAction(2,1,6,"admin_group","edit_plugin_auth","管理员组","应用权限设置",siteId)
		call insertAction(2,1,7,"admin_group","delete","管理员组","删除管理员组",siteId)
		
		call insertAction(2,2,1,"member_group","list","会员组","会员组列表",siteId)
		call insertAction(2,2,2,"member_group","add","会员组","添加会员组",siteId)
		call insertAction(2,2,3,"member_group","edit","会员组","编辑会员组",siteId)
		call insertAction(2,2,4,"member_group","edit_category_auth","会员组","栏目权限设置",siteId)
		call insertAction(2,2,5,"member_group","delete","会员组","删除会员组",siteId)
		
		call insertAction(2,3,1,"member_special_group","list","特殊会员组","会员组列表",siteId)
		call insertAction(2,3,2,"member_special_group","add","特殊会员组","添加会员组",siteId)
		call insertAction(2,3,3,"member_special_group","edit","特殊会员组","编辑会员组",siteId)
		call insertAction(2,3,4,"member_special_group","edit_category_auth","特殊会员组","栏目权限设置",siteId)
		call insertAction(2,3,5,"member_special_group","delete","特殊会员组","删除会员组",siteId)
		
		call insertAction(2,4,1,"admin","list","管理员管理","管理员列表",siteId)
		call insertAction(2,4,2,"admin","add","管理员管理","添加管理员",siteId)
		call insertAction(2,4,3,"admin","edit","管理员管理","编辑管理员",siteId)
		call insertAction(2,4,4,"admin","delete","管理员管理","解除管理员职务",siteId)
		
		call insertAction(2,5,1,"member","list","会员管理","会员列表",siteId)
		call insertAction(2,5,2,"member","detail","会员管理","会员详细",siteId)
		call insertAction(2,5,3,"member","add","会员管理","添加新会员",siteId)
		call insertAction(2,5,4,"member","edit","会员管理","会员编辑",siteId)
		call insertAction(2,5,5,"member","charge","会员管理","预存款/积分充值",siteId)
		call insertAction(2,5,5,"member","deduct","会员管理","预存款/积分扣除",siteId)
		call insertAction(2,5,6,"member","delete","会员管理","删除会员",siteId)
		
		call insertAction(2,6,1,"member_deposit_log","list","会员预存款记录","记录列表",siteId)
		call insertAction(2,6,2,"member_deposit_log","detail","会员预存款记录","记录详细",siteId)
		call insertAction(2,6,3,"member_deposit_log","delete","会员预存款记录","删除记录",siteId)
		
		call insertAction(2,7,1,"member_point_log","list","会员积分记录","记录列表",siteId)
		call insertAction(2,7,2,"member_point_log","detail","会员积分记录","记录详细",siteId)
		call insertAction(2,7,3,"member_point_log","delete","会员积分记录","删除记录",siteId)
		
		if OS.versionType="x" then
			call insertAction(2,8,1,"pay_trade_log","list","支付交易记录","记录列表",siteId)
			call insertAction(2,8,2,"pay_trade_log","detail","支付交易记录","记录详细",siteId)
			call insertAction(2,8,3,"pay_trade_log","delete","支付交易记录","删除记录",siteId)
		end if
		
		call insertAction(2,9,1,"system_msg","list","用户消息","消息列表",siteId)
		call insertAction(2,9,2,"system_msg","add","用户消息","发送消息",siteId)
		call insertAction(2,9,3,"system_msg","detail","用户消息","消息详细",siteId)
		call insertAction(2,9,4,"system_msg","delete","用户消息","删除消息",siteId)		
		
		if OS.versionType="x" then
			call insertAction(2,10,1,"member_commission_log","list","佣金记录","列表",siteId)
			call insertAction(2,10,2,"member_commission_log","edit","佣金记录","编辑审核",siteId)
			call insertAction(2,10,3,"member_commission_log","delete","佣金记录","删除",siteId)
			
			call insertAction(2,11,1,"member_commission_drawcash","list","佣金提现","列表",siteId)
			call insertAction(2,11,2,"member_commission_drawcash","add","佣金提现","添加",siteId)
			call insertAction(2,11,3,"member_commission_drawcash","edit","佣金提现","编辑",siteId)
			call insertAction(2,11,4,"member_commission_drawcash","delete","佣金提现","删除",siteId)
			
			call insertAction(2,12,1,"member_deposit_drawcash","list","余额提现","列表",siteId)
			call insertAction(2,12,2,"member_deposit_drawcash","add","余额提现","添加",siteId)
			call insertAction(2,12,3,"member_deposit_drawcash","edit","余额提现","编辑",siteId)
			call insertAction(2,12,4,"member_deposit_drawcash","delete","余额提现","删除",siteId)
		
		end if
		
		'**网站管理类
		call insertAction(3,1,1,"navigator","list","网站导航","导航列表",siteId)
		call insertAction(3,1,2,"navigator","add","网站导航","添加导航",siteId)
		call insertAction(3,1,3,"navigator","edit","网站导航","编辑导航",siteId)
		call insertAction(3,1,4,"navigator","delete","网站导航","删除导航",siteId)
		
		call insertAction(3,2,1,"mail_tpl","list","邮件模板","列表/详细",siteId)
		call insertAction(3,2,2,"mail_tpl","add","邮件模板","添加",siteId)
		call insertAction(3,2,3,"mail_tpl","edit","邮件模板","编辑",siteId)
		call insertAction(3,2,4,"mail_tpl","delete","邮件模板","删除",siteId)
		
		call insertAction(3,3,1,"region","list","地区管理","查看地区",siteId)
		call insertAction(3,3,2,"region","add","地区管理","添加地区",siteId)
		call insertAction(3,3,3,"region","edit","地区管理","编辑地区",siteId)
		call insertAction(3,3,4,"region","delete","地区管理","删除地区",siteId)
		
		call insertAction(3,5,1,"cache","list","缓存管理","缓存列表",siteId)
		call insertAction(3,5,2,"cache","add","缓存管理","生成缓存",siteId)
		call insertAction(3,5,3,"cache","delete","缓存管理","删除缓存",siteId)
		
		call insertAction(3,6,1,"static","list","静态页面管理","静态页面列表",siteId)
		call insertAction(3,6,2,"static","add","静态页面管理","生成静态页面",siteId)
		call insertAction(3,6,3,"static","delete","静态页面管理","删除静态页面",siteId)
		
		call insertAction(3,10,1,"uploads","list","上传文件管理","查看目录及文件",siteId)
		call insertAction(3,10,2,"uploads","list_redundant_check","上传文件管理","冗余文件检测",siteId)
		call insertAction(3,10,3,"uploads","add_uploadfile","上传文件管理","上传文件",siteId)
		call insertAction(3,10,4,"uploads","add_createfolder","上传文件管理","新建文件夹",siteId)
		call insertAction(3,10,5,"uploads","edit_filerename","上传文件管理","文件重命名",siteId)
		call insertAction(3,10,6,"uploads","delete","上传文件管理","删除文件夹和文件",siteId)
		
		call insertAction(3,12,1,"label","list","自定义标签","标签列表",siteId)
		call insertAction(3,12,2,"label","add","自定义标签","添加标签",siteId)
		call insertAction(3,12,3,"label","edit","自定义标签","编辑标签",siteId)
		call insertAction(3,12,4,"label","delete","自定义标签","删除标签",siteId)
		
		call insertAction(3,13,1,"template","list","模板管理","模板列表",siteId)
		call insertAction(3,13,2,"template","add","模板管理","安装模板",siteId)
		call insertAction(3,13,3,"template","edit","模板管理","编辑模板",siteId)
		call insertAction(3,13,4,"template","delete","模板管理","删除模板",siteId)
		call insertAction(3,13,5,"template","tool","模板管理","模板标签工具使用",siteId)
		
		call insertAction(3,14,1,"sitemap","list","Sitemap管理","sitemap列表",siteId)
		call insertAction(3,14,2,"sitemap","add","Sitemap管理","sitemap生成",siteId)
		call insertAction(3,14,3,"sitemap","delete","Sitemap管理","sitemap删除",siteId)
		
		'**内容管理类
		call insertAction(4,1,1,"model","list","内容模型","内容模型列表",siteId)
		call insertAction(4,1,2,"model","add","内容模型","添加内容模型",siteId)
		call insertAction(4,1,3,"model","edit","内容模型","编辑内容模型",siteId)
		call insertAction(4,1,4,"model","delete","内容模型","删除内容模型",siteId)
		
		call insertAction(4,2,1,"model_field","list","内容模型字段","字段列表",siteId)
		call insertAction(4,2,2,"model_field","add","内容模型字段","添加字段",siteId)
		call insertAction(4,2,3,"model_field","edit","内容模型字段","编辑字段",siteId)
		call insertAction(4,2,4,"model_field","delete","内容模型字段","删除字段",siteId)
		
		call insertAction(4,3,1,"category","list","内容栏目","栏目列表",siteId)
		call insertAction(4,3,2,"category","add","内容栏目","添加栏目",siteId)
		call insertAction(4,3,3,"category","edit","内容栏目","编辑栏目",siteId)
		call insertAction(4,3,4,"category","delete","内容栏目","删除栏目",siteId)
		
		call insertAction(4,4,1,"content","list","内容管理","内容列表",siteId)
		call insertAction(4,4,2,"content","add","内容管理","添加内容",siteId)
		call insertAction(4,4,3,"content","edit","内容管理","内容编辑",siteId)
		call insertAction(4,4,4,"content","delete","内容管理","删除内容",siteId)
		
		call insertAction(4,5,1,"position","list","内容推荐位","推荐位列表",siteId)
		call insertAction(4,5,2,"position","add","内容推荐位","添加推荐位",siteId)
		call insertAction(4,5,3,"position","edit","内容推荐位","推荐位编辑",siteId)
		call insertAction(4,5,4,"position","delete","内容推荐位","删除推荐位",siteId)
		
		call insertAction(4,6,1,"position_data","list","推荐位内容","推荐位内容列表",siteId)
		call insertAction(4,6,2,"position_data","add","推荐位内容","推荐位内容添加",siteId)
		call insertAction(4,6,3,"position_data","edit","推荐位内容","推荐位内容编辑",siteId)
		call insertAction(4,6,4,"position_data","delete","推荐位内容","推荐位内容删除",siteId)
		
		call insertAction(4,7,1,"ad","list","广告位","广告位列表",siteId)
		call insertAction(4,7,2,"ad","add","广告位","添加广告位",siteId)
		call insertAction(4,7,3,"ad","edit","广告位","广告位编辑",siteId)
		call insertAction(4,7,4,"ad","edit_data","广告位","广告内容管理",siteId)
		call insertAction(4,7,5,"ad","delete","广告位","删除广告位",siteId)
		
		call insertAction(4,9,1,"form","list","表单","表单列表",siteId)
		call insertAction(4,9,2,"form","add","表单","添加表单",siteId)
		call insertAction(4,9,3,"form","edit","表单","表单编辑",siteId)
		call insertAction(4,9,4,"form","edit_tpl","表单","模板编辑",siteId)
		call insertAction(4,9,5,"form","delete","表单","表单删除",siteId)
		
		call insertAction(4,10,1,"form_field","list","表单字段","字段列表",siteId)
		call insertAction(4,10,2,"form_field","add","表单字段","添加字段",siteId)
		call insertAction(4,10,3,"form_field","edit","表单字段","字段编辑",siteId)
		call insertAction(4,10,4,"form_field","delete","表单字段","字段删除",siteId)
		
		call insertAction(4,11,1,"form_data","list","表单内容","内容列表",siteId)
		call insertAction(4,11,2,"form_data","detail","表单内容","详细",siteId)
		call insertAction(4,11,3,"form_data","edit","表单内容","编辑(审核)",siteId)
		call insertAction(4,11,4,"form_data","reply","表单内容","回复",siteId)
		call insertAction(4,11,5,"form_data","delete","表单内容","删除",siteId)
		
		
		call insertAction(4,12,1,"feedback","list","在线留言","留言列表",siteId)
		call insertAction(4,12,2,"feedback","add","在线留言","留言回复",siteId)
		call insertAction(4,12,3,"feedback","edit","在线留言","留言审核",siteId)
		call insertAction(4,12,4,"feedback","delete","在线留言","留言删除",siteId)
		
		call insertAction(4,13,1,"service_online","list","在线客服","查看客服设置",siteId)
		call insertAction(4,13,2,"service_online","edit","在线客服","修改客服设置",siteId)
		
		call insertAction(4,14,1,"links","list","友情链接","友情链接列表",siteId)
		call insertAction(4,14,2,"links","add","友情链接","友情链接添加",siteId)
		call insertAction(4,14,3,"links","edit","友情链接","友情链接编辑",siteId)
		call insertAction(4,14,4,"links","delete","友情链接","友情链接删除",siteId)
		
		call insertAction(4,15,1,"tags","list","Tags管理","Tags列表",siteId)
		call insertAction(4,15,2,"tags","add","Tags管理","Tags添加",siteId)
		call insertAction(4,15,3,"tags","edit","Tags管理","Tags编辑",siteId)
		call insertAction(4,15,4,"tags","delete","Tags管理","Tags删除",siteId)
		
		call insertAction(4,16,1,"keywords","list","内链关键词管理","关键词列表",siteId)
		call insertAction(4,16,2,"keywords","add","内链关键词管理","关键词添加",siteId)
		call insertAction(4,16,3,"keywords","edit","内链关键词管理","关键词编辑",siteId)
		call insertAction(4,16,4,"keywords","delete","内链关键词管理","关键词删除",siteId)
		
		call insertAction(4,17,1,"search_keywords","list","内容搜索关键词","关键词列表",siteId)
		call insertAction(4,17,2,"search_keywords","add","内容搜索关键词","关键词添加",siteId)
		call insertAction(4,17,3,"search_keywords","edit","内容搜索关键词","关键词编辑",siteId)
		call insertAction(4,17,4,"search_keywords","delete","内容搜索关键词","关键词删除",siteId)
		
		call insertAction(4,18,1,"content_comment","list","评论管理","列表",siteId)
		call insertAction(4,18,2,"content_comment","detail","评论管理","详细",siteId)
		call insertAction(4,18,3,"content_comment","reply","评论管理","回复",siteId)
		call insertAction(4,18,4,"content_comment","edit","评论管理","编辑/审核",siteId)
		call insertAction(4,18,5,"content_comment","delete","评论管理","删除",siteId)
		
		call insertAction(4,20,1,"content_type_cate","list","内容类型","列表",siteId)
		call insertAction(4,20,2,"content_type_cate","add","内容类型","添加",siteId)
		call insertAction(4,20,3,"content_type_cate","edit","内容类型","编辑",siteId)
		call insertAction(4,20,4,"content_type_cate","delete","内容类型","删除",siteId)
		
		call insertAction(4,21,1,"content_type_attr","list","内容类型属性","列表",siteId)
		call insertAction(4,21,2,"content_type_attr","add","内容类型属性","添加",siteId)
		call insertAction(4,21,3,"content_type_attr","edit","内容类型属性","编辑",siteId)
		call insertAction(4,21,4,"content_type_attr","delete","内容类型属性","删除",siteId)
		
		call insertAction(4,22,1,"content_type","list","内容类型属性值","列表",siteId)
		call insertAction(4,22,2,"content_type","add","内容类型属性值","添加",siteId)
		call insertAction(4,22,3,"content_type","edit","内容类型属性值","编辑",siteId)
		call insertAction(4,22,4,"content_type","delete","内容类型属性值","删除",siteId)
		
		if OS.versionType="x" then
			'**网店管理类
			call insertAction(5,1,1,"shop_config","view","网店系统设置","查看设置",siteId)
			call insertAction(5,1,1,"shop_config","edit","网店系统设置","修改设置",siteId)
			
			call insertAction(5,2,1,"shop_category","list","商品栏目","栏目列表",siteId)
			call insertAction(5,2,2,"shop_category","add","商品栏目","添加栏目",siteId)
			call insertAction(5,2,3,"shop_category","edit","商品栏目","编辑栏目",siteId)
			call insertAction(5,2,4,"shop_category","delete","商品栏目","删除栏目",siteId)
			
			call insertAction(5,3,1,"goods","list","商品管理","商品列表",siteId)
			call insertAction(5,3,2,"goods","add","商品管理","添加商品",siteId)
			call insertAction(5,3,3,"goods","edit","商品管理","商品编辑",siteId)
			call insertAction(5,3,4,"goods","delete","商品管理","删除商品",siteId)
			
			call insertAction(5,4,1,"goods_model","list","商品模型","内容模型列表",siteId)
			call insertAction(5,4,2,"goods_model","add","商品模型","添加内容模型",siteId)
			call insertAction(5,4,3,"goods_model","edit","商品模型","编辑内容模型",siteId)
			call insertAction(5,4,4,"goods_model","delete","商品模型","删除内容模型",siteId)
			
			call insertAction(5,5,1,"goods_model_field","list","商品模型字段","字段列表",siteId)
			call insertAction(5,5,2,"goods_model_field","add","商品模型字段","添加字段",siteId)
			call insertAction(5,5,3,"goods_model_field","edit","商品模型字段","编辑字段",siteId)
			call insertAction(5,5,4,"goods_model_field","delete","商品模型字段","删除字段",siteId)
			
			call insertAction(5,6,1,"goods_type","list","商品参数","列表",siteId)
			call insertAction(5,6,2,"goods_type","add","商品参数","添加",siteId)
			call insertAction(5,6,3,"goods_type","edit","商品参数","编辑",siteId)
			call insertAction(5,6,4,"goods_type","delete","商品参数","删除",siteId)
			
			call insertAction(5,7,1,"goods_type_attr","list","商品参数值","列表",siteId)
			call insertAction(5,7,2,"goods_type_attr","add","商品参数值","添加",siteId)
			call insertAction(5,7,3,"goods_type_attr","edit","商品参数值","编辑",siteId)
			call insertAction(5,7,4,"goods_type_attr","delete","商品参数值","删除",siteId)
			
			call insertAction(5,8,1,"goods_spec","list","商品规格","规格列表",siteId)
			call insertAction(5,8,2,"goods_spec","add","商品规格","添加规格",siteId)
			call insertAction(5,8,3,"goods_spec","edit","商品规格","编辑规格",siteId)
			call insertAction(5,8,4,"goods_spec","delete","商品规格","删除规格",siteId)
			
			call insertAction(5,9,1,"goods_spec_value","list","商品规格值","规格值列表",siteId)
			call insertAction(5,9,2,"goods_spec_value","add","商品规格值","添加规格值",siteId)
			call insertAction(5,9,3,"goods_spec_value","edit","商品规格值","编辑规格值",siteId)
			call insertAction(5,9,4,"goods_spec_value","delete","商品规格值","删除规格值",siteId)
			
			call insertAction(5,10,1,"order_form","list","商品订单表单","表单列表",siteId)
			call insertAction(5,10,2,"order_form","add","商品订单表单","添加表单",siteId)
			call insertAction(5,10,3,"order_form","edit","商品订单表单","表单编辑",siteId)
			call insertAction(5,10,4,"order_form","edit_tpl","商品订单表单","模板编辑",siteId)
			call insertAction(5,10,5,"order_form","delete","商品订单表单","表单删除",siteId)
			
			call insertAction(5,11,1,"order_form_field","list","表单字段","字段列表",siteId)
			call insertAction(5,11,2,"order_form_field","add","表单字段","添加字段",siteId)
			call insertAction(5,11,3,"order_form_field","edit","表单字段","字段编辑",siteId)
			call insertAction(5,11,4,"order_form_field","delete","表单字段","字段删除",siteId)
			
			call insertAction(5,12,1,"payment","list","支付方式","支付方式列表",siteId)
			call insertAction(5,12,2,"payment","add","支付方式","添加支付方式",siteId)
			call insertAction(5,12,3,"payment","edit","支付方式","支付方式编辑",siteId)
			call insertAction(5,12,4,"payment","delete","支付方式","删除支付方式",siteId)
			
			call insertAction(5,13,1,"delivery","list","配送方式","配送方式列表",siteId)
			call insertAction(5,13,2,"delivery","add","配送方式","添加配送方式",siteId)
			call insertAction(5,13,3,"delivery","edit","配送方式","配送方式编辑",siteId)
			call insertAction(5,13,4,"delivery","delete","配送方式","删除配送方式",siteId)
			
			call insertAction(5,14,1,"delivery_corp","list","物流公司","物流列表",siteId)
			call insertAction(5,14,2,"delivery_corp","add","物流公司","添加物流",siteId)
			call insertAction(5,14,3,"delivery_corp","edit","物流公司","物流编辑",siteId)
			call insertAction(5,14,4,"delivery_corp","delete","物流公司","删除物流",siteId)
			
			call insertAction(5,15,1,"brand","list","品牌管理","品牌列表",siteId)
			call insertAction(5,15,2,"brand","add","品牌管理","添加品牌",siteId)
			call insertAction(5,15,3,"brand","edit","品牌管理","品牌编辑",siteId)
			call insertAction(5,15,4,"brand","delete","品牌管理","删除品牌",siteId)
			
			call insertAction(5,16,1,"shop_position","list","商品推荐位","推荐位列表",siteId)
			call insertAction(5,16,2,"shop_position","add","商品推荐位","添加推荐位",siteId)
			call insertAction(5,16,3,"shop_position","edit","商品推荐位","推荐位编辑",siteId)
			call insertAction(5,16,4,"shop_position","delete","商品推荐位","删除推荐位",siteId)
			
			call insertAction(5,17,1,"shop_position_data","list","推荐位商品","推荐位商品列表",siteId)
			call insertAction(5,17,2,"shop_position_data","add","推荐位商品","推荐位商品添加",siteId)
			call insertAction(5,17,3,"shop_position_data","edit","推荐位商品","推荐位商品编辑",siteId)
			call insertAction(5,17,4,"shop_position_data","delete","推荐位商品","推荐位商品删除",siteId)
			
			call insertAction(5,18,1,"brand_category","list","品牌分类","分类列表",siteId)
			call insertAction(5,18,2,"brand_category","add","品牌分类","添加分类",siteId)
			call insertAction(5,18,3,"brand_category","edit","品牌分类","编辑分类",siteId)
			call insertAction(5,18,4,"brand_category","delete","品牌分类","删除分类",siteId)
			
			call insertAction(5,19,1,"goods_tags","list","商品Tags管理","Tags列表",siteId)
			call insertAction(5,19,2,"goods_tags","add","商品Tags管理","Tags添加",siteId)
			call insertAction(5,19,3,"goods_tags","edit","商品Tags管理","Tags编辑",siteId)
			call insertAction(5,19,4,"goods_tags","delete","商品Tags管理","Tags删除",siteId)
			
			call insertAction(5,20,1,"shop_search_keywords","list","商品搜索关键词","关键词列表",siteId)
			call insertAction(5,20,2,"shop_search_keywords","add","商品搜索关键词","关键词添加",siteId)
			call insertAction(5,20,3,"shop_search_keywords","edit","商品搜索关键词","关键词编辑",siteId)
			call insertAction(5,20,4,"shop_search_keywords","delete","商品搜索关键词","关键词删除",siteId)
			
			call insertAction(5,21,1,"goods_consultation","list","商品咨询","列表",siteId)
			call insertAction(5,21,2,"goods_consultation","detail","商品咨询","详细",siteId)
			call insertAction(5,21,3,"goods_consultation","reply","商品咨询","回复",siteId)
			call insertAction(5,21,4,"goods_consultation","edit","商品咨询","编辑/审核",siteId)
			call insertAction(5,21,5,"goods_consultation","delete","商品咨询","删除",siteId)
			
			call insertAction(5,22,1,"goods_comment","list","商品评价","列表",siteId)
			call insertAction(5,22,2,"goods_comment","detail","商品评价","详细",siteId)
			call insertAction(5,22,2,"goods_comment","reply","商品评价","回复",siteId)
			call insertAction(5,22,3,"goods_comment","edit","商品评价","编辑/审核",siteId)
			call insertAction(5,22,4,"goods_comment","delete","商品评价","删除",siteId)
			
			call insertAction(5,23,1,"shop_type_cate","list","商品类型","列表",siteId)
			call insertAction(5,23,2,"shop_type_cate","add","商品类型","添加",siteId)
			call insertAction(5,23,3,"shop_type_cate","edit","商品类型","编辑",siteId)
			call insertAction(5,23,4,"shop_type_cate","delete","商品类型","删除",siteId)
			
			call insertAction(5,24,1,"shop_type_attr","list","商品类型属性","列表",siteId)
			call insertAction(5,24,2,"shop_type_attr","add","商品类型属性","添加",siteId)
			call insertAction(5,24,3,"shop_type_attr","edit","商品类型属性","编辑",siteId)
			call insertAction(5,24,4,"shop_type_attr","delete","商品类型属性","删除",siteId)
			
			call insertAction(5,24,1,"shop_type","list","商品类型属性值","列表",siteId)
			call insertAction(5,24,2,"shop_type","add","商品类型属性值","添加",siteId)
			call insertAction(5,24,3,"shop_type","edit","商品类型属性值","编辑",siteId)
			call insertAction(5,24,4,"shop_type","delete","商品类型属性值","删除",siteId)
			
			call insertAction(5,25,1,"coupon","list","优惠券设置","列表",siteId)
			call insertAction(5,25,2,"coupon","add","优惠券设置","添加",siteId)
			call insertAction(5,25,3,"coupon","edit","优惠券设置","编辑",siteId)
			call insertAction(5,25,4,"coupon","delete","优惠券设置","删除",siteId)
			
			call insertAction(5,26,1,"coupon_manage","list","优惠券管理","列表",siteId)
			call insertAction(5,26,2,"coupon_manage","add","优惠券管理","添加",siteId)
			call insertAction(5,26,3,"coupon_manage","edit","优惠券管理","编辑",siteId)
			call insertAction(5,26,4,"coupon_manage","delete","优惠券管理","删除",siteId)
			
			call insertAction(5,27,1,"charge_config","view","充值营销","查看设置",siteId)
			call insertAction(5,27,2,"charge_config","edit","充值营销","修改设置",siteId)
			
			call insertAction(5,29,1,"category_goods","list","栏目推荐商品","列表",siteId)
			call insertAction(5,29,2,"category_goods","add","栏目推荐商品","添加",siteId)
			call insertAction(5,29,3,"category_goods","edit","栏目推荐商品","编辑",siteId)
			call insertAction(5,29,4,"category_goods","delete","栏目推荐商品","删除",siteId)
			
			call insertAction(5,30,1,"orders","list","订单管理","订单列表",siteId)
			call insertAction(5,30,2,"orders","detail","订单管理","订单详细",siteId)
			call insertAction(5,30,3,"orders","add","订单管理","订单添加",siteId)
			call insertAction(5,30,4,"orders","edit","订单管理","订单编辑",siteId)
			call insertAction(5,30,4,"orders","order_pay","订单管理","订单支付",siteId)
			call insertAction(5,30,4,"orders","order_pay_refund","订单管理","订单退款",siteId)
			call insertAction(5,30,4,"orders","order_ship","订单管理","订单配货/发货",siteId)
			call insertAction(5,30,4,"orders","order_ship_refund","订单管理","订单退货",siteId)
			call insertAction(5,30,5,"orders","delete","订单管理","订单删除",siteId)
			
			call insertAction(5,31,1,"order_pay_bill","list","收款单","收款单列表",siteId)
			call insertAction(5,31,2,"order_pay_bill","detail","收款单","收款单详细",siteId)
			
			call insertAction(5,32,1,"order_pay_refund_bill","list","退款单","退款单列表",siteId)
			call insertAction(5,32,2,"order_pay_refund_bill","detail","退款单","退款单详细",siteId)
			
			call insertAction(5,33,1,"order_ship_bill","list","发货单","发货单列表",siteId)
			call insertAction(5,33,2,"order_ship_bill","detail","发货单","发货单详细",siteId)
			
			call insertAction(5,34,1,"order_ship_refund_bill","list","退货单","退货单列表",siteId)
			call insertAction(5,34,2,"order_ship_refund_bill","detail","退货单","退货单详细",siteId)
			
			call insertAction(5,35,1,"order_refund_apply","list","退款申请","列表",siteId)
			call insertAction(5,35,2,"order_refund_apply","edit","退款申请","审核及回复",siteId)
			call insertAction(5,35,3,"order_refund_apply","delete","退款申请","删除",siteId)
			
			call insertAction(5,36,1,"offline_store","list","线下实体店","列表",siteId)
			call insertAction(5,36,2,"offline_store","add","线下实体店","添加",siteId)
			call insertAction(5,36,3,"offline_store","edit","线下实体店","编辑",siteId)
			call insertAction(5,36,4,"offline_store","delete","线下实体店","删除",siteId)
			
			call insertAction(5,50,1,"report","list","报表统计","报表总览",siteId)
			
			
			
			
			
		end if
		
		'**应用管理类
		call insertAction(6,1,1,"plugins","list","应用管理","应用列表",siteId)
		call insertAction(6,1,2,"plugins","add","应用管理","应用安装",siteId)
		call insertAction(6,1,3,"plugins","edit","应用管理","应用编辑",siteId)
		call insertAction(6,1,4,"plugins","delete","应用管理","应用卸载",siteId)
		
		'**微信
		call insertAction(10,1,1,"weixin_config","view","微信系统设置","查看设置",siteId)
		call insertAction(10,1,1,"weixin_config","edit","微信系统设置","修改设置",siteId)
		
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function ad(byval tip)
		if tip<>"" then print tip
		dim adTable,adDataTable
		adTable     = DB_PRE &"ad"
		adDataTable = DB_PRE &"ad_data"
		'**pc
		call OW.DB.addRecord(adTable,array("site_id:1","ad_id:1","sequence:1","status:0","name:【PC端】首页banner","start_time:2016-09-20 00:00:01","end_time:2020-09-20 00:00:01","height:600px","width:1920px","full_screen:1","switch_time:6","type:image","view:0","hits:0"))
		call OW.DB.addRecord(adDataTable,array("site_id:1","ad_id:1","sequence:0","status:0","config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/index1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/index2.jpg&quot;,&quot;name&quot;:&quot;2&quot;,&quot;link&quot;:&quot;#&quot;}]","config_flash:","config_code:","config_text:"))
		'**pc
		call OW.DB.addRecord(adTable,array("site_id:1","ad_id:2","sequence:2","status:0","name:【PC端】栏目页banner","start_time:2016-09-20 00:00:01","end_time:2020-09-20 00:00:01","height:280px","width:1680px","full_screen:1","switch_time:6","type:image","view:0","hits:0"))
		call OW.DB.addRecord(adDataTable,array("site_id:1","ad_id:2","sequence:0","status:0","config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/cate_banner1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]","config_flash:","config_code:","config_text:"))
		'**mob
		call OW.DB.addRecord(adTable,array("site_id:1","ad_id:1001","sequence:1001","status:0","name:【手机端】首页banner","start_time:2016-09-20 00:00:01","end_time:2020-09-20 00:00:01","height:280px","width:640px","full_screen:1","switch_time:6","type:image","view:0","hits:0"))
		call OW.DB.addRecord(adDataTable,array("site_id:1","ad_id:1001","sequence:0","status:0","config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/mob_index1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/mob_index2.jpg&quot;,&quot;name&quot;:&quot;2&quot;,&quot;link&quot;:&quot;#&quot;}]","config_flash:","config_code:","config_text:"))
		
		if tip<>"" then print "完成<br>"
	end function
	
	'写入管理员权限
	public function admin_action(byval tip)
		if tip<>"" then print tip &"<br>"
		'**创始人
		dim rs1,rs2,siteId,ctl,act
		set rs1 = OW.DB.getRecordBySQL("SELECT site_id FROM ["& DB_PRE &"sites] ORDER BY site_id ASC")
		do while not(rs1.eof)
			siteId  = OW.int(rs1("site_id"))
			set rs2 = OW.DB.getRecordBySQL("SELECT ctl,act FROM ["& DB_PRE &"action]")
			do while not(rs2.eof)
				ctl = rs2("ctl")
				act = rs2("act")
				call OW.DB.execute("INSERT INTO ["& DB_PRE &"admin_action] ([site_id],[group_id],[ctl],[act],[is_plugin],[allow]) VALUES ("& siteId &",1,'"& ctl &"','"& act &"',0,1)")
				call OW.DB.execute("INSERT INTO ["& DB_PRE &"admin_action] ([site_id],[group_id],[ctl],[act],[is_plugin],[allow]) VALUES ("& siteId &",2,'"& ctl &"','"& act &"',0,1)")
				print siteId &":"& ctl &":"& act &"<br>"
			    rs2.movenext()
			loop
			OW.DB.closeRs rs2
		rs1.movenext()
		loop
		OW.DB.closeRs rs1
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function category(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"category"
		call OW.DB.addRecord(table,array("site_id:1","cate_id:1","model_id:1","model_type:1","is_shop:0","sequence:1","status:0","cate_type:1","name:公司简介","root_id:0","rootpath:","urlpath:","parent_id:0","path:,1,","depth:1","children:6","tpl_inherit:0","tpl_page:spage.html","tpl_index:","tpl_category:","tpl_content:"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:2","model_id:2","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:新闻资讯","root_id:0","rootpath:","urlpath:news","parent_id:0","path:,2,","depth:1","children:2","tpl_inherit:0","tpl_page:","tpl_index:news.html","tpl_category:news.category.html","tpl_content:news.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:3","model_id:3","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:产品与服务","root_id:0","rootpath:","urlpath:product","parent_id:0","path:,3,","depth:1","children:4","type_cate_id:1","tpl_inherit:0","tpl_page:","tpl_index:product.html","tpl_category:product.category.html","tpl_content:product.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:4","model_id:4","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:案例展示","root_id:0","rootpath:","urlpath:case","parent_id:0","path:,4,","depth:1","children:4","tpl_inherit:0","tpl_page:","tpl_index:case.html","tpl_category:case.category.html","tpl_content:case.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:5","model_id:5","model_type:0","is_shop:0","sequence:5","status:0","cate_type:0","name:下载中心","root_id:0","rootpath:","urlpath:download","parent_id:0","path:,5,","depth:1","children:4","tpl_inherit:0","tpl_page:","tpl_index:download.html","tpl_category:download.category.html","tpl_content:download.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:6","model_id:6","model_type:0","is_shop:0","sequence:6","status:0","cate_type:0","name:视频中心","root_id:0","rootpath:","urlpath:video","parent_id:0","path:,6,","depth:1","children:4","tpl_inherit:0","tpl_page:","tpl_index:video.html","tpl_category:video.category.html","tpl_content:video.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:7","model_id:7","model_type:0","is_shop:0","sequence:7","status:0","cate_type:0","name:人才招聘","subname:join us","root_id:0","rootpath:","urlpath:join","parent_id:0","path:,7,","depth:1","children:4","tpl_inherit:0","tpl_page:","tpl_index:join.html","tpl_category:join.category.html","tpl_content:join.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:8","model_id:8","model_type:0","is_shop:0","sequence:8","status:0","cate_type:0","name:常见问题","subname:我们提供全方位的技术支持和售后服务，如有疑问请联系客服咨询。","root_id:0","rootpath:","urlpath:faq","parent_id:0","path:,8,","depth:1","children:3","tpl_inherit:0","tpl_page:","tpl_index:faq.html","tpl_category:faq.category.html","tpl_content:faq.content.html"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:9","model_id:1","model_type:0","is_shop:0","sequence:9","status:0","cate_type:1","name:其他单页","root_id:0","rootpath:","urlpath:","parent_id:0","path:,9,","depth:1","children:6","tpl_inherit:0","tpl_page:spage.html","tpl_index:","tpl_category:","tpl_content:"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:10","model_id:1","model_type:1","is_shop:0","sequence:1","status:0","cate_type:0","name:公司介绍","root_id:0","rootpath:","urlpath:about","parent_id:1","path:,1,10,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:11","model_id:1","model_type:1","is_shop:0","sequence:2","status:0","cate_type:0","name:发展历程","root_id:0","rootpath:","urlpath:development","parent_id:1","path:,1,11,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:12","model_id:1","model_type:1","is_shop:0","sequence:3","status:0","cate_type:0","name:管理团队","root_id:0","rootpath:","urlpath:team","parent_id:1","path:,1,12,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:13","model_id:1","model_type:1","is_shop:0","sequence:4","status:0","cate_type:0","name:合作伙伴","root_id:0","rootpath:","urlpath:partners","parent_id:1","path:,1,13,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:14","model_id:1","model_type:1","is_shop:0","sequence:5","status:0","cate_type:0","name:公司环境","root_id:0","rootpath:","urlpath:environment","parent_id:1","path:,1,14,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:15","model_id:1","model_type:1","is_shop:0","sequence:6","status:0","cate_type:0","name:联系我们","root_id:0","rootpath:","urlpath:contact","parent_id:1","path:,1,15,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:16","model_id:2","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:公司动态","root_id:2","rootpath:news","urlpath:company","parent_id:2","path:,2,16,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:17","model_id:2","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:行业资讯","root_id:2","rootpath:news","urlpath:industry","parent_id:2","path:,2,17,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:18","model_id:3","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:家居建材","root_id:3","rootpath:product","urlpath:cate1","parent_id:3","path:,3,18,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:19","model_id:3","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:按摩器材","root_id:3","rootpath:product","urlpath:cate2","parent_id:3","path:,3,19,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:20","model_id:3","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:汽车配件","root_id:3","rootpath:product","urlpath:cate3","parent_id:3","path:,3,20,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:21","model_id:3","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:电子产品","root_id:3","rootpath:product","urlpath:cate4","parent_id:3","path:,3,21,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:22","model_id:4","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:建材合作案例","root_id:4","rootpath:case","urlpath:cate1","parent_id:4","path:,4,22,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:23","model_id:4","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:保健产品案例","root_id:4","rootpath:case","urlpath:cate2","parent_id:4","path:,4,23,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:24","model_id:4","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:汽车配件案例","root_id:4","rootpath:case","urlpath:cate3","parent_id:4","path:,4,24,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:25","model_id:4","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:电子产品案例","root_id:4","rootpath:case","urlpath:cate4","parent_id:4","path:,4,25,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:26","model_id:5","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:常见文档","root_id:5","rootpath:download","urlpath:cate1","parent_id:5","path:,5,26,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:27","model_id:5","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:技术文档","root_id:5","rootpath:download","urlpath:cate2","parent_id:5","path:,5,27,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:28","model_id:5","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:招商文档","root_id:5","rootpath:download","urlpath:cate3","parent_id:5","path:,5,28,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:29","model_id:5","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:软件下载","root_id:5","rootpath:download","urlpath:cate4","parent_id:5","path:,5,29,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:30","model_id:6","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:媒体宣传","root_id:6","rootpath:video","urlpath:cate1","parent_id:6","path:,6,30,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:31","model_id:6","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:公司视频","root_id:6","rootpath:video","urlpath:cate2","parent_id:6","path:,6,31,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:32","model_id:6","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:产品视频","root_id:6","rootpath:video","urlpath:cate3","parent_id:6","path:,6,32,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:33","model_id:6","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:使用视频","root_id:6","rootpath:video","urlpath:cate4","parent_id:6","path:,6,33,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:34","model_id:7","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:行政部","root_id:7","rootpath:join","urlpath:am","parent_id:7","path:,7,34,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:35","model_id:7","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:市场部","root_id:7","rootpath:join","urlpath:mk","parent_id:7","path:,7,35,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:36","model_id:7","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:产品部","root_id:7","rootpath:join","urlpath:pd","parent_id:7","path:,7,36,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:37","model_id:7","model_type:0","is_shop:0","sequence:4","status:0","cate_type:0","name:销售部","root_id:7","rootpath:join","urlpath:se","parent_id:7","path:,7,37,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:38","model_id:8","model_type:0","is_shop:0","sequence:1","status:0","cate_type:0","name:售前问题","root_id:8","rootpath:faq","urlpath:cate1","parent_id:8","path:,8,38,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:39","model_id:8","model_type:0","is_shop:0","sequence:2","status:0","cate_type:0","name:售后问题","root_id:8","rootpath:faq","urlpath:cate2","parent_id:8","path:,8,39,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:40","model_id:8","model_type:0","is_shop:0","sequence:3","status:0","cate_type:0","name:技术问题","root_id:8","rootpath:faq","urlpath:cate3","parent_id:8","path:,8,40,","depth:2","children:0","tpl_inherit:1"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","cate_id:41","model_id:1","model_type:1","is_shop:0","sequence:1","status:0","cate_type:0","name:用户协议","root_id:0","rootpath:","urlpath:agreement","parent_id:9","path:,9,41,","depth:2","children:0","tpl_inherit:1"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:42","model_id:1","model_type:1","is_shop:0","sequence:2","status:0","cate_type:0","name:隐私政策","root_id:0","rootpath:","urlpath:privacy","parent_id:9","path:,9,42,","depth:2","children:0","tpl_inherit:1"))
		
		if tip<>"" then print "完成<br>"
	end function
	
	public function content(byval tip)
		if tip<>"" then print tip
		'****
		dim data
		table     = DB_PRE &"content1"
		tableData = DB_PRE &"content1_data"
		'**单页
		call OW.DB.addRecord(table,array("cate_id:10","sequence:1","status:0","title:公司简介","root_id:0","rootpath:","urlpath:about","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:1","seo_title:公司介绍","keywords:公司介绍,公司简介","description:公司详细介绍","content:公司介绍详细内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:1"))
		
		call OW.DB.addRecord(table,array("cate_id:11","sequence:1","status:0","title:发展历程","root_id:0","rootpath:","urlpath:development","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:2","seo_title:发展历程","keywords:发展历程","description:公司发展历程","content:发展历程内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:2"))
		
		call OW.DB.addRecord(table,array("cate_id:12","sequence:1","status:0","title:管理团队","root_id:0","rootpath:","urlpath:team","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:3","seo_title:管理团队","keywords:管理团队","description:公司管理团队介绍","content:管理团队内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:3"))
		
		call OW.DB.addRecord(table,array("cate_id:13","sequence:1","status:0","title:合作伙伴","root_id:0","rootpath:","urlpath:partners","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:4","seo_title:合作伙伴","keywords:合作伙伴","description:合作伙伴介绍","content:合作伙伴内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:4"))
		
		call OW.DB.addRecord(table,array("cate_id:14","sequence:1","status:0","title:办公环境","root_id:0","rootpath:","urlpath:environment","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:5","seo_title:办公环境","keywords:办公环境","description:办公环境","content:办公环境内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:5"))
		
		call OW.DB.addRecord(table,array("cate_id:15","sequence:1","status:0","title:联系我们","root_id:0","rootpath:","urlpath:contact","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:6","seo_title:联系我们","keywords:联系我们","description:公司联系方式","content:联系方式内容..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:6"))
		
		call OW.DB.addRecord(table,array("cate_id:41","sequence:1","status:0","title:用户协议","root_id:0","rootpath:","urlpath:agreement","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:7","seo_title:","keywords:","description:","content:用户协议..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:7"))
		
		call OW.DB.addRecord(table,array("cate_id:42","sequence:1","status:0","title:隐私政策","root_id:0","rootpath:","urlpath:privacy","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:8","seo_title:","keywords:","description:","content:隐私政策..."))
		call OW.DB.addRecord(DB_PRE &"content1_page",array("cid:8"))
		
		'******新闻******
		call OW.DB.addRecord(table,array("cate_id:16","sequence:1","status:0","title:世界，你好！","root_id:2","rootpath:news","urlpath:hello_world","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:9","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:9","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/1.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:16","sequence:2","status:0","title:这是一篇测试新闻","root_id:2","rootpath:news","urlpath:10","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:10","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:10","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/2.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:16","sequence:3","status:0","title:这是第2篇测试新闻","root_id:2","rootpath:news","urlpath:11","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:11","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:11","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/3.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:16","sequence:4","status:0","title:这是第3篇测试新闻","root_id:2","rootpath:news","urlpath:12","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:12","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:12","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/4.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:17","sequence:5","status:0","title:这是第4篇测试新闻","root_id:2","rootpath:news","urlpath:13","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:13","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:13","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/5.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:17","sequence:6","status:0","title:这是第5篇测试新闻","root_id:2","rootpath:news","urlpath:14","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:14","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:14","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/6.jpg","author:"))
		'**
		call OW.DB.addRecord(table,array("cate_id:17","sequence:7","status:0","title:这是第6篇测试新闻","root_id:2","rootpath:news","urlpath:15","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"summary:这里是新闻内容摘要简介","recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:15","seo_title:","keywords:","description:","content:欢迎使用 OpenWBS。这是系统自动生成的演示文章。编辑或者删除它，然后开始您的建站之旅！"))
		call OW.DB.addRecord(DB_PRE &"content1_news",array("cid:15","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/news/thumb/7.jpg","author:"))
		
		
		'******产品******
		call OW.DB.addRecord(table,array("cate_id:18","type_id1:1","type_id2:8","sequence:1","status:0","title:家用办公时尚转椅","root_id:3","rootpath:product","urlpath:guyongbangongshishangzhuaiyi","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:16","seo_title:家用办公时尚转椅","keywords:家用转椅,办公转椅,时尚转椅","description:家用办公时尚转椅","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:16","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/1/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/1/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/1/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/1/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:1","type_id2:7","sequence:2","status:0","title:比拉尚都韩版修身新款女装冬装","root_id:3","rootpath:product","urlpath:hanban-dongzhuang","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:17","seo_title:比拉尚都韩版修身新款女装冬装","keywords:韩版修身,女装,冬装","description:比拉尚都韩版修身新款女装冬装","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:17","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/2/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/2/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/2/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/2/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:1","type_id2:9","sequence:3","status:0","title:联想笔记本","subtitle:14.8mm+1.29kg超轻薄！配940MX 2G独显！预装终身正版office！指纹识别 超窄边框！","root_id:3","rootpath:product","urlpath:18","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:18","seo_title:联想笔记本","keywords:联想笔记本","description:联想笔记本","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:18","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/3/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/3/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/3/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/3/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:2","type_id2:9","sequence:4","status:0","title:三星显示器","root_id:3","rootpath:product","urlpath:19","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:19","seo_title:三星显示器","keywords:三星显示器","description:三星显示器","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:19","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/4/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/4/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/4/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/4/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:2","type_id2:8","sequence:5","status:0","title:星梦席梦诗床","root_id:3","rootpath:product","urlpath:20","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:20","seo_title:星梦席梦诗床","keywords:星梦席梦诗床","description:星梦席梦诗床","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:20","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/5/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/5/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/5/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/5/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:3","type_id2:9","sequence:6","status:0","title:索尼按摩椅6系","root_id:3","rootpath:product","urlpath:21","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:21","seo_title:索尼按摩椅6系","keywords:索尼按摩椅6系","description:索尼按摩椅6系","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:21","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/6/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/6/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/6/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/6/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:3","type_id2:9","sequence:7","status:0","title:索尼按摩椅7系","root_id:3","rootpath:product","urlpath:22","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:22","seo_title:索尼按摩椅7系","keywords:索尼按摩椅7系","description:索尼按摩椅7系","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:22","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/7/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/7/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/7/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/7/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:1","type_id2:8","sequence:8","status:0","title:企业网站模板","root_id:3","rootpath:product","urlpath:23","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:23","seo_title:企业网站模板","keywords:企业网站模板","description:企业网站模板","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:23","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/8/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/8/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/8/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/8/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:4","type_id2:9","sequence:9","status:0","title:苹果Iphone5手机","root_id:3","rootpath:product","urlpath:24","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:24","seo_title:苹果Iphone5手机","keywords:苹果Iphone5手机","description:苹果Iphone5手机","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:24","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/9/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/9/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/9/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/9/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		'**
		call OW.DB.addRecord(table,array("cate_id:19","type_id1:1","type_id2:6","sequence:10","status:0","title:孕妇隔离防护套装","root_id:3","rootpath:product","urlpath:25","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:25","seo_title:孕妇隔离防护套装","keywords:孕妇隔离防护套装","description:孕妇隔离防护套装","content:产品详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_product",array("cid:25","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/10/thumbnail.jpg","images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/10/1.jpg&quot;,&quot;name&quot;:&quot;1&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/10/2.jpg&quot;,&quot;name&quot;:&quot;2&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/product/10/3.jpg&quot;,&quot;name&quot;:&quot;3&quot;}]"))
		
		'******案例******
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:1","status:0","title:案例示例1","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli1","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:26","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:26","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/1.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:2","status:0","title:案例示例2","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli2","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:27","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:27","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/2.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:3","status:0","title:案例示例3","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli3","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:28","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:28","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/3.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:4","status:0","title:案例示例4","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli4","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:29","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:29","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/4.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:5","status:0","title:案例示例5","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli5","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:30","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:30","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/5.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:6","status:0","title:案例示例6","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli6","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:31","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:31","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/6.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:7","status:0","title:案例示例7","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli7","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:32","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:32","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/7.jpg"))
		'**
		call OW.DB.addRecord(table,array("cate_id:22","type_id1:0","type_id2:0","sequence:8","status:0","title:案例示例8","subtitle:案例示例简单介绍文字","root_id:4","rootpath:case","urlpath:anli8","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:33","seo_title:","keywords:","description:","content:案例示例详细介绍"))
		call OW.DB.addRecord(DB_PRE &"content1_case",array("cid:33","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/case/thumb/8.jpg"))
		
		'******下载******
		data = "下载示例内容详细介绍"
		call OW.DB.addRecord(table,array("cate_id:26","type_id1:0","type_id2:0","sequence:1","status:0","title:下载示例1","root_id:5","rootpath:download","urlpath:xiazai1","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:34","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_download",array("cid:34","attachment:1"))
		call OW.DB.addRecord(DB_PRE &"attachment",array("site_id:1","cid:34","gid:0","cate_id:26","fileurl:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/download/test1.rar","filename:test1","filesize:20000","downloads:0"))
		'**
		data = "下载示例内容详细介绍"
		call OW.DB.addRecord(table,array("cate_id:26","type_id1:0","type_id2:0","sequence:2","status:0","title:下载示例2","root_id:5","rootpath:download","urlpath:xiazai2","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:35","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_download",array("cid:35","attachment:2"))
		call OW.DB.addRecord(DB_PRE &"attachment",array("site_id:1","cid:35","gid:0","cate_id:26","fileurl:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/download/test2.rar","filename:test2","filesize:20000","downloads:0"))
		
		'******视频******
		data = "本地MP4视频示例内容详细介绍"
		call OW.DB.addRecord(table,array("cate_id:30","type_id1:0","type_id2:0","sequence:1","status:0","title:本地MP4视频示例","root_id:6","rootpath:video","urlpath:localvideo","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:36","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_video",array("cid:36","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/videos/localvideo.jpg","video:http://x4.demo.openwbs.com/ow-content/uploads/videos/demovideo.mp4"))
		'**
		data = "引用优酷等外部网站视频示例示例内容详细介绍"
		call OW.DB.addRecord(table,array("cate_id:30","type_id1:0","type_id2:0","sequence:2","status:0","title:引用优酷等外部网站视频示例","root_id:6","rootpath:video","urlpath:webvideo","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:37","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_video",array("cid:37","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/videos/webvideo.jpg","video:http://player.youku.com/player.php/sid/XMTY2MTQ1ODMzMg==/v.swf"))
		
		'******人才招聘******
		data = "&lt;p&gt;&lt;strong&gt;岗位描述： &lt;/strong&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;1、负责业务集群的大规模、高可用和稳定性运维工作； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;2、深入研究大数据业务运维相关技术，持续优化服务架构； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;3、深入了解业务产品流程和模型，解决业务产品各种异常； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;4、深入了解容量规划和集群性能优化； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;5、深度参与业务系统的架构设计与实施，主导系统架构可运维设计方案； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;6、设计实现可支撑大规模分布式集群的运维平台与工具； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;7、喜欢探索、专研新的运维技术方向，对MTTR/SLA/TCO保持敏感。 &lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;strong&gt;岗位要求： &lt;/strong&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;1、5年以上互联网行业业务运维经验，本科以及以上学历； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;2、精通python/ruby/shell等脚本语言，且有运维产品化开发经验； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;3、熟悉systemtap、perf、oprofile 等分析调试工具； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;4、精通linux操作系统以及性能tuning.； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;5、很强的Trouble-shooting能力、且能够推动产品线问题改善和解决； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;6、扎实的计算机专业基础知识，良好的沟通能力、细心负责热爱运维相关工作； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;7、有DevOps实践经验者优先考虑。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(table,array("cate_id:35","type_id1:0","type_id2:0","sequence:1","status:0","title:业务运维专家","root_id:7","rootpath:join","urlpath:mk1","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:38","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_join",array("cid:38"))
		'**
		data = "&lt;p&gt;&lt;span style=&quot;font-size: 14px;&quot;&gt;&lt;strong&gt;岗位描述： &lt;/strong&gt;&lt;/span&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;1、能够完整负责某一产品的规划、实施、跟踪、验收等各个环节；&lt;/p&gt;&lt;p&gt;2、能够总结并优化当前产品； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;3、能规划运营、市场PR计划，并和相关部门一起实施。 &lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 14px;&quot;&gt;&lt;strong&gt;岗位要求： &lt;/strong&gt;&lt;/span&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;1、从事互联网产品工作3年以上； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;2、最好有社交、社区产品经验； &lt;br/&gt;&lt;/p&gt;&lt;p&gt;3、有toB经验更佳。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(table,array("cate_id:36","type_id1:0","type_id2:0","sequence:2","status:0","title:产品经理","root_id:7","rootpath:join","urlpath:pd1","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:39","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_join",array("cid:39"))
		'**
		
		'******常见问题******
		data = "有手机端（触屏版），PC端和手机端是同一个后台和数据库，数据同步，而且网站网址不变，系统自动会根据用户使用的设备来显示，如果是PC电脑就显示PC端的页面，如果是手机和平板就显示手机移动端的页面！"
		call OW.DB.addRecord(table,array("cate_id:38","type_id1:0","type_id2:0","sequence:1","status:0","title:OpenWBS建站系统带有手机端微网站吗？","root_id:8","rootpath:faq","urlpath:q1","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:40","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_faq",array("cid:40"))
		'**
		data = "不可以，一个商业授权只能用于一个网站，多个网站需要分别购买多套商业授权！"
		call OW.DB.addRecord(table,array("cate_id:38","type_id1:0","type_id2:0","sequence:2","status:0","title:购买一套网站商业授权，可不可以用来制作多个网站？","root_id:8","rootpath:faq","urlpath:q2","views:0","post_time:"&SYS_TIME,"update_time:"&SYS_TIME,"recommend:0"))
		call OW.DB.addRecord(tableData,array("cid:41","seo_title:","keywords:","description:","content:"& data,"mob_content:"& data))
		call OW.DB.addRecord(DB_PRE &"content1_faq",array("cid:41"))
		'**
		
		if tip<>"" then print "完成<br>"
	end function
	
	public function type_case(byval tip)
		if tip<>"" then print tip
		if OS.versionType="x" then
			call OW.DB.addRecord(DB_PRE &"type_cate",array("site_id:1","is_shop:1","sequence:1","status:0","type_cate_name:手机数码产品筛选","description:"))
			call OW.DB.addRecord(DB_PRE &"type_attr",array("site_id:1","is_shop:1","type_cate_id:1","sequence:1","status:0","type_attr_name:产地","description:"))
			call OW.DB.addRecord(DB_PRE &"type_attr",array("site_id:1","is_shop:1","type_cate_id:1","sequence:2","status:0","type_attr_name:价格","description:"))
		else
			call OW.DB.addRecord(DB_PRE &"type_cate",array("site_id:1","is_shop:0","sequence:1","status:0","type_cate_name:产品类型筛选","description:"))
			call OW.DB.addRecord(DB_PRE &"type_attr",array("site_id:1","is_shop:0","type_cate_id:1","sequence:1","status:0","type_attr_name:产地","description:"))
			call OW.DB.addRecord(DB_PRE &"type_attr",array("site_id:1","is_shop:0","type_cate_id:1","sequence:2","status:0","type_attr_name:价格","description:"))
		end if
		'**
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:1","sequence:1","status:0","type_name:中国","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:1","sequence:2","status:0","type_name:德国","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:1","sequence:3","status:0","type_name:日本","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:1","sequence:4","status:0","type_name:美国","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:1","sequence:5","status:0","type_name:法国","description:"))
		'**
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:2","sequence:1","status:0","type_name:0-200元","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:2","sequence:2","status:0","type_name:200-500元","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:2","sequence:3","status:0","type_name:500-1000元","description:"))
		call OW.DB.addRecord(DB_PRE &"type",array("site_id:1","type_cate_id:1","type_attr_id:2","sequence:4","status:0","type_name:1000元以上","description:"))
	end function
	
	public function form(byval tip)
		if tip<>"" then print tip
		table     = DB_PRE &"form"
		dim listTpl,fieldTpl,replyTpl
		listTpl = "<div class=""form-data"">"
		listTpl = listTpl &"<div class=""avatar"">"
		listTpl = listTpl &"<img src=""{$vo:avatar}"">"
		listTpl = listTpl &"<h6>{$vo:username}</h6>"
		listTpl = listTpl &"</div>"
		listTpl = listTpl &"<div class=""form-data-content"">"
		listTpl = listTpl &"<div class=""heading""><span class=""datetime"">{$vo:post_time}</span><span class=""data-id"">#{$vo:id}</span></div>"
		listTpl = listTpl &"<table border=""0"" cellpadding=""0"" cellspacing=""0"">{$vo:fields_html}</table>"
		listTpl = listTpl &"</div>"
		listTpl = listTpl &"</div>"
		listTpl = listTpl &"{$vo:reply}"
		
		fieldTpl = "<tr class=""row""><td class=""col-name""><div>{$field:name}</div></td><td class=""col-value""><div>{$field:value}</div></td></tr>"
		
		replyTpl = "<div class=""form-data form-data-reply"">"
        replyTpl = replyTpl &"<div class=""avatar"">"
        replyTpl = replyTpl &"<img src=""{$reply:avatar}"">"
        replyTpl = replyTpl &"<h6>管理员</h6>"
        replyTpl = replyTpl &"</div>"
        replyTpl = replyTpl &"<div class=""form-data-content"">"
		replyTpl = replyTpl &"<div class=""heading""><span class=""datetime"">回复于 {$reply:post_time}</span></div>"
        replyTpl = replyTpl &"<div class=""reply-content"">"
        replyTpl = replyTpl &"{$reply:content}"
        replyTpl = replyTpl &"</div>"
        replyTpl = replyTpl &"</div>"
        replyTpl = replyTpl &"</div>"
		
		call OW.DB.addRecord(table,array("site_id:1","form_id:1","is_shop:0","sequence:1","status:0","name:在线留言","table:feedback","urlpath:feedback","display:1","pagesize:10","tpl:form.html","list_tpl:"& listTpl,"field_tpl:"& fieldTpl,"reply_tpl:"& replyTpl,"post_html:","send_email:1","rec_email:admin@openwbs.com,manager@openwbs.com","auth:0","post_once:0","forbid_member_group:","need_check:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:1","site_id:1","form_id:1","sequence:1","status:0","field:nickname","field_name:昵称","field_type:text","field_datasize:32","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:2","site_id:1","form_id:1","sequence:2","status:0","field:tel","field_name:联系电话","field_type:text","field_datasize:30","field_default:","field_options:","not_null:0","tips:不会公开,请放心填写","display_in_admin:1","display_in_client:0"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:3","site_id:1","form_id:1","sequence:3","status:0","field:email","field_name:联系邮箱","field_type:text","field_datasize:64","field_default:","field_options:","not_null:0","tips:不会公开,请放心填写","display_in_admin:1","display_in_client:0"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:4","site_id:1","form_id:1","sequence:4","status:0","field:website","field_name:网址","field_type:text","field_datasize:255","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:5","site_id:1","form_id:1","sequence:5","status:0","field:content","field_name:留言内容","field_type:editor","field_datasize:","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
		call createFormFeedbackTable(DB_PRE &"form1_feedback")
		call OW.DB.execute("UPDATE ["& DB_PRE &"form] SET post_html='"& OW.validDBData(OS.createFormPostHtml(1,1),0) &"' WHERE form_id=1 AND site_id=1")
		
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table,array("site_id:2","form_id:1","is_shop:0","sequence:1","status:0","name:feedback","table:feedback","urlpath:feedback","display:1","pagesize:10","tpl:form.html","list_tpl:"& listTpl,"field_tpl:"& fieldTpl,"reply_tpl:"& replyTpl,"post_html:","send_email:1","rec_email:admin@openwbs.com,manager@openwbs.com","auth:0","post_once:0","forbid_member_group:","need_check:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:1","site_id:2","form_id:1","sequence:1","status:0","field:nickname","field_name:昵称","field_type:text","field_datasize:32","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:2","site_id:2","form_id:1","sequence:2","status:0","field:tel","field_name:联系电话","field_type:text","field_datasize:30","field_default:","field_options:","not_null:0","tips:secret","display_in_admin:1","display_in_client:0"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:3","site_id:2","form_id:1","sequence:3","status:0","field:email","field_name:联系邮箱","field_type:text","field_datasize:64","field_default:","field_options:","not_null:0","tips:secret","display_in_admin:1","display_in_client:0"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:4","site_id:2","form_id:1","sequence:4","status:0","field:website","field_name:网址","field_type:text","field_datasize:255","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:5","site_id:2","form_id:1","sequence:5","status:0","field:content","field_name:留言内容","field_type:editor","field_datasize:","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
			call createFormFeedbackTable(DB_PRE &"form2_feedback")
			call OW.DB.execute("UPDATE ["& DB_PRE &"form] SET post_html='"& OW.validDBData(OS.createFormPostHtml(1,2),0) &"' WHERE form_id=1 AND site_id=2")
			'**
			call OW.DB.addRecord(table,array("site_id:3","form_id:1","is_shop:0","sequence:1","status:0","name:在線留言","table:feedback","urlpath:feedback","display:1","pagesize:10","tpl:form.html","list_tpl:"& listTpl,"field_tpl:"& fieldTpl,"reply_tpl:"& replyTpl,"post_html:","send_email:1","rec_email:admin@openwbs.com,manager@openwbs.com","auth:0","post_once:0","forbid_member_group:","need_check:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:1","site_id:3","form_id:1","sequence:1","status:0","field:nickname","field_name:昵称","field_type:text","field_datasize:32","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:2","site_id:3","form_id:1","sequence:2","status:0","field:tel","field_name:联系电话","field_type:text","field_datasize:30","field_default:","field_options:","not_null:0","tips:不會公開,請放心填寫","display_in_admin:1","display_in_client:0"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:3","site_id:3","form_id:1","sequence:3","status:0","field:email","field_name:联系邮箱","field_type:text","field_datasize:64","field_default:","field_options:","not_null:0","tips:不會公開,請放心填寫","display_in_admin:1","display_in_client:0"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:4","site_id:3","form_id:1","sequence:4","status:0","field:website","field_name:网址","field_type:text","field_datasize:255","field_default:","field_options:","not_null:0","tips:","display_in_admin:1","display_in_client:1"))
			call OW.DB.addRecord(DB_PRE &"form_field",array("field_id:5","site_id:3","form_id:1","sequence:5","status:0","field:content","field_name:留言内容","field_type:editor","field_datasize:","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
			call createFormFeedbackTable(DB_PRE &"form3_feedback")
			call OW.DB.execute("UPDATE ["& DB_PRE &"form] SET post_html='"& OW.validDBData(OS.createFormPostHtml(1,3),0) &"' WHERE form_id=1 AND site_id=3")
		end if
		
		if tip<>"" then print "完成<br>"
	end function
	
	public function label(byval tip)
		if tip<>"" then print tip
		'**推荐位
		table = DB_PRE &"label"
		dim content
		'****
		content = "&lt;h3&gt;&lt;a href=&quot;"& SITE_HURL &"about"& SITE_HTML_FILE_SUFFIX &"&quot; &gt;关于OpenWBS建站系统&lt;/a&gt;&lt;/h3&gt;&lt;a href=&quot;"& SITE_HURL &"about"& SITE_HTML_FILE_SUFFIX &"&quot; &gt;&lt;img class=&quot;img-responsive&quot; src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/about.jpg&quot; alt=&quot;201402211837036157&quot; /&gt;&lt;/a&gt;&lt;p&gt;OpenWBS 开放式企业商务建站系统，是一种开源的全新互联网建站系统，功能模块非常丰富，可随意组合出个性化的网站，用户在短时间内即可迅速架设属于自己的企业网站、电子商务网站、外贸网站、资讯门户和博客等 ...&lt;/p&gt;"
		call OW.DB.addRecord(table,array("site_id:1","label_id:1","sequence:1","status:0","name:index-about","description:网站首页公司简介","type:5","content:"& content,"config:0"))
		'****
		content = "10年技术沉淀、专业的研发与服务团队、服务企业超过12万家"
		call OW.DB.addRecord(table,array("site_id:1","label_id:2","sequence:2","status:0","name:index-case-summary","description:网站首页案例介绍","type:1","content:"& content,"config:0"))
		'****
		content = "&lt;h3&gt;OpenWBS · 企业建站系统&lt;/h3&gt;&lt;p class=&quot;text1&quot;&gt;新一代全新架构，采用分层设计，拥有优秀的执行效率、扩展性和稳定性，一个快速帮您打造企业官网和企业手机微官网的优秀系统！&lt;/p&gt;&lt;p class=&quot;text2&quot;&gt;QQ 客服： 100000&lt;br&gt;客服热线： 400-800-800 或 020-00000000&lt;/p&gt;"
		call OW.DB.addRecord(table,array("site_id:1","label_id:3","sequence:3","status:0","name:contact","description:网页底部公司联系方式","type:10","content:"& content,"config:0"))
		'****
		content = "&lt;img class=&quot;img-responsive&quot; src=&quot;/ow-content/uploads/"& tplImageFolder &"/images/qrcode.jpg&quot; alt=&quot;qrcode&quot; /&gt;&lt;h3&gt;官方微信&lt;/h3&gt;&lt;p&gt;关注我们 · 更多干货资讯&lt;/p&gt;"
		call OW.DB.addRecord(table,array("site_id:1","label_id:4","sequence:4","status:0","name:qrcode","description:微信公众号","type:4","content:"& content,"config:0"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function links(byval tip)
		if tip<>"" then print tip
		'**推荐位
		table = DB_PRE &"links"
		call OW.DB.addRecord(table,array("site_id:1","link_id:1","sequence:1","status:0","cate_id:1","name:OpenWBS 企业建站系统","url:http://www.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","link_id:2","sequence:2","status:0","cate_id:1","name:OpenWBS 用户社区","url:http://www.openwbs.com/ow-forum/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","link_id:3","sequence:3","status:0","cate_id:1","name:OpenWBS 用户手册","url:http://doc.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","link_id:4","sequence:4","status:0","cate_id:1","name:企业网站模板","url:http://www.openwbs.com/template/","hits:0"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function plugins(byval tip)
		if tip<>"" then print tip
		'**推荐位
		table = DB_PRE &"plugins"
		if tip<>"" then print "完成<br>"
	end function
	
	public function position(byval tip)
		if tip<>"" then print tip
		'**推荐位
		table = DB_PRE &"position"
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","is_shop:0","model_id:2","sequence:1","status:0","name:首页新闻动态"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","is_shop:0","model_id:3","sequence:2","status:0","name:首页产品服务"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","is_shop:0","model_id:4","sequence:3","status:0","name:首页案例"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function position_data(byval tip)
		if tip<>"" then print tip
		'**推荐位数据
		table = DB_PRE &"position_data"
		'**新闻
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:1","status:0","cid:9","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:2","status:0","cid:10","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:3","status:0","cid:11","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:4","status:0","cid:12","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:5","status:0","cid:13","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:6","status:0","cid:14","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:1","sequence:7","status:0","cid:15","gid:0"))
		'**产品
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:1","status:0","cid:16","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:2","status:0","cid:17","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:3","status:0","cid:18","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:4","status:0","cid:19","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:5","status:0","cid:20","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:6","status:0","cid:21","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:7","status:0","cid:22","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:2","sequence:8","status:0","cid:23","gid:0"))
		'**案例
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:1","status:0","cid:26","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:2","status:0","cid:27","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:3","status:0","cid:28","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:4","status:0","cid:29","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:5","status:0","cid:30","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:6","status:0","cid:31","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:7","status:0","cid:32","gid:0"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:3","sequence:8","status:0","cid:33","gid:0"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function sites(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"sites"
		call OW.DB.addRecord(table,array("site_id:1","status:0","sequence:1","site_sname:主站点","site_domain:"& SITE_DOMAIN,"site_url:"& SITE_URL,"site_folder:"))
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table,array("site_id:2","status:0","sequence:2","site_sname:英文站","site_domain:"& OW.createSubDomain("en",SITE_DOMAIN),"site_url:http://"& OW.createSubDomain("en",SITE_DOMAIN) & SITE_PATH,"site_folder:en/"))
			call OW.DB.addRecord(table,array("site_id:3","status:0","sequence:3","site_sname:繁体站","site_domain:"& OW.createSubDomain("big5",SITE_DOMAIN),"site_url:http://"& OW.createSubDomain("big5",SITE_DOMAIN) & SITE_PATH,"site_folder:big5/"))
		end if
		if tip<>"" then print "完成<br>"
	end function
	
	public function site_domains(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"site_domains"
		call OW.DB.addRecord(table,array("site_id:1","site_domain:"& SITE_DOMAIN,"site_url:"& SITE_URL,"is_mobile:0","is_redirect:0"))
		if OW.isNotNul(siteDomain2) then
			call OW.DB.addRecord(table,array("site_id:1","site_domain:"& siteDomain2,"site_url:http://"& siteDomain2 &"/","is_mobile:0","is_redirect:0"))
		end if
		if OW.isNotNul(siteDomain3) then
			call OW.DB.addRecord(table,array("site_id:1","site_domain:"& siteDomain3,"site_url:http://"& siteDomain3 &"/","is_mobile:0","is_redirect:0"))
		end if
		'call OW.DB.addRecord(table,array("site_id:1","site_domain:"& OW.createSubDomain("m",SITE_DOMAIN),"site_url:http://"& OW.createSubDomain("m",SITE_DOMAIN) & SITE_PATH,"is_mobile:1","is_redirect:0"))
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table,array("site_id:2","site_domain:"& OW.createSubDomain("en",SITE_DOMAIN),"site_url:http://"& OW.createSubDomain("en",SITE_DOMAIN) & SITE_PATH))
			call OW.DB.addRecord(table,array("site_id:3","site_domain:"& OW.createSubDomain("big5",SITE_DOMAIN),"site_url:http://"& OW.createSubDomain("big5",SITE_DOMAIN) & SITE_PATH))
		end if
		if tip<>"" then print "完成"
	end function
	
	public function addConfig(byval siteId,byval name,byval value)
		table = DB_PRE &"site_config"
		call OW.DB.addRecord(table,array("site_id:"& siteId,"config_name:"& name,"config_value:"& value))
	end function
	
	public function site_config(byval tip)
		if tip<>"" then print tip
		dim tplFolder,mobileTplFolder
		if OS.versionType="x" then
			tplFolder = "ow.x4.default.pc"
		else
			tplFolder = "ow.v4.default.pc"
		end if
		if OS.versionType="x" then
			mobileTplFolder = "ow.x4.default.mob"
		else
			mobileTplFolder = "ow.v4.default.mob"
		end if
		'写入配置数据
		
		call addConfig(0,"member_share_manage","0")
		call addConfig(0,"upload_share_manage","0")
		call addConfig(0,"run_mode","0")
		call addConfig(0,"login_timeout","240")
		call addConfig(0,"forbid_username","admin|administrator|manager|openwbs|username")
		
		call addConfig(1,"site_sname","主站点")
		call addConfig(1,"site_name",SITE_NAME)
		call addConfig(1,"site_mini_name","我的网站")
		call addConfig(1,"site_domain",SITE_DOMAIN)
		call addConfig(1,"site_path",SITE_PATH)
		call addConfig(1,"site_url",SITE_URL)
		call addConfig(1,"site_folder","")
		call addConfig(1,"site_lang","zh-cn")
		call addConfig(1,"site_admin_lang","zh-cn")
		call addConfig(1,"site_admin_theme","default")
		call addConfig(1,"site_close","0")
		call addConfig(1,"site_close_html","")
		
		call addConfig(1,"site_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo.png")
		call addConfig(1,"site_ucenter_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo_ucenter.png")
		call addConfig(1,"site_mobile_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/site_mobile_logo.png")
		call addConfig(1,"site_title","网站首页")
		call addConfig(1,"site_keywords","填写您的网站seo关键词")
		call addConfig(1,"site_description","填写您的网站seo网页描述")
		call addConfig(1,"icp","粤ICP备00000000号")
		call addConfig(1,"statistics","")
		call addConfig(1,"tpl_folder",tplFolder)
		call addConfig(1,"tpl_html_folder","html")
		call addConfig(1,"money_sb","￥")
		call addConfig(1,"debug","0")
		call addConfig(1,"cache_folder",OW.randsn(28))
		
		call addConfig(1,"cache_open","1")
		call addConfig(1,"cache_time","43200")
		call addConfig(1,"html_cache_open","0")
		call addConfig(1,"html_cache_time","4320")
		call addConfig(1,"gzip_open","0")
		call addConfig(1,"url_type","0")
		call addConfig(1,"url_path_type","1")
		
		call addConfig(1,"is_point_open","1")
		call addConfig(1,"user_login_close","0")
		call addConfig(1,"user_reg_close","0")
		call addConfig(1,"user_reg_check","0")
		call addConfig(1,"is_user_mobile_open","0")
		call addConfig(1,"mobile_interval_time","120")
		call addConfig(1,"is_user_email_open","1")
		call addConfig(1,"is_user_email_activate","0")
		call addConfig(1,"is_reg_need_username","1")
		
		call addConfig(1,"user_login_vcode_open_pc","1")
		call addConfig(1,"user_login_vcode_open_mb","1")
		call addConfig(1,"user_reg_vcode_open_pc","1")
		call addConfig(1,"user_reg_vcode_open_mb","1")
		call addConfig(1,"user_forget_vcode_open_pc","1")
		call addConfig(1,"user_forget_vcode_open_mb","1")
		call addConfig(1,"user_set_vcode_open_pc","1")
		call addConfig(1,"user_set_vcode_open_mb","1")
		call addConfig(1,"form_vcode_open","1")
		call addConfig(1,"is_comment_need_check","0")
		call addConfig(1,"comment_limit_one_day","20")
		
		call addConfig(1,"upload_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.psd;*.rar;*.zip;*.pdf;*.txt;*.doc;*.docx;*.ppt;*.pptx;*.xlsx;*.rm;*.rmvb;*.avi;*.wmv;*.mp3;*.mp4;*.swf;*.flv")
		call addConfig(1,"upload_file_size_limit","10")
		call addConfig(1,"upload_client_file","0")
		call addConfig(1,"upload_client_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.rar;*.zip")
		call addConfig(1,"upload_client_file_size_limit","2")
		call addConfig(1,"wartermark","0")
		call addConfig(1,"wartermark_min_width","200")
		call addConfig(1,"wartermark_min_height","200")
		call addConfig(1,"wartermark_transparency","1")
		call addConfig(1,"wartermark_type","0")
		call addConfig(1,"wartermark_image","ow-content/uploads/"& tplImageFolder &"/images/wartermark.png")
		call addConfig(1,"wartermark_font","OpenWBS建站系统")
		call addConfig(1,"wartermark_font_color","#333333")
		call addConfig(1,"wartermark_font_size","12")
		call addConfig(1,"wartermark_position","8")
		
		call addConfig(1,"firewall_ip_open","0")
		call addConfig(1,"firewall_words_open","0")
		
		call addConfig(1,"mail_smtp","smtp.exmail.qq.com")
		call addConfig(1,"mail_mailserver_username","system@domain.com")
		call addConfig(1,"mail_mailserver_password","")
		call addConfig(1,"mail_from","system@domain.com")
		call addConfig(1,"mail_fromname","网站管理员")
		
		call addConfig(1,"member_field_list","uid,username,email,mobile,nickname,avatar,credits,points,last_login_time,last_login_ip,group_name,special_group_name,admin_group_name,status")
		call addConfig(1,"member_export_field_list","uid,username,email,mobile,nickname,fullname,avatar,sex,credits,points,reg_time,reg_ip,login_times,last_login_time,last_login_ip,group_name,special_group_name,admin_group_name,status")
		
		call addConfig(1,"mobile_open","1")
		call addConfig(1,"mobile_design_open","0")
		call addConfig(1,"mobile_tpl_folder",mobileTplFolder)
		call addConfig(1,"mobile_tpl_html_folder","html")
		
		call addConfig(1,"website_id","0")
		call addConfig(1,"website_sn","")
		call addConfig(1,"website_key","")
		call addConfig(1,"website_sms_key","")
		call addConfig(1,"website_cfg","")
		call addConfig(1,"website_cfgtime",SYS_TIME)
		
		call addConfig(1,"service_online_open","1")
		call addConfig(1,"service_online","[{&quot;name&quot;:&quot;%u7F51%u7AD9%u5EFA%u8BBE%u54A8%u8BE2&quot;,&quot;tel&quot;:&quot;400-800-800&quot;,&quot;qq&quot;:&quot;100000&quot;,&quot;crmqq&quot;:&quot;&quot;,&quot;wangwang&quot;:&quot;&quot;,&quot;skype&quot;:&quot;&quot;,&quot;text&quot;:&quot;&quot;}]")
		
		
		if IS_MULTI_SITES then
			'**英文站
			call addConfig(2,"site_sname","英文站")
			call addConfig(2,"site_name",SITE_NAME)
			call addConfig(2,"site_mini_name","my website")
			call addConfig(2,"site_domain",OW.createSubDomain("en",SITE_DOMAIN))
			call addConfig(2,"site_path",SITE_PATH)
			call addConfig(2,"site_url","http://"& OW.createSubDomain("en",SITE_DOMAIN) & SITE_PATH)
			call addConfig(2,"site_folder","en/")
			call addConfig(2,"site_lang","en-us")
			call addConfig(2,"site_admin_lang","zh-cn")
			call addConfig(2,"site_admin_theme","default")
			call addConfig(2,"site_close","0")
			call addConfig(2,"site_close_html","")
			
			call addConfig(2,"site_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo.png")
			call addConfig(2,"site_ucenter_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo_ucenter.png")
			call addConfig(2,"site_mobile_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/site_mobile_logo.png")
			call addConfig(2,"site_title","home")
			call addConfig(2,"site_keywords","site keywords")
			call addConfig(2,"site_description","site description")
			call addConfig(2,"icp","粤ICP备00000000号")
			call addConfig(2,"copyright","{$site_name}")
			call addConfig(2,"statistics","")
			call addConfig(2,"tpl_folder",tplFolder)
			call addConfig(2,"tpl_html_folder","html")
			call addConfig(2,"money_sb","￥")
			call addConfig(2,"debug","0")
			call addConfig(2,"cache_folder",OW.randsn(28))
			
			call addConfig(2,"cache_open","0")
			call addConfig(2,"cache_time","14400")
			call addConfig(2,"html_cache_open","0")
			call addConfig(2,"html_cache_time","1440")
			call addConfig(2,"gzip_open","0")
			call addConfig(2,"url_type","0")
			call addConfig(2,"url_path_type","1")
			
			call addConfig(2,"is_point_open","1")
			call addConfig(2,"user_login_close","0")
			call addConfig(2,"user_reg_close","0")
			call addConfig(2,"user_reg_check","0")
			call addConfig(2,"is_user_mobile_open","0")
			call addConfig(2,"mobile_interval_time","120")
			call addConfig(2,"is_user_email_open","1")
			call addConfig(2,"is_user_email_activate","0")
			call addConfig(2,"is_reg_need_username","1")
			
			call addConfig(2,"user_login_vcode_open_pc","1")
			call addConfig(2,"user_login_vcode_open_mb","1")
			call addConfig(2,"user_reg_vcode_open_pc","1")
			call addConfig(2,"user_reg_vcode_open_mb","1")
			call addConfig(2,"user_forget_vcode_open_pc","1")
			call addConfig(2,"user_forget_vcode_open_mb","1")
			call addConfig(2,"user_set_vcode_open_pc","1")
			call addConfig(2,"user_set_vcode_open_mb","1")
			call addConfig(2,"form_vcode_open","1")
			call addConfig(2,"is_comment_need_check","0")
			call addConfig(2,"comment_limit_one_day","20")
			
			call addConfig(2,"upload_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.psd;*.rar;*.zip;*.pdf;*.txt;*.doc;*.docx;*.ppt;*.pptx;*.xlsx;*.rm;*.rmvb;*.avi;*.wmv;*.mp3;*.mp4;*.swf")
			call addConfig(2,"upload_file_size_limit","10")
			call addConfig(2,"upload_client_file","0")
			call addConfig(2,"upload_client_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.rar;*.zip")
			call addConfig(2,"upload_client_file_size_limit","2")
			call addConfig(2,"wartermark","0")
			call addConfig(2,"wartermark_min_width","200")
			call addConfig(2,"wartermark_min_height","200")
			call addConfig(2,"wartermark_transparency","1")
			call addConfig(2,"wartermark_type","0")
			call addConfig(2,"wartermark_image","ow-content/uploads/"& tplImageFolder &"/images/wartermark.png")
			call addConfig(2,"wartermark_font","OpenWBS")
			call addConfig(2,"wartermark_font_color","#333333")
			call addConfig(2,"wartermark_font_size","12")
			call addConfig(2,"wartermark_position","8")
			
			call addConfig(2,"firewall_ip_open","0")
			call addConfig(2,"firewall_words_open","0")
			
			call addConfig(2,"mail_smtp","smtp.exmail.qq.com")
			call addConfig(2,"mail_mailserver_username","system@domain.com")
			call addConfig(2,"mail_mailserver_password","")
			call addConfig(2,"mail_from","system@domain.com")
			call addConfig(2,"mail_fromname","master")
			
			call addConfig(2,"mobile_open","0")
			call addConfig(2,"mobile_design_open","0")
			call addConfig(2,"mobile_tpl_folder",mobileTplFolder)
			call addConfig(2,"mobile_tpl_html_folder","html")
			
			call addConfig(2,"website_id","0")
			call addConfig(2,"website_sn","")
			call addConfig(2,"website_key","")
			call addConfig(2,"website_sms_key","")
			call addConfig(2,"website_cfg","")
			call addConfig(2,"website_cfgtime",SYS_TIME)
			
			'**繁体站
			call addConfig(3,"is_point_open","1")
			call addConfig(3,"site_sname","繁體站")
			call addConfig(3,"site_name",SITE_NAME)
			call addConfig(3,"site_mini_name","我的網站")
			call addConfig(3,"site_domain",OW.createSubDomain("big5",SITE_DOMAIN))
			call addConfig(3,"site_path",SITE_PATH)
			call addConfig(3,"site_url","http://"& OW.createSubDomain("big5",SITE_DOMAIN) & SITE_PATH)
			call addConfig(3,"site_folder","big5/")
			call addConfig(3,"site_lang","zh-hk")
			call addConfig(3,"site_admin_lang","zh-cn")
			call addConfig(3,"site_admin_theme","default")
			call addConfig(3,"site_close","0")
			call addConfig(3,"site_close_html","")
			
			call addConfig(3,"site_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo.png")
			call addConfig(3,"site_ucenter_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/logo_ucenter.png")
			call addConfig(3,"site_mobile_logo",SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/images/site_mobile_logo.png")
			call addConfig(3,"site_title","網站首頁")
			call addConfig(3,"site_keywords","填寫您的網站seo關鍵詞")
			call addConfig(3,"site_description","填寫您的網站seo網頁描述")
			call addConfig(3,"icp","粤ICP备00000000号")
			call addConfig(3,"statistics","")
			call addConfig(3,"tpl_folder",tplFolder)
			call addConfig(3,"tpl_html_folder","html")
			call addConfig(3,"money_sb","￥")
			call addConfig(3,"debug","0")
			call addConfig(3,"cache_folder",OW.randsn(28))
			
			call addConfig(3,"cache_open","0")
			call addConfig(3,"cache_time","14400")
			call addConfig(3,"html_cache_open","0")
			call addConfig(3,"html_cache_time","1440")
			call addConfig(3,"gzip_open","0")
			call addConfig(3,"url_type","0")
			call addConfig(3,"url_path_type","1")
			
			call addConfig(3,"user_login_close","0")
			call addConfig(3,"user_reg_close","0")
			call addConfig(3,"user_reg_check","0")
			call addConfig(3,"is_user_mobile_open","0")
			call addConfig(3,"mobile_interval_time","120")
			call addConfig(3,"is_user_email_open","1")
			call addConfig(3,"is_user_email_activate","0")
			call addConfig(3,"is_reg_need_username","1")
			
			call addConfig(3,"user_login_vcode_open_pc","1")
			call addConfig(3,"user_login_vcode_open_mb","1")
			call addConfig(3,"user_reg_vcode_open_pc","1")
			call addConfig(3,"user_reg_vcode_open_mb","1")
			call addConfig(3,"user_forget_vcode_open_pc","1")
			call addConfig(3,"user_forget_vcode_open_mb","1")
			call addConfig(3,"user_set_vcode_open_pc","1")
			call addConfig(3,"user_set_vcode_open_mb","1")
			call addConfig(3,"form_vcode_open","1")
			call addConfig(3,"is_comment_need_check","0")
			call addConfig(3,"comment_limit_one_day","20")
			
			call addConfig(3,"upload_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.psd;*.rar;*.zip;*.pdf;*.txt;*.doc;*.docx;*.ppt;*.pptx;*.xlsx;*.rm;*.rmvb;*.avi;*.wmv;*.mp3;*.mp4;*.swf")
			call addConfig(3,"upload_file_size_limit","10")
			call addConfig(3,"upload_client_file","0")
			call addConfig(3,"upload_client_file_types","*.jpg;*.jpeg;*.png;*.gif;*.bmp;*.rar;*.zip")
			call addConfig(3,"upload_client_file_size_limit","2")
			call addConfig(3,"wartermark","0")
			call addConfig(3,"wartermark_min_width","200")
			call addConfig(3,"wartermark_min_height","200")
			call addConfig(3,"wartermark_transparency","1")
			call addConfig(3,"wartermark_type","0")
			call addConfig(3,"wartermark_image","ow-content/uploads/"& tplImageFolder &"/images/wartermark.png")
			call addConfig(3,"wartermark_font","OpenWBS建站係統")
			call addConfig(3,"wartermark_font_color","#333333")
			call addConfig(3,"wartermark_font_size","12")
			call addConfig(3,"wartermark_position","8")
			
			call addConfig(3,"firewall_ip_open","0")
			call addConfig(3,"firewall_words_open","0")
			
			call addConfig(3,"mail_smtp","smtp.exmail.qq.com")
			call addConfig(3,"mail_mailserver_username","system@domain.com")
			call addConfig(3,"mail_mailserver_password","")
			call addConfig(3,"mail_from","system@domain.com")
			call addConfig(3,"mail_fromname","網站琯理員")
			
			call addConfig(3,"mobile_open","0")
			call addConfig(3,"mobile_design_open","0")
			call addConfig(3,"mobile_tpl_folder",mobileTplFolder)
			call addConfig(3,"mobile_tpl_html_folder","html")
			
			call addConfig(3,"website_id","0")
			call addConfig(3,"website_sn","")
			call addConfig(3,"website_key","")
			call addConfig(3,"website_sms_key","")
			call addConfig(3,"website_cfg","")
			call addConfig(3,"website_cfgtime",SYS_TIME)
			
		end if
		'**
		call OS.getConfig()
		'**
		if tip<>"" then print "完成<br>"
	end function

	public function keywords(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"keywords"
		call OW.DB.addRecord(table,array("site_id:1","kid:1","sequence:1","status:0","keyword:cms","url:http://www.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","kid:2","sequence:2","status:0","keyword:企业建站系统","url:http://www.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","kid:3","sequence:3","status:0","keyword:网店系统","url:http://www.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","kid:4","sequence:4","status:0","keyword:企业建站","url:http://www.openwbs.com/","hits:0"))
		call OW.DB.addRecord(table,array("site_id:1","kid:5","sequence:5","status:0","keyword:OpenWBS","url:http://www.openwbs.com/","hits:0"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function tags(byval tip)
		if tip<>"" then print tip
		dim tagsTable,tagsData
		tagsTable = DB_PRE &"tags"
		tagsData  = DB_PRE &"tags_data"
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:0","sequence:1","status:0","tag:cms","hits:0"))
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:0","sequence:2","status:0","tag:企业建站","hits:0"))
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:0","sequence:3","status:0","tag:OpenWBS企业建站系统","hits:0"))
		if OS.versionType="x" then
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:1","sequence:1","status:0","tag:新品","hits:0"))
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:1","sequence:2","status:0","tag:热销","hits:0"))
		call OW.DB.addRecord(tagsTable,array("site_id:1","is_shop:1","sequence:3","status:0","tag:婚纱摄影","hits:0"))
		end if
		'**
		call OW.DB.addRecord(tagsData,array("site_id:1","tag_id:5","cid:0","gid:1"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function mailTpl(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"mail_tpl"
		dim tpl
		tpl = ""
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","is_default:1","mail_type:reg_success","mail_name:会员注册邮件","mail_desc:用户注册成功后发送的欢迎邮件","mail_title:恭喜您成功注册成为会员","mail_body:"& tpl))
		tpl = ""
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","is_default:1","mail_type:reg_activation","mail_name:会员激活邮件","mail_desc:用户注册后发送会员激活邮件","mail_title:会员激活邮件","mail_body:"& tpl))
		tpl = "取回密码说明<p>{$username}，这封信是由 {$site_name} 发送的。</p>"
		tpl = tpl &"<p>您收到这封邮件，是由于这个邮箱地址在 {$site_name} 被登记为用户邮箱，且该用户请求使用 Email 密码重置功能所致。</p>"
		tpl = tpl &"<p>----------------------------------------------------------------------<br/><strong>重要！</strong><br/>----------------------------------------------------------------------</p>"
		tpl = tpl &"<p>如果您没有提交密码重置的请求或不是 {$site_name} 的注册用户，请立即忽略并删除这封邮件。只有在您确认需要重置密码的情况下，才需要继续阅读下面的内容。</p>"
		tpl = tpl &"<p>----------------------------------------------------------------------<br/><strong>密码重置说明</strong><br/>----------------------------------------------------------------------</p>"
		tpl = tpl &"<p>请通过点击下面的链接重置您的密码：<br/><a href=""{$reset_password_url}"" target=""_blank"">{$reset_password_url}</a><br/>(如果上面不是链接形式，请将该地址手工粘贴到浏览器地址栏再访问)</p>"
		tpl = tpl &"<p>在上面的链接所打开的页面中输入新的密码后提交，您即可使用新的密码登录网站了。您可以在用户控制面板中随时修改您的密码。</p>"
		tpl = tpl &"<p>本请求提交者的 IP 为 {$ip}</p>"
		tpl = tpl &"<p>此致</p>"
		tpl = tpl &"<p>{$site_name} 管理团队. {$site_url}</p>"
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","is_default:1","mail_type:forget_password","mail_name:会员找回密码","mail_desc:用户忘记密码后用邮箱找回密码","mail_title:找回密码","mail_body:"& tpl))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function member(byval tip)

		'**用户
		table = DB_PRE &"member"
		call OW.DB.addRecord(table,array("utype:1","username:"& username,"password:"& password,"email:"& email,"mobile:","nickname:创始人","avatar:"& SITE_PATH &"ow-content/uploads/avatar/1.jpg","admin_group_id:1","group_id:5","special_group_id:11","reg_time:"& SYS_TIME,"reg_ip:"& OW.getClientIP(),"login_times:0","status:0","approved:1","recommend_uid:0","site_id:1"))
		'**ucenter
		table = DB_PRE &"ucenter_member"
		call OW.DB.addRecord(table,array("uid:1","username:"& username,"password:"& password,"email:"& email,"mobile:","status:0","site_id:1"))
		'**详细
		table = DB_PRE &"member_detail"
		call OW.DB.addRecord(table,array("uid:1"))
		'**存款
		table = DB_PRE &"member_deposit"
		call OW.DB.addRecord(table,array("uid:1","available:0","freeze:0","deposit:0"))
		'**积分
		table = DB_PRE &"member_point"
		call OW.DB.addRecord(table,array("uid:1","available:0","freeze:0","point:0"))
		'**
		table  = DB_PRE &"member_group"
		table2 = DB_PRE &"member_group_sites"
		'**管理员组
		call OW.DB.addRecord(table,array("group_id:1","group_type:1","group_name:创始人","group_rank:10000","group_color:#000000","group_point:0","group_credits:0","group_icon:","discount:100","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:1","group_name:创始人","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:2","group_type:1","group_name:超级管理员","group_rank:90","group_color:#111111","group_point:0","group_credits:0","group_icon:","discount:100","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:2","group_name:超级管理员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:3","group_type:1","group_name:内容编辑人员","group_rank:20","group_color:#666666","group_point:0","group_credits:0","group_icon:","discount:100","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:3","group_name:内容编辑人员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:4","group_type:1","group_name:内容审核人员","group_rank:10","group_color:#888888","group_point:0","group_credits:0","group_icon:","discount:100","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:4","group_name:内容审核人员","site_id:1"))
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table2,array("group_id:1","group_name:Founder","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:1","group_name:創始人","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:2","group_name:Administrator","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:2","group_name:超級管理員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:3","group_name:Editorial staff","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:3","group_name:內容編輯人員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:4","group_name:Audit staff ","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:4","group_name:內容審核人員","site_id:3"))
		end if
		
		'会员组
		call OW.DB.addRecord(table,array("group_id:5","group_type:2","group_name:至尊VIP","group_rank:100","group_color:#000000","group_point:0","group_credits:100000","group_icon:","discount:95","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:5","group_name:至尊VIP","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:6","group_type:2","group_name:金牌会员","group_rank:90","group_color:#222222","group_point:0","group_credits:10000","group_icon:","discount:96","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:6","group_name:金牌会员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:7","group_type:2","group_name:高级会员","group_rank:80","group_color:#444444","group_point:0","group_credits:5000","group_icon:","discount:97","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:7","group_name:高级会员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:8","group_type:2","group_name:中级会员","group_rank:50","group_color:#666666","group_point:0","group_credits:1000","group_icon:","discount:98","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:8","group_name:中级会员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:9","group_type:2","group_name:初级会员","group_rank:10","group_color:#888888","group_point:0","group_credits:1","group_icon:","discount:99","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:9","group_name:初级会员","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:10","group_type:2","group_name:游客","group_rank:0","group_color:#888888","group_point:0","group_credits:0","group_icon:","discount:100","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:10","group_name:游客","site_id:1"))
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table2,array("group_id:5","group_name:Extreme VIP","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:5","group_name:至尊VIP","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:6","group_name:Gold member","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:6","group_name:金牌會員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:7","group_name:Senior member","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:7","group_name:高級會員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:8","group_name:Intermediate member","site_id:2"))
		    call OW.DB.addRecord(table2,array("group_id:8","group_name:中級會員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:9","group_name:Junior member","site_id:2"))
		    call OW.DB.addRecord(table2,array("group_id:9","group_name:初級會員","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:10","group_name:Unregistered member","site_id:2"))
		    call OW.DB.addRecord(table2,array("group_id:10","group_name:遊客","site_id:3"))
		end if
		
		'特别会员组
		call OW.DB.addRecord(table,array("group_id:11","group_type:3","group_name:战略合作伙伴","group_rank:100","group_color:#000000","group_point:0","group_credits:0","group_icon:","discount:82","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:11","group_name:战略合作伙伴","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:12","group_type:3","group_name:顶级代理商","group_rank:90","group_color:#000000","group_point:0","group_credits:0","group_icon:","discount:83","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:12","group_name:顶级代理商","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:13","group_type:3","group_name:中级代理商","group_rank:50","group_color:#000000","group_point:0","group_credits:0","group_icon:","discount:84","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:13","group_name:中级代理商","site_id:1"))
		call OW.DB.addRecord(table,array("group_id:14","group_type:3","group_name:初级代理商","group_rank:20","group_color:#000000","group_point:0","group_credits:0","group_icon:","discount:85","description:","status:0","site_id:1"))
		call OW.DB.addRecord(table2,array("group_id:14","group_name:初级代理商","site_id:1"))
		if IS_MULTI_SITES then
			call OW.DB.addRecord(table2,array("group_id:11","group_name:Strategic partner","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:11","group_name:戰略合作夥伴","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:12","group_name:Top agents","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:12","group_name:頂級代理商","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:13","group_name:Intermediate agent","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:13","group_name:中級代理商","site_id:3"))
			call OW.DB.addRecord(table2,array("group_id:14","group_name:Junior agent","site_id:2"))
			call OW.DB.addRecord(table2,array("group_id:14","group_name:初級代理商","site_id:3"))
		end if
		if tip<>"" then print "完成<br>"
	end function
	
	public function model(byval tip)
		if tip<>"" then print tip
		call model_adding(1)
		if IS_MULTI_SITES then
			call model_adding(2)
			call model_adding(3)
		end if
		if tip<>"" then print "完成<br>"
	end function
	
	public function model_adding(byval siteId)
		dim tableContent
		'写入配置数据
		table = DB_PRE &"model"
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:1","is_shop:0","model_type:1","model_name:单页模型","model_table:page","tpl_page:spage.html","sequence:1","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_page","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:2","is_shop:0","model_type:0","model_name:新闻模型","model_table:news","tpl_index:news.html","tpl_category:news.category.html","tpl_content:news.content.html","sequence:2","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_news","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:3","is_shop:0","model_type:0","model_name:产品模型","model_table:product","tpl_index:product.html","tpl_category:product.category.html","tpl_content:product.content.html","sequence:3","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_product","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:4","is_shop:0","model_type:0","model_name:案例模型","model_table:case","tpl_index:case.html","tpl_category:case.category.html","tpl_content:case.content.html","sequence:4","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_case","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:5","is_shop:0","model_type:0","model_name:下载模型","model_table:download","tpl_index:download.html","tpl_category:download.category.html","tpl_content:download.content.html","sequence:5","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_download","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:6","is_shop:0","model_type:0","model_name:视频模型","model_table:video","tpl_index:video.html","tpl_category:video.category.html","tpl_content:video.content.html","sequence:6","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_video","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:7","is_shop:0","model_type:0","model_name:招聘模型","model_table:join","tpl_index:join.html","tpl_category:join.category.html","tpl_content:join.content.html","sequence:7","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_join","cid")
		call OW.DB.addRecord(table,array("site_id:"& siteId,"model_id:8","is_shop:0","model_type:0","model_name:问答模型","model_table:faq","tpl_index:faq.html","tpl_category:faq.category.html","tpl_content:faq.content.html","sequence:8","status:0"))
		call OW.DB.createModelTable(DB_PRE &"content"& siteId &"_faq","cid")
	end function
	
	public function model_field(byval tip)
		if tip<>"" then print tip
		call model_field_adding(1)
		if IS_MULTI_SITES then
			call model_field_adding(2)
			call model_field_adding(3)
		end if
		if tip<>"" then print "完成<br>"
	end function
	
	public function model_field_adding(byval siteId)
		'写入配置数据
		table = DB_PRE &"model_field"
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:1","model_id:2","status:0","field:thumbnail","field_name:缩略图","field_type:image","field_datasize:255","field_options:","not_null:0","tips:","sequence:1","display:0"))
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:2","model_id:2","status:0","field:author","field_name:作者","field_type:text","field_datasize:50","field_options:","not_null:0","tips:","sequence:2","display:0"))
		
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:3","model_id:3","status:0","field:thumbnail","field_name:缩略图","field_type:image","field_datasize:255","field_options:","not_null:0","tips:","sequence:1","display:0"))
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:4","model_id:3","status:0","field:images","field_name:产品图片","field_type:images","field_datasize:0","field_options:","not_null:0","tips:","sequence:2","display:0"))
		
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:5","model_id:4","status:0","field:thumbnail","field_name:缩略图","field_type:image","field_datasize:255","field_options:","not_null:0","tips:","sequence:1","display:0"))
		
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:6","model_id:5","status:0","field:attachment","field_name:附件下载","field_type:attachment","field_datasize:0","field_options:","not_null:0","tips:","sequence:1","display:0"))
		
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:7","model_id:6","status:0","field:thumbnail","field_name:视频缩略图","field_type:image","field_datasize:255","field_options:","not_null:0","tips:","sequence:1","display:0"))
		call OW.DB.addRecord(table,array("site_id:"& siteId,"field_id:8","model_id:6","status:0","field:video","field_name:视频地址","field_type:video","field_datasize:255","field_options:","not_null:0","tips:","sequence:2","display:0"))
		'****
		
		select case DB_TYPE
		case 0
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_news", "[thumbnail] text (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_news", "[author] text (50) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_product", "[thumbnail] text (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_product", "[images] memo NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_case", "[thumbnail] text (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_download", "[attachment] integer NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_video", "[thumbnail] text (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_video", "[video] text (255) NULL")
			'**
		case 1
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_news", "[thumbnail] [nvarchar] (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_news", "[author] [nvarchar] (50) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_product", "[thumbnail] [nvarchar] (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_product", "[images] [ntext] NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_case", "[thumbnail] [nvarchar] (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_download", "[attachment] [int] NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_video", "[thumbnail] [nvarchar] (255) NULL")
			call OW.DB.addColumn(DB_PRE &"content"& siteId &"_video", "[video] [nvarchar] (255) NULL")
			'**
		end select
		'**
	end function
	
	public function navigator(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"navigator"
		
		'**顶部导航
		if OS.versionType="v" then
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:1","path:,1,","depth:1","children:0","type:0","cate_id:0","sync:0","name:OpenWBS 官网","subname:","url:http://www.openwbs.com/","icon:","image:","target:_blank"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:2","path:,2,","depth:1","children:0","type:0","cate_id:0","sync:0","name:网站授权","subname:","url:http://www.openwbs.com/","icon:","image:","target:_blank"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:3","path:,3,","depth:1","children:0","type:0","cate_id:0","sync:0","name:用户社区","subname:","url:http://www.openwbs.com/ow-forum/","icon:","image:","target:_blank"))
		end if
		
		'**主导航
		if OS.versionType="v" then
			call OW.DB.addRecord(table,array("site_id:1","sequence:0","status:0","parent_id:0","nav_id:100","path:,100,","depth:1","children:0","type:1","cate_id:0","sync:0","name:网站首页","subname:home","url:{$site_url}","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:110","path:,110,","depth:1","children:5","type:1","cate_id:10","sync:1","name:公司介绍","subname:about us","url:{$site_hurl}about"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:120","path:,120,","depth:1","children:2","type:1","cate_id:2","sync:1","name:新闻资讯","subname:news","url:{$site_hurl}news/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:130","path:,130,","depth:1","children:4","type:1","cate_id:3","sync:1","name:产品与服务","subname:product","url:{$site_hurl}product/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:0","nav_id:140","path:,140,","depth:1","children:0","type:1","cate_id:4","sync:1","name:案例展示","subname:case","url:{$site_hurl}case/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:0","nav_id:150","path:,150,","depth:1","children:0","type:1","cate_id:5","sync:1","name:下载中心","subname:download","url:{$site_hurl}download/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:6","status:0","parent_id:0","nav_id:160","path:,160,","depth:1","children:0","type:1","cate_id:6","sync:1","name:视频中心","subname:video","url:{$site_hurl}video/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:7","status:0","parent_id:0","nav_id:170","path:,170,","depth:1","children:1","type:1","cate_id:8","sync:1","name:常见问题","subname:faqs","url:{$site_hurl}faq/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:8","status:0","parent_id:0","nav_id:180","path:,180,","depth:1","children:0","type:1","cate_id:15","sync:1","name:联系我们","subname:contact","url:{$site_hurl}contact"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:110","nav_id:111","path:,110,111,","depth:2","children:0","type:1","cate_id:11","sync:1","name:发展历程","subname:","url:{$site_hurl}development"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:110","nav_id:112","path:,110,112,","depth:2","children:0","type:1","cate_id:12","sync:1","name:管理团队","subname:","url:{$site_hurl}team"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:110","nav_id:113","path:,110,113,","depth:2","children:0","type:1","cate_id:13","sync:1","name:合作伙伴","subname:","url:{$site_hurl}partners"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:110","nav_id:114","path:,110,114,","depth:2","children:0","type:1","cate_id:14","sync:1","name:人才招聘","subname:","url:{$site_hurl}join/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:110","nav_id:115","path:,110,115,","depth:2","children:0","type:1","cate_id:15","sync:1","name:联系我们","subname:","url:{$site_hurl}contact"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
			
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:120","nav_id:121","path:,120,121,","depth:2","children:0","type:1","cate_id:16","sync:1","name:公司动态","subname:","url:{$site_hurl}news/company/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:120","nav_id:122","path:,120,122,","depth:2","children:0","type:1","cate_id:17","sync:1","name:行业资讯","subname:","url:{$site_hurl}news/industry/","icon:","image:","target:_self"))
			
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:130","nav_id:131","path:,130,131,","depth:2","children:0","type:1","cate_id:18","sync:1","name:家居建材","subname:","url:{$site_hurl}product/cate1/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:130","nav_id:132","path:,130,132,","depth:2","children:0","type:1","cate_id:19","sync:1","name:按摩器材","subname:","url:{$site_hurl}product/cate2/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:130","nav_id:133","path:,130,133,","depth:2","children:0","type:1","cate_id:20","sync:1","name:汽车配件","subname:","url:{$site_hurl}product/cate3/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:130","nav_id:134","path:,130,134,","depth:2","children:0","type:1","cate_id:21","sync:1","name:电子产品","subname:","url:{$site_hurl}product/cate4/","icon:","image:","target:_self"))
			
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:170","nav_id:171","path:,170,171,","depth:2","children:0","type:1","cate_id:0","sync:0","name:在线留言(万能表单)","subname:","url:{$site_hurl}form/feedback.html","icon:","image:","target:_self"))
		end if
		
		'**底部导航
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:210","path:,210,","depth:1","children:5","type:2","cate_id:1","sync:1","name:公司信息","subname:","url:#","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:220","path:,220,","depth:1","children:4","type:2","cate_id:3","sync:1","name:产品服务","subname:","url:#","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:230","path:,230,","depth:1","children:4","type:2","cate_id:8","sync:1","name:帮助支持","subname:","url:#","icon:","image:","target:_self"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:210","nav_id:211","path:,210,211,","depth:2","children:0","type:2","cate_id:10","sync:1","name:公司介绍","subname:","url:{$site_hurl}about"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:210","nav_id:212","path:,210,212,","depth:2","children:0","type:2","cate_id:12","sync:1","name:管理团队","subname:","url:{$site_hurl}team"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:210","nav_id:213","path:,210,213,","depth:2","children:0","type:2","cate_id:13","sync:1","name:合作伙伴","subname:","url:{$site_hurl}partners"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:210","nav_id:214","path:,210,214,","depth:2","children:0","type:2","cate_id:7","sync:1","name:人才招聘","subname:","url:{$site_hurl}join/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:210","nav_id:215","path:,210,215,","depth:2","children:0","type:2","cate_id:15","sync:1","name:联系我们","subname:","url:{$site_hurl}contact"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:220","nav_id:221","path:,220,221,","depth:2","children:0","type:2","cate_id:2","sync:1","name:新闻中心","subname:","url:{$site_hurl}news/","icon:","image:","target:_self"))
		if OS.versionType="v" then
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:220","nav_id:222","path:,220,222,","depth:2","children:0","type:2","cate_id:3","sync:1","name:产品与服务","subname:","url:{$site_hurl}product/","icon:","image:","target:_self"))
		end if
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:220","nav_id:223","path:,220,223,","depth:2","children:0","type:2","cate_id:4","sync:1","name:客户案例","subname:","url:{$site_hurl}case/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:220","nav_id:224","path:,220,224,","depth:2","children:0","type:2","cate_id:6","sync:1","name:公司视频","subname:","url:{$site_hurl}video/","icon:","image:","target:_self"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:230","nav_id:231","path:,230,231,","depth:2","children:0","type:2","cate_id:8","sync:1","name:常见问题","subname:","url:{$site_hurl}faq/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:230","nav_id:232","path:,230,232,","depth:2","children:0","type:2","cate_id:5","sync:1","name:文档下载","subname:","url:{$site_hurl}download/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:230","nav_id:233","path:,230,233,","depth:2","children:0","type:2","cate_id:41","sync:1","name:用户协议","subname:","url:{$site_hurl}agreement"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:230","nav_id:234","path:,230,234,","depth:2","children:0","type:2","cate_id:42","sync:1","name:隐私政策","subname:","url:{$site_hurl}privacy"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		
		'**用户中心
		if OS.versionType="v" then
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:410","path:,410,","depth:1","children:0","type:4","cate_id:0","sync:0","name:网站首页","subname:","url:{$site_url}","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:420","path:,420,","depth:1","children:0","type:4","cate_id:3","sync:1","name:产品与服务","subname:","url:{$site_hurl}product/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:430","path:,430,","depth:1","children:0","type:4","cate_id:15","sync:1","name:联系我们","subname:","url:{$site_hurl}contact"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		end if
		
		'**手机端主导航
		if OS.versionType="v" then
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:510","path:,510,","depth:1","children:0","type:5","cate_id:0","sync:0","name:首页","subname:","url:{$site_url}","icon:/ow-content/uploads/icon/home.png","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:520","path:,520,","depth:1","children:0","type:5","cate_id:0","sync:0","name:关于","subname:","url:{$site_hurl}about"& SITE_HTML_FILE_SUFFIX,"icon:/ow-content/uploads/icon/about.png","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:530","path:,530,","depth:1","children:3","type:5","cate_id:0","sync:0","name:新闻","subname:","url:{$site_hurl}news/","icon:/ow-content/uploads/icon/news.png","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:530","nav_id:531","path:,530,531,","depth:2","children:0","type:5","cate_id:2","sync:1","name:新闻中心","subname:","url:{$site_hurl}news/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:530","nav_id:532","path:,530,532,","depth:2","children:0","type:5","cate_id:16","sync:1","name:公司动态","subname:","url:{$site_hurl}news/company/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:530","nav_id:533","path:,530,533,","depth:2","children:0","type:5","cate_id:17","sync:1","name:行业资讯","subname:","url:{$site_hurl}news/industry/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:0","nav_id:540","path:,540,","depth:1","children:5","type:5","cate_id:0","sync:0","name:产品","subname:","url:{$site_hurl}product/","icon:/ow-content/uploads/icon/product.png","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:540","nav_id:541","path:,540,541,","depth:2","children:0","type:5","cate_id:3","sync:1","name:产品与服务","subname:","url:{$site_hurl}product/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:540","nav_id:542","path:,540,542,","depth:2","children:0","type:5","cate_id:18","sync:1","name:家居建材","subname:","url:{$site_hurl}product/cate1/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:540","nav_id:543","path:,540,543,","depth:2","children:0","type:5","cate_id:19","sync:1","name:按摩器材","subname:","url:{$site_hurl}product/cate2/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:540","nav_id:544","path:,540,544,","depth:2","children:0","type:5","cate_id:20","sync:1","name:汽车配件","subname:","url:{$site_hurl}product/cate3/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:540","nav_id:545","path:,540,545,","depth:2","children:0","type:5","cate_id:21","sync:1","name:电子产品","subname:","url:{$site_hurl}product/cate4/","icon:","image:","target:_self"))
			call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:0","nav_id:550","path:,550,","depth:1","children:0","type:5","cate_id:0","sync:0","name:我的","subname:","url:{$site_url}ow-ucenter/","icon:/ow-content/uploads/icon/my.png","image:","target:_self"))
		end if
		'**
		if tip<>"" then print "完成<br>"
	end function
	
end class

%>