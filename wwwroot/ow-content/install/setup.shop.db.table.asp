<%
'安装商城系统表**
class STSHOPDBTable_Class
	
	public canDoNext,sql,table,cresult,aresult
	
	private sub class_initialize()
		canDoNext = true
	end sub
	private sub class_terminate()
	end sub
	
	public sub init()
		OW.DB.auxSQLValid = false
		call brand()
		call brand_category()
		call category_goods()
		call coupon()
		call coupon_data()
		call delivery()
		call delivery_corp()
		call delivery_region()
		call payment()
		call pay_trade_log()
		call goods()
		call goods_attr()
		call goods_consultation()
		call goods_comment()
		call goods_data()
		call goods_favorite()
		call goods_related()
		call goods_price()
		call goods_product()
		call goods_spec()
		call goods_spec_value()
		call goods_suit()
		call goods_suit_goods()
		call goods_type()
		call goods_type_attr()
		call goods_value()
		'**
		call invoice()
		'**
		call member_charge_config()
		call member_commission_log()
		call member_commission_drawcash()
		call member_data()
		call member_deposit_drawcash()
		'**
		call offline_store()
		call orders()
		call order_form_data()
		call order_goods()
		call order_log()
		call order_process()
		call order_process_detail()
		call order_pay_bill()
		call order_refund_apply()
		call order_ship_bill()
		call order_ship_bill_goods()
		call order_suit()
		call order_stats()
	end sub
	
	private function success(byval s)
		echo s &" 创建成功<br>"
	end function
	
	private function failed(byval s)
		canDoNext = false
		echo s &" <font style=""color:#f00;"">创建失败</font><br>"
	end function
	
	private function brand()
		table   = DB_PRE &"brand"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[brand_id] integer NOT NULL,"
			sql = sql & "[cate_ids] text (250) NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[urlpath] text (64) NULL,"
			sql = sql & "[name] text (100) NOT NULL,"
			sql = sql & "[logo] text (255) NULL,"
			sql = sql & "[url] text (255) NULL,"
			sql = sql & "[tpl] text (50) NOT NULL,"
			sql = sql & "[seo_title] text (250) NULL,"
			sql = sql & "[keywords] text (250) NULL,"
			sql = sql & "[description] text (250) NULL,"
			sql = sql & "[content] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_brand_id ON ["& table &"] ([brand_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[brand_id] [int] NOT NULL,"
			sql = sql & "[cate_ids] [nvarchar] (250) NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[urlpath] [nvarchar] (64) NULL,"
			sql = sql & "[name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[logo] [nvarchar] (255) NULL,"
			sql = sql & "[url] [nvarchar] (255) NULL,"
			sql = sql & "[tpl] [nvarchar] (50) NOT NULL,"
			sql = sql & "[seo_title] [nvarchar] (250) NULL,"
			sql = sql & "[keywords] [nvarchar] (250) NULL,"
			sql = sql & "[description] [nvarchar] (250) NULL,"
			sql = sql & "[content] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_brand_id ON ["& table &"] ([brand_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function brand_category()
		table   = DB_PRE &"brand_category"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[parent_id] integer NOT NULL,"
			sql = sql & "[path] text (32) NOT NULL,"
			sql = sql & "[depth] integer NOT NULL,"
			sql = sql & "[children] integer NOT NULL,"
			sql = sql & "[name] text (100) NOT NULL,"
			sql = sql & "[subname] text (100) NULL,"
			sql = sql & "[root_id] integer NULL,"
			sql = sql & "[rootpath] text (64) NULL,"
			sql = sql & "[urlpath] text (64) NULL,"
			sql = sql & "[url] text (255) NULL,"
			sql = sql & "[icon] text (255) NULL,"
			sql = sql & "[image] text (255) NULL,"
			sql = sql & "[tpl_inherit] integer NOT NULL,"
			sql = sql & "[tpl_index] text (50) NULL,"
			sql = sql & "[tpl_category] text (50) NULL,"
			sql = sql & "[tpl_content] text (50) NULL,"
			sql = sql & "[seo_title] text (250) NULL,"
			sql = sql & "[keywords] text (250) NULL,"
			sql = sql & "[description] text (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_urlpath ON ["& table &"] ([urlpath])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[parent_id] [int] NOT NULL,"
			sql = sql & "[path] [nvarchar] (32) NOT NULL,"
			sql = sql & "[depth] [tinyint] NOT NULL,"
			sql = sql & "[children] [int] NOT NULL,"
			sql = sql & "[name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[subname] [nvarchar] (100) NULL,"
			sql = sql & "[root_id] [int] NULL,"
			sql = sql & "[rootpath] [nvarchar] (64) NULL,"
			sql = sql & "[urlpath] [nvarchar] (64) NULL,"
			sql = sql & "[url] [nvarchar] (255) NULL,"
			sql = sql & "[icon] [nvarchar] (255) NULL,"
			sql = sql & "[image] [nvarchar] (255) NULL,"
			sql = sql & "[tpl_inherit] [int] NOT NULL,"
			sql = sql & "[tpl_index] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_category] [nvarchar] (50) NULL,"
			sql = sql & "[tpl_content] [nvarchar] (50) NULL,"
			sql = sql & "[seo_title] [nvarchar] (250) NULL,"
			sql = sql & "[keywords] [nvarchar] (250) NULL,"
			sql = sql & "[description] [nvarchar] (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_urlpath ON ["& table &"] ([urlpath])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function category_goods()
		table = DB_PRE &"category_goods"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function coupon()
		table = DB_PRE &"coupon"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[coupon_id] integer NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[coupon_type] text (4) NOT NULL,"
			sql = sql & "[coupon_code] text (32) NOT NULL,"
			sql = sql & "[coupon_name] text (250) NOT NULL,"
			sql = sql & "[coupon_money] currency NOT NULL,"
			sql = sql & "[coupon_exchange_point] integer NOT NULL,"
			sql = sql & "[is_coupon_max] integer NOT NULL,"
			sql = sql & "[coupon_max] integer NOT NULL,"
			sql = sql & "[coupon_member_group] text (250) NOT NULL,"
			sql = sql & "[coupon_member_get_limit] integer NOT NULL,"
			sql = sql & "[coupon_have_get] integer NOT NULL,"
			sql = sql & "[coupon_have_used] integer NOT NULL,"
			sql = sql & "[coupon_rule_type] integer NOT NULL,"
			sql = sql & "[cate_ids] memo NULL,"
			sql = sql & "[gids] memo NULL,"
			sql = sql & "[is_get_timelimit] integer NOT NULL,"
			sql = sql & "[get_starttime] date NOT NULL,"
			sql = sql & "[get_endtime] date NOT NULL,"
			sql = sql & "[is_can_mix_use] integer NOT NULL,"
			sql = sql & "[use_min_money] currency NOT NULL,"
			sql = sql & "[is_use_timelimit] integer NOT NULL,"
			sql = sql & "[use_starttime] date NOT NULL,"
			sql = sql & "[use_endtime] date NOT NULL,"
			sql = sql & "[desc] memo NULL,"
			sql = sql & "[tpl] text (50) NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[seo_title] text (250) NULL,"
			sql = sql & "[keywords] text (250) NULL,"
			sql = sql & "[description] text (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_coupon_id ON ["& table &"] ([coupon_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[coupon_id] [int] NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[coupon_type] [nvarchar] (4) NOT NULL,"
			sql = sql & "[coupon_code] [nvarchar] (32) NOT NULL,"
			sql = sql & "[coupon_name] [nvarchar] (250) NOT NULL,"
			sql = sql & "[coupon_money] [money] NOT NULL,"
			sql = sql & "[coupon_exchange_point] [int] NOT NULL,"
			sql = sql & "[is_coupon_max] [tinyint] NOT NULL,"
			sql = sql & "[coupon_max] [int] NOT NULL,"
			sql = sql & "[coupon_member_group] [nvarchar] (250) NOT NULL,"
			sql = sql & "[coupon_member_get_limit] integer NOT NULL,"
			sql = sql & "[coupon_have_get] [int] NOT NULL,"
			sql = sql & "[coupon_have_used] [int] NOT NULL,"
			sql = sql & "[coupon_rule_type] [tinyint] NOT NULL,"
			sql = sql & "[cate_ids] [ntext] NULL,"
			sql = sql & "[gids] [ntext] NULL,"
			sql = sql & "[is_get_timelimit] [tinyint] NOT NULL,"
			sql = sql & "[get_starttime] [datetime] NOT NULL,"
			sql = sql & "[get_endtime] [datetime] NOT NULL,"
			sql = sql & "[is_can_mix_use] [tinyint] NOT NULL,"
			sql = sql & "[use_min_money] [money] NOT NULL,"
			sql = sql & "[is_use_timelimit] [tinyint] NOT NULL,"
			sql = sql & "[use_starttime] [datetime] NOT NULL,"
			sql = sql & "[use_endtime] [datetime] NOT NULL,"
			sql = sql & "[desc] [ntext] NULL,"
			sql = sql & "[tpl] [nvarchar] (50) NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[seo_title] [nvarchar] (250) NULL,"
			sql = sql & "[keywords] [nvarchar] (250) NULL,"
			sql = sql & "[description] [nvarchar] (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_coupon_id ON ["& table &"] ([coupon_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function coupon_data()
		table = DB_PRE &"coupon_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[coupon_id] integer NOT NULL,"
			sql = sql & "[coupon_code] text (32) NOT NULL,"
			sql = sql & "[exchange_point] integer NOT NULL,"
			sql = sql & "[is_used] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[get_time] date NOT NULL,"
			sql = sql & "[use_time] date NULL,"
			sql = sql & "[use_money] currency NOT NULL,"
			sql = sql & "[operater_uid] integer NOT NULL,"
			sql = sql & "[ip] text (64) NULL,"
			sql = sql & "[is_user_deleted] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[coupon_id] [int] NOT NULL,"
			sql = sql & "[coupon_code] [nvarchar] (32) NOT NULL,"
			sql = sql & "[exchange_point] [int] NOT NULL,"
			sql = sql & "[is_used] [tinyint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[get_time] [datetime] NOT NULL,"
			sql = sql & "[use_time] [datetime] NULL,"
			sql = sql & "[use_money] [money] NOT NULL,"
			sql = sql & "[operater_uid] [int] NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL,"
			sql = sql & "[is_user_deleted] [tinyint] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function payment()
		table   = DB_PRE &"payment"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[pay_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_mobile] integer NOT NULL,"
			sql = sql & "[is_charge] integer NOT NULL,"
			sql = sql & "[pay_code] text (20) NOT NULL,"
			sql = sql & "[pay_name] text (100) NOT NULL,"
			sql = sql & "[pay_logo] text (255) NULL,"
			sql = sql & "[pay_fee] currency NOT NULL,"
			sql = sql & "[pay_fee_type] integer NOT NULL,"
			sql = sql & "[pay_config] memo NOT NULL,"
			sql = sql & "[pay_desc] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[pay_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[is_mobile] [tinyint] NOT NULL,"
			sql = sql & "[is_charge] integer NOT NULL,"
			sql = sql & "[pay_code] [nvarchar] (20) NOT NULL,"
			sql = sql & "[pay_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[pay_logo] [nvarchar] (255) NULL,"
			sql = sql & "[pay_fee] [money] NOT NULL,"
			sql = sql & "[pay_fee_type] [tinyint] NOT NULL,"
			sql = sql & "[pay_config] [ntext] NOT NULL,"
			sql = sql & "[pay_desc] [ntext] NULL,"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([pay_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function pay_trade_log()
		table   = DB_PRE &"pay_trade_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[operater_uid] integer NULL,"         '操作人(用户id)
			sql = sql & "[uid] integer NULL,"                  '被操作用户id
			sql = sql & "[trade_no] text (20) NOT NULL,"       '支付交易号
			sql = sql & "[trade_type] integer NOT NULL,"       '交易类型(0:会员余额充值,1:订单支付)
			sql = sql & "[order_id] text (20) NULL,"           '对应订单表的order_id
			sql = sql & "[currency] text (8) NOT NULL,"        '货币
			sql = sql & "[trade_fee] currency NOT NULL,"       '手续费
			sql = sql & "[trade_money] currency NOT NULL,"     '交易金额
			sql = sql & "[trade_desc] text (250) NULL,"        '交易备注
			sql = sql & "[trade_status] text (10) NULL,"       '交易状态(ready:等待支付,failed:支付失败,success:支付完成)
			sql = sql & "[bank_trade_no] text (64) NOT NULL,"  '银行交易号(支付宝返回的交易号)
			sql = sql & "[pay_id] integer NOT NULL,"           '支付方式id (对应payment表的pay_id)
			sql = sql & "[pay_code] text (20) NOT NULL,"       '支付方式代码(对应payment表的pay_code)
			sql = sql & "[pay_name] text (100) NOT NULL,"      '支付方式名称(对应payment表的pay_name)
			sql = sql & "[bank_code] text (64) NULL,"          '银行简码
			sql = sql & "[date_start] date NOT NULL,"          '支付开始时间
			sql = sql & "[date_end] date NULL,"                '支付完成时间
			sql = sql & "[referer] text (255) NULL,"           '交易来源页面
			sql = sql & "[ip] text (64) NULL"                  '客户端ip
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[operater_uid] [int] NULL,"
			sql = sql & "[uid] [int] NULL,"
			sql = sql & "[trade_no] [nvarchar] (20) NOT NULL,"
			sql = sql & "[trade_type] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (20) NULL,"
			sql = sql & "[currency] [nvarchar] (8) NOT NULL,"
			sql = sql & "[trade_fee] [money] NOT NULL,"
			sql = sql & "[trade_money] [money] NOT NULL,"
			sql = sql & "[trade_desc] [nvarchar] (250) NULL,"
			sql = sql & "[trade_status] [nvarchar] (10) NULL,"
			sql = sql & "[bank_trade_no] [nvarchar] (64) NOT NULL,"
			sql = sql & "[pay_id] [int] NOT NULL,"
			sql = sql & "[pay_code] [nvarchar] (20) NOT NULL,"
			sql = sql & "[pay_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_code] [nvarchar] (64) NULL,"
			sql = sql & "[date_start] [datetime] NOT NULL,"
			sql = sql & "[date_end] [datetime] NULL,"
			sql = sql & "[referer] [nvarchar] (255) NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function delivery()
		table   = DB_PRE &"delivery"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[dly_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[dly_code] text (20) NOT NULL,"
			sql = sql & "[dly_name] text (100) NOT NULL,"
			sql = sql & "[dly_logo] text (255) NULL,"
			sql = sql & "[dly_fee] currency NOT NULL,"     '快递费用
			sql = sql & "[dly_fee_type] integer NOT NULL," '快递费用方式(0:直接设置金额,1:按订单金额百分比)
			sql = sql & "[dly_cod] integer NOT NULL,"      '是否支持货到付款
			sql = sql & "[dly_config] memo NOT NULL,"
			sql = sql & "[dly_desc] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[dly_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[dly_code] [nvarchar] (20) NOT NULL,"
			sql = sql & "[dly_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[dly_logo] [nvarchar] (255) NULL,"
			sql = sql & "[dly_fee] [money] NOT NULL,"
			sql = sql & "[dly_fee_type] [tinyint] NOT NULL,"
			sql = sql & "[dly_cod] [tinyint] NOT NULL,"
			sql = sql & "[dly_config] [ntext] NOT NULL,"
			sql = sql & "[dly_desc] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([dly_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function delivery_corp()
		table   = DB_PRE &"delivery_corp"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[corp_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[corp_code] text (20) NOT NULL,"
			sql = sql & "[corp_name] text (100) NOT NULL,"
			sql = sql & "[corp_logo] text (255) NULL,"
			sql = sql & "[corp_url] text (255) NULL,"
			sql = sql & "[corp_desc] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[corp_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[corp_code] [nvarchar] (20) NOT NULL,"
			sql = sql & "[corp_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[corp_logo] [nvarchar] (255) NULL,"
			sql = sql & "[corp_url] [nvarchar] (255) NULL,"
			sql = sql & "[corp_desc] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([corp_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function delivery_region()
		table = DB_PRE &"delivery_region"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[dly_id] integer NOT NULL,"
			sql = sql & "[zone_name] text (100) NOT NULL,"
			sql = sql & "[zone_region_ids] memo NOT NULL,"
			sql = sql & "[zone_dly_config] memo NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[dly_id] [int] NOT NULL,"
			sql = sql & "[zone_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[zone_region_ids] [ntext] NOT NULL,"
			sql = sql & "[zone_dly_config] [ntext] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods()
		table = DB_PRE &"goods"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[cate_id] integer NOT NULL,"
			sql = sql & "[ex1_cate_id] integer NULL,"
			sql = sql & "[ex2_cate_id] integer NULL,"
			sql = sql & "[type_id1] text (100) NULL,"
			sql = sql & "[type_id2] text (100) NULL,"
			sql = sql & "[type_id3] text (100) NULL,"
			sql = sql & "[type_id4] text (100) NULL,"
			sql = sql & "[type_id5] text (100) NULL,"
			sql = sql & "[type_id6] text (100) NULL,"
			sql = sql & "[type_id7] text (100) NULL,"
			sql = sql & "[type_id8] text (100) NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[is_book] integer NOT NULL,"
			sql = sql & "[book_front_money_rate] currency NULL,"
			sql = sql & "[book_price_discount] currency NULL,"
			sql = sql & "[book_final_pay_day] integer NULL,"
			sql = sql & "[book_arrival_time] integer NULL,"
			sql = sql & "[is_book_timelimit] integer NULL,"
			sql = sql & "[book_starttime] date NULL,"
			sql = sql & "[book_endtime] date NULL,"
			sql = sql & "[goods_sn] text (28) NOT NULL,"
			sql = sql & "[barcode] text (32) NULL,"
			sql = sql & "[market_price] currency NOT NULL,"
			sql = sql & "[price] currency NOT NULL,"
			sql = sql & "[thumbnail] text (255) NULL,"
			sql = sql & "[spec_id] text (32) NULL,"
			sql = sql & "[type_id] integer NULL,"
			sql = sql & "[form_id] integer NOT NULL,"
			sql = sql & "[is_need_ship] integer NOT NULL,"
			sql = sql & "[brand_id] integer NOT NULL,"
			sql = sql & "[sales] integer NOT NULL,"
			sql = sql & "[comments] integer NOT NULL,"
			sql = sql & "[title] text (100) NOT NULL,"
			sql = sql & "[font_color] text (7) NULL,"
			sql = sql & "[font_weight] integer NULL,"
			sql = sql & "[root_id] integer NULL,"
			sql = sql & "[rootpath] text (64) NULL,"
			sql = sql & "[subtitle] text (100) NULL,"
			sql = sql & "[urlpath] text (64) NULL,"
			sql = sql & "[url] text (255) NULL,"
			sql = sql & "[views] integer NOT NULL,"
			sql = sql & "[post_time] date NULL,"
			sql = sql & "[update_time] date NULL,"
			sql = sql & "[summary] text (250) NULL,"
			sql = sql & "[recommend] integer NOT NULL,"
			sql = sql & "[weight] integer NULL,"
			sql = sql & "[dly_fee_type] integer NULL,"
			sql = sql & "[dly_fee] currency NULL,"
			sql = sql & "[dly_id] integer NULL,"
			sql = sql & "[quota] integer NULL,"
			sql = sql & "[point_set] integer NULL,"
			sql = sql & "[point_get_type] integer NULL,"
			sql = sql & "[point_get_amount] integer NULL,"
			sql = sql & "[point_pay_amount] integer NULL,"
			sql = sql & "[commission_type] integer NULL,"
			sql = sql & "[commission_rate] currency NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ex1_cate_id ON ["& table &"] ([ex1_cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ex2_cate_id ON ["& table &"] ([ex2_cate_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[cate_id] [int] NOT NULL,"
			sql = sql & "[ex1_cate_id] [int] NULL,"
			sql = sql & "[ex2_cate_id] [int] NULL,"
			sql = sql & "[type_id1] [nvarchar] (100) NULL,"
			sql = sql & "[type_id2] [nvarchar] (100) NULL,"
			sql = sql & "[type_id3] [nvarchar] (100) NULL,"
			sql = sql & "[type_id4] [nvarchar] (100) NULL,"
			sql = sql & "[type_id5] [nvarchar] (100) NULL,"
			sql = sql & "[type_id6] [nvarchar] (100) NULL,"
			sql = sql & "[type_id7] [nvarchar] (100) NULL,"
			sql = sql & "[type_id8] [nvarchar] (100) NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[is_book] [tinyint] NOT NULL,"
			sql = sql & "[book_front_money_rate] [money] NULL,"
			sql = sql & "[book_price_discount] [money] NULL,"
			sql = sql & "[book_final_pay_day] [int] NULL,"
			sql = sql & "[book_arrival_time] [int] NULL,"
			sql = sql & "[is_book_timelimit] [tinyint] NULL,"
			sql = sql & "[book_starttime] [datetime] NULL,"
			sql = sql & "[book_endtime] [datetime] NULL,"
			sql = sql & "[goods_sn] [nvarchar] (28) NOT NULL,"
			sql = sql & "[barcode] [nvarchar] (32) NULL,"
			sql = sql & "[market_price] [money] NOT NULL,"
			sql = sql & "[price] [money] NOT NULL,"
			sql = sql & "[thumbnail] [nvarchar] (255) NULL,"
			sql = sql & "[spec_id] [nvarchar] (32) NULL,"
			sql = sql & "[type_id] [int] NULL,"
			sql = sql & "[form_id] [int] NOT NULL,"
			sql = sql & "[is_need_ship] [int] NOT NULL,"
			sql = sql & "[brand_id] [int] NOT NULL,"
			sql = sql & "[sales] [int] NOT NULL,"
			sql = sql & "[comments] [int] NOT NULL,"
			sql = sql & "[title] [nvarchar] (100) NOT NULL,"
			sql = sql & "[font_color] [nvarchar] (7) NULL,"
			sql = sql & "[font_weight] [int] NULL,"
			sql = sql & "[root_id] [int] NULL,"
			sql = sql & "[rootpath] [nvarchar] (64) NULL,"
			sql = sql & "[subtitle] [nvarchar] (100) NULL,"
			sql = sql & "[urlpath] [nvarchar] (64) NULL,"
			sql = sql & "[url] [nvarchar] (255) NULL,"
			sql = sql & "[views] [int] NOT NULL,"
			sql = sql & "[post_time] [datetime] NULL,"
			sql = sql & "[update_time] [datetime] NULL,"
			sql = sql & "[summary] [nvarchar] (250) NULL,"
			sql = sql & "[recommend] [tinyint] NOT NULL,"
			sql = sql & "[weight] [int] NULL,"
			sql = sql & "[dly_fee_type] [int] NULL,"
			sql = sql & "[dly_fee] [money] NULL,"
			sql = sql & "[dly_id] [int] NULL,"
			sql = sql & "[quota] [int] NULL,"
			sql = sql & "[point_set] [tinyint] NULL,"
			sql = sql & "[point_get_type] [tinyint] NULL,"
			sql = sql & "[point_get_amount] [int] NULL,"
			sql = sql & "[point_pay_amount] [int] NULL,"
			sql = sql & "[commission_type] [int] NULL,"
			sql = sql & "[commission_rate] [money] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
			aresult = OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ex1_cate_id ON ["& table &"] ([ex1_cate_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_ex2_cate_id ON ["& table &"] ([ex2_cate_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_attr()
		table   = DB_PRE &"goods_attr"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[type_id] integer NOT NULL,"
			sql = sql & "[attr_id] integer NOT NULL,"
			sql = sql & "[attr_value] text (250) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[type_id] [int] NOT NULL,"
			sql = sql & "[attr_id] [int] NOT NULL,"
			sql = sql & "[attr_value] [nvarchar] (250) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_data()
		table = DB_PRE &"goods_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[seo_title] text (250) NULL,"
			sql = sql & "[keywords] text (250) NULL,"
			sql = sql & "[description] text (250) NULL,"
			sql = sql & "[content] memo NULL,"
			sql = sql & "[mob_content] memo NULL,"
			sql = sql & "[images] memo NULL,"
			sql = sql & "[tpl_inherit] integer NULL,"
			sql = sql & "[tpl] text (50) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[seo_title] [nvarchar] (250) NULL,"
			sql = sql & "[keywords] [nvarchar] (250) NULL,"
			sql = sql & "[description] [nvarchar] (250) NULL,"
			sql = sql & "[content] [ntext] NULL,"
			sql = sql & "[mob_content] [ntext] NULL,"
			sql = sql & "[images] [ntext] NULL,"
			sql = sql & "[tpl_inherit] [int] NULL,"
			sql = sql & "[tpl] [nvarchar] (50) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_comment()
		table = DB_PRE &"goods_comment"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cmt_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[pid] integer NOT NULL,"
			sql = sql & "[spec_value] text (250) NOT NULL,"
			sql = sql & "[approved] integer NOT NULL,"
			sql = sql & "[cmt_uid] integer NOT NULL,"
			sql = sql & "[cmt_author] text (32) NOT NULL,"
			sql = sql & "[cmt_author_ip] text (64) NOT NULL,"
			sql = sql & "[cmt_date] date NOT NULL,"
			sql = sql & "[cmt_type] integer NOT NULL,"
			sql = sql & "[cmt_content] memo NOT NULL,"
			sql = sql & "[cmt_agent] text (250) NOT NULL," '评论来源客户端信息
			sql = sql & "[reply_uid] integer NOT NULL,"
			sql = sql & "[reply_date] date NOT NULL,"
			sql = sql & "[reply_content] text (250) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cmt_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[pid] [int] NOT NULL,"
			sql = sql & "[spec_value] [nvarchar] (250) NULL,"
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[cmt_uid] [int] NOT NULL,"
			sql = sql & "[cmt_author] [nvarchar] (32) NOT NULL,"
			sql = sql & "[cmt_author_ip] [nvarchar] (64) NULL,"
			sql = sql & "[cmt_date] [datetime] NOT NULL,"
			sql = sql & "[cmt_type] [int] NOT NULL,"
			sql = sql & "[cmt_content] [nvarchar] (250) NULL,"
			sql = sql & "[cmt_agent] [nvarchar] (250) NOT NULL,"
			sql = sql & "[reply_uid] [int] NOT NULL,"
			sql = sql & "[reply_date] [datetime] NULL,"
			sql = sql & "[reply_content] [nvarchar] (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cmt_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_consultation()
		table = DB_PRE &"goods_consultation"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cst_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[approved] integer NOT NULL,"
			sql = sql & "[cst_uid] integer NOT NULL,"
			sql = sql & "[cst_author] text (32) NOT NULL,"
			sql = sql & "[cst_author_email] text (64) NULL,"
			sql = sql & "[cst_author_ip] text (64) NOT NULL,"
			sql = sql & "[cst_date] date NOT NULL,"
			sql = sql & "[cst_type] integer NOT NULL,"
			sql = sql & "[cst_content] text (250) NOT NULL,"
			sql = sql & "[cst_agent] text (250) NOT NULL,"
			sql = sql & "[reply_uid] integer NOT NULL,"
			sql = sql & "[reply_date] date NULL,"
			sql = sql & "[reply_content] text (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cst_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[cst_uid] [int] NOT NULL,"
			sql = sql & "[cst_author] [nvarchar] (32) NOT NULL,"
			sql = sql & "[cst_author_email] [nvarchar] (64) NULL,"
			sql = sql & "[cst_author_ip] [nvarchar] (64) NULL,"
			sql = sql & "[cst_date] [datetime] NOT NULL,"
			sql = sql & "[cst_type] [int] NOT NULL,"
			sql = sql & "[cst_content] [nvarchar] (250) NULL,"
			sql = sql & "[cst_agent] [nvarchar] (250) NOT NULL,"
			sql = sql & "[reply_uid] [int] NOT NULL,"
			sql = sql & "[reply_date] [datetime] NULL,"
			sql = sql & "[reply_content] [nvarchar] (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cst_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_favorite()
		table = DB_PRE &"goods_favorite"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_uid ON ["& table &"] ([uid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_related()
		table = DB_PRE &"goods_related"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[related_gid] integer NOT NULL,"
			sql = sql & "[related_cid] integer NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[related_gid] [int] NOT NULL,"
			sql = sql & "[related_cid] [int] NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_price()
		table = DB_PRE &"goods_price"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[pid] integer NOT NULL,"
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[market_price] currency NULL,"
			sql = sql & "[price] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
			aresult = OW.DB.execute("CREATE INDEX IDX_pid ON ["& table &"] ([pid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[pid] [int] NOT NULL,"
			sql = sql & "[group_id] [int] NOT NULL,"
			sql = sql & "[market_price] [money] NULL,"
			sql = sql & "[price] [money] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			'**aresult = OW.DB.execute("CREATE INDEX IDX_site_id ON ["& table &"] ([site_id])")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
			aresult = OW.DB.execute("CREATE INDEX IDX_pid ON ["& table &"] ([pid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_spec()
		table   = DB_PRE &"goods_spec"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[spec_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[spec_name] text (50) NOT NULL,"
			sql = sql & "[spec_type] integer NOT NULL,"
			sql = sql & "[spec_select_type] integer NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_spec_id ON ["& table &"] ([spec_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[spec_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[spec_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[spec_type] [int] NOT NULL,"
			sql = sql & "[spec_select_type] [int] NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_spec_id ON ["& table &"] ([spec_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_spec_value()
		table   = DB_PRE &"goods_spec_value"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[value_id] integer NOT NULL,"
			sql = sql & "[spec_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[value_name] text (50) NOT NULL,"
			sql = sql & "[value_alias] text (50) NOT NULL,"
			sql = sql & "[value_image] text (255) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_value_id ON ["& table &"] ([value_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[value_id] [int] NOT NULL,"
			sql = sql & "[spec_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[value_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[value_alias] [nvarchar] (50) NOT NULL,"
			sql = sql & "[value_image] [nvarchar] (255) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_value_id ON ["& table &"] ([value_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_suit()
		table = DB_PRE &"goods_suit"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[suit_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[suit_name] text (100) NOT NULL,"
			sql = sql & "[suit_discount_type] integer NOT NULL,"
			sql = sql & "[suit_discount] currency NOT NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[suit_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[suit_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[suit_discount_type] [tinyint] NOT NULL,"
			sql = sql & "[suit_discount] [money] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([suit_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_suit_goods()
		table = DB_PRE &"goods_suit_goods"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[suit_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[suit_gid] integer NOT NULL,"
			sql = sql & "[suit_pid] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[suit_id] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[suit_gid] [int] NOT NULL,"
			sql = sql & "[suit_pid] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_product()
		table   = DB_PRE &"goods_product"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[pid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[product_sn] text (32) NOT NULL,"
			sql = sql & "[spec_value_id] text (32) NOT NULL,"
			sql = sql & "[spec_value] text (250) NOT NULL,"
			sql = sql & "[stock] integer NOT NULL,"
			sql = sql & "[stock_default] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_pid ON ["& table &"] ([pid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[pid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[product_sn] [nvarchar] (32) NOT NULL,"
			sql = sql & "[spec_value_id] [nvarchar] (32) NOT NULL,"
			sql = sql & "[spec_value] [nvarchar] (250) NOT NULL,"
			sql = sql & "[stock] [int] NOT NULL,"
			sql = sql & "[stock_default] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_pid ON ["& table &"] ([pid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_type()
		table   = DB_PRE &"goods_type"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[type_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[type_name] text (50) NOT NULL,"
			sql = sql & "[description] text (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_type_id ON ["& table &"] ([type_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[type_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[type_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[description] [nvarchar] (80) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_type_id ON ["& table &"] ([type_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_type_attr()
		table   = DB_PRE &"goods_type_attr"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[attr_id] integer NOT NULL,"
			sql = sql & "[type_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[attr_name] text (50) NOT NULL,"
			sql = sql & "[attr_type] integer NOT NULL,"
			sql = sql & "[attr_input_type] integer NULL,"
			sql = sql & "[attr_value] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_attr_id ON ["& table &"] ([attr_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[attr_id] [int] NOT NULL,"
			sql = sql & "[type_id] [int] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[attr_name] [nvarchar] (50) NOT NULL,"
			sql = sql & "[attr_type] [int] NOT NULL,"
			sql = sql & "[attr_input_type] [int] NOT NULL,"
			sql = sql & "[attr_value] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_attr_id ON ["& table &"] ([attr_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function goods_value()
		table   = DB_PRE &"goods_value"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[spec_id] integer NOT NULL,"
			sql = sql & "[value_id] integer NOT NULL,"
			sql = sql & "[value_name] text (100) NULL,"
			sql = sql & "[value_image] text (255) NULL,"
			sql = sql & "[value_images] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[spec_id] [int] NOT NULL,"
			sql = sql & "[value_id] [int] NOT NULL,"
			sql = sql & "[value_name] [nvarchar] (100) NULL,"
			sql = sql & "[value_image] [nvarchar] (255) NULL,"
			sql = sql & "[value_images] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_gid ON ["& table &"] ([gid])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function invoice()
		table = DB_PRE &"invoice"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[invoice_type] integer NOT NULL,"
			sql = sql & "[invoice_title] text (250) NOT NULL,"
			sql = sql & "[invoice_content_type] integer NOT NULL,"
			sql = sql & "[invoice_content] text (250) NOT NULL,"
			sql = sql & "[invoice_data] memo NOT NULL,"
			sql = sql & "[add_time] date NOT NULL,"
			sql = sql & "[edit_time] date NULL,"
			sql = sql & "[ip] text (64) NULL,"
			sql = sql & "[status] integer NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[invoice_type] [int] NOT NULL,"
			sql = sql & "[invoice_title] [nvarchar] (250) NOT NULL,"
			sql = sql & "[invoice_content_type] [tinyint] NOT NULL,"
			sql = sql & "[invoice_content] [nvarchar] (250) NOT NULL,"
			sql = sql & "[invoice_data] [ntext] NOT NULL,"
			sql = sql & "[add_time] [datetime] NOT NULL,"
			sql = sql & "[edit_time] [datetime] NULL,"
			sql = sql & "[status] [tinyint] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_charge_config()
		table = DB_PRE &"member_charge_config"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[group_id] integer NOT NULL,"
			sql = sql & "[to_group_id] integer NOT NULL,"
			sql = sql & "[charge_amount] currency NOT NULL,"
			sql = sql & "[starttime] date NOT NULL,"
			sql = sql & "[endtime] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[cid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[group_id] [int] NOT NULL,"
			sql = sql & "[to_group_id] [int] NOT NULL,"
			sql = sql & "[charge_amount] [money] NOT NULL,"
			sql = sql & "[starttime] [datetime] NOT NULL,"
			sql = sql & "[endtime] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_commission_log()
		table = DB_PRE &"member_commission_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NULL,"
			sql = sql & "[gid] integer NOT NULL,"
			sql = sql & "[goods_name] text (250) NOT NULL,"
			sql = sql & "[goods_amount] integer NOT NULL,"
			sql = sql & "[goods_price] currency NOT NULL,"
			sql = sql & "[goods_sum] currency NOT NULL,"
			sql = sql & "[commission_uid] integer NOT NULL,"
			sql = sql & "[commission_money] currency NOT NULL,"
			sql = sql & "[commission_status] integer NOT NULL,"
			sql = sql & "[commission_charge_time] date NOT NULL,"
			sql = sql & "[logtime] date NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[goods_name] [nvarchar] (250) NOT NULL,"
			sql = sql & "[goods_amount] [int] NOT NULL,"
			sql = sql & "[goods_price] [money] NOT NULL,"
			sql = sql & "[goods_sum] [money] NOT NULL,"
			sql = sql & "[commission_uid] [int] NOT NULL,"
			sql = sql & "[commission_money] [money] NOT NULL,"
			sql = sql & "[commission_status] [int] NOT NULL,"
			sql = sql & "[commission_charge_time] [datetime] NOT NULL,"
			sql = sql & "[logtime] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_commission_drawcash()
		table = DB_PRE &"member_commission_drawcash"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[approved] integer NOT NULL,"
			sql = sql & "[drawcash_money] currency NOT NULL,"
			sql = sql & "[bank_type] integer NOT NULL,"
			sql = sql & "[bank_name] text (100) NOT NULL,"
			sql = sql & "[bank_account] text (100) NOT NULL,"
			sql = sql & "[bank_account_name] text (100) NOT NULL,"
			sql = sql & "[ip] text (64) NULL,"
			sql = sql & "[date_apply] date NOT NULL,"
			sql = sql & "[date_drawcash] date NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [int] NOT NULL,"
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[drawcash_money] [money] NOT NULL,"
			sql = sql & "[bank_type] [int] NOT NULL,"
			sql = sql & "[bank_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL,"
			sql = sql & "[date_apply] [datetime] NOT NULL,"
			sql = sql & "[date_drawcash] [datetime] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_data()
		table = DB_PRE &"member_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[cart_data] memo NULL,"
			sql = sql & "[latest_view_data] memo NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[cart_data] [ntext] NULL,"
			sql = sql & "[latest_view_data] [ntext] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function member_deposit_drawcash()
		table = DB_PRE &"member_deposit_drawcash"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[approved] integer NOT NULL,"
			sql = sql & "[drawcash_money] currency NOT NULL,"
			sql = sql & "[bank_type] integer NOT NULL,"
			sql = sql & "[bank_name] text (100) NOT NULL,"
			sql = sql & "[bank_account] text (100) NOT NULL,"
			sql = sql & "[bank_account_name] text (100) NOT NULL,"
			sql = sql & "[ip] text (64) NULL,"
			sql = sql & "[date_apply] date NOT NULL,"
			sql = sql & "[date_drawcash] date NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[logid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [int] NOT NULL,"
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[drawcash_money] [money] NOT NULL,"
			sql = sql & "[bank_type] [int] NOT NULL,"
			sql = sql & "[bank_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL,"
			sql = sql & "[date_apply] [datetime] NOT NULL,"
			sql = sql & "[date_drawcash] [datetime] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([logid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function offline_store()
		table = DB_PRE &"offline_store"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[store_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[store_mobile] text (11) NOT NULL,"
			sql = sql & "[is_deposit] integer NOT NULL,"
			sql = sql & "[store_name] text (100) NOT NULL,"
			sql = sql & "[store_address] text (250) NOT NULL,"
			sql = sql & "[store_mapgps] text (32) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[store_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[status] [tinyint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[store_mobile] [nvarchar] (11) NOT NULL,"
			sql = sql & "[is_deposit] [int] NOT NULL,"
			sql = sql & "[store_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[store_address] [nvarchar] (250) NOT NULL,"
			sql = sql & "[store_mapgps] [nvarchar] (32) NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([store_id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function orders()
		table   = DB_PRE &"orders"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"    '站点id
			sql = sql & "[order_id] text (18) NOT NULL," '订单号
			sql = sql & "[order_type] integer NOT NULL," '订单类型(0:普通商品,1:余额充值,2:积分充值)
			sql = sql & "[approved] integer NOT NULL,"   '订单是否已确认(0:未确认,1:已确认)
			sql = sql & "[uid] integer NOT NULL,"            '下单会员id
			sql = sql & "[status] integer NOT NULL,"         '订单状态(0:正常,1:已取消[作废]) 
			sql = sql & "[weight] number NULL,"              '订单重量
			sql = sql & "[cost_item] currency NOT NULL,"     '商品总金额
			sql = sql & "[cost_invoice] currency NOT NULL,"  '税费
			sql = sql & "[cost_freight] currency NOT NULL,"  '物流费用
			sql = sql & "[cost_pay] currency NOT NULL,"      '支付费用，跟支付方式的配置相关
			sql = sql & "[cost_coupon] currency NOT NULL,"   '优惠券金额抵消
			sql = sql & "[discount] currency NOT NULL,"      '订单优惠
			sql = sql & "[total_amount] currency NOT NULL,"  '总金额(除去优惠后的金额，即应付款金额)
			sql = sql & "[is_book] integer NOT NULL,"            '预订订单
			sql = sql & "[book_front_money] currency NOT NULL,"  '预付款
			sql = sql & "[book_pay_open] integer NOT NULL,"      '尾款支付是否开启
			sql = sql & "[book_arrival_time] date NULL,"         '预计到货时间
			sql = sql & "[book_final_pay_time] date NULL,"       '尾款最迟支付时间，超过时间关闭支付通道
			
			sql = sql & "[money_paid] currency NOT NULL,"        '已支付金额
			sql = sql & "[money_refund] currency NOT NULL,"      '已退款金额
			
			sql = sql & "[is_paid] integer NOT NULL,"            '是否已支付(0:尚未支付完[部分支付算未支付完],1:已支付)
			sql = sql & "[pay_status] integer NOT NULL,"         '支付状态(0:未付款,1:部分支付,2:已全额支付)
			sql = sql & "[pay_refund_status] integer NOT NULL,"  '退款状态(0:未退款,1:部分退款,2:已全额退款)
			sql = sql & "[pay_id] integer NULL,"                 '支付方式id
			sql = sql & "[bank_code] text (64) NULL,"            '银行简码
			
			sql = sql & "[is_shipped] integer NOT NULL,"         '是否已发货(0:尚未发货完[部分发货算尚未发货完],1:已发货)
			sql = sql & "[ship_status] integer NOT NULL,"        '商品配送状态(-1:备货中,0:未发货,1:部分发货,2:所有已发货,3:所有已收货)
			sql = sql & "[ship_refund_status] integer NOT NULL," '退款状态(0:未退货,1:部分退货,2:已全部退货)
			sql = sql & "[dly_id] integer NOT NULL,"             '配送方式id
			sql = sql & "[dly_corp] integer NOT NULL,"           '物流公司
			
			sql = sql & "[inv_type] integer NULL,"       '发票类型(0:普通发票,1:增值税发票)
			sql = sql & "[inv_payee] text (120) NULL,"   '发票抬头，用户页面填写
			sql = sql & "[inv_content] text (250) NULL," '发票内容
			sql = sql & "[express_no] text (32) NULL,"   '快递单号
			sql = sql & "[to_buyer] text (250) NULL,"    '商家给客户的留言,当该字段有值时客户可以在订单详细中看到
			sql = sql & "[referer] text (255) NULL,"     '订单的来源页面
			sql = sql & "[ip] text (64) NULL,"           '订单的来源ip
			sql = sql & "[device_type] integer NULL,"    '订单的来源设备(0:PC端,1:移动端)
			sql = sql & "[device_info] text (250) NULL,"'订单的来源设备详细信息
			
			sql = sql & "[order_form_table] text (250) NULL,"       '订单表单名集合default,hotel(输出后需要解析成ow_order_form1_default,ow_order_form1_hotel)
			sql = sql & "[order_process_config] text (250) NULL,"   '订单处理流程默认值(1:订单提交,2:商品出库,3:正在配送,4:收货完成)
			sql = sql & "[order_name] text (250) NULL,"             '订单名称
			sql = sql & "[order_content] memo NULL,"                '订单详细内容(额外)
			sql = sql & "[invoice] memo NULL,"                      '发票信息
			
			sql = sql & "[date_added] date NOT NULL,"    '下单时间
			sql = sql & "[date_approved] date NULL,"     '核准/确认时间
			sql = sql & "[date_paid] date NULL,"         '付款时间
			sql = sql & "[date_shipped] date NULL,"      '发货时间
			sql = sql & "[date_modified] date NULL,"     '修改时间
			sql = sql & "[region_data] text (250) NULL,"
			sql = sql & "[region_names] text (250) NULL,"
			
			sql = sql & "[recomd_uid] integer NULL,"
			sql = sql & "[is_recycle] integer NULL,"
			sql = sql & "[is_user_recycle] integer NULL,"
			sql = sql & "[is_user_delete] integer NULL,"
			
			sql = sql & "[point_get_amount] integer NULL,"
			sql = sql & "[point_pay_amount] integer NULL,"
			sql = sql & "[offline_store_id] integer NULL,"
			sql = sql & "[order_commission] currency NULL,"
			sql = sql & "[remark] text (250) NULL,"
			sql = sql & "[flag] integer NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[order_type] [tinyint] NOT NULL," 
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [int] NOT NULL,"
			sql = sql & "[weight] [int] NULL,"
			sql = sql & "[cost_item] [money] NOT NULL,"
			sql = sql & "[cost_invoice] [money] NOT NULL,"
			sql = sql & "[cost_freight] [money] NOT NULL,"
			sql = sql & "[cost_pay] [money] NOT NULL,"
			sql = sql & "[cost_coupon] [money] NOT NULL,"
			sql = sql & "[discount] [money] NOT NULL,"
			sql = sql & "[total_amount] [money] NOT NULL,"
			sql = sql & "[is_book] [tinyint] NOT NULL,"
			sql = sql & "[book_front_money] [money] NOT NULL,"
			sql = sql & "[book_pay_open] integer NOT NULL,"
			sql = sql & "[book_final_pay_time] [datetime] NULL,"
			sql = sql & "[book_arrival_time] [datetime] NULL,"
			
			sql = sql & "[money_paid] [money] NOT NULL,"
			sql = sql & "[money_refund] [money] NOT NULL,"
			
			sql = sql & "[is_paid] [smallint] NOT NULL," 
			sql = sql & "[pay_status] [smallint] NOT NULL,"
			sql = sql & "[pay_refund_status] [smallint] NOT NULL,"
			sql = sql & "[pay_id] [int] NULL,"
			sql = sql & "[bank_code] [nvarchar] (64) NULL,"
			
			sql = sql & "[is_shipped] [smallint] NOT NULL,"
			sql = sql & "[ship_status] [smallint] NOT NULL,"
			sql = sql & "[ship_refund_status] [smallint] NOT NULL,"
			sql = sql & "[dly_id] [int] NOT NULL,"
			sql = sql & "[dly_corp] [int] NOT NULL,"
			
			sql = sql & "[inv_type] [smallint] NULL,"
			sql = sql & "[inv_payee] [nvarchar] (120) NULL,"
			sql = sql & "[inv_content] [nvarchar] (250) NULL,"
			sql = sql & "[express_no] [nvarchar] (32) NULL,"
			sql = sql & "[to_buyer] [nvarchar] (250) NULL,"
			sql = sql & "[referer] [nvarchar] (255) NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL,"
			sql = sql & "[device_type] [tinyint] NULL,"    '订单的来源设备(0:PC端,1:移动端)
			sql = sql & "[device_info] [nvarchar] (250) NULL,"'订单的来源设备详细信息
			
			sql = sql & "[order_form_table] [nvarchar] (250) NULL,"
			sql = sql & "[order_process_config] [nvarchar] (250) NULL,"
			sql = sql & "[order_name] [nvarchar] (250) NULL,"
			sql = sql & "[order_content] [ntext] NULL,"
			sql = sql & "[invoice] [ntext] NULL,"
			
			sql = sql & "[date_added] [datetime] NOT NULL,"
			sql = sql & "[date_approved] [datetime] NULL,"
			sql = sql & "[date_paid] [datetime] NULL,"
			sql = sql & "[date_shipped] [datetime] NULL,"
			sql = sql & "[date_modified] [datetime] NULL,"
			sql = sql & "[region_data] [nvarchar] (250) NULL,"
			sql = sql & "[region_names] [nvarchar] (250) NULL,"
			
			sql = sql & "[recomd_uid] [int] NULL,"
			sql = sql & "[is_recycle] [tinyint] NULL,"
			sql = sql & "[is_user_recycle] [tinyint] NULL,"
			sql = sql & "[is_user_delete] [tinyint] NULL,"
			
			sql = sql & "[point_get_amount] [int] NULL,"
			sql = sql & "[point_pay_amount] [int] NULL,"
			sql = sql & "[offline_store_id] [int] NULL,"
			sql = sql & "[order_commission] [money] NULL,"
			sql = sql & "[remark] [nvarchar] (250) NULL,"
			sql = sql & "[flag] [int] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_form_data()
		table = DB_PRE &"order_form_data"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[form_id] integer NOT NULL,"
			sql = sql & "[data] memo NULL,"
			sql = sql & "[is_default] integer NULL,"
			sql = sql & "[sequence] integer NOT NULL,"
			sql = sql & "[region_data] text (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[form_id] [int] NOT NULL,"
			sql = sql & "[data] [ntext] NULL,"
			sql = sql & "[is_default] [tinyint] NULL,"
			sql = sql & "[sequence] [int] NOT NULL,"
			sql = sql & "[region_data] [nvarchar] (250) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_goods()
		table   = DB_PRE &"order_goods"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"            '商品id
			sql = sql & "[pid] integer NOT NULL,"            '商品产品id
			sql = sql & "[goods_name] text (100) NULL,"      '商品名称
			sql = sql & "[goods_sn] text (28) NULL,"         '商品编号
			sql = sql & "[product_sn] text (32) NULL,"       '商品货号
			sql = sql & "[spec_value_id] text (32) NULL,"    '商品规格id
			sql = sql & "[spec_value] text (250) NULL,"      '商品规格
			sql = sql & "[goods_price] currency NOT NULL,"   '商品价格
			sql = sql & "[goods_amount] integer NOT NULL,"   '商品数量
			sql = sql & "[goods_sum] currency NOT NULL,"     '商品金额总计
			sql = sql & "[suit_id] integer NOT NULL,"        '是否预订
			sql = sql & "[is_book] integer NULL,"        '是否预订
			sql = sql & "[book_price_discount] currency NOT NULL,"'预订优惠价格
			sql = sql & "[have_ship_num] integer NOT NULL,"  '已发货数量
			sql = sql & "[have_refund_num] integer NOT NULL" '已退货数量
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"
			sql = sql & "[pid] [int] NOT NULL,"
			sql = sql & "[goods_name] [nvarchar] (100) NULL,"  '商品名称
			sql = sql & "[goods_sn] [nvarchar] (28) NULL,"     '商品编号
			sql = sql & "[product_sn] [nvarchar] (32) NULL,"   '商品货号
			sql = sql & "[spec_value_id] [nvarchar] (32) NULL,"'商品规格id
			sql = sql & "[spec_value] [nvarchar] (250) NULL,"  '商品规格
			sql = sql & "[goods_price] [money] NOT NULL,"
			sql = sql & "[goods_amount] [int] NOT NULL,"
			sql = sql & "[goods_sum] [money] NOT NULL,"
			sql = sql & "[suit_id] [int] NOT NULL,"
			sql = sql & "[is_book] [tinyint] NULL,"
			sql = sql & "[book_price_discount] [money] NOT NULL,"
			sql = sql & "[have_ship_num] [int] NOT NULL,"
			sql = sql & "[have_refund_num] [int] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_log()
		table   = DB_PRE &"order_log"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[log_id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"           '操作人
			sql = sql & "[log_action] text (20) NOT NULL,"  '订单操作行为(create:创建订单,pay:订单付款,pay_refund:订单退款,ship_prepare:订单配货,ship:订单发货,ship_receiving:确认收货,ship_refund:订单退货,approved:订单确认,cancel:取消订单)
			sql = sql & "[log_result] text (8) NOT NULL,"   '订单操作结果(success:成功，failed:失败)
			sql = sql & "[log_desc] text (250) NOT NULL,"   '日志详细
			sql = sql & "[log_time] date NOT NULL"          '操作时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[log_id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[log_action] [nvarchar] (20) NOT NULL,"
			sql = sql & "[log_result] [nvarchar] (8) NOT NULL,"
			sql = sql & "[log_desc] [nvarchar] (250) NOT NULL,"
			sql = sql & "[log_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([log_id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_process()
		table   = DB_PRE &"order_process"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[process_type] integer NOT NULL,"  '进程标识
			sql = sql & "[process_tips] text (250) NULL,"   '进程提示
			sql = sql & "[process_time] date NOT NULL"      '进程时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[process_type] [int] NOT NULL,"
			sql = sql & "[process_tips] [nvarchar] (250) NULL,"
			sql = sql & "[process_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_process_detail()
		table   = DB_PRE &"order_process_detail"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[process_desc] text (250) NOT NULL," '描述
			sql = sql & "[process_tips] text (250) NULL,"     '进程提示
			sql = sql & "[process_time] date NOT NULL"        '时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[process_desc] [nvarchar] (250) NOT NULL,"
			sql = sql & "[process_tips] [nvarchar] (250) NULL,"
			sql = sql & "[process_time] [datetime] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_pay_bill()
		table   = DB_PRE &"order_pay_bill"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[bill_id] text (20) NOT NULL,"   '单据号
			sql = sql & "[bill_type] integer NOT NULL,"   '单据类型(0:收款单据,1:退款单据)
			sql = sql & "[order_id] text (18) NOT NULL,"  '订单号
			sql = sql & "[admin_uid] integer NOT NULL,"   '如果是管理员操作的则记录管理员uid
			sql = sql & "[uid] integer NOT NULL,"         '如果是客户在线付款操作的则记录客户的uid
			sql = sql & "[bank] text (100) NULL,"         '收款银行-退款银行
			sql = sql & "[account] text (100) NULL,"      '收款银行账号-退款银行账号
			sql = sql & "[customer_bank] text (100) NULL,"     '对方(客户)银行
			sql = sql & "[customer_account] text (100) NULL,"  '对方(客户)银行账号
			sql = sql & "[currency] text (8) NULL,"       '货币
			sql = sql & "[currency_money] currency NULL," '货币金额
			sql = sql & "[cost_pay] currency NULL,"       '手续费
			sql = sql & "[money] currency NULL,"          '转换为本站货币(人民币)后的金额
			sql = sql & "[trade_no] text (20) NULL,"      '支付交易号(对应pay_trade_log表的trade_no)
			sql = sql & "[pay_status] integer NULL,"      '支付状态(0:等待到账,1已支付到帐)
			sql = sql & "[pay_id] integer NULL,"          '支付方式id(对应payment表的pay_id)
			sql = sql & "[pay_code] text (20) NULL,"      '支付方式代码(对应payment表的pay_code)
			sql = sql & "[pay_name] text (100) NULL,"     '支付方式代码(对应payment表的pay_name)
			sql = sql & "[bill_desc] text (250) NULL,"    '备注
			sql = sql & "[ip] text (64) NULL,"            '客户端ip
			sql = sql & "[date_added] date NOT NULL,"     '单据生成时间
			sql = sql & "[date_paid] date NULL"           '支付时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[bill_id] [nvarchar] (20) NOT NULL,"   '单据号
			sql = sql & "[bill_type] [smallint] NOT NULL,"      '单据类型(0:收款单据,1:退款单据)
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"  '订单号
			sql = sql & "[admin_uid] [int] NOT NULL,"           '如果是管理员操作的则记录管理员uid
			sql = sql & "[uid] [int] NOT NULL,"                 '如果是客户在线付款操作的则记录客户的uid
			sql = sql & "[bank] [nvarchar] (100) NULL,"         '收款银行-退款银行
			sql = sql & "[account] [nvarchar] (100) NULL,"      '收款银行账号-退款银行账号
			sql = sql & "[customer_bank] [nvarchar] (100) NULL,"     '对方(客户)银行
			sql = sql & "[customer_account] [nvarchar] (100) NULL,"  '对方(客户)银行账号
			sql = sql & "[currency] [nvarchar] (8) NULL,"       '货币
			sql = sql & "[currency_money] [money] NULL,"        '货币金额
			sql = sql & "[cost_pay] [money] NULL,"              '手续费
			sql = sql & "[money] [money] NULL,"                 '转换为本站货币(人民币)后的金额
			sql = sql & "[trade_no] [nvarchar] (20) NULL,"      '支付交易号(对应pay_trade_log表的trade_no)
			sql = sql & "[pay_status] [smallint] NULL,"         '支付状态(0:等待到账,1:已支付到帐)
			sql = sql & "[pay_id] [int] NULL,"                  '支付方式id(对应payment表的pay_id)
			sql = sql & "[pay_code] [nvarchar] (20) NULL,"      '支付方式代码(对应payment表的pay_code)
			sql = sql & "[pay_name] [nvarchar] (100) NULL,"     '支付方式代码(对应payment表的pay_name)
			sql = sql & "[bill_desc] [nvarchar] (250) NULL,"    '备注
			sql = sql & "[ip] [nvarchar] (64) NULL,"            '客户端ip
			sql = sql & "[date_added] [datetime] NOT NULL,"     '单据生成时间
			sql = sql & "[date_paid] [datetime] NULL"           '支付时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_refund_apply()
		table = DB_PRE &"order_refund_apply"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[status] integer NOT NULL,"
			sql = sql & "[approved] integer NOT NULL,"'0:待审核，1:已同意
			sql = sql & "[refund_money] currency NOT NULL,"
			sql = sql & "[refund_reason] text (250) NOT NULL,"
			sql = sql & "[bank_type] integer NOT NULL,"
			sql = sql & "[bank_name] text (100) NOT NULL,"
			sql = sql & "[bank_account] text (100) NOT NULL,"
			sql = sql & "[bank_account_name] text (100) NOT NULL,"
			sql = sql & "[reply] text (250) NOT NULL,"
			sql = sql & "[reply_uid] integer NOT NULL,"
			sql = sql & "[ip] text (64) NULL,"
			sql = sql & "[date_apply] date NOT NULL,"
			sql = sql & "[date_reply] date NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[status] [int] NOT NULL,"
			sql = sql & "[approved] [int] NOT NULL,"
			sql = sql & "[refund_money] [money] NOT NULL,"
			sql = sql & "[refund_reason] [nvarchar] (250) NOT NULL,"
			sql = sql & "[bank_type] [int] NOT NULL,"
			sql = sql & "[bank_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account] [nvarchar] (100) NOT NULL,"
			sql = sql & "[bank_account_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[reply] [nvarchar] (250) NOT NULL,"
			sql = sql & "[reply_uid] [int] NOT NULL,"
			sql = sql & "[ip] [nvarchar] (64) NULL,"
			sql = sql & "[date_apply] [datetime] NOT NULL,"
			sql = sql & "[date_reply] [datetime] NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_ship_bill()
		table   = DB_PRE &"order_ship_bill"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[bill_id] text (20) NOT NULL,"   '单据号
			sql = sql & "[bill_type] integer NOT NULL,"   '单据类型(0:发货单据,1:退货单据)
			sql = sql & "[order_id] text (18) NOT NULL,"  '订单号
			sql = sql & "[admin_uid] integer NOT NULL,"   '管理员uid
			sql = sql & "[cost_freight] currency NULL,"   '物流费用(包含保价费)
			sql = sql & "[is_protect] integer NULL,"      '是否保价
			sql = sql & "[cost_protect] currency NULL,"   '保价费
			sql = sql & "[ship_status] integer NULL,"     '配送状态(0:正在配货,1:已发货)
			sql = sql & "[is_ship_received] integer NULL,"'配送状态(0:未收到货,1:已收到货)
			sql = sql & "[dly_id] integer NULL,"          '配送方式id(对应delivery表的dly_id)
			sql = sql & "[dly_code] text (20) NULL,"      '配送方式代码(对应delivery表的dly_code)
			sql = sql & "[dly_name] text (100) NULL,"     '配送方式名称(对应delivery表的dly_name)
			sql = sql & "[dly_corp_id] integer NULL,"     '物流公司id
			sql = sql & "[dly_corp_code] text (20) NULL," '物流公司代号
			sql = sql & "[dly_corp_name] text (100) NULL,"'物流公司名称
			sql = sql & "[express_no] text (32) NULL,"    '快递单号
			sql = sql & "[bill_desc] text (250) NULL,"    '备注
			sql = sql & "[ip] text (64) NULL,"            '客户端ip
			sql = sql & "[date_added] date NOT NULL,"     '单据生成时间
			sql = sql & "[date_shipped] date NULL,"       '单据发货时间
			sql = sql & "[date_received] date NULL"       '收货时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[bill_id] [nvarchar] (20) NOT NULL,"   '单据号
			sql = sql & "[bill_type] [smallint] NOT NULL,"      '单据类型(0:收款单据,1:退款单据)
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"  '订单号
			sql = sql & "[admin_uid] integer NOT NULL,"         '管理员uid
			sql = sql & "[cost_freight] [money] NULL,"          '物流费用(包含保价费)
			sql = sql & "[is_protect] [smallint] NULL,"         '是否保价
			sql = sql & "[cost_protect] [money] NULL,"          '保价费
			sql = sql & "[ship_status] [smallint] NULL,"        '配送状态(0:正在配货,1:已发货)
			sql = sql & "[is_ship_received] [smallint] NULL,"   '收货状态(0:未收到货,1:已收到货)
			sql = sql & "[dly_id] [int] NULL,"                  '配送方式id(对应delivery表的dly_id)
			sql = sql & "[dly_code] [nvarchar] (20) NULL,"      '配送方式代码(对应delivery表的dly_code)
			sql = sql & "[dly_name] [nvarchar] (100) NULL,"     '配送方式名称(对应delivery表的dly_name)
			sql = sql & "[dly_corp_id] [int] NULL,"             '物流公司id
			sql = sql & "[dly_corp_code] [nvarchar] (20) NULL," '物流公司代号
			sql = sql & "[dly_corp_name] [nvarchar] (100) NULL,"'物流公司名称
			sql = sql & "[express_no] [nvarchar] (32) NULL,"    '快递单号
			sql = sql & "[bill_desc] [nvarchar] (250) NULL,"    '备注
			sql = sql & "[ip] [nvarchar] (64) NULL,"            '客户端ip
			sql = sql & "[date_added] [datetime] NOT NULL,"     '单据生成时间
			sql = sql & "[date_shipped] [datetime] NULL,"       '单据发货时间
			sql = sql & "[date_received] [datetime] NULL"       '收货时间
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_order_id ON ["& table &"] ([order_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_ship_bill_goods()
		table   = DB_PRE &"order_ship_bill_goods"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[bill_id] text (20) NOT NULL,"
			sql = sql & "[suit_id] integer NOT NULL,"
			sql = sql & "[gid] integer NOT NULL,"            '商品id
			sql = sql & "[pid] integer NOT NULL,"            '商品产品id
			sql = sql & "[goods_name] text (100) NOT NULL,"  '商品名称
			sql = sql & "[goods_sn] text (28) NOT NULL,"     '商品编号
			sql = sql & "[product_sn] text (32) NOT NULL,"   '商品货号
			sql = sql & "[spec_value_id] text (32) NULL,"    '商品规格id
			sql = sql & "[spec_value] text (250) NULL,"      '商品规格
			sql = sql & "[ship_num] integer NOT NULL"        '已发货数量
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("CREATE INDEX IDX_bill_id ON ["& table &"] ([bill_id])")
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[bill_id] [nvarchar] (20) NOT NULL,"
			sql = sql & "[suit_id] [int] NOT NULL,"
			sql = sql & "[gid] [int] NOT NULL,"                    '商品id
			sql = sql & "[pid] [int] NOT NULL,"                    '商品产品id
			sql = sql & "[goods_name] [nvarchar] (100) NOT NULL,"  '商品名称
			sql = sql & "[goods_sn] [nvarchar] (28) NOT NULL,"     '商品编号
			sql = sql & "[product_sn] [nvarchar] (32) NOT NULL,"   '商品货号
			sql = sql & "[spec_value_id] [nvarchar] (32) NULL,"    '商品规格id
			sql = sql & "[spec_value] [nvarchar] (250) NULL,"      '商品规格
			sql = sql & "[ship_num] [int] NOT NULL"                '已发货数量
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
			aresult = OW.DB.execute("CREATE INDEX IDX_bill_id ON ["& table &"] ([bill_id])")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_suit()
		table = DB_PRE &"order_suit"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[suit_id] integer NOT NULL,"
			sql = sql & "[suit_name] text (100) NOT NULL,"
			sql = sql & "[suit_price] currency NOT NULL,"
			sql = sql & "[suit_amount] integer NOT NULL,"
			sql = sql & "[suit_sum] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[suit_id] [int] NOT NULL,"
			sql = sql & "[suit_name] [nvarchar] (100) NOT NULL,"
			sql = sql & "[suit_price] [money] NOT NULL,"
			sql = sql & "[suit_amount] [int] NOT NULL,"
			sql = sql & "[suit_sum] [money] NOT NULL,"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
	private function order_stats()
		table   = DB_PRE &"order_stats"
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case DB_TYPE
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[site_id] integer NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[stats_date] integer NOT NULL,"
			sql = sql & "[order_count] integer NOT NULL,"
			sql = sql & "[order_paid_count] integer NOT NULL,"
			sql = sql & "[order_money_amount] currency NOT NULL,"
			sql = sql & "[money_paid_amount] currency NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[sid] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[site_id] [smallint] NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[stats_date] [int] NOT NULL,"
			sql = sql & "[order_count] [int] NOT NULL,"
			sql = sql & "[order_paid_count] [int] NOT NULL,"
			sql = sql & "[order_money_amount] [money] NOT NULL,"
			sql = sql & "[money_paid_amount] [money] NOT NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([sid]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then success(table) else failed(table) : end if
	end function
	
end class
%>