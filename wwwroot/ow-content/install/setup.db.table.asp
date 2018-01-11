<%
'**
'安装OpenWBS
'**
class STDBTable_Class
	
	public canDoNext,sql,table,cresult,aresult
	
	private sub class_initialize()
		canDoNext = true
	end sub
	
	private sub class_terminate()
	end sub
	
	public sub init()
		OW.DB.auxSQLValid = false
		call action()
		call admin_action()
		'**
		call ad()
		call ad_data()
		call attachment()
		'**
		call category()
		call category_admin_auth()
		call category_member_auth()
		'**
		call content(DB_PRE &"content1")
		call content_data(DB_PRE &"content1_data")
		if IS_MULTI_SITES then
			call content(DB_PRE &"content2")
			call content_data(DB_PRE &"content2_data")
			call content(DB_PRE &"content3")
			call content_data(DB_PRE &"content3_data")
		end if
		call content_related()
		call comment()
		call comment_stats()
		'**
		call firewall_ip()
		call firewall_words()
		call form()
		call form_field()
		call form_reply()
		call keywords()
		call label()
		call links()
		call mail_tpl()
		'**
		call member()
		call member_credits_log()
		call member_detail()
		call member_deposit()
		call member_deposit_log()
		call member_group()
		call member_group_sites()
		call member_point()
		call member_point_log()
		call member_stats()
		call member_qq()
		call member_weixin()
		'**
		call mobile_sms_log()
		call mobile_sms_code()
		call model()
		call model_field()
		'**
		call navigator()
		'**
		call plugins()
		call position()
		call position_data()
		call region()
		call region_zone()
		call search_keywords()
		call security_code_lib()
		'**
		call sites()
		call site_config()
		call site_domains()
		'**
		call system_log()
		call system_error()
		call system_msg()
		call tags()
		call tags_data()
		call type_cate()
		call type_attr()
		call type_()
		call ucenter_member()
		call ucenter_session()
	end sub
	
	private function success(byval s)
		echo s &" 创建成功<br>"
	end function
	
	private function failed(byval s)
		canDoNext = false
		echo s &" <font style=""color:#f00;"">创建失败</font><br>"
	end function
	
	private function action()
		table   = DB_PRE &"action"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sys_id] integer NOT NULL,"
			sql = sql & "[ctl_id] integer NOT NULL,"
			sql = sql & "[act_id] integer NOT NULL,"
			sql = sql & "[ctl] text (30) NOT NULL,"
			sql = sql & "[act] text (30) NOT NULL,"
			sql = sql & "[ctl_name] text (50) NOT NULL,"
			sql = sql & "[act_name] text (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ctl ON ["& table &"] ([ctl])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sys_id] [tinyint] NOT NULL,"
			sql = sql & "[ctl_id] [tinyint] NOT NULL,"
			sql = sql & "[act_id] [tinyint] NOT NULL,"
			sql = sql & "[ctl] [nvarchar] (30) NOT NULL,"
			sql = sql & "[act] [nvarchar] (30) NOT NULL,"
			sql = sql & "[ctl_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[act_name] [nvarchar] (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ctl ON ["& table &"] ([ctl])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function admin_action()
		table   = DB_PRE &"admin_action"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[ctl] text (30) NOT NULL,"
			sql = sql & "[act] text (30) NOT NULL,"
			sql = sql & "[is_plugin] integer NOT NULL,"
			sql = sql & "[allow] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ctl ON ["& table &"] ([ctl])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[group_id] [smallint] NOT NULL,"
			sql = sql & "[ctl] [nvarchar] (30) NOT NULL,"
			sql = sql & "[act] [nvarchar] (30) NOT NULL,"
			sql = sql & "[is_plugin] [tinyint] NOT NULL,"
			sql = sql & "[allow] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ctl ON ["& table &"] ([ctl])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function ad()
		table   = DB_PRE &"ad"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[ad_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[name] text (50) NOT NULL,"
			sql = sql & "[start_time] date NOT NULL,"
			sql = sql & "[end_time] date NOT NULL,"
			sql = sql & "[height] text (8) NOT NULL,"
			sql = sql & "[width] text (8) NOT NULL,"
			sql = sql & "[full_screen] integer NOT NULL,"
			sql = sql & "[switch_time] integer NULL,"
			sql = sql & "[type] text (10) NOT NULL,"
			sql = sql & "[view] integer NOT NULL,"
			sql = sql & "[hits] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_ad_id ON ["& table &"] ([ad_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[ad_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[start_time] [datetime] NOT NULL,"
			sql = sql & "[end_time] [datetime] NOT NULL,"
			sql = sql & "[height] [nvarchar] (8) NOT NULL,"
			sql = sql & "[width] [nvarchar] (8) NOT NULL,"
			sql = sql & "[full_screen] [int] NOT NULL,"
			sql = sql & "[switch_time] [int] NULL,"
			sql = sql & "[type] [nvarchar] (10) NOT NULL,"
			sql = sql & "[view] [int] NOT NULL,"
			sql = sql & "[hits] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ad_id ON ["& table &"] ([ad_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function ad_data()
		table   = DB_PRE &"ad_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[ad_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[config_image] memo NOT NULL,"
			sql = sql & "[config_flash] memo NOT NULL,"
			sql = sql & "[config_code] memo NOT NULL,"
			sql = sql & "[config_text] memo NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_ad_id ON ["& table &"] ([ad_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[ad_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[config_image] [ntext] NOT NULL,"
			sql = sql & "[config_flash] [ntext] NOT NULL,"
			sql = sql & "[config_code] [ntext] NOT NULL,"
			sql = sql & "[config_text] [ntext] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ad_id ON ["& table &"] ([ad_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function attachment()
		table   = DB_PRE &"attachment"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[aid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[fileurl] text (255) NOT NULL,"
			sql = sql & "[filename] text (50) NOT NULL,"
			sql = sql & "[filesize] integer NOT NULL,"
			sql = sql & "[downloads] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[aid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[fileurl] [nvarchar] (255) NOT NULL,"
			sql = sql & "[filename] [nvarchar] (50) NOT NULL,"
			sql = sql & "[filesize] [int] NOT NULL,"
			sql = sql & "[downloads] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([aid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function category()
		table   = DB_PRE &"category"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[model_id] integer NOT NULL,"
			sql = sql & "[model_type] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[parent_id] integer NOT NULL,"
			sql = sql & "[path] text (32) NOT NULL,"
			sql = sql & "[depth] integer NOT NULL,"
			sql = sql & "[children] integer NOT NULL,"
			sql = sql & "[cate_type] integer NOT NULL,"
			sql = sql & "[name] text (100) NOT NULL,"
			sql = sql & "[subname] text (100) NULL,"
			sql = sql & "[root_id] integer NULL,"
			sql = sql & "[rootpath] text (64) NULL,"
			sql = sql & "[urlpath] text (64) NULL,"
			sql = sql & "[url] text (255) NULL,"
			sql = sql & "[type_cate_id] integer NULL,"
			sql = sql & "[icon] text (255) NULL,"
			sql = sql & "[image] text (255) NULL,"
			sql = sql & "[tpl_inherit] integer NOT NULL,"
			sql = sql & "[tpl_page] text (50) NULL,"
			sql = sql & "[tpl_index] text (50) NULL,"
			sql = sql & "[tpl_category] text (50) NULL,"
			sql = sql & "[tpl_content] text (50) NULL,"
			sql = sql & "[seo_title] text (250) NULL,"
			sql = sql & "[keywords] text (250) NULL,"
			sql = sql & "[description] text (250) NULL,"
			sql = sql & "[ad_image_data] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_parent_id ON ["& table &"] ([parent_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[model_id] [int] NOT NULL,"
			sql = sql & "[model_type] [int] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[parent_id] [int] NOT NULL,"
			sql = sql & "[path] [nvarchar] (32) NOT NULL,"
			sql = sql & "[depth] [tinyint] NOT NULL,"
			sql = sql & "[children] [int] NOT NULL,"
			sql = sql & "[cate_type] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[subname] [nvarchar] (100) NULL,"
			sql = sql & "[root_id] [int] NULL,"
			sql = sql & "[rootpath] [nvarchar] (64) NULL,"
			sql = sql & "[urlpath] [nvarchar] (64) NULL,"
			sql = sql & "[url] [nvarchar] (255) NULL,"
			sql = sql & "[type_cate_id] [int] NULL,"
			sql = sql & "[icon] [nvarchar] (255) NULL,"
			sql = sql & "[image] [nvarchar] (255) NULL,"
			sql = sql & "[tpl_inherit] [int] NOT NULL,"
			sql = sql & "[tpl_page] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_index] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_category] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_content] [nvarchar] (50) NULL,"
			sql = sql & "[seo_title] [nvarchar] (250) NULL,"
			sql = sql & "[keywords] [nvarchar] (250) NULL,"
			sql = sql & "[description] [nvarchar] (250) NULL,"
			sql = sql & "[ad_image_data] [ntext] NULL,"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_is_shop ON ["& table &"] ([is_shop])")
			aresult = OW.DB.execute("CREATE INDEX IDX_parent_id ON ["& table &"] ([parent_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function category_admin_auth()
		table   = DB_PRE &"category_admin_auth"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[act] text (30) NOT NULL,"
			sql = sql & "[forbid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_group_id ON ["& table &"] ([group_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[group_id] [smallint] NOT NULL,"
			sql = sql & "[act] [nvarchar] (30) NOT NULL,"
			sql = sql & "[forbid] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_group_id ON ["& table &"] ([group_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function category_member_auth()
		table   = DB_PRE &"category_member_auth"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[forbid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_group_id ON ["& table &"] ([group_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[group_id] [smallint] NOT NULL,"
			sql = sql & "[forbid] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_group_id ON ["& table &"] ([group_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function comment()
		table   = DB_PRE &"comment"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cmtid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[cid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[depth] integer NOT NULL,"
			sql = sql & "[parent_cmtid] integer NOT NULL,"
			sql = sql & "[children] integer NOT NULL,"
			sql = sql & "[comment] memo NOT NULL,"
			sql = sql & "[post_time] date NOT NULL,"
			sql = sql & "[user_device] integer NOT NULL,"
			sql = sql & "[userip] text (15) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_cid ON ["& table &"] ([cid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cmtid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[cid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[depth] [int] NOT NULL,"
			sql = sql & "[parent_cmtid] [int] NOT NULL,"
			sql = sql & "[children] [int] NOT NULL,"
			sql = sql & "[comment] [ntext] NOT NULL,"
			sql = sql & "[post_time] [datetime] NOT NULL,"
			sql = sql & "[user_device] [tinyint] NOT NULL,"
			sql = sql & "[userip] [nvarchar] (15) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cmtid]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_cid ON ["& table &"] ([cid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function comment_stats()
		table   = DB_PRE &"comment_stats"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[stats_date] integer NOT NULL,"
			sql = sql & "[comment_count] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[stats_date] [int] NOT NULL,"
			sql = sql & "[comment_count] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([sid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function content(byval table)
		table   = trim(table)
		cresult = OW.DB.createDBTable(table,"content")
		if cresult=true then success(table) else failed(table)
	end function
	
	private function content_data(byval table)
		table   = trim(table)
		cresult = OW.DB.createDBTable(table,"content.data")
		if cresult=true then success(table) else failed(table)
	end function
	
	private function content_related()
		table = DB_PRE &"content_related"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cid] integer NOT NULL,"
			sql = sql & "[related_cid] integer NOT NULL,"
			sql = sql & "[related_gid] integer NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cid] [int] NOT NULL,"
			sql = sql & "[related_cid] [int] NOT NULL,"
			sql = sql & "[related_gid] [int] NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function firewall_ip()
		table   = DB_PRE &"firewall_ip"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[ip] text (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_ip ON ["& table &"] ([ip])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_ip ON ["& table &"] ([ip])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function firewall_words()
		table   = DB_PRE &"firewall_words"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[word] text (64) NOT NULL,"
			sql = sql & "[replace_word] text (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[word] [nvarchar] (64) NOT NULL,"
			sql = sql & "[replace_word] [nvarchar] (64) NOT NULL,"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function form()
		table   = DB_PRE &"form"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[form_id] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[name] text (50) NOT NULL,"
			sql = sql & "[table] text (30) NOT NULL,"
			sql = sql & "[urlpath] text(64) NOT NULL,"
			sql = sql & "[display] integer NOT NULL,"
			sql = sql & "[pagesize] integer NOT NULL,"
			sql = sql & "[tpl] text (50) NOT NULL,"
			sql = sql & "[list_tpl] memo NOT NULL,"
			sql = sql & "[field_tpl] memo NOT NULL,"
			sql = sql & "[reply_tpl] memo NOT NULL,"
			sql = sql & "[post_html] memo NOT NULL,"
			sql = sql & "[send_email] integer NOT NULL,"
			sql = sql & "[rec_email] text (255) NOT NULL,"
			sql = sql & "[auth] integer NOT NULL,"
			sql = sql & "[post_once] integer NOT NULL,"
			sql = sql & "[forbid_member_group] text (250) NOT NULL,"
			sql = sql & "[need_check] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_form_id ON ["& table &"] ([form_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[form_id] [int] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[table] [nvarchar] (30) NOT NULL,"
			sql = sql & "[urlpath] [nvarchar] (64) NOT NULL,"
			sql = sql & "[display] [tinyint] NOT NULL,"
			sql = sql & "[pagesize] [tinyint] NOT NULL,"
			sql = sql & "[tpl] [nvarchar] (50) NOT NULL,"
			sql = sql & "[list_tpl] [ntext] NOT NULL,"
			sql = sql & "[field_tpl] [ntext] NOT NULL,"
			sql = sql & "[reply_tpl] [ntext] NOT NULL,"
			sql = sql & "[post_html] [ntext] NOT NULL,"
			sql = sql & "[send_email] [tinyint] NOT NULL,"
			sql = sql & "[rec_email] [nvarchar] (255) NOT NULL,"
			sql = sql & "[auth] [tinyint] NOT NULL,"
			sql = sql & "[post_once] [tinyint] NOT NULL,"
			sql = sql & "[forbid_member_group] [nvarchar] (250) NOT NULL,"
			sql = sql & "[need_check] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_form_id ON ["& table &"] ([form_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function form_field()
		table   = DB_PRE &"form_field"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[field_id] integer NOT NULL,"
			sql = sql & "[form_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[field] text (50) NOT NULL,"
			sql = sql & "[field_name] text (50) NOT NULL,"
			sql = sql & "[field_type] text (20) NOT NULL,"
			sql = sql & "[field_datasize] integer NULL,"
			sql = sql & "[field_default] text (250) NULL,"
			sql = sql & "[field_options] memo NULL,"
			sql = sql & "[not_null] integer NOT NULL,"
			sql = sql & "[tips] text (250) NULL,"
			sql = sql & "[display_in_client] integer NOT NULL,"
			sql = sql & "[display_in_admin] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_field_id ON ["& table &"] ([field_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[field_id] [int] NOT NULL,"
			sql = sql & "[form_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[field] [nvarchar] (50) NOT NULL,"
			sql = sql & "[field_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[field_type] [nvarchar] (20) NOT NULL,"
			sql = sql & "[field_datasize] [int] NULL,"
			sql = sql & "[field_default] [nvarchar] (250) NULL,"
			sql = sql & "[field_options] [ntext] NULL,"
			sql = sql & "[not_null] [int] NOT NULL,"
			sql = sql & "[tips] [nvarchar] (250) NULL,"
			sql = sql & "[display_in_client] [tinyint] NOT NULL,"
			sql = sql & "[display_in_admin] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_field_id ON ["& table &"] ([field_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function form_reply()
		table = DB_PRE &"form_reply"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[form_id] integer NOT NULL,"
			sql = sql & "[data_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[post_time] date NOT NULL,"
			sql = sql & "[content] memo NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_form_id ON ["& table &"] ([form_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[form_id] [int] NOT NULL,"
			sql = sql & "[data_id] [int] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[post_time] [datetime] NOT NULL,"
			sql = sql & "[content] [ntext] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_form_id ON ["& table &"] ([form_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function keywords()
		table   = DB_PRE &"keywords"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[kid] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[keyword] text (100) NOT NULL,"
			sql = sql & "[url] text (255) NOT NULL,"
			sql = sql & "[hits] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_kid ON ["& table &"] ([kid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[kid] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[keyword] [nvarchar] (100) NOT NULL,"
			sql = sql & "[url] [nvarchar] (255) NOT NULL,"
			sql = sql & "[hits] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_kid ON ["& table &"] ([kid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function label()
		table   = DB_PRE &"label"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[label_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[name] text (50) NOT NULL,"
			sql = sql & "[description] text (80) NULL,"
			sql = sql & "[type] integer NOT NULL,"
			sql = sql & "[content] memo NULL,"
			sql = sql & "[config] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_name ON ["& table &"] ([name])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[label_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL,"
			sql = sql & "[type] [tinyint] NOT NULL,"
			sql = sql & "[content] [ntext] NULL,"
			sql = sql & "[config] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_name ON ["& table &"] ([name])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function links()
		table   = DB_PRE &"links"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[link_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[name] text (50) NOT NULL,"
			sql = sql & "[logo] text (255) NULL,"
			sql = sql & "[url] text (255) NOT NULL,"
			sql = sql & "[hits] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_link_id ON ["& table &"] ([link_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[link_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[cate_id] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[logo] [nvarchar] (255) NULL,"
			sql = sql & "[url] [nvarchar] (255) NOT NULL,"
			sql = sql & "[hits] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_link_id ON ["& table &"] ([link_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function mail_tpl()
		table = DB_PRE &"mail_tpl"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_default] integer NOT NULL,"
			sql = sql & "[mail_type] text (32) NOT NULL,"
			sql = sql & "[mail_name] text (50) NOT NULL,"
			sql = sql & "[mail_desc] text (250) NULL,"
			sql = sql & "[mail_title] text (250) NOT NULL,"
			sql = sql & "[mail_body] memo NOT NULL,"
			sql = sql & "[mail_tpl_file] text (50) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [smallint] NOT NULL,"
			sql = sql & "[is_default] [smallint] NOT NULL,"
			sql = sql & "[mail_type] [nvarchar] (32) NOT NULL,"
			sql = sql & "[mail_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[mail_desc] [nvarchar] (250) NULL,"
			sql = sql & "[mail_title] [nvarchar] (250) NOT NULL,"
			sql = sql & "[mail_body] [ntext] NOT NULL,"
			sql = sql & "[mail_tpl_file] [nvarchar] (50) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member()
		table   = DB_PRE &"member"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[utype] integer NOT NULL,"
			sql = sql & "[username] text (32) NOT NULL,"
			sql = sql & "[password] text (64) NOT NULL,"
			sql = sql & "[password_dynamic] text (64) NULL,"
			sql = sql & "[email] text (64) NOT NULL,"
			sql = sql & "[mobile] text (11) NOT NULL,"
			sql = sql & "[nickname] text (32) NULL,"
			sql = sql & "[fullname] text (50) NULL,"
			sql = sql & "[sex] integer NULL,"
			sql = sql & "[avatar] text (255) NULL,"
			sql = sql & "[avatar_big] text (255) NULL,"
			sql = sql & "[credits] integer NULL,"
			sql = sql & "[paid_order_amount] currency NULL,"
			sql = sql & "[admin_group_id] integer NULL,"
			sql = sql & "[group_id] integer NULL,"
			sql = sql & "[recomd_uid] integer NULL,"
			sql = sql & "[special_group_id] integer NULL,"
			sql = sql & "[reg_time] date NOT NULL,"
			sql = sql & "[reg_ip] text (64) NOT NULL,"
			sql = sql & "[login_times] integer NOT NULL,"
			sql = sql & "[last_login_time] date NULL,"
			sql = sql & "[last_login_ip] text (64) NULL,"
			sql = sql & "[recommend_uid] integer NULL,"
			sql = sql & "[approved] integer NULL,"
			sql = sql & "[commission_count] currency NULL,"
			sql = sql & "[commission_valid] currency NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[utype] [tinyint] NOT NULL,"'用户类型:0代表普通会员,1代表管理员
			sql = sql & "[username] [nvarchar] (32) NOT NULL,"
			sql = sql & "[password] [nvarchar] (64) NOT NULL,"
			sql = sql & "[password_dynamic] [nvarchar] (64) NULL,"
			sql = sql & "[email] [nvarchar] (64) NOT NULL,"
			sql = sql & "[mobile] [nvarchar] (11) NOT NULL,"
			sql = sql & "[nickname] [nvarchar] (32) NULL,"
			sql = sql & "[fullname] [nvarchar] (50) NULL,"
			sql = sql & "[sex] [int] NULL,"'用户类型:0代表普通会员,1代表管理员
			sql = sql & "[avatar] [nvarchar] (255) NULL,"
			sql = sql & "[avatar_big] [nvarchar] (255) NULL,"
			sql = sql & "[credits] [int] NULL,"
			sql = sql & "[paid_order_amount] [money] NULL,"
			sql = sql & "[admin_group_id] [smallint] NULL,"
			sql = sql & "[group_id] [smallint] NULL,"
			sql = sql & "[special_group_id] [smallint] NULL,"
			sql = sql & "[recomd_uid] [int] NULL,"
			sql = sql & "[reg_time] [datetime] NOT NULL,"
			sql = sql & "[reg_ip] [nvarchar] (64) NOT NULL,"
			sql = sql & "[login_times] [int] NOT NULL,"
			sql = sql & "[last_login_time] [datetime] NULL,"
			sql = sql & "[last_login_ip] [nvarchar] (64) NULL,"
			sql = sql & "[recommend_uid] [int] NULL,"
			sql = sql & "[approved] [tinyint] NULL,"
			sql = sql & "[commission_count] [money] NULL,"
			sql = sql & "[commission_valid] [money] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_credits_log()
		table = DB_PRE &"member_credits_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[credits] integer NOT NULL,"
			sql = sql & "[income] integer NOT NULL,"
			sql = sql & "[remark] text (250) NOT NULL,"
			sql = sql & "[time] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[credits] [int] NOT NULL,"
			sql = sql & "[income] [int] NOT NULL,"
			sql = sql & "[remark] [nvarchar] (250) NOT NULL,"
			sql = sql & "[time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_detail()
		table   = DB_PRE &"member_detail"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[birthday] date NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[birthday] [datetime] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_group()
		table   = DB_PRE &"member_group"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[group_id] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[group_type] integer NOT NULL,"
			sql = sql & "[group_name] text (50) NOT NULL,"
			sql = sql & "[group_rank] integer NOT NULL,"
			sql = sql & "[group_point] integer NOT NULL,"
			sql = sql & "[group_credits] integer NOT NULL,"
			sql = sql & "[group_color] text (7) NULL,"
			sql = sql & "[group_icon] text (255) NULL,"
			sql = sql & "[discount] number NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[group_id] [smallint] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[group_type] [int] NOT NULL,"
			sql = sql & "[group_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[group_rank] [int] NOT NULL,"
			sql = sql & "[group_point] [int] NOT NULL,"
			sql = sql & "[group_credits] [int] NOT NULL,"
			sql = sql & "[group_color] [nvarchar] (7) NULL,"
			sql = sql & "[group_icon] [nvarchar] (255) NULL,"
			sql = sql & "[discount] [float] NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([group_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_group_sites()
		table   = DB_PRE &"member_group_sites"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[group_name] text (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[group_id] [smallint] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[group_name] [nvarchar] (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_deposit()
		table = DB_PRE &"member_deposit"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[available] currency NOT NULL,"
			sql = sql & "[freeze] currency NOT NULL,"
			sql = sql & "[deposit] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[available] [money] NOT NULL,"
			sql = sql & "[freeze] [money] NOT NULL,"
			sql = sql & "[deposit] [money] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_deposit_log()
		table = DB_PRE &"member_deposit_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[type] integer NOT NULL,"
			sql = sql & "[time] date NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[sn] text (28) NOT NULL,"
			sql = sql & "[trade_no] text (20) NULL,"
			sql = sql & "[income] currency NOT NULL,"
			sql = sql & "[expend] currency NOT NULL,"
			sql = sql & "[deposit] currency NOT NULL,"
			sql = sql & "[remark] text (100) NULL,"
			sql = sql & "[ip] text (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_uid ON ["& table &"] ([uid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[type] [smallint] NOT NULL,"
			sql = sql & "[time] [datetime] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[sn] [nvarchar] (28) NOT NULL,"
			sql = sql & "[trade_no] [nvarchar] (20) NULL,"
			sql = sql & "[income] [money] NOT NULL,"
			sql = sql & "[expend] [money] NOT NULL,"
			sql = sql & "[deposit] [money] NOT NULL,"
			sql = sql & "[remark] [nvarchar] (100) NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_uid ON ["& table &"] ([uid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_point()
		table = DB_PRE &"member_point"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[available] currency NOT NULL,"
			sql = sql & "[freeze] currency NOT NULL,"
			sql = sql & "[point] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[available] [money] NOT NULL,"
			sql = sql & "[freeze] [money] NOT NULL,"
			sql = sql & "[point] [money] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_point_log()
		table = DB_PRE &"member_point_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[type] integer NOT NULL,"
			sql = sql & "[time] date NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[sn] text (28) NOT NULL,"
			sql = sql & "[income] currency NOT NULL,"
			sql = sql & "[expend] currency NOT NULL,"
			sql = sql & "[point] currency NOT NULL,"
			sql = sql & "[remark] text (100) NULL,"
			sql = sql & "[ip] text (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_uid ON ["& table &"] ([uid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[type] [smallint] NOT NULL,"
			sql = sql & "[time] [datetime] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[sn] [nvarchar] (28) NOT NULL,"
			sql = sql & "[income] [money] NOT NULL,"
			sql = sql & "[expend] [money] NOT NULL,"
			sql = sql & "[point] [money] NOT NULL,"
			sql = sql & "[remark] [nvarchar] (100) NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_uid ON ["& table &"] ([uid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_stats()
		table   = DB_PRE &"member_stats"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[stats_date] integer NOT NULL,"
			sql = sql & "[charge_count] integer NOT NULL,"
			sql = sql & "[charge_paid_count] integer NOT NULL,"
			sql = sql & "[charge_money_amount] currency NOT NULL,"
			sql = sql & "[charge_money_paid_amount] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[stats_date] [int] NOT NULL,"
			sql = sql & "[charge_count] [int] NOT NULL,"
			sql = sql & "[charge_paid_count] [int] NOT NULL,"
			sql = sql & "[charge_money_amount] [money] NOT NULL,"
			sql = sql & "[charge_money_paid_amount] [money] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([sid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_qq()
		table = DB_PRE &"member_qq"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[unionid] text (64) NOT NULL,"
			sql = sql & "[openid] text (64) NOT NULL,"
			sql = sql & "[nickname] text (32) NOT NULL,"
			sql = sql & "[sex] integer NOT NULL,"
			sql = sql & "[year] integer NOT NULL,"
			sql = sql & "[country] text (100) NOT NULL,"
			sql = sql & "[province] text (100) NOT NULL,"
			sql = sql & "[city] text (100) NOT NULL,"
			sql = sql & "[avatar] text (255) NOT NULL,"
			sql = sql & "[userinfo_data] memo NOT NULL,"
			sql = sql & "[access_token] text (250) NOT NULL,"
			sql = sql & "[refresh_token] text (250) NOT NULL,"
			sql = sql & "[token_time] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[unionid] [nvarchar] (64) NOT NULL,"
			sql = sql & "[openid] [nvarchar] (64) NOT NULL,"
			sql = sql & "[nickname] [nvarchar] (32) NOT NULL,"
			sql = sql & "[sex] [int] NOT NULL,"
			sql = sql & "[year] [int] NOT NULL,"
			sql = sql & "[country] [nvarchar] (100) NOT NULL,"
			sql = sql & "[province] [nvarchar] (100) NOT NULL,"
			sql = sql & "[city] [nvarchar] (100) NOT NULL,"
			sql = sql & "[avatar] [nvarchar] (255) NOT NULL,"
			sql = sql & "[userinfo_data] [ntext] NOT NULL,"
			sql = sql & "[access_token] [nvarchar] (250) NOT NULL,"
			sql = sql & "[refresh_token] [nvarchar] (250) NOT NULL,"
			sql = sql & "[token_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function member_weixin()
		table = DB_PRE &"member_weixin"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[unionid] text (64) NOT NULL,"
			sql = sql & "[openid] text (64) NOT NULL,"
			sql = sql & "[nickname] text (32) NOT NULL,"
			sql = sql & "[sex] integer NOT NULL,"
			sql = sql & "[country] text (100) NOT NULL,"
			sql = sql & "[province] text (100) NOT NULL,"
			sql = sql & "[city] text (100) NOT NULL,"
			sql = sql & "[headimgurl] text (255) NOT NULL,"
			sql = sql & "[access_token] text (250) NOT NULL,"
			sql = sql & "[refresh_token] text (250) NOT NULL,"
			sql = sql & "[token_time] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[unionid] [nvarchar] (64) NOT NULL,"
			sql = sql & "[openid] [nvarchar] (64) NOT NULL,"
			sql = sql & "[nickname] [nvarchar] (32) NOT NULL,"
			sql = sql & "[sex] [tinyint] NOT NULL,"
			sql = sql & "[country] [nvarchar] (100) NOT NULL,"
			sql = sql & "[province] [nvarchar] (100) NOT NULL,"
			sql = sql & "[city] [nvarchar] (100) NOT NULL,"
			sql = sql & "[headimgurl] [nvarchar] (255) NOT NULL,"
			sql = sql & "[access_token] [nvarchar] (250) NOT NULL,"
			sql = sql & "[refresh_token] [nvarchar] (250) NOT NULL,"
			sql = sql & "[token_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function mobile_sms_log()
		table = DB_PRE &"mobile_sms_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[operate_uid] integer NOT NULL,"
			sql = sql & "[sms_uid] integer NOT NULL,"
			sql = sql & "[sms_type] integer NOT NULL,"
			sql = sql & "[mobile] text (50) NOT NULL,"
			sql = sql & "[sms_text] text (250) NOT NULL,"
			sql = sql & "[send_result] integer NOT NULL,"
			sql = sql & "[send_time] date NOT NULL,"
			sql = sql & "[debug_text] text (250) NOT NULL,"
			sql = sql & "[ip] text (64) NOT NULL,"
			sql = sql & "[useragent] text (250) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[operate_uid] [int] NOT NULL,"
			sql = sql & "[sms_uid] [int] NOT NULL,"
			sql = sql & "[sms_type] [tinyint] NOT NULL,"
			sql = sql & "[mobile] [nvarchar] (50) NOT NULL,"
			sql = sql & "[sms_text] [nvarchar] (250) NOT NULL,"
			sql = sql & "[send_result] [tinyint] NOT NULL,"
			sql = sql & "[send_time] [datetime] NOT NULL,"
			sql = sql & "[debug_text] [nvarchar] (250) NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL,"
			sql = sql & "[useragent] [nvarchar] (250) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function mobile_sms_code()
		table = DB_PRE &"mobile_sms_code"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[operate_uid] integer NOT NULL,"
			sql = sql & "[sms_uid] integer NOT NULL,"
			sql = sql & "[sms_type] integer NOT NULL,"
			sql = sql & "[mobile] text (50) NOT NULL,"
			sql = sql & "[sms_text] text (50) NOT NULL,"
			sql = sql & "[sms_time] date NOT NULL,"
			sql = sql & "[verify_times] integer NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[operate_uid] [int] NOT NULL,"
			sql = sql & "[sms_uid] [int] NOT NULL,"
			sql = sql & "[sms_type] [tinyint] NOT NULL,"
			sql = sql & "[mobile] [nvarchar] (50) NOT NULL,"
			sql = sql & "[sms_text] [nvarchar] (50) NOT NULL,"
			sql = sql & "[sms_time] [datetime] NOT NULL,"
			sql = sql & "[verify_times] [int] NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function model()
		table   = DB_PRE &"model"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[model_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[model_type] integer NOT NULL,"
			sql = sql & "[model_name] text (50) NOT NULL,"
			sql = sql & "[model_table] text (30) NOT NULL,"
			sql = sql & "[tpl_page] text (50) NULL,"
			sql = sql & "[tpl_index] text (50) NULL,"
			sql = sql & "[tpl_category] text (50) NULL,"
			sql = sql & "[tpl_content] text (50) NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_model_id ON ["& table &"] ([model_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[model_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"'0:内容模型，1：商品模型
			sql = sql & "[model_type] [int] NOT NULL,"'1:单页模型，2:列表模型
			sql = sql & "[model_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[model_table] [nvarchar] (30) NOT NULL,"
			sql = sql & "[tpl_page] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_index] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_category] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_content] [nvarchar] (50) NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_model_id ON ["& table &"] ([model_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function model_field()
		table   = DB_PRE &"model_field"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[field_id] integer NOT NULL,"
			sql = sql & "[model_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[field] text (50) NOT NULL,"
			sql = sql & "[field_name] text (50) NOT NULL,"
			sql = sql & "[field_type] text (20) NOT NULL,"
			sql = sql & "[field_datasize] integer NULL,"
			sql = sql & "[field_default] text (250) NULL,"
			sql = sql & "[field_options] memo NULL,"
			sql = sql & "[not_null] integer NOT NULL,"
			sql = sql & "[tips] text (250) NULL,"
			sql = sql & "[display] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_field_id ON ["& table &"] ([field_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[field_id] [int] NOT NULL,"
			sql = sql & "[model_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[field] [nvarchar] (50) NOT NULL,"
			sql = sql & "[field_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[field_type] [nvarchar] (20) NOT NULL,"
			sql = sql & "[field_datasize] [int] NULL,"
			sql = sql & "[field_default] [nvarchar] (250) NULL,"
			sql = sql & "[field_options] [ntext] NULL,"
			sql = sql & "[not_null] [int] NOT NULL,"
			sql = sql & "[tips] [nvarchar] (250) NULL,"
			sql = sql & "[display] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_field_id ON ["& table &"] ([field_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	
	private function navigator()
		table   = DB_PRE &"navigator"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[parent_id] integer NOT NULL,"
			sql = sql & "[nav_id] integer NOT NULL,"
			sql = sql & "[path] text (32) NOT NULL,"
			sql = sql & "[depth] integer NOT NULL,"
			sql = sql & "[children] integer NOT NULL,"
			sql = sql & "[type] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[sync] integer NOT NULL,"
			sql = sql & "[name] text (100) NOT NULL,"
			sql = sql & "[subname] text (100) NOT NULL,"
			sql = sql & "[url] text (255) NOT NULL,"
			sql = sql & "[icon] text (255) NULL,"
			sql = sql & "[image] text (255) NULL,"
			sql = sql & "[target] text (10) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_nav_id ON ["& table &"] ([nav_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_parent_id ON ["& table &"] ([parent_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[parent_id] [int] NOT NULL,"
			sql = sql & "[nav_id] [int] NOT NULL,"
			sql = sql & "[path] [nvarchar] (32) NOT NULL,"
			sql = sql & "[depth] [int] NOT NULL,"
			sql = sql & "[children] [int] NOT NULL,"
			sql = sql & "[type] [tinyint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[sync] [int] NOT NULL,"
			sql = sql & "[name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[subname] [nvarchar] (100) NOT NULL,"
			sql = sql & "[url] [nvarchar] (255) NOT NULL,"
			sql = sql & "[icon] [nvarchar] (255) NULL,"
			sql = sql & "[image] [nvarchar] (255) NULL,"
			sql = sql & "[target] [nvarchar] (10) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_nav_id ON ["& table &"] ([nav_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_parent_id ON ["& table &"] ([parent_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	
	private function plugins()
		table   = DB_PRE &"plugins"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[plugin_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[plugin_code] text (32) NOT NULL,"
			sql = sql & "[plugin_name] text (100) NOT NULL,"
			sql = sql & "[plugin_logo] text (255) NOT NULL,"
			sql = sql & "[plugin_version] text (20) NOT NULL,"
			sql = sql & "[plugin_author] text (30) NOT NULL,"
			sql = sql & "[install_time] date NOT NULL,"
			sql = sql & "[plugin_sn] text (32) NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[plugin_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[plugin_code] [nvarchar] (32) NOT NULL,"
			sql = sql & "[plugin_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[plugin_logo] [nvarchar] (255) NOT NULL,"
			sql = sql & "[plugin_version] [nvarchar] (20) NOT NULL,"
			sql = sql & "[plugin_author] [nvarchar] (30) NOT NULL,"
			sql = sql & "[install_time] [datetime] NOT NULL,"
			sql = sql & "[plugin_sn] [nvarchar] (32) NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([plugin_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function position()
		table = DB_PRE &"position"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[pos_id] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[model_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[name] text (200) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_pos_id ON ["& table &"] ([pos_id])")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[pos_id] [int] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[model_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[name] [nvarchar] (100) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
			aresult = OW.DB.execute("CREATE INDEX IDX_pos_id ON ["& table &"] ([pos_id])")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	
	private function region()
		table = DB_PRE &"region"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[region_id] integer NOT NULL,"
			sql = sql & "[parent_region_id] integer NOT NULL,"
			sql = sql & "[region_path] text (50) NOT NULL,"
			sql = sql & "[region_depth] integer NOT NULL,"
			sql = sql & "[region_name] text (100) NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[region_id] [int] NOT NULL,"
			sql = sql & "[parent_region_id] [int] NOT NULL,"
			sql = sql & "[region_path] [nvarchar] (50) NOT NULL,"
			sql = sql & "[region_depth] [tinyint] NOT NULL,"
			sql = sql & "[region_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function region_zone()
		table = DB_PRE &"region_zone"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[zone_name] text (100) NOT NULL,"
			sql = sql & "[zone_region_ids] memo NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[zone_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[zone_region_ids] [ntext] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function position_data()
		table = DB_PRE &"position_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[pos_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[cid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_pos_id ON ["& table &"] ([pos_id])")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[pos_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[cid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_pos_id ON ["& table &"] ([pos_id])")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function search_keywords()
		table   = DB_PRE &"search_keywords"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[kid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[keyword] text (64) NOT NULL,"
			sql = sql & "[search_count] integer NOT NULL,"
			sql = sql & "[recommend] integer NOT NULL,"
			sql = sql & "[cate_id] integer NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[kid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[keyword] [nvarchar] (64) NOT NULL,"
			sql = sql & "[search_count] [int] NOT NULL,"
			sql = sql & "[recommend] [int] NOT NULL,"
			sql = sql & "[cate_id] [int] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([kid]) ON [PRIMARY]")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function security_code_lib()
		table = DB_PRE &"security_code_lib"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[scode_name] text (32) NOT NULL,"
			sql = sql & "[scode_value] text (32) NOT NULL,"
			sql = sql & "[used_times] integer NOT NULL,"
			sql = sql & "[create_time] date NOT NULL,"
			sql = sql & "[latest_use_time] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[scode_name] [nvarchar] (32) NOT NULL,"
			sql = sql & "[scode_value] [nvarchar] (32) NOT NULL,"
			sql = sql & "[used_times] [int] NOT NULL,"
			sql = sql & "[create_time] [datetime] NOT NULL,"
			sql = sql & "[latest_use_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function sites()
		table = DB_PRE &"sites"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[site_sname] text (50) NOT NULL,"
			sql = sql & "[site_domain] text (100) NOT NULL,"
			sql = sql & "[site_url] text (150) NOT NULL,"
			sql = sql & "[site_folder] text (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[site_sname] [nvarchar] (50) NOT NULL,"
			sql = sql & "[site_domain] [nvarchar] (100) NOT NULL,"
			sql = sql & "[site_url] [nvarchar] (150) NOT NULL,"
			sql = sql & "[site_folder] [nvarchar] (50) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([site_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function site_config()
		table = DB_PRE &"site_config"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cfg_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[config_name] text (64) NOT NULL,"
			sql = sql & "[config_value] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_config_name ON ["& table &"] ([config_name])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cfg_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[config_name] [nvarchar] (64) NOT NULL,"
			sql = sql & "[config_value] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cfg_id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_config_name ON ["& table &"] ([config_name])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	private function site_domains()
		table = DB_PRE &"site_domains"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[site_domain] text (100) NOT NULL,"
			sql = sql & "[site_url] text (150) NOT NULL,"
			sql = sql & "[is_mobile] integer NULL,"
			sql = sql & "[is_redirect] integer NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_site_domain ON ["& table &"] ([site_domain])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[site_domain] [nvarchar] (100) NOT NULL,"
			sql = sql & "[site_url] [nvarchar] (150) NOT NULL,"
			sql = sql & "[is_mobile] [int] NULL,"
			sql = sql & "[is_redirect] [int] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_site_domain ON ["& table &"] ([site_domain])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function system_log()
		table   = DB_PRE &"system_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[username] text (32) NOT NULL,"
			sql = sql & "[ip] text (64) NOT NULL,"
			sql = sql & "[datetime] date NOT NULL,"
			sql = sql & "[ctl] text (30) NOT NULL,"
			sql = sql & "[act] text (30) NOT NULL,"
			sql = sql & "[subact] text (30) NOT NULL,"
			sql = sql & "[log_content] memo NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[username] [nvarchar] (32) NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL,"
			sql = sql & "[datetime] [datetime] NOT NULL,"
			sql = sql & "[ctl] [nvarchar] (30) NOT NULL,"
			sql = sql & "[act] [nvarchar] (30) NOT NULL,"
			sql = sql & "[subact] [nvarchar] (30) NOT NULL,"
			sql = sql & "[log_content] [ntext] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function system_error()
		table   = DB_PRE &"system_error"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[description] text (250) NOT NULL,"
			sql = sql & "[source] text (250) NOT NULL,"
			sql = sql & "[uid] integer NULL,"
			sql = sql & "[current_url] text (255) NULL,"
			sql = sql & "[referer] text (255) NULL,"
			sql = sql & "[ip] text (64) NOT NULL,"
			sql = sql & "[datetime] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[description] [nvarchar] (250) NOT NULL,"
			sql = sql & "[source] [nvarchar] (250) NOT NULL,"
			sql = sql & "[uid] [int] NULL,"
			sql = sql & "[current_url] [nvarchar] (255) NULL,"
			sql = sql & "[referer] [nvarchar] (255) NULL,"
			sql = sql & "[ip] [nvarchar] (64) NOT NULL,"
			sql = sql & "[datetime] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function system_msg()
		table = DB_PRE &"system_msg"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[operate_uid] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_user_read] integer NOT NULL,"
			sql = sql & "[is_user_delete] integer NOT NULL,"
			sql = sql & "[msg_type] integer NOT NULL,"
			sql = sql & "[msg_title] text (100) NOT NULL,"
			sql = sql & "[msg_content] memo NOT NULL,"
			sql = sql & "[msg_time] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[operate_uid] [int] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[is_user_read] [tinyint] NOT NULL,"
			sql = sql & "[is_user_delete] [tinyint] NOT NULL,"
			sql = sql & "[msg_type] [tinyint] NOT NULL,"
			sql = sql & "[msg_title] [nvarchar] (100) NOT NULL,"
			sql = sql & "[msg_content] [ntext] NOT NULL,"
			sql = sql & "[msg_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function tags()
		table   = DB_PRE &"tags"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[tag_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[tag] text (50) NOT NULL,"
			sql = sql & "[hits] integer NOT NULL,"
			sql = sql & "[cate_id] integer NULL,"
			sql = sql & "[recommend] integer NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[tag_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[tag] [nvarchar] (50) NOT NULL,"
			sql = sql & "[hits] [int] NOT NULL,"
			sql = sql & "[cate_id] [int] NULL,"
			sql = sql & "[recommend] [int] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([tag_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function tags_data()
		table   = DB_PRE &"tags_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[tag_id] integer NOT NULL,"
			sql = sql & "[cid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_tag_id ON ["& table &"] ([tag_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[tag_id] [int] NOT NULL,"
			sql = sql & "[cid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_tag_id ON ["& table &"] ([tag_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function type_cate()
		table = DB_PRE &"type_cate"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_cate_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[type_cate_name] text (50) NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_cate_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[type_cate_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([type_cate_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function type_attr()
		table = DB_PRE &"type_attr"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_attr_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[is_shop] integer NOT NULL,"
			sql = sql & "[type_cate_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[type_attr_name] text (50) NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_attr_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[is_shop] [tinyint] NOT NULL,"
			sql = sql & "[type_cate_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[type_attr_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([type_attr_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function type_()
		table = DB_PRE &"type"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[type_cate_id] integer NOT NULL,"
			sql = sql & "[type_attr_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[type_name] text (50) NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[type_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[type_cate_id] [int] NOT NULL,"
			sql = sql & "[type_attr_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[type_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([type_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function ucenter_member()
		table   = DB_PRE &"ucenter_member"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[username] text (32) NOT NULL,"
			sql = sql & "[password] text (64) NOT NULL,"
			sql = sql & "[email] text (64) NOT NULL,"
			sql = sql & "[mobile] text (11) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[username] [nvarchar] (32) NOT NULL,"
			sql = sql & "[password] [nvarchar] (64) NOT NULL,"
			sql = sql & "[email] [nvarchar] (64) NOT NULL,"
			sql = sql & "[mobile] [nvarchar] (11) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
	private function ucenter_session()
		table   = DB_PRE &"ucenter_session"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] integer PRIMARY KEY NOT NULL,"
			sql = sql & "[utype] integer NOT NULL,"
			sql = sql & "[username] text (32) NOT NULL,"
			sql = sql & "[uss_key] text (32) NOT NULL,"
			sql = sql & "[uss_value] text (32) NOT NULL,"
			sql = sql & "[datetime] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[utype] [tinyint] NOT NULL,"
			sql = sql & "[username] [nvarchar] (32) NOT NULL,"
			sql = sql & "[uss_key] [nvarchar] (32) NOT NULL,"
			sql = sql & "[uss_value] [nvarchar] (32) NOT NULL,"
			sql = sql & "[datetime] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([uid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table)
	end function
	
end class

%>