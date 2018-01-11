<%
class STSHOPDBData_Class
	
	public canDoNext,sql,table,tableData,table2,table3,cresult,aresult
	public tplImageFolder
	public username,password,email
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
		call deleteContentData("准备开始安装商城数据 ... ")
		call shop_config("正在安装商城配置数据 ... ")
		call shop_category("正在安装商城分类数据 ... ")
		call category_goods("正在安装商城推荐商品数据 ... ")
		call navigator("正在安装商城导航数据 ... ")
		call ad("正在安装商城广告信息 ... ")
		call brand("正在安装品牌数据 ... ")
		call coupon("正在安装优惠券数据 ... ")
		call delivery("正在安装送货方式数据 ... ")
		call payment("正在安装支付方式数据 ... ")
		call goods_model("正在安装商品模型数据 ... ")
		call goods_type("正在安装商品类型数据 ... ")
		call goods_spec("正在安装商品规格数据 ... ")
		call order_form("正在安装订单表单数据 ... ")
		call goods("正在安装商品数据 ... ")
		call mailTpl("正在安装商城邮件模板数据 ... ")
		call position("正在安装商城推荐位数据 ... ")
		call position_data("正在安装商城推荐位内容数据 ... ")
		call searchWords("正在安装搜索关键词数据 ... ")
	end sub
	
	private function success(byval s)
		echo s &" 安装成功<br>"
	end function
	
	function failed(byval s)
		echo s &" <font style=""color:#f00;"">安装失败</font><br>"
	end function
	
	public function addConfig(byval siteId,byval name,byval value)
		table = DB_PRE &"site_config"
		call OW.DB.addRecord(table,array("site_id:"& siteId,"config_name:"& name,"config_value:"& value))
	end function
	
	'**创建表单[默认订单表单]表，若表存在则会被删除重新创建
	private function createOrderFormTable(byval table)
		dim sql,cresult,aresult
		if OW.DB.isTableExists(table) then OW.DB.deleteTable(table)
		select case db_type
		case 0
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,"
			sql = sql & "[order_id] text (18) NOT NULL,"
			sql = sql & "[uid] integer NOT NULL,"
			sql = sql & "[consignee] text (32) NULL,"
			sql = sql & "[address] text (150) NULL,"
			sql = sql & "[tel] text (30) NULL,"
			sql = sql & "[email] text (64) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = true
		case 1
			sql = "CREATE TABLE ["& table &"] ("
			sql = sql & "[id] [int] IDENTITY (1,1) NOT NULL,"
			sql = sql & "[order_id] [nvarchar] (18) NOT NULL,"
			sql = sql & "[uid] [int] NOT NULL,"
			sql = sql & "[consignee] [nvarchar] (32) NULL,"
			sql = sql & "[address] [nvarchar] (150) NULL,"
			sql = sql & "[tel] [nvarchar] (30) NULL,"
			sql = sql & "[email] [nvarchar] (64) NULL"
			sql = sql & ")"
			cresult = OW.DB.execute(sql)
			aresult = OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([id]) ON [PRIMARY]")
		end select
		if cresult=true and aresult=true then createOrderFormTable=true else createOrderFormTable=false
	end function
	
	public function deleteContentData(byval tip)
		if tip<>"" then print tip
		dim rs
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=3")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=18")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=19")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=20")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=21")
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"content1 WHERE root_id=3")
		do while not rs.eof
			call OW.DB.execute("DELETE FROM "& DB_PRE &"content1 WHERE cid="& OW.int(rs("cid")) &"")
			call OW.DB.execute("DELETE FROM "& DB_PRE &"content1_data WHERE cid="& OW.int(rs("cid")) &"")
			call OW.DB.execute("DELETE FROM "& DB_PRE &"content1_product WHERE cid="& OW.int(rs("cid")) &"")
			rs.movenext
		loop
		OW.DB.closeRs rs
		'**
		call OW.DB.execute("DELETE FROM "& DB_PRE &"category WHERE cate_id=3")
		'**
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position WHERE pos_id=2")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position_data WHERE pos_id=2")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position WHERE pos_id=3")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position_data WHERE pos_id=3")
		'**
		call OW.DB.updateRecord(DB_PRE &"ad",array("height:460px"),array("ad_id:1"))
		call OW.DB.updateRecord(DB_PRE &"ad_data",array("config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index2.jpg&quot;,&quot;name&quot;:&quot;2&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index3.jpg&quot;,&quot;name&quot;:&quot;3&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index4.jpg&quot;,&quot;name&quot;:&quot;4&quot;,&quot;link&quot;:&quot;#&quot;}]"),array("ad_id:1"))
		call OW.DB.updateRecord(DB_PRE &"ad_data",array("config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/mob_index1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/mob_index2.jpg&quot;,&quot;name&quot;:&quot;2&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/mob_index3.jpg&quot;,&quot;name&quot;:&quot;3&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/mob_index4.jpg&quot;,&quot;name&quot;:&quot;4&quot;,&quot;link&quot;:&quot;#&quot;}]"),array("ad_id:1001"))
		'**
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position_data WHERE cid=14")
		call OW.DB.execute("DELETE FROM "& DB_PRE &"position_data WHERE cid=15")
	end function
	
	public function shop_config(byval tip)
		if tip<>"" then print tip
		'**
		call addConfig(1,"shopping_is_need_login","1")
		call addConfig(1,"is_invoice_open","1")
		call addConfig(1,"is_region_open","1")
		call addConfig(1,"order_process_config_default","1:提交订单|2:商品出库|3:正在配送|4:收货完成")
		call addConfig(1,"order_limit_one_day","100")
		call addConfig(1,"order_cancel_time","0")
		call addConfig(1,"is_refund_open","0")
		call addConfig(1,"order_is_send_user_email","0")
		call addConfig(1,"order_is_send_admin_email","0")
		call addConfig(1,"order_rec_email",email)
		call addConfig(1,"is_member_price_show","1")
		call addConfig(1,"order_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,total_amount,uid,pay_status,ship_status,device_type")
		call addConfig(1,"order_export_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,weight,cost_freight,cost_coupon,total_amount,uid,pay_status,ship_status,date_paid,date_added,ip,device_type")
		call addConfig(1,"goods_field_list","gid,is_book,title,thumbnail,goods_sn,stock,price,views,comments,status,recommend,sequence,cate_id")
		call addConfig(1,"goods_export_field_list","gid,is_book,title,thumbnail,goods_sn,product_sn,barcode,stock,price,weight,dly_fee_type,sales,views,comments,post_time,update_time,status,recommend,sequence,cate_id")
		call addConfig(1,"shop_logo","")
		call addConfig(1,"shop_name","")
		call addConfig(1,"shop_title","商城商品分类")
		call addConfig(1,"shop_keywords","商城商品分类")
		call addConfig(1,"shop_description","商城商品分类")
		call addConfig(1,"brand_title","品牌大全")
		call addConfig(1,"brand_keywords","品牌大全，品牌列表")
		call addConfig(1,"brand_description","品牌大全，这里集中列出显示所有品牌。")
		call addConfig(1,"coupon_title","优惠券")
		call addConfig(1,"coupon_keywords","优惠券")
		call addConfig(1,"coupon_description","优惠券")
		call addConfig(1,"is_fenxiao_open","1")
		call addConfig(1,"is_commission_open","1")
		call addConfig(1,"not_commission_member_group","14,13,12,11")
		call addConfig(1,"commission_valid_time","10080")
		call addConfig(1,"drawcash_limit","100")
		'****
		if IS_MULTI_SITES then
			call addConfig(2,"shopping_is_need_login","1")
			call addConfig(2,"is_invoice_open","1")
			call addConfig(2,"is_invoice_open","1")
			call addConfig(2,"order_process_config_default","1:order|2:prepare|3:shipping|4:finish")
			call addConfig(2,"order_limit_one_day","100")
			call addConfig(2,"order_cancel_time","0")
			call addConfig(2,"is_refund_open","0")
			call addConfig(2,"order_is_send_user_email","0")
		    call addConfig(2,"order_is_send_admin_email","0")
			call addConfig(2,"order_rec_email",email)
			call addConfig(2,"is_member_price_show","1")
			call addConfig(2,"order_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,total_amount,uid,pay_status,ship_status,device_type")
			call addConfig(2,"order_export_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,weight,cost_freight,cost_coupon,total_amount,uid,pay_status,ship_status,date_paid,date_added,ip,device_type")
			call addConfig(2,"goods_field_list","gid,is_book,title,thumbnail,goods_sn,stock,price,views,comments,status,recommend,sequence,cate_id")
			call addConfig(2,"goods_export_field_list","gid,is_book,title,thumbnail,goods_sn,product_sn,barcode,stock,price,weight,dly_fee_type,sales,views,comments,post_time,update_time,status,recommend,sequence,cate_id")
			call addConfig(2,"shop_logo","")
			call addConfig(2,"shop_name","")
			call addConfig(2,"shop_title","商城商品分类")
			call addConfig(2,"shop_keywords","商城商品分类")
			call addConfig(2,"shop_description","商城商品分类")
			call addConfig(2,"brand_title","品牌大全")
			call addConfig(2,"brand_keywords","品牌大全，品牌列表")
			call addConfig(2,"brand_description","品牌大全，这里集中列出显示所有品牌。")
			call addConfig(2,"coupon_title","优惠券")
			call addConfig(2,"coupon_keywords","优惠券")
			call addConfig(2,"coupon_description","优惠券")
			call addConfig(2,"is_fenxiao_open","1")
			call addConfig(2,"is_commission_open","1")
			call addConfig(2,"not_commission_member_group","14,13,12,11")
			call addConfig(2,"commission_valid_time","10080")
			call addConfig(2,"drawcash_limit","100")
			'**
			call addConfig(3,"shopping_is_need_login","1")
			call addConfig(3,"is_invoice_open","1")
			call addConfig(3,"is_invoice_open","1")
			call addConfig(3,"order_process_config_default","1:提交订单|2:商品出库|3:正在配送|4:收货完成")
			call addConfig(3,"order_limit_one_day","100")
			call addConfig(3,"order_cancel_time","0")
			call addConfig(3,"is_refund_open","0")
			call addConfig(3,"order_is_send_user_email","0")
			call addConfig(3,"order_is_send_admin_email","0")
			call addConfig(3,"order_rec_email",email)
			call addConfig(3,"is_member_price_show","1")
			call addConfig(3,"order_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,total_amount,uid,pay_status,ship_status,device_type")
			call addConfig(3,"order_export_field_list","id,order_id,is_book,goods_info,approved,status,cost_item,weight,cost_freight,cost_coupon,total_amount,uid,pay_status,ship_status,date_paid,date_added,ip,device_type")
			call addConfig(3,"goods_field_list","gid,is_book,title,thumbnail,goods_sn,stock,price,views,comments,status,recommend,sequence,cate_id")
			call addConfig(3,"goods_export_field_list","gid,is_book,title,thumbnail,goods_sn,product_sn,barcode,stock,price,weight,dly_fee_type,sales,views,comments,post_time,update_time,status,recommend,sequence,cate_id")
			call addConfig(3,"shop_logo","")
			call addConfig(3,"shop_name","")
			call addConfig(3,"shop_title","商城商品分类")
			call addConfig(3,"shop_keywords","商城商品分类")
			call addConfig(3,"shop_description","商城商品分类")
			call addConfig(3,"brand_title","品牌大全")
			call addConfig(3,"brand_keywords","品牌大全，品牌列表")
			call addConfig(3,"brand_description","品牌大全，这里集中列出显示所有品牌。")
			call addConfig(3,"coupon_title","优惠券")
			call addConfig(3,"coupon_keywords","优惠券")
			call addConfig(3,"coupon_description","优惠券")
			call addConfig(3,"is_fenxiao_open","0")
			call addConfig(3,"is_fenxiao_open","1")
			call addConfig(3,"is_commission_open","1")
			call addConfig(3,"not_commission_member_group","14,13,12,11")
			call addConfig(3,"commission_valid_time","10080")
			call addConfig(3,"drawcash_limit","100")
		end if
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function ad(byval tip)
		if tip<>"" then print tip
		dim adTable,adDataTable
		adTable     = DB_PRE &"ad"
		adDataTable = DB_PRE &"ad_data"
		'**广告3
		call OW.DB.addRecord(adTable,array("site_id:1","ad_id:3","sequence:3","status:0","name:【PC端】商城主广告","start_time:2016-09-20 00:00:01","end_time:2018-09-20 00:00:01","height:500px","width:404px","full_screen:0","type:image","view:0","hits:0"))
		call OW.DB.addRecord(adDataTable,array("site_id:1","ad_id:3","sequence:0","status:0","config_image:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/promo1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/promo2.jpg&quot;,&quot;name&quot;:&quot;2&quot;,&quot;link&quot;:&quot;#&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/promo3.jpg&quot;,&quot;name&quot;:&quot;3&quot;,&quot;link&quot;:&quot;#&quot;}]","config_flash:","config_code:","config_text:"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function shop_category(byval tip)
		if tip<>"" then print tip
		'**商品栏目
		table = DB_PRE &"category"
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","model_id:10","model_type:0","is_shop:1","sequence:1","status:0","cate_type:0","name:手机数码产品","root_id:0","rootpath:","urlpath:buyphone","parent_id:0","path:,101,","depth:1","children:0","type_cate_id:1","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c1.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:102","model_id:10","model_type:0","is_shop:1","sequence:2","status:0","cate_type:0","name:笔记本平板","root_id:0","rootpath:","urlpath:buymibook","parent_id:0","path:,102,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c2.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:103","model_id:10","model_type:0","is_shop:1","sequence:3","status:0","cate_type:0","name:智能硬件","root_id:0","rootpath:","urlpath:smart","parent_id:0","path:,103,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c3.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:104","model_id:10","model_type:0","is_shop:1","sequence:4","status:0","cate_type:0","name:耳机/音响/配件","root_id:0","rootpath:","urlpath:earphone","parent_id:0","path:,104,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c4.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:105","model_id:10","model_type:0","is_shop:1","sequence:5","status:0","cate_type:0","name:移动电源/电池/插线板","root_id:0","rootpath:","urlpath:power","parent_id:0","path:,105,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c5.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:106","model_id:10","model_type:0","is_shop:1","sequence:6","status:0","cate_type:0","name:保护套/贴膜","root_id:0","rootpath:","urlpath:protecting","parent_id:0","path:,106,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c6.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:107","model_id:10","model_type:0","is_shop:1","sequence:7","status:0","cate_type:0","name:线材/支架/存储卡","root_id:0","rootpath:","urlpath:card","parent_id:0","path:,107,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c7.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:108","model_id:10","model_type:0","is_shop:1","sequence:8","status:0","cate_type:0","name:箱包/服饰","root_id:0","rootpath:","urlpath:dress","parent_id:0","path:,108,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c8.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:100","model_id:10","model_type:0","is_shop:1","sequence:9","status:0","cate_type:0","name:积分商城","root_id:0","rootpath:","urlpath:point","parent_id:0","path:,100,","depth:1","children:0","type_cate_id:0","tpl_inherit:1","ad_image_data:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/hero/shop/index_c0.jpg&quot;,&quot;name&quot;:&quot;1&quot;,&quot;link&quot;:&quot;#&quot;}]"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function category_goods(byval tip)
		if tip<>"" then print tip
		'**商品栏目
		table = DB_PRE &"category_goods"
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:1","sequence:1","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:2","sequence:2","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:3","sequence:3","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:4","sequence:4","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:5","sequence:5","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:6","sequence:6","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:7","sequence:7","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:8","sequence:8","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:101","gid:9","sequence:9","status:0"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","cate_id:102","gid:11","sequence:1","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:102","gid:12","sequence:2","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:102","gid:13","sequence:3","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:102","gid:14","sequence:4","status:0"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","cate_id:103","gid:16","sequence:1","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:103","gid:17","sequence:2","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:103","gid:18","sequence:3","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:103","gid:19","sequence:4","status:0"))
		'****
		call OW.DB.addRecord(table,array("site_id:1","cate_id:100","gid:26","sequence:1","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:100","gid:27","sequence:2","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:100","gid:28","sequence:3","status:0"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:100","gid:29","sequence:4","status:0"))
		'****
		if tip<>"" then print "完成<br>"
	end function
	
	public function navigator(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"navigator"
		
		'**顶部导航
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:1","path:,1,","depth:1","children:0","type:0","cate_id:0","sync:0","name:个人中心","subname:","url:{$site_url}ow-ucenter/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:2","path:,2,","depth:1","children:0","type:0","cate_id:0","sync:0","name:我的订单","subname:","url:{$site_url}ow-ucenter/?ctl=orders","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:3","path:,3,","depth:1","children:0","type:0","cate_id:0","sync:0","name:我的优惠券","subname:","url:{$site_url}ow-ucenter/?ctl=coupon","icon:","image:","target:_self"))
			
		'**主导航
		call OW.DB.addRecord(table,array("site_id:1","sequence:0","status:0","parent_id:0","nav_id:100","path:,100,","depth:1","children:0","type:1","cate_id:0","sync:0","name:首页","subname:home","url:{$site_url}","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:110","path:,110,","depth:1","children:0","type:1","cate_id:101","sync:1","name:购买手机","subname:buy phone","url:{$site_hurl}buyphone/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:120","path:,120,","depth:1","children:0","type:1","cate_id:102","sync:1","name:平板·笔记本","subname:buy mibook","url:{$site_hurl}buymibook/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:130","path:,130,","depth:1","children:0","type:1","cate_id:103","sync:1","name:智能硬件","subname:smart","url:{$site_hurl}smart/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:0","nav_id:140","path:,140,","depth:1","children:0","type:1","cate_id:104","sync:1","name:耳机·配件","subname:earphone","url:{$site_hurl}earphone/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:0","nav_id:150","path:,150,","depth:1","children:0","type:1","cate_id:100","sync:1","name:积分商城","subname:point","url:{$site_hurl}point/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:6","status:0","parent_id:0","nav_id:160","path:,160,","depth:1","children:0","type:1","cate_id:0","sync:0","name:品牌","subname:brand","url:{$site_hurl}brand/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:7","status:0","parent_id:0","nav_id:170","path:,170,","depth:1","children:0","type:1","cate_id:0","sync:0","name:优惠券","subname:coupon","url:{$site_hurl}coupon/","icon:","image:","target:_self"))
		
		'**用户中心
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:410","path:,410,","depth:1","children:0","type:4","cate_id:0","sync:0","name:首页","subname:","url:{$site_url}","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:420","path:,420,","depth:1","children:0","type:4","cate_id:0","sync:0","name:商品分类","subname:","url:{$site_hurl}shop/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:430","path:,430,","depth:1","children:0","type:4","cate_id:0","sync:0","name:积分商城","subname:","url:{$site_hurl}point/","icon:","image:","target:_self"))
		
		'**手机端主导航
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:0","nav_id:510","path:,510,","depth:1","children:0","type:5","cate_id:0","sync:0","name:首页","subname:","url:{$site_url}","icon:/ow-content/uploads/icon/home.png","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:0","nav_id:520","path:,520,","depth:1","children:4","type:5","cate_id:0","sync:0","name:关于","subname:","url:{$site_hurl}about"& SITE_HTML_FILE_SUFFIX,"icon:/ow-content/uploads/icon/about.png","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:520","nav_id:521","path:,520,521,","depth:2","children:0","type:5","cate_id:10","sync:1","name:关于我们","subname:","url:{$site_hurl}about/"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:520","nav_id:522","path:,520,522,","depth:2","children:0","type:5","cate_id:2","sync:1","name:新闻资讯","subname:","url:{$site_hurl}news/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:520","nav_id:523","path:,520,523,","depth:2","children:0","type:5","cate_id:7","sync:1","name:人才招聘","subname:","url:{$site_hurl}join/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:520","nav_id:524","path:,520,524,","depth:2","children:0","type:5","cate_id:15","sync:1","name:关于我们","subname:","url:{$site_hurl}contact/"& SITE_HTML_FILE_SUFFIX,"icon:","image:","target:_self"))
		
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:0","nav_id:530","path:,530,","depth:1","children:0","type:5","cate_id:0","sync:0","name:分类","subname:","url:{$site_hurl}shop/","icon:/ow-content/uploads/icon/goods.png","image:","target:_self"))
		
		
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:0","nav_id:540","path:,540,","depth:1","children:0","type:5","cate_id:0","sync:0","name:积分商城","subname:","url:{$site_hurl}point/","icon:/ow-content/uploads/icon/point.png","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:0","nav_id:550","path:,550,","depth:1","children:6","type:5","cate_id:0","sync:0","name:我的","subname:","url:{$site_url}ow-ucenter/","icon:/ow-content/uploads/icon/my.png","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","parent_id:550","nav_id:551","path:,550,551,","depth:2","children:0","type:5","cate_id:0","sync:0","name:会员中心","subname:","url:{$site_url}ow-ucenter/","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","parent_id:550","nav_id:552","path:,550,552,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的订单","subname:","url:{$site_url}ow-ucenter/?ctl=orders","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","parent_id:550","nav_id:553","path:,550,553,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的余额","subname:","url:{$site_url}ow-ucenter/?ctl=finance","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","parent_id:550","nav_id:554","path:,550,554,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的积分","subname:","url:{$site_url}ow-ucenter/?ctl=point","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","parent_id:550","nav_id:555","path:,550,555,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的优惠券","subname:","url:{$site_url}ow-ucenter/?ctl=coupon","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:6","status:0","parent_id:550","nav_id:556","path:,550,556,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的收藏","subname:","url:{$site_url}ow-ucenter/?ctl=favorite","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:7","status:0","parent_id:550","nav_id:557","path:,550,557,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的收货地址","subname:","url:{$site_url}ow-ucenter/?ctl=order_form_data","icon:","image:","target:_self"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:8","status:0","parent_id:550","nav_id:558","path:,550,558,","depth:2","children:0","type:5","cate_id:0","sync:0","name:我的消息","subname:","url:{$site_url}ow-ucenter/?ctl=system_msg","icon:","image:","target:_self"))
		
	end function
	
	public function brand(byval tip)
		if tip<>"" then print tip
		'****
		table = DB_PRE &"brand_category"
		call OW.DB.addRecord(table,array("site_id:1","cate_id:1","sequence:1","status:0","parent_id:0","path:,1,","depth:1","children:0","name:手机品牌","subname:国内外知名手机品牌","root_id:0","rootpath:","urlpath:mobile","url:","icon:","image:","tpl_inherit:1","tpl_index:shop.brand.category.html","tpl_category:","tpl_content:","seo_title:手机品牌","keywords:手机品牌","description:国内外知名手机品牌"))
		call OW.DB.addRecord(table,array("site_id:1","cate_id:2","sequence:2","status:0","parent_id:0","path:,2,","depth:1","children:0","name:家电品牌","subname:国内外知名家电品牌","root_id:0","rootpath:","urlpath:jiadian","url:","icon:","image:","tpl_inherit:1","tpl_index:shop.brand.category.html","tpl_category:","tpl_content:","seo_title:家电品牌","keywords:家电品牌","description:国内外知名家电品牌"))
		
		'****
		table = DB_PRE &"brand"
		call OW.DB.addRecord(table,array("site_id:1","brand_id:1","cate_ids:,1,","sequence:1","status:0","urlpath:apple","name:apple(苹果)","logo:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/brand/apple.jpg","url:http://www.apple.com/","tpl:","seo_title:apple介绍-apple产品购买","keywords:apple介绍,apple产品购买","description:apple介绍,apple产品购买","content:&lt;p&gt;APPLE 即 苹果公司 。&lt;br/&gt;苹果公司( Apple Inc. )是美国的一家高科技公司，2007年由美国苹果电脑公司( Apple Computer Inc. )更名为苹果公司，在2013年世界500强排行榜中排名第19，总部位于加利福尼亚州的库比蒂诺。苹果公司由史蒂夫·乔布斯、斯蒂夫·盖瑞·沃兹尼亚克和罗纳德·杰拉尔德·韦恩在1976年4月1日创立，在高科技企业中以创新而闻名，设计并全新打造了iPod、iTunes和Mac 笔记本电脑和台式电脑、OS X 操作系统，以及革命性的iPhone和 iPad。苹果公司已连续三年成为全球市值最大公司，在2012年曾经创下6235亿美元记录，在2013年后因企业市值缩水24%为4779亿美元，但仍然是全球市值最大的公司。&lt;/p&gt;"))
		call OW.DB.addRecord(table,array("site_id:1","brand_id:2","cate_ids:,1,","sequence:2","status:0","urlpath:mi","name:小米","logo:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/brand/mi.jpg","url:http://www.mi.com/","tpl:","seo_title:小米介绍-小米产品购买","keywords:小米介绍,小米产品购买","description:小米介绍,小米产品购买","content:&lt;p&gt;小米公司正式成立于2010年4月，是一家专注于高端智能手机、互联网电视以及智能家居生态链建设的创新型科技企业。&lt;/p&gt;"))
		call OW.DB.addRecord(table,array("site_id:1","brand_id:3","cate_ids:,2,","sequence:3","status:0","urlpath:midea","name:美的","logo:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/brand/midea.jpg","url:http://www.midea.com/","tpl:","seo_title:美的介绍-美的产品购买","keywords:美的介绍,美的产品购买","description:美的介绍,美的产品购买","content:&lt;p&gt;Midea 即 美的集团 。&lt;br/&gt;美的集团（SZ.000333）是一家以家电制造业为主的大型综合性企业集团，于2013年9月18日在深交所上市，旗下拥有小天鹅（SZ000418）、威灵控股（HK00382）两家子上市公司。2012年，美的集团整体实现销售收入达1027亿元，其中外销销售收入达72亿美元。2013年中国最有价值品牌评价中，美的品牌价值达到653.36亿元，名列全国最有价值品牌第5位。&lt;/p&gt;"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function coupon(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"coupon"
		call OW.DB.addRecord(table,array("site_id:1","coupon_id:1","sequence:1","status:0","seo_title:10元优惠券","keywords:","description:","coupon_type:c1","coupon_code:C16092000000001","coupon_name:10元优惠券","coupon_money:10","coupon_exchange_point:0","is_coupon_max:0","coupon_max:0","coupon_member_group:9,8,7,6,5,14,13,12,11","coupon_member_get_limit:1","coupon_have_get:0","coupon_have_used:0","coupon_rule_type:0","cate_ids:","gids:","is_get_timelimit:0","get_starttime:2016-09-20 00:00:01","get_endtime:","is_can_mix_use:0","use_min_money:100","is_use_timelimit:0","use_starttime:2016-09-20 00:00:01","use_endtime:","desc:","tpl:shop.coupon.detail.html"))
		call OW.DB.addRecord(table,array("site_id:1","coupon_id:2","sequence:2","status:0","seo_title:20元优惠券","keywords:","description:","coupon_type:c1","coupon_code:C16092000000002","coupon_name:20元优惠券","coupon_money:20","coupon_exchange_point:0","is_coupon_max:0","coupon_max:0","coupon_member_group:9,8,7,6,5,14,13,12,11","coupon_member_get_limit:1","coupon_have_get:0","coupon_have_used:0","coupon_rule_type:0","cate_ids:","gids:","is_get_timelimit:0","get_starttime:2016-09-20 00:00:01","get_endtime:","is_can_mix_use:0","use_min_money:200","is_use_timelimit:0","use_starttime:2016-09-20 00:00:01","use_endtime:","desc:","tpl:shop.coupon.detail.html"))
	end function
	
	public function delivery(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"delivery"
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","dly_code:express","dly_name:邮政快递包裹","dly_fee:10","dly_fee_type:0","dly_cod:0","dly_config:","dly_desc:邮政快递包裹的描述内容。"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","dly_code:ems","dly_name:EMS国内邮政特快专递","dly_fee:10","dly_fee_type:0","dly_cod:0","dly_config:","dly_desc:EMS国内邮政特快专递描述内容。"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","dly_code:cac","dly_name:上门自提","dly_fee:0","dly_fee_type:0","dly_cod:0","dly_config:","dly_desc:用户自己上门提货"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","dly_code:express","dly_name:普通快递","dly_fee:20","dly_fee_type:0","dly_cod:0","dly_config:","dly_desc:圆通/顺丰/申通/中通/韵达等快递"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function payment(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"payment"
		'**PC端
		call OW.DB.addRecord(table,array("site_id:1","sequence:1","status:0","is_mobile:0","is_charge:0","pay_code:deposit","pay_name:余额支付","pay_fee:0","pay_fee_type:0","pay_config:","pay_desc:"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:2","status:0","is_mobile:0","is_charge:1","pay_code:alipay","pay_name:支付宝","pay_fee:0","pay_fee_type:0","pay_config:{""interface_type"":""direct"",""seller_email"":"""",""parter_id"":"""",""key"":""""}","pay_desc:"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:3","status:0","is_mobile:0","is_charge:1","pay_code:weixin","pay_name:微信扫码支付","pay_fee:0","pay_fee_type:0","pay_config:{""appid"":""appId"",""appsecret"":""appsecret"",""mchid"":""001"",""key"":""key""}","pay_desc:扫微信二维码支付"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","is_mobile:0","is_charge:1","pay_code:alipay","pay_name:网银支付","pay_fee:0","pay_fee_type:0","pay_config:{""interface_type"":""bankpay"",""seller_email"":"""",""parter_id"":"""",""key"":""""}","pay_desc:"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","is_mobile:0","is_charge:0","pay_code:bank","pay_name:银行汇款/转帐","pay_fee:0","pay_fee_type:0","pay_config:","pay_desc:这里填写银行账号信息"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:6","status:0","is_mobile:0","is_charge:0","pay_code:cod","pay_name:货到付款","pay_fee:0","pay_fee_type:0","pay_config:","pay_desc:"))
		'**手机端
		call OW.DB.addRecord(table,array("site_id:1","sequence:11","status:0","is_mobile:1","is_charge:0","pay_code:deposit","pay_name:余额支付","pay_fee:0","pay_fee_type:0","pay_config:","pay_desc:"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:12","status:0","is_mobile:1","is_charge:1","pay_code:weixin","pay_name:微信支付","pay_fee:0","pay_fee_type:0","pay_config:{""appid"":""appId"",""appsecret"":""appsecret"",""mchid"":""001"",""key"":""key""}","pay_desc:"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:13","status:0","is_mobile:1","is_charge:1","pay_code:alipay","pay_name:手机支付宝","pay_fee:0","pay_fee_type:0","pay_config:{""interface_type"":""paywap"",""seller_email"":"""",""parter_id"":"""",""key"":""""}","pay_desc:"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function goods_model(byval tip)
		if tip<>"" then print tip
		dim tableGoods
		'写入配置数据
		table = DB_PRE &"model"
		'**主站
		tableGoods = DB_PRE &"goods1"
		call OW.DB.addRecord(table,array("site_id:1","model_id:10","is_shop:1","model_type:0","model_name:默认商品模型","model_table:default","sequence:1","status:0","tpl_index:shop.category.html","tpl_category:shop.category.html","tpl_content:shop.goods.html"))
		call OW.DB.createModelTable(tableGoods &"_default","gid")
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function goods_type(byval tip)
		if tip<>"" then print tip
		'写入配置数据
		table = DB_PRE &"goods_type"
		call OW.DB.addRecord(table,array("site_id:1","type_id:1","sequence:1","status:0","type_name:服装类","description:"))
		call OW.DB.addRecord(table,array("site_id:1","type_id:2","sequence:2","status:0","type_name:笔记本电脑","description:"))
		'******
		table = DB_PRE &"goods_type_attr"
		call OW.DB.addRecord(table,array("site_id:1","attr_id:1","type_id:1","sequence:1","status:0","attr_name:产地","attr_type:0","attr_input_type:0","attr_value:"))
		call OW.DB.addRecord(table,array("site_id:1","attr_id:2","type_id:1","sequence:2","status:0","attr_name:季节","attr_type:0","attr_input_type:1","attr_value:春季"& chr(13) &"夏季"& chr(13) &"秋季"& chr(13) &"冬季"))
		call OW.DB.addRecord(table,array("site_id:1","attr_id:3","type_id:1","sequence:3","status:0","attr_name:风格","attr_type:0","attr_input_type:1","attr_value:韩版"& chr(13) &"日版"& chr(13) &"休闲"& chr(13) &"百搭"& chr(13) &"瑞丽"& chr(13) &"欧式"& chr(13) &"民族风"))
		call OW.DB.addRecord(table,array("site_id:1","attr_id:4","type_id:2","sequence:1","status:0","attr_name:屏幕尺寸","attr_type:0","attr_input_type:0","attr_value:"))
		call OW.DB.addRecord(table,array("site_id:1","attr_id:5","type_id:2","sequence:1","status:0","attr_name:硬盘大小","attr_type:0","attr_input_type:0","attr_value:"))
		call OW.DB.addRecord(table,array("site_id:1","attr_id:6","type_id:2","sequence:1","status:0","attr_name:内存容量","attr_type:0","attr_input_type:0","attr_value:"))
		if tip<>"" then print "完成<br>"
	end function
	
	public function goods_spec(byval tip)
		if tip<>"" then print tip
		'写入配置数据
		table = DB_PRE &"goods_spec"
		call OW.DB.addRecord(table,array("site_id:1","spec_id:1","sequence:1","status:0","spec_name:颜色","spec_type:1","spec_select_type:0","description:手机颜色"))
		call OW.DB.addRecord(table,array("site_id:1","spec_id:2","sequence:1","status:0","spec_name:版本","spec_type:0","spec_select_type:0","description:手机版本"))
		call OW.DB.addRecord(table,array("site_id:1","spec_id:3","sequence:1","status:0","spec_name:尺码","spec_type:0","spec_select_type:0","description:服装尺码"))
		call OW.DB.addRecord(table,array("site_id:1","spec_id:4","sequence:1","status:0","spec_name:尺码","spec_type:0","spec_select_type:0","description:鞋子尺码"))

		'**
		table = DB_PRE &"goods_spec_value"
		call OW.DB.addRecord(table,array("site_id:1","value_id:1","spec_id:1","sequence:1","status:0","value_name:白色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:2","spec_id:1","sequence:2","status:0","value_name:银色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:3","spec_id:1","sequence:3","status:0","value_name:金色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:4","spec_id:1","sequence:4","status:0","value_name:玫瑰金色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:5","spec_id:1","sequence:5","status:0","value_name:黑色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:6","spec_id:1","sequence:6","status:0","value_name:亮黑色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:7","spec_id:1","sequence:7","status:0","value_name:灰色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:8","spec_id:1","sequence:8","status:0","value_name:深灰色","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:9","spec_id:1","sequence:9","status:0","value_name:香槟金","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:10","spec_id:1","sequence:10","status:0","value_name:月光银","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:11","spec_id:1","sequence:11","status:0","value_name:月牙白","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:12","spec_id:1","sequence:12","status:0","value_name:陶瓷白","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:13","spec_id:1","sequence:13","status:0","value_name:星空黑","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:14","spec_id:1","sequence:14","status:0","value_name:典雅灰","value_alias:","value_image:"))
		
		call OW.DB.addRecord(table,array("site_id:1","value_id:20","spec_id:2","sequence:1","status:0","value_name:标准版4GB内存+64GB容量","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:21","spec_id:2","sequence:2","status:0","value_name:高配版6GB内存+128GB容量","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:22","spec_id:2","sequence:3","status:0","value_name:3GB内存+64GB容量","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:23","spec_id:2","sequence:4","status:0","value_name:4GB内存+128GB容量","value_alias:","value_image:"))
		
		call OW.DB.addRecord(table,array("site_id:1","value_id:30","spec_id:3","sequence:1","status:0","value_name:165/84(S)","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:31","spec_id:3","sequence:2","status:0","value_name:170/88(M)","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:32","spec_id:3","sequence:3","status:0","value_name:175/92(L)","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:33","spec_id:3","sequence:4","status:0","value_name:180/96(XL)","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:34","spec_id:3","sequence:5","status:0","value_name:185/100(XXL)","value_alias:","value_image:"))
		
		call OW.DB.addRecord(table,array("site_id:1","value_id:40","spec_id:4","sequence:1","status:0","value_name:35","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:41","spec_id:4","sequence:2","status:0","value_name:36","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:42","spec_id:4","sequence:3","status:0","value_name:37","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:43","spec_id:4","sequence:4","status:0","value_name:38","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:44","spec_id:4","sequence:5","status:0","value_name:39","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:45","spec_id:4","sequence:6","status:0","value_name:40","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:46","spec_id:4","sequence:7","status:0","value_name:41","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:47","spec_id:4","sequence:8","status:0","value_name:42","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:48","spec_id:4","sequence:9","status:0","value_name:43","value_alias:","value_image:"))
		call OW.DB.addRecord(table,array("site_id:1","value_id:49","spec_id:4","sequence:10","status:0","value_name:44","value_alias:","value_image:"))

		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function goods(byval tip)
		if tip<>"" then print tip
		dim goodsTable,goodsData,goodsModelData,goodsProduct,goodsPrice,goodsValue
		dim content
		goodsTable     = DB_PRE &"goods"
		goodsData      = DB_PRE &"goods_data"
		goodsModelData = DB_PRE &"goods1_default"
		goodsProduct   = DB_PRE &"goods_product"
		goodsPrice     = DB_PRE &"goods_price"
		goodsValue     = DB_PRE &"goods_value"
		'****商品1
		content = "&lt;p&gt;&lt;img src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/d2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/d3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/d4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/d5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:1","cate_id:101","sequence:1","status:0","is_book:1","book_front_money_rate:50","book_price_discount:100","book_final_pay_day:0","book_arrival_time:10","is_book_timelimit:0","goods_sn:OWS0000001","market_price:2299.00","price:2199.00","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/thumbnail.jpg","spec_id:1,2","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:【预订演示】预订小米5s Plus","subtitle:图片规格商品规格演示","font_weight:0","root_id:101","rootpath:buyphone","urlpath:xiaomi_5s_plus","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:1","seo_title:小米手机5s Plus（商品规格演示）","keywords:小米手机5s","description:小米手机5s","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:1"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:1","gid:1","sequence:1","status:0","product_sn:OWS0000001","spec_value_id:","spec_value:","stock:800","stock_default:800"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:2","gid:1","sequence:2","status:0","product_sn:OWS0000001-1","spec_value_id:2,20","spec_value:银色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:3","gid:1","sequence:3","status:0","product_sn:OWS0000001-2","spec_value_id:2,21","spec_value:银色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:4","gid:1","sequence:4","status:0","product_sn:OWS0000001-3","spec_value_id:3,20","spec_value:金色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:5","gid:1","sequence:5","status:0","product_sn:OWS0000001-4","spec_value_id:3,21","spec_value:金色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:6","gid:1","sequence:6","status:0","product_sn:OWS0000001-5","spec_value_id:4,20","spec_value:玫瑰金色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:7","gid:1","sequence:7","status:0","product_sn:OWS0000001-6","spec_value_id:4,21","spec_value:玫瑰金色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:8","gid:1","sequence:8","status:0","product_sn:OWS0000001-7","spec_value_id:8,20","spec_value:深灰色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:9","gid:1","sequence:9","status:0","product_sn:OWS0000001-8","spec_value_id:8,21","spec_value:深灰色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:1","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:2","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:3","group_id:0","market_price:2599","price:2499"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:4","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:5","group_id:0","market_price:2599","price:2499"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:6","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:7","group_id:0","market_price:2599","price:2499"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:8","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:1","pid:9","group_id:0","market_price:2599","price:2499"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:1","value_id:2","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:1","value_id:3","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:1","value_id:4","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:1","value_id:8","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/4.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:2","value_id:20","value_image:","value_images:"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:1","spec_id:2","value_id:21","value_image:","value_images:"))
		
		
		'****商品2
		content = "苹果手机IPhone 8"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:2","cate_id:101","sequence:2","status:0","is_book:1","book_front_money_rate:50","book_price_discount:100","book_final_pay_day:0","book_arrival_time:30","is_book_timelimit:0","goods_sn:OWS0000002","market_price:6899","price:6699","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/thumbnail.jpg","spec_id:1,2","type_id:0","form_id:2","is_need_ship:1","brand_id:1","sales:0","comments:0","title:【预订演示】预订苹果IPhone 8","subtitle:预订商品演示","font_weight:0","root_id:101","rootpath:buyphone","urlpath:iphone7","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:2","seo_title:苹果手机IPhone 8","keywords:苹果手机IPhone 8","description:苹果手机IPhone 8","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:2"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:10","gid:2","sequence:1","status:0","product_sn:OWS0000002","spec_value_id:","spec_value:","stock:400","stock_default:400"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:11","gid:2","sequence:2","status:0","product_sn:OWS0000002-1","spec_value_id:6,20","spec_value:亮黑色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:12","gid:2","sequence:3","status:0","product_sn:OWS0000002-2","spec_value_id:6,21","spec_value:亮黑色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:13","gid:2","sequence:4","status:0","product_sn:OWS0000002-3","spec_value_id:1,20","spec_value:白色,标准版4GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:14","gid:2","sequence:5","status:0","product_sn:OWS0000002-4","spec_value_id:1,21","spec_value:白色,高配版6GB内存+128GB容量","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:2","pid:10","group_id:0","market_price:6899","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:2","pid:11","group_id:0","market_price:6899","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:2","pid:12","group_id:0","market_price:7899","price:7699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:2","pid:13","group_id:0","market_price:6899","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:2","pid:14","group_id:0","market_price:7899","price:7699"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:2","spec_id:1","value_id:6","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:2","spec_id:1","value_id:1","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/1/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/2_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/2_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/2_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/2/2_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:2","spec_id:2","value_id:20","value_image:","value_images:"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:2","spec_id:2","value_id:21","value_image:","value_images:"))
		
		
		'****商品3
		content = "小米5s"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:3","cate_id:101","sequence:3","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000003","market_price:1999","price:1899","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/thumbnail.jpg","spec_id:1,2","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米5s（商品规格演示）","subtitle:图片规格商品规格演示商品","font_weight:0","root_id:101","rootpath:buyphone","urlpath:xiaomi5","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:3","seo_title:小米5s","keywords:小米5s","description:小米5s","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:3"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:30","gid:3","sequence:1","status:0","product_sn:OWS0000003","spec_value_id:","spec_value:","stock:800","stock_default:800"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:31","gid:3","sequence:2","status:0","product_sn:OWS0000003-1","spec_value_id:2,22","spec_value:银色,3GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:32","gid:3","sequence:3","status:0","product_sn:OWS0000003-2","spec_value_id:2,23","spec_value:银色,4GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:33","gid:3","sequence:4","status:0","product_sn:OWS0000003-3","spec_value_id:3,22","spec_value:金色,3GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:34","gid:3","sequence:5","status:0","product_sn:OWS0000003-4","spec_value_id:3,23","spec_value:金色,4GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:35","gid:3","sequence:6","status:0","product_sn:OWS0000003-5","spec_value_id:4,22","spec_value:玫瑰金色,3GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:36","gid:3","sequence:7","status:0","product_sn:OWS0000003-6","spec_value_id:4,23","spec_value:玫瑰金色,4GB内存+128GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:37","gid:3","sequence:8","status:0","product_sn:OWS0000003-7","spec_value_id:8,22","spec_value:深灰色,3GB内存+64GB容量","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:38","gid:3","sequence:9","status:0","product_sn:OWS0000003-8","spec_value_id:8,23","spec_value:深灰色,4GB内存+128GB容量","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:30","group_id:0","market_price:1999","price:1899"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:31","group_id:0","market_price:1999","price:1899"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:32","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:33","group_id:0","market_price:1999","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:34","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:35","group_id:0","market_price:1999","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:36","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:37","group_id:0","market_price:1999","price:6699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:3","pid:38","group_id:0","market_price:2299","price:2199"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:1","value_id:2","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:1","value_id:3","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:1","value_id:4","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:1","value_id:8","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/4.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/3/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:2","value_id:22","value_image:","value_images:"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:3","spec_id:2","value_id:23","value_image:","value_images:"))
		
		
		'****商品4
		content = "&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d10.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d5.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d6.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d7.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d8.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d9.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d11.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/4/d12.png&quot;/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:4","cate_id:101","sequence:4","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000004","market_price:2299","price:2199","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/thumbnail.jpg","spec_id:1","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:魅族PRO 6","subtitle:27日10点起，最高享12免息，更有机会赢免单","font_weight:0","root_id:101","rootpath:buyphone","urlpath:meizu_pro6","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:4","seo_title:魅族PRO 6","keywords:魅族PRO 6","description:魅族PRO 6","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:4"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:40","gid:4","sequence:1","status:0","product_sn:OWS0000004","spec_value_id:","spec_value:","stock:400","stock_default:400"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:41","gid:4","sequence:2","status:0","product_sn:OWS0000004-1","spec_value_id:4","spec_value:玫瑰金色","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:42","gid:4","sequence:3","status:0","product_sn:OWS0000004-2","spec_value_id:9","spec_value:香槟金","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:43","gid:4","sequence:4","status:0","product_sn:OWS0000004-3","spec_value_id:10","spec_value:月光银","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:44","gid:4","sequence:5","status:0","product_sn:OWS0000004-4","spec_value_id:13","spec_value:星空黑","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:4","pid:40","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:4","pid:41","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:4","pid:42","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:4","pid:43","group_id:0","market_price:2299","price:2199"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:4","pid:44","group_id:0","market_price:2299","price:2199"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:4","spec_id:1","value_id:4","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:4","spec_id:1","value_id:9","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/2_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/2_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/2_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:4","spec_id:1","value_id:10","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/3_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/3_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/3_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:4","spec_id:1","value_id:13","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/4.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/4_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/4_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/4/4_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		
		
		'****商品5
		content = "荣耀V8"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:5","cate_id:101","sequence:5","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000005","market_price:2799","price:2699","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/thumbnail.jpg","spec_id:1","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:荣耀V8","subtitle:双1200万像素平行镜头，3500mAh电池长久续航！","font_weight:0","root_id:101","rootpath:buyphone","urlpath:honor8","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:5","seo_title:荣耀V8","keywords:荣耀V8","description:荣耀V8","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:5"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:50","gid:5","sequence:1","status:0","product_sn:OWS0000005","spec_value_id:","spec_value:","stock:400","stock_default:400"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:51","gid:5","sequence:2","status:0","product_sn:OWS0000005-1","spec_value_id:4","spec_value:玫瑰金色","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:52","gid:5","sequence:3","status:0","product_sn:OWS0000005-2","spec_value_id:9","spec_value:香槟金","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:53","gid:5","sequence:4","status:0","product_sn:OWS0000005-3","spec_value_id:12","spec_value:陶瓷白","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:54","gid:5","sequence:5","status:0","product_sn:OWS0000005-4","spec_value_id:14","spec_value:典雅灰","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:5","pid:50","group_id:0","market_price:2799","price:2699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:5","pid:51","group_id:0","market_price:2799","price:2699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:5","pid:52","group_id:0","market_price:2799","price:2699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:5","pid:53","group_id:0","market_price:2799","price:2699"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:5","pid:54","group_id:0","market_price:2799","price:2699"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:5","spec_id:1","value_id:4","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:5","spec_id:1","value_id:9","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:5","spec_id:1","value_id:12","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:5","spec_id:1","value_id:14","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/4.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/5/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		
		
		'****商品6
		content = "&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d10.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d6.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d7.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d8.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/6/d9.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:6","cate_id:101","sequence:6","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000006","market_price:3988","price:3888","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/thumbnail.jpg","spec_id:1","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:HUAWEI P9 Plus","subtitle:1200万像素徕卡双摄像头，5.5英寸+3400mAh大电池，金属雕刻纹理。","font_weight:0","root_id:101","rootpath:buyphone","urlpath:huawei_p9_plus","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:6","seo_title:HUAWEI P9 Plus","keywords:HUAWEI P9 Plus","description:HUAWEI P9 Plus","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:6"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:60","gid:6","sequence:1","status:0","product_sn:OWS0000006","spec_value_id:","spec_value:","stock:400","stock_default:400"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:61","gid:6","sequence:2","status:0","product_sn:OWS0000006-1","spec_value_id:4","spec_value:玫瑰金色","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:62","gid:6","sequence:3","status:0","product_sn:OWS0000006-2","spec_value_id:9","spec_value:香槟金","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:63","gid:6","sequence:4","status:0","product_sn:OWS0000006-3","spec_value_id:12","spec_value:陶瓷白","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:64","gid:6","sequence:5","status:0","product_sn:OWS0000006-4","spec_value_id:14","spec_value:典雅灰","stock:100","stock_default:100"))
		'**
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:6","pid:60","group_id:0","market_price:3988","price:3888"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:6","pid:61","group_id:0","market_price:3988","price:3888"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:6","pid:62","group_id:0","market_price:3988","price:3888"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:6","pid:63","group_id:0","market_price:3988","price:3888"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:6","pid:64","group_id:0","market_price:3988","price:3888"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:6","spec_id:1","value_id:4","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:6","spec_id:1","value_id:9","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:6","spec_id:1","value_id:12","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:6","spec_id:1","value_id:14","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/4.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/6/4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		
		
		'****商品7
		content = "盖乐世 Note7"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:7","cate_id:101","sequence:7","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000007","market_price:5988","price:5888","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/7/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:盖乐世 Note7","subtitle:中行12期免息分期支付立减500元","font_weight:0","root_id:101","rootpath:buyphone","urlpath:galaxy_note7","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:7","seo_title:盖乐世 Note7","keywords:盖乐世 Note7","description:盖乐世 Note7","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/7/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/7/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/7/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/7/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:7"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:70","gid:7","sequence:1","status:0","product_sn:OWS0000007","spec_value_id:","spec_value:","stock:400","stock_default:400"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:7","pid:70","group_id:0","market_price:5988","price:5888"))
		
		
		'****商品8
		content = "红米Pro"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:8","cate_id:101","sequence:8","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000008","market_price:1499","price:1399","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/8/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:红米Pro","subtitle:9.30-10.8 购机即可参与1分钱购福袋活动，百分百中奖！","font_weight:0","root_id:101","rootpath:buyphone","urlpath:redmipro","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:8","seo_title:红米Pro","keywords:红米Pro","description:红米Pro","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/8/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/8/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/8/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:8"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","pid:80","gid:8","sequence:1","status:0","product_sn:OWS0000008","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:8","pid:80","group_id:0","market_price:1499","price:1399"))
		
		
		'****商品9
		content = "红米Note4"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:9","cate_id:101","sequence:9","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000009","market_price:1499","price:1399","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/9/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:红米Note4","subtitle:购机即可参与1分钱福袋百分百中奖！","font_weight:0","root_id:101","rootpath:buyphone","urlpath:redmi_note4","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:9","seo_title:红米Note4","keywords:红米Note4","description:红米Note4","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/9/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/9/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/9/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:9"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:9","pid:90","sequence:1","status:0","product_sn:OWS0000009","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:9","pid:90","group_id:0","market_price:1499","price:1399"))
		
		
		'****商品10
		content = "小米Max"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:10","cate_id:101","sequence:10","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000010","market_price:1499","price:1399","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/thumbnail.jpg","spec_id:1","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米Max","subtitle:购机即可参与1分钱福袋百分百中奖！","font_weight:0","root_id:101","rootpath:buyphone","urlpath:mimax","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:10","seo_title:小米Max","keywords:小米Max","description:小米Max","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:10"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:10","pid:100","sequence:1","status:0","product_sn:OWS0000010","spec_value_id:","spec_value:","stock:300","stock_default:300"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:10","pid:101","sequence:2","status:0","product_sn:OWS0000010-1","spec_value_id:3","spec_value:金色","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:10","pid:102","sequence:3","status:0","product_sn:OWS0000010-2","spec_value_id:2","spec_value:银色","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:10","pid:103","sequence:4","status:0","product_sn:OWS0000010-3","spec_value_id:7","spec_value:灰色","stock:100","stock_default:100"))
		
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:10","pid:100","group_id:0","market_price:1499","price:1399"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:10","pid:101","group_id:0","market_price:1499","price:1399"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:10","pid:102","group_id:0","market_price:1499","price:1399"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:10","pid:103","group_id:0","market_price:1499","price:1399"))
		'**
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:10","spec_id:1","value_id:3","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/1.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:10","spec_id:1","value_id:2","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/2.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		call OW.DB.addRecord(goodsValue,array("site_id:1","gid:10","spec_id:1","value_id:7","value_image:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/3.jpg","value_images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/10/3.jpg&quot;,&quot;name&quot;:&quot;&quot;}]"))
		
		'****商品11
		content = "&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/11/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/11/d2.jpg&quot;/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:11","cate_id:102","sequence:11","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000110","market_price:3499","price:3399","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/11/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米笔记本Air","subtitle:小米笔记本Air13.3英寸9月29日早10点开售！","font_weight:0","root_id:102","rootpath:buymibook","urlpath:miair","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:11","seo_title:小米笔记本Air","keywords:小米笔记本Air","description:小米笔记本Air","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/11/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:11"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:11","pid:110","sequence:1","status:0","product_sn:OWS0000110","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:11","pid:110","group_id:0","market_price:3499","price:3399"))
		
		
		'****商品12
		content = "小米平板2"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:12","cate_id:102","sequence:12","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000120","market_price:999","price:988","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/12/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米平板2","subtitle:小米平板213.3英寸9月29日早10点开售！","font_weight:0","root_id:102","rootpath:buymibook","urlpath:mipad2","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:12","seo_title:小米平板2","keywords:小米平板2","description:小米平板2","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/12/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:12"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:12","pid:120","sequence:1","status:0","product_sn:OWS0000120","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:12","pid:120","group_id:0","market_price:999","price:988"))
		
		
		'****商品13
		content = "华为平板M3_4GB+32GB_WIFI版（日晖金）"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:13","cate_id:102","sequence:13","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000130","market_price:1888","price:1788","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/13/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:华为平板M3_4GB+32GB_WIFI版（日晖金）","subtitle:8.4英寸+2K高清屏幕","font_weight:0","root_id:102","rootpath:buymibook","urlpath:huaweipad","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:13","seo_title:华为平板M3_4GB+32GB_WIFI版（日晖金）","keywords:华为平板M3_4GB+32GB_WIFI版（日晖金）","description:华为平板M3_4GB+32GB_WIFI版（日晖金）","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/13/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/13/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:13"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:13","pid:130","sequence:1","status:0","product_sn:OWS0000130","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:13","pid:130","group_id:0","market_price:1888","price:1788"))
		
		
		'****商品14
		content = "&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d6.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d7.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/14/d8.jpg&quot;/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:14","cate_id:102","sequence:14","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000140","market_price:4988","price:4888","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/14/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:华为（HUAWEI）MateBook 12英寸平板二合一笔记本","subtitle:8.4英寸+2K高清屏幕","font_weight:0","root_id:102","rootpath:buymibook","urlpath:huawei_mateBook","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:14","seo_title:华为（HUAWEI）MateBook 12英寸平板二合一笔记本","keywords:华为（HUAWEI）MateBook 12英寸平板二合一笔记本","description:华为（HUAWEI）MateBook 12英寸平板二合一笔记本","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/14/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/14/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:14"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:14","pid:140","sequence:1","status:0","product_sn:OWS0000140","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:14","pid:140","group_id:0","market_price:4988","price:4888"))
		
		
		'****商品15
		content = "&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d6.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d7.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/ow-content/uploads/"& tplImageFolder &"/goods/15/d8.jpg&quot;/&gt;&lt;/p&gt;"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:15","cate_id:102","sequence:15","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000150","market_price:1888","price:1788","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/15/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:0","sales:0","comments:0","title:华为揽阅M2青春版7.0英寸16GB全网通版","subtitle:8.4英寸+2K高清屏幕","font_weight:0","root_id:102","rootpath:buymibook","urlpath:huawei_padm2","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:15","seo_title:华为揽阅M2青春版7.0英寸16GB全网通版","keywords:华为揽阅M2青春版7.0英寸16GB全网通版","description:华为揽阅M2青春版7.0英寸16GB全网通版","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/15/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/15/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:15"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:15","pid:150","sequence:1","status:0","product_sn:OWS0000150","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:15","pid:150","group_id:0","market_price:1599","price:1499"))
		
		'****商品16
		content = "小米净水器（厨上式）"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:16","cate_id:103","sequence:16","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000160","market_price:1888","price:1788","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/16/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米净水器（厨上式）","subtitle:大流量直出纯净水，健康家庭必备","font_weight:0","root_id:103","rootpath:smart","urlpath:water","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:16","seo_title:小米净水器（厨上式）","keywords:小米净水器（厨上式）","description:小米净水器（厨上式）","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/16/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/16/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:16"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:16","pid:160","sequence:1","status:0","product_sn:OWS0000160","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:16","pid:160","group_id:0","market_price:1999","price:1899"))
		
		
		'****商品17
		content = "米家扫地机器人"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:17","cate_id:103","sequence:17","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000170","market_price:1888","price:1688","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/17/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:米家扫地机器人","subtitle:大流量直出纯净水，健康家庭必备","font_weight:0","root_id:103","rootpath:smart","urlpath:roomrobot","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:17","seo_title:米家扫地机器人","keywords:米家扫地机器人","description:米家扫地机器人","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/17/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/17/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:17"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:17","pid:170","sequence:1","status:0","product_sn:OWS0000170","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:17","pid:170","group_id:0","market_price:1888","price:1688"))
		
		
		'****商品18
		content = "九号平衡车"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:18","cate_id:103","sequence:18","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000180","market_price:1999","price:1899","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:九号平衡车","subtitle:年轻人的酷玩具，骑行遥控两种玩法","font_weight:0","root_id:103","rootpath:smart","urlpath:scooter","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:18","seo_title:九号平衡车","keywords:九号平衡车","description:九号平衡车","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/18/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:18"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:18","pid:180","sequence:1","status:0","product_sn:OWS0000180","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:18","pid:180","group_id:0","market_price:1999","price:1899"))
		
		
		'****商品19
		content = "米家骑记电助力折叠自行车"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:19","cate_id:103","sequence:19","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000190","market_price:588","price:488","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/19/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:米家骑记电助力折叠自行车","subtitle:力矩传感电助力让城市出行轻松有趣","font_weight:0","root_id:103","rootpath:smart","urlpath:mibicycle","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:19","seo_title:米家骑记电助力折叠自行车","keywords:米家骑记电助力折叠自行车","description:米家骑记电助力折叠自行车","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/19/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/19/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:19"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:19","pid:190","sequence:1","status:0","product_sn:OWS0000190","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:19","pid:190","group_id:0","market_price:588","price:488"))
		
		
		'****商品20
		content = "Yeelight床头灯"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:20","cate_id:103","sequence:20","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000200","market_price:128","price:118","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:Yeelight床头灯","subtitle:触摸式操作给卧室1600万种颜色","font_weight:0","root_id:103","rootpath:smart","urlpath:yeelight","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:20","seo_title:Yeelight床头灯","keywords:Yeelight床头灯","description:Yeelight床头灯","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/20/1_5.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:20"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:20","pid:200","sequence:1","status:0","product_sn:OWS0000200","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:20","pid:200","group_id:0","market_price:128","price:118"))
		
		
		'****商品21
		content = "1MORE三单元圈铁耳机"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:21","cate_id:104","sequence:21","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000210","market_price:198","price:188","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/21/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:1MORE三单元圈铁耳机","subtitle:单动圈+双动铁，呈现自然逼真的聆听体验","font_weight:0","root_id:104","rootpath:earphone","urlpath:1more1","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:21","seo_title:1MORE三单元圈铁耳机","keywords:1MORE三单元圈铁耳机","description:1MORE三单元圈铁耳机","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/21/1.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:21"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:21","pid:210","sequence:1","status:0","product_sn:OWS0000210","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:21","pid:210","group_id:0","market_price:198","price:188"))
		
		
		'****商品22
		content = "1MORE头戴式耳机"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:22","cate_id:104","sequence:22","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000220","market_price:198","price:188","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/22/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:1MORE头戴式耳机","subtitle:格莱美奖音乐大师定调随时享受音乐 ","font_weight:0","root_id:104","rootpath:earphone","urlpath:1more2","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:22","seo_title:1MORE头戴式耳机","keywords:1MORE头戴式耳机","description:1MORE头戴式耳机","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/22/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/22/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/22/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/22/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:22"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:22","pid:220","sequence:1","status:0","product_sn:OWS0000220","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:22","pid:220","group_id:0","market_price:198","price:188"))
		
		
		'****商品23
		content = "小米小钢炮蓝牙音箱"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:23","cate_id:104","sequence:23","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000230","market_price:298","price:288","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/23/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米小钢炮蓝牙音箱","subtitle:青春澎湃的好声音","font_weight:0","root_id:104","rootpath:earphone","urlpath:xiaogangpao","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:23","seo_title:小米小钢炮蓝牙音箱","keywords:小米小钢炮蓝牙音箱","description:小米小钢炮蓝牙音箱","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/23/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/23/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:23"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:23","pid:230","sequence:1","status:0","product_sn:OWS0000230","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:23","pid:230","group_id:0","market_price:298","price:288"))
		
		
		'****商品24
		content = "中国好声音1MORE活塞耳机入耳式 "
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:24","cate_id:104","sequence:24","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000240","market_price:188","price:178","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/24/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:中国好声音1MORE活塞耳机入耳式 ","subtitle:触摸式操作给卧室1600万种颜色","font_weight:0","root_id:104","rootpath:earphone","urlpath:1more3","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:24","seo_title:中国好声音1MORE活塞耳机入耳式 ","keywords:中国好声音1MORE活塞耳机入耳式 ","description:中国好声音1MORE活塞耳机入耳式 ","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/24/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/24/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/24/1_3.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/24/1_4.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:24"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:24","pid:240","sequence:1","status:0","product_sn:OWS0000240","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:24","pid:240","group_id:0","market_price:188","price:178"))
		
		
		'****商品25
		content = "小米随身蓝牙音箱"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:25","cate_id:104","sequence:25","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000250","market_price:198","price:188","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/25/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小米随身蓝牙音箱","subtitle:玲珑身材，不同凡响","font_weight:0","root_id:104","rootpath:earphone","urlpath:littleaudio","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:0","point_get_type:0","point_get_amount:0","point_pay_amount:0"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:25","seo_title:小米随身蓝牙音箱","keywords:小米随身蓝牙音箱","description:小米随身蓝牙音箱","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/25/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/25/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:25"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:25","pid:250","sequence:1","status:0","product_sn:OWS0000250","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:25","pid:250","group_id:0","market_price:198","price:188"))
		
		
		'****积分商品26
		content = "华为 Mate 8 时尚商务手包"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:26","cate_id:100","sequence:26","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000260","market_price:98","price:18","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/26/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:华为 Mate 8 时尚商务手包","subtitle:数量有限，兑完即止","font_weight:0","root_id:100","rootpath:point","urlpath:mate8bag","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:1","point_get_type:0","point_get_amount:0","point_pay_amount:8000"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:26","seo_title:华为 Mate 8 时尚商务手包","keywords:华为 Mate 8 时尚商务手包","description:华为 Mate 8 时尚商务手包","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/26/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/26/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:26"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:26","pid:250","sequence:1","status:0","product_sn:OWS0000250","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:26","pid:250","group_id:0","market_price:98","price:18"))
		
		'****积分商品27
		content = "闪迪SanDisk高速TF卡"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:27","cate_id:100","sequence:27","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000270","market_price:29","price:0","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/27/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:闪迪SanDisk高速TF卡","subtitle:声声动听的桌上艺术品","font_weight:0","root_id:100","rootpath:point","urlpath:sandisktf","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:1","point_get_type:0","point_get_amount:0","point_pay_amount:2900"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:27","seo_title:闪迪SanDisk高速TF卡","keywords:闪迪SanDisk高速TF卡","description:闪迪SanDisk高速TF卡","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/27/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/27/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:27"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:27","pid:250","sequence:1","status:0","product_sn:OWS0000270","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:27","pid:250","group_id:0","market_price:29","price:0"))
		
		'****积分商品28
		content = "小口哨AM07智控随充蓝牙耳机"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:28","cate_id:100","sequence:28","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000280","market_price:189","price:20","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/28/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:小口哨AM07智控随充蓝牙耳机","subtitle:数量有限，兑完即止","font_weight:0","root_id:100","rootpath:point","urlpath:lanyaerji","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:1","point_get_type:0","point_get_amount:0","point_pay_amount:17000"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:28","seo_title:小口哨AM07智控随充蓝牙耳机","keywords:小口哨AM07智控随充蓝牙耳机","description:小口哨AM07智控随充蓝牙耳机","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/28/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/28/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:28"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:28","pid:250","sequence:1","status:0","product_sn:OWS0000280","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:28","pid:250","group_id:0","market_price:189","price:20"))
		
		'****积分商品29
		content = "钢化玻璃贴膜(0.22mm) "
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:29","cate_id:100","sequence:29","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000290","market_price:29","price:2","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/29/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:钢化玻璃贴膜(0.22mm) ","subtitle:高透光率还原屏幕真实色彩","font_weight:0","root_id:100","rootpath:point","urlpath:tiemo","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:1","point_get_type:0","point_get_amount:0","point_pay_amount:2700"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:29","seo_title:钢化玻璃贴膜(0.22mm) ","keywords:钢化玻璃贴膜(0.22mm) ","description:钢化玻璃贴膜(0.22mm) ","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/29/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/29/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:29"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:29","pid:250","sequence:1","status:0","product_sn:OWS0000290","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:29","pid:250","group_id:0","market_price:29","price:2"))
		
		'****积分商品30
		content = "多彩半透手机保护壳"
		call OW.DB.addRecord(goodsTable,array("site_id:1","gid:30","cate_id:100","sequence:30","status:0","is_book:0","book_front_money_rate:0","book_price_discount:0","book_final_pay_day:0","is_book_timelimit:0","goods_sn:OWS0000300","market_price:29","price:2","thumbnail:"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/30/thumbnail.jpg","spec_id:","type_id:0","form_id:2","is_need_ship:1","brand_id:2","sales:0","comments:0","title:多彩半透手机保护壳","subtitle:一体式设计完美贴合","font_weight:0","root_id:100","rootpath:point","urlpath:shoujike","views:0","post_time:"& SYS_TIME,"update_time:"& SYS_TIME,"recommend:0","weight:0","dly_fee_type:0","dly_fee:0","dly_id:0","quota:0","point_set:1","point_get_type:0","point_get_amount:0","point_pay_amount:2800"))
		call OW.DB.addRecord(goodsData,array("site_id:1","gid:30","seo_title:多彩半透手机保护壳","keywords:多彩半透手机保护壳","description:多彩半透手机保护壳","content:"& content,"mob_content:"& content,"images:[{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/30/1.jpg&quot;,&quot;name&quot;:&quot;&quot;},{&quot;url&quot;:&quot;"& SITE_PATH &"ow-content/uploads/"& tplImageFolder &"/goods/30/1_2.jpg&quot;,&quot;name&quot;:&quot;&quot;}]","tpl_inherit:1","tpl:"))
		call OW.DB.addRecord(goodsModelData,array("gid:30"))
		call OW.DB.addRecord(goodsProduct,array("site_id:1","gid:30","pid:250","sequence:1","status:0","product_sn:OWS0000300","spec_value_id:","spec_value:","stock:100","stock_default:100"))
		call OW.DB.addRecord(goodsPrice,array("site_id:1","gid:30","pid:250","group_id:0","market_price:29","price:2"))
		
		
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function mailTpl(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"mail_tpl"
		call OW.DB.addRecord(table,array("site_id:1","sequence:4","status:0","is_default:1","mail_type:order_success_for_user","mail_name:下单成功邮件(发送给会员)","mail_desc:会员下单成功后系统会给会员发送一封订单邮件","mail_title:订单({$order_id})确认邮件","mail_body:","mail_tpl_file:order_success_for_user.html"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:5","status:0","is_default:1","mail_type:order_success_for_admin","mail_name:下单成功邮件(发送给管理员)","mail_desc:会员下单成功后系统会发送邮件通知管理员","mail_title:用户{$username}刚提交了一个订单({$order_id})","mail_body:","mail_tpl_file:order_success_for_admin.html"))
		call OW.DB.addRecord(table,array("site_id:1","sequence:6","status:0","is_default:1","mail_type:order_bookfinalpay_for_user","mail_name:尾款支付提醒","mail_desc:管理员开启尾款支付后给会员发送邮件提醒","mail_title:您的订单({$order_id})尾款支付提醒通知！","mail_body:","mail_tpl_file:order_bookfinalpay_for_user.html"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	
	public function order_form(byval tip)
		if tip<>"" then print tip
		table     = DB_PRE &"form"
		
		call OW.DB.addRecord(table,array("site_id:1","form_id:2","is_shop:1","sequence:1","status:0","name:默认订单表单","table:default","urlpath:","display:1","pagesize:0","tpl:","list_tpl:","field_tpl:","reply_tpl:","post_html:","send_email:0","rec_email:","auth:0","post_once:0","forbid_member_group:","need_check:0"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("site_id:1","field_id:6","form_id:2","sequence:1","status:0","field:consignee","field_name:收货人","field_type:text","field_datasize:32","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("site_id:1","field_id:7","form_id:2","sequence:2","status:0","field:address","field_name:收货地址","field_type:text","field_datasize:150","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("site_id:1","field_id:8","form_id:2","sequence:3","status:0","field:tel","field_name:联系电话","field_type:text","field_datasize:30","field_default:","field_options:","not_null:1","tips:","display_in_admin:0","display_in_client:1"))
		call OW.DB.addRecord(DB_PRE &"form_field",array("site_id:1","field_id:9","form_id:2","sequence:4","status:0","field:email","field_name:Email","field_type:text","field_datasize:64","field_default:","field_options:","not_null:0","tips:","display_in_admin:0","display_in_client:1"))
		call createOrderFormTable(DB_PRE &"order_form1_default")
		
		if tip<>"" then print "完成<br>"
	end function
	
	public function position(byval tip)
		if tip<>"" then print tip
		'**推荐位
		table = DB_PRE &"position"
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","is_shop:1","model_id:10","sequence:1","status:0","name:热品推荐"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","is_shop:1","model_id:10","sequence:1","status:0","name:为你推荐"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function position_data(byval tip)
		if tip<>"" then print tip
		'**推荐位数据
		table = DB_PRE &"position_data"
		'**商品**
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:1","status:0","cid:0","gid:1"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:2","status:0","cid:0","gid:2"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:3","status:0","cid:0","gid:6"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:4","status:0","cid:0","gid:7"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:5","status:0","cid:0","gid:5"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:6","status:0","cid:0","gid:11"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:7","status:0","cid:0","gid:14"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:8","status:0","cid:0","gid:13"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:4","sequence:9","status:0","cid:0","gid:18"))
		'**
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","sequence:1","status:0","cid:0","gid:1"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","sequence:2","status:0","cid:0","gid:5"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","sequence:3","status:0","cid:0","gid:2"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","sequence:4","status:0","cid:0","gid:11"))
		call OW.DB.addRecord(table,array("site_id:1","pos_id:5","sequence:5","status:0","cid:0","gid:15"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
	public function searchWords(byval tip)
		if tip<>"" then print tip
		table = DB_PRE &"search_keywords"
		call OW.DB.addRecord(table,array("site_id:1","status:0","is_shop:1","keyword:小米","search_count:1"))
		call OW.DB.addRecord(table,array("site_id:1","status:0","is_shop:1","keyword:苹果","search_count:1"))
		'**
		if tip<>"" then print "完成<br>"
	end function
	
end class
%>