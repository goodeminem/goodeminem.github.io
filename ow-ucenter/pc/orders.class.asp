<%
dim UC_ORDERS
class UC_ORDERS_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "do"
		case "detail"
			call OS.SHOP.orderProcessInit()
			call getOrderDetail()
			if V("order_exist") then
				call orderDetail()
			else
				UC.errorLink = array(UC.lang(1601) &">"& UCENTER_HURL &"ctl=orders",OS.lang(75) &">javascript:OW.goBack();")
				call UC.errorSetting(UC.lang(1654))
			end if
		case "goods_comment"
			call getGoodsDetail()
			if V("goods_exist") then
				if V("ship_status")=3 then
					call goodsComment()
				else
					UC.errorLink = array(UC.lang(1601) &">"& UCENTER_HURL &"ctl=orders",OS.lang(75) &">javascript:OW.goBack();")
					call UC.errorSetting(UC.lang(1655))
				end if
			else
				UC.errorLink = array(UC.lang(1601) &">"& UCENTER_HURL &"ctl=orders",OS.lang(75) &">javascript:OW.goBack();")
				call UC.errorSetting(UC.lang(1656))
			end if
		case "refund_apply"
			if SUBACT="view" then
				call refundApplyView()
			else
				if SAVE then
					call refundApplySave()
				else
					call refundApply()
				end if
			end if
		case else
			call OS.SHOP.orderProcessInit()
			call main()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function getOrderDetail()
		dim fieldsCount
		V("order_id")    = OW.parseOrderId(OW.getForm("get","order_id"))
		V("order_exist") = false
		set oRs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"orders WHERE order_id='"& V("order_id") &"' AND uid="& UID &"")
		fieldsCount = oRs.fields.count-1
		if not oRs.eof then
			V("order_exist") = true
			for i=1 to fieldsCount
				V(oRs.fields(i).name) = OW.rs(oRs(oRs.fields(i).name))
			next
			'**
			V("order_type")   = OW.int(V("order_type"))
			V("cost_item")    = OW.parseMoney(V("cost_item"))
			V("cost_invoice") = OW.parseMoney(V("cost_invoice"))
			V("cost_freight") = OW.parseMoney(V("cost_freight"))
			V("cost_pay")     = OW.parseMoney(V("cost_pay"))
			V("discount")     = OW.parseMoney(V("discount"))
			V("total_amount") = OW.parseMoney(V("total_amount"))
			V("money_paid")   = OW.parseMoney(V("money_paid"))
			V("date_added")   = OW.formatDateTime(V("date_added"),0)
			V("money_need_pay")= OW.parseMoney(V("total_amount")-V("money_paid"))
			'**
			V("offline_store_id") = OW.int(V("offline_store_id"))
			'**
			V("pay_id")            = OW.int(V("pay_id"))
			V("dly_id")            = OW.int(V("dly_id"))
			V("dly_corp")          = OW.int(V("dly_corp"))
			V("dly_corp_id")       = V("dly_corp")
			V("pay_status")        = OW.int(V("pay_status"))
			V("pay_refund_status") = OW.int(V("pay_refund_status"))
			'**
			V("is_book")                    = OW.int(V("is_book"))
			V("book_pay_open")              = OW.int(V("book_pay_open"))
			V("book_front_money")           = OW.parseMoney(V("book_front_money"))
			V("book_final_pay_time")        = OW.formatDateTime(V("book_final_pay_time"),0)
			V("is_need_pay_bookfrontmoney") = false
			V("is_need_pay_bookfinalmoney") = false
			V("btn_pay_name") = UC.lang(1645)
			if V("is_book")=1 then
			    V("book_order_text") = "<span class=""book-order"">"& UC.lang(1605) &"</span>"
				if V("book_front_money")>0 then
					if V("money_paid")=0 then V("is_need_pay_bookfrontmoney") = true : V("btn_pay_name") = UC.lang(1646)
					if V("money_paid")=V("book_front_money") then V("is_need_pay_bookfinalmoney") = true : V("btn_pay_name") = UC.lang(1647)
					if V("money_paid")>V("book_front_money") then V("is_need_pay_bookfinalmoney") = true : V("btn_pay_name") = UC.lang(1648)
				end if
			end if
		end if
		OW.DB.closeRs oRs
		'**
		if not(V("order_exist")) then exit function
		'**
		arr           = OW.DB.getFieldValueBySQL("SELECT pay_code,pay_name FROM "& DB_PRE &"payment WHERE pay_id="& V("pay_id") &" AND "& OW.DB.auxSQL &"")
		V("pay_code") = OW.rs(arr(0))
		V("pay_name") = OW.rs(arr(1))
		arr           = OW.DB.getFieldValueBySQL("SELECT dly_code,dly_name FROM "& DB_PRE &"delivery WHERE dly_id="& V("dly_id") &" AND "& OW.DB.auxSQL &"")
		V("dly_code") = OW.rs(arr(0))
		V("dly_name") = OW.rs(arr(1))
		arr                = OW.DB.getFieldValueBySQL("SELECT corp_code,corp_name FROM "& DB_PRE &"delivery_corp WHERE corp_id="& V("dly_corp_id") &" AND "& OW.DB.auxSQL &"")
		V("dly_corp_code") = OW.rs(arr(0))
		V("dly_corp_name") = OW.rs(arr(1))
		'**
		V("is_pay_online")     = lcase(OS.SHOP.isPayOnline(V("pay_id")))
		V("order_pay_url")     = SITE_URL &"ow-includes/ow.order_pay.asp?order_id="& V("order_id")
		V("order_payment_url") = SITE_URL &"?ctl=order&act=payment&order_id="& V("order_id")
		'**
		if V("total_amount")>0 and V("is_paid")<>1 and V("status")<>1 then
			dim sb,str : set sb = OW.stringBuilder()
			if V("is_book")=0 then
				if V("is_pay_online") then
					sb.append "<a href="""& V("order_pay_url") &""" class=""btn btn-primary"" name=""order_pay"" target=""_blank"">"& V("btn_pay_name") &"</a>"
					sb.append "<a href="""& V("order_payment_url") &""" class=""link"" name=""edit_payment"" target=""_blank"">"& UC.lang(1649) &"</a>"
				else
					sb.append "<a href="""& V("order_payment_url") &""" class=""btn btn-primary"" name=""order_pay"" target=""_blank"">"& V("btn_pay_name") &"</a>"
				end if
			else
				if V("is_need_pay_bookfrontmoney") then
					if V("is_pay_online") then
						sb.append "<a href="""& V("order_pay_url") &""" class=""btn btn-primary"" name=""order_pay"" target=""_blank"">"& V("btn_pay_name") &"</a>"
						sb.append "<a href="""& V("order_payment_url") &""" class=""link"" name=""edit_payment"" target=""_blank"">"& UC.lang(1649) &"</a>"
					else
						sb.append "<a href="""& V("order_payment_url") &""" class=""btn btn-primary"" name=""order_pay"" target=""_blank"">"& V("btn_pay_name") &"</a>"
					end if
				else
					if V("book_pay_open") then
						if OW.dateDiff("s",SYS_TIME,V("book_final_pay_time"))>0 then
							sb.append "<a href="""& V("order_pay_url") &""" class=""btn btn-primary"" name=""order_pay"" target=""_blank"">"& V("btn_pay_name") &"</a>"
							sb.append "<a href="""& V("order_payment_url") &""" class=""link"" name=""edit_payment"" target=""_blank"">"& UC.lang(1649) &"</a>"
							sb.append "<span class=""book-pay-time"" name=""book_paytime_tip"">"& replace(UC.lang(1657),"{$book_final_pay_time}","<b>"& OW.formatDateTime(V("book_final_pay_time"),0) &"</b>") &"</span>"
						else
							sb.append "<button type=""button"" class=""btn disabled"">"& UC.lang(1659) &"</button>"
							sb.append "<span class=""book-pay-time"" name=""book_paytime_tip"">"& replace(UC.lang(1658),"{$book_final_pay_time}","<b>"& OW.formatDateTime(V("book_final_pay_time"),0) &"</b>") &"</span>"
						end if
					else
						sb.append "<button type=""button"" class=""btn disabled"">"& UC.lang(1660) &"</button>"
					end if
				end if
			end if
			'**
			str = sb.toString() : set sb = nothing
			V("buttons_pay_html") = str
		end if
		'**
		V("pay_refund_tip_text") = OW.iif(V("pay_refund_status")>0,OW.iif(V("pay_refund_status")=2,UC.lang("pay_refund_status_2"),UC.lang("pay_refund_status_1")),"")
		if OS.isOrderCanRefund(V("order_id")) then
			V("order_refund_link") = "<a class=""btn-link"" href="""& UCENTER_HURL &"ctl=orders&act=refund_apply&order_id="& V("order_id") &""">"& UC.lang(1650) &"</a>"
		end if
		if OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"order_refund_apply WHERE order_id='"& V("order_id") &"'") then
			V("order_refund_link") = "<a class=""btn-link"" href="""& UCENTER_HURL &"ctl=orders&act=refund_apply&subact=view&order_id="& V("order_id") &""">"& UC.lang(1668) &"</a>"
		end if
		
	end function
	
	private function getGoodsDetail()
		dim arr,fieldsCount
		V("gid") = OW.int(OW.getForm("get","gid"))
		V("pid") = OW.int(OW.getForm("get","pid"))
		V("order_id")    = OW.parseOrderId(OW.getForm("get","order_id"))
		V("ship_status") = OW.int(OW.DB.getFieldValueBySQL("SELECT ship_status FROM "& OW.DB.Table.orders &" WHERE order_id='"& V("order_id") &"' AND uid="& UID &" AND "& OW.DB.auxSQL &""))
		set oRs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& V("order_id") &"' AND uid="& UID &" AND gid="& V("gid") &" AND pid="& V("pid") &"")
		fieldsCount = oRs.fields.count-1
		if oRs.eof then
			V("goods_exist") = false
		else
			V("goods_exist") = true
			for i=1 to fieldsCount
				V(oRs.fields(i).name) = OW.rs(oRs(oRs.fields(i).name))
			next
			'**
			arr = OW.DB.getFieldValueBySQL("SELECT thumbnail,rootpath,urlpath FROM "& OW.DB.Table.goods &" WHERE gid="& V("gid") &" AND "& OW.DB.auxSQL &"")
			V("thumbnail")= arr(0)
			V("rootpath") = arr(1)
			V("urlpath")  = arr(2)
			V("link")     = OW.reps(OW.reps(OW.urlRewrite("c7"),"{$rootpath}",V("rootpath")),"{$urlpath}",V("urlpath"))
		end if
		OW.DB.closeRs oRs
	end function
	
	private function getComment()
		dim fieldsCount,fieldName,fieldValue,html,loopStr,k,tpl,replyTpl,orderId,rs
		dim replyAvatar	
		tpl = "<div class=""comment-data""><div class=""avatar""><img name=""avatar"" src=""{$cmt_author_avatar}""><p class=""user"">{$cmt_author}</p></div><div class=""comment-data-content""><div class=""cmt-header""><span class=""cmt-spec"">"& UC.lang(1716) &"<b>{$spec_value}</b></span><span class=""cmt-buy-time"">"& UC.lang(1717) &"<b>{$buy_date}</b></span></div><div class=""cmt-content"">{$cmt_content}</div><div class=""cmt-footer""><span class=""cmt-type"">"& UC.lang(1718) &"{$cmt_type}</span><span class=""cmt-time"">"& UC.lang(1719) &"<b>{$cmt_date}</b></span></div></div></div><div class=""comment-data comment-data-reply"" name=""comment_data_reply""><div class=""avatar""><img name=""avatar"" src=""{$reply_author_avatar}""><p class=""user""></p></div><div class=""comment-data-content""><div class=""cmt-header"">"& UC.lang(1720) &"</div><div class=""cmt-content"" name=""reply_content"">{$reply_content}</div><div class=""cmt-footer""><span class=""cmt-time"">"& UC.lang(1721) &"<b>{$reply_date}</b></span></div></div></div>"
		set rs = OW.DB.getRecordBySQL("SELECT * from "& DB_PRE &"goods_comment where gid="& OW.int(V("gid")) &" AND cmt_uid="& UID &" AND "& OW.DB.auxSQL &" ORDER BY cmt_id ASC")
		fieldsCount = rs.fields.count-1
		do while not rs.eof
			orderId     = OW.rs(rs("order_id"))
			replyAvatar = OW.DB.getFieldValueBySQL("SELECT avatar FROM "& OW.DB.Table.member &" WHERE uid="& OW.int(rs("reply_uid")) &"")
			loopStr = tpl
			loopStr = OW.rep(loopStr,"{\$cmt_type}",OS.SHOP.commentType(rs("cmt_type")))
			loopStr = OW.rep(loopStr,"{\$buy_date}",OW.DB.getFieldValueBySQL("SELECT date_added FROM "& OW.DB.Table.orders &" WHERE order_id='"& orderId &"'"))
			loopStr = OW.rep(loopStr,"{\$cmt_author_avatar}",AVATAR)
			loopStr = OW.rep(loopStr,"{\$reply_author_avatar}",replyAvatar)
			for k=0 to fieldsCount
				fieldName = rs.fields(k).name
				fieldValue= OW.rs(rs(fieldName))
				loopStr   = OW.rep(loopStr,"{\$"& fieldName &"}",fieldValue)
			next
			html    = html & loopStr
			rs.movenext
		loop
		OW.DB.closeRs rs
		getComment = html
	end function
	
	private function goodsComment()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1722)%></h1>
          <div class="section-goods-commemt" id="goods_commemt">
			  <div class="section-goods" id="goods">
                  <table cellspacing="0" cellpadding="0" border="0" class="table  table-bordered table-hover">
                  <thead><tr><th><%=UC.lang(1325)%></th><th><%=UC.lang(1707)%></th><th><%=UC.lang(1326)%></th></tr></thead>
                  <tbody>
                      <tr>
                      <td><div class="goods-item"><div class="item-pic"><a href="<%=V("link")%>" target="_blank"><img class="pic" src="<%=V("thumbnail")%>"></a></div><div class="item-info"><a class="item-title" href="<%=V("link")%>" target="_blank"><%=V("goods_name")%></a><div class="item-spec"><%=V("spec_value")%></div></div></div></td>
                      <td><%=V("goods_sn")%></td>
                      <td><%=V("goods_amount")%></td>
                    </tr>
                    </tbody>
                </table>
              </div>
              <div class="section-commemt-post post-section" name="comment_post_form">
                  <div class="header"><%=UC.lang(1723)%></div>
                  <div class="section">
                      <dl>
                          <dt><%=UC.lang(1718)%></dt>
                          <dd>
                              <label><input type="radio" name="cmt_type" checked="checked" value="10"><%=OS.SHOP.commentType(10)%></label>
                              <label><input type="radio" name="cmt_type" value="7"><%=OS.SHOP.commentType(7)%></label>
                              <label><input type="radio" name="cmt_type" value="4"><%=OS.SHOP.commentType(4)%></label>
                          </dd>
                      </dl>
                      <dl>
                          <dt><%=UC.lang(1724)%></dt>
                          <dd><textarea class="textarea" name="cmt_content"></textarea><span name="t_cmt_content" class="t-normal ml5"></span></dd>
                      </dl>
                      <dl>
                          <dt><%=OS.lang(6)%></dt>
                          <dd><input type="text" class="text text-verifycode" name="verifycode_value" placeholder="<%=OS.lang(7)%>" ><span class="verifycode" name="verifycode"></span></dd>
                      </dl>
                  </div>
                  <div class="footer"><button type="button" class="btn btn-sbig btn-primary" name="submit"><%=UC.lang(1725)%></button><label><input type="checkbox" name="is_anonymous" value="true"><%=OS.lang(210)%></label></div>
              </div>
              <div class="section-commemt-list" id="comment_list">
                  <div class="header"><%=UC.lang(1726)%></div>
                  <div class="section">
                      <%=getComment()%>
                  </div>
              </div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//评价初始化
		var $form = $("[name='comment_post_form']");
		UC.commentInit({
			orderId:"<%=V("order_id")%>",
			gid:"<%=V("gid")%>",
			pid:"<%=V("pid")%>",
			form:$form,
			content:$form.find("textarea[name='cmt_content']"),
			vcodeValue:$form.find("input[name='verifycode_value']"),
			verifycode:$form.find("span[name='verifycode']"),
			submit:$form.find("button[name='submit']")
		});
		$("[name='comment_data_reply']").each(function(){if(OW.isNull($(this).find("[name='reply_content']").html())){$(this).remove();}});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function refundApply()
		dim rs
		V("order_id") = OW.parseOrderId(OW.getForm("get","order_id"))
		if OS.isOrderCanRefund(V("order_id")) then
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"orders WHERE order_id='"& V("order_id") &"'")
			if not(rs.eof) then
				V("pay_status")   = OW.int(rs("pay_status"))
				V("ship_status")  = OW.int(rs("ship_status"))
				V("total_amount") = OW.parseMoney(rs("total_amount"))
				V("cost_freight") = OW.parseMoney(rs("cost_freight"))
				V("money_paid")   = OW.parseMoney(rs("money_paid"))
				V("money_refund") = OW.parseMoney(rs("money_refund"))
				V("is_book")      = OW.int(rs("is_book"))
			end if
			OW.DB.closeRs rs
			V("money_can_refund") = V("money_paid") - V("money_refund")
			if V("ship_status")>0 and V("is_book")=0 then
				V("money_can_refund") = V("money_can_refund") - V("cost_freight")
			end if
			'**
			call refundApplyHtml()
		else
			call UC.errorSetting(UC.lang(1669))
		end if
	end function
	
	private function refundApplyView()
		dim rs
		V("order_id") = OW.parseOrderId(OW.getForm("get","order_id"))
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"orders WHERE order_id='"& V("order_id") &"'")
		if not(rs.eof) then
			V("pay_status")   = OW.int(rs("pay_status"))
			V("ship_status")  = OW.int(rs("ship_status"))
			V("total_amount") = OW.parseMoney(rs("total_amount"))
			V("cost_freight") = OW.parseMoney(rs("cost_freight"))
			V("money_paid")   = OW.parseMoney(rs("money_paid"))
			V("money_refund") = OW.parseMoney(rs("money_refund"))
			V("is_book")      = OW.int(rs("is_book"))
		end if
		OW.DB.closeRs rs
		V("money_can_refund") = V("money_paid") - V("money_refund")
		if V("ship_status")>0 and V("is_book")=0 then
			V("money_can_refund") = V("money_can_refund") - V("cost_freight")
		end if
		'**
		set rs = OW.DB.getRecordBySQL("SELECT top 1 * FROM "& DB_PRE &"order_refund_apply WHERE order_id='"& V("order_id") &"' ORDER BY id DESC")
		if not(rs.eof) then
			V("approved")          = OW.int(rs("approved"))
			V("refund_money")      = OW.parseMoney(rs("refund_money"))
			V("refund_reason")     = OW.rs(rs("refund_reason"))
			V("bank_type")         = OW.int(rs("bank_type"))
			V("bank_name")         = OW.rs(rs("bank_name"))
			V("bank_account")      = OW.rs(rs("bank_account"))
			V("bank_account_name") = OW.rs(rs("bank_account_name"))
			'**
			V("reply_uid")         = OW.int(rs("reply_uid"))
			V("reply")             = OW.rs(rs("reply"))
			V("date_reply")        = OW.rs(rs("date_reply"))
			'**
			V("money_can_refund")  = V("refund_money")
		end if
		OW.DB.closeRs rs
		call refundApplyHtml()
	end function
	
	private function refundApplyHtml()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1650)%></h1>
          <% if SUBACT<>"view" then%>
          <div class="flow"><ul><li class="current"><%=UC.lang(1728)%></li><li class="last"><%=UC.lang(1729)%></li></ul></div>
          <% end if %>
		  <div class="section-refund-apply">
              <div class="goods-section">
              <%=orderGoodsList(V("order_id"),"refund")%>
              </div>
              <form name="save_form" id="save_form" action="javascript:;" method="post">
              <div class="tablegrid">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formtable">
                  <tr><td class="titletd"><%=UC.lang(1603)%></td><td class="infotd"><%=V("order_id")%><span class="ship-status"><%=OW.iif(V("ship_status")>0,OS.SHOP.orderShipStatus(V("ship_status")),"")%></span></td></tr>
                  <tr><td class="titletd"><%=UC.lang(1641)%></td><td class="infotd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("total_amount"))%></b></span></td></tr>
                  <tr><td class="titletd"><%=UC.lang(1642)%></td><td class="infotd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_paid"))%></b></span></td></tr>
                  <% if V("ship_status")>0 then %>
                  <tr><td class="titletd"><%=UC.lang(1643)%></td><td class="infotd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_freight"))%></b></span></td></tr>
                  <% end if %>
                  <tr><td class="titletd"><%=UC.lang(1644)%></td><td class="infotd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_refund"))%></b></span></td></tr>
                  <tr><td class="titletd"><i class="important">*</i><%=OW.iif(SUBACT="view",UC.lang(1663),UC.lang(1664))%></td><td class="infotd"><input type="text" class="text text-short readonly" name="refund_money" readonly="readonly" value="<%=OW.config("money_sb")%><%=OW.parsePrice(V("money_can_refund"))%>" /><span name="t_refund_money" class="t-normal ml5"></span></td></tr>
                  <tr><td class="titletd top"><i class="important">*</i><%=UC.lang(1665)%></td>
                      <td class="infotd">
                      <textarea class="textarea" name="refund_reason" errmsg="<%=UC.lang(1666)%>" datatype="*" tips="" datasize="250" maxlength="250"><%=V("refund_reason")%></textarea>
                      <span name="t_refund_reason" class="t-normal ml5"></span>
                      </td>
                  </tr>
                  <tr><td class="titletd top"><%=UC.lang(1667)%></td>
                      <td class="infotd"><select name="bank_type"><%=OS.createOptions(array("0:"& UC.lang("bank_type_0") &"","1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></td>
                  </tr>
                  <tr name="bank_name_title"><td class="titletd top"><i class="important">*</i><%=UC.lang(1671)%></td>
                      <td class="infotd"><input type="text" class="text" name="bank_name" value="<%=V("bank_name")%>" /><span name="t_bank_name" class="t-normal ml5"></span></td>
                  </tr>
                  <tr name="bank_account_name_title"><td class="titletd top"><i class="important">*</i><span name="bank_account_name_title"><%=UC.lang(1672)%></span></td>
                      <td class="infotd"><input type="text" class="text" name="bank_account_name" maxlength="100" value="<%=V("bank_account_name")%>" /><span name="t_bank_account_name" class="t-normal ml5"></span></td>
                  </tr>
                  <tr name="bank_account_title"><td class="titletd top"><i class="important">*</i><span name="bank_account_title"><%=UC.lang(1673)%></span></td>
                      <td class="infotd"><input type="text" class="text" name="bank_account" maxlength="100" value="<%=V("bank_account")%>" /><span name="t_bank_account" class="t-normal ml5"></span></td>
                  </tr>
                  
                  </table>
              </div>
              <% if SUBACT="view" and V("reply_uid")>0 then echo refundAdminReplyHtml()%>
              <div class="form-actions">
                  <%=OW.iif(SUBACT="view","","<button type=""submit"" class=""btn btn-primary"" name=""submit"">"& UC.lang(155) &"</button>")%>
              </div>
              </form>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		$("select[name='bank_type']").change(function(){
			var bankType = $(this).val(),bankNameTip,bankAccountName,bankAccountNameTip,bankAccount,bankAccountTip;
			if(bankType==0){
				bankNameTip        = "";
				bankAccountName    = "";
				bankAccountNameTip = '';
				bankAccount        = "";
				bankAccountTip     = '';
				$("tr[name='bank_name_title']").hide();
				$("tr[name='bank_account_name_title']").hide();
				$("tr[name='bank_account_title']").hide();
			}else if(bankType==1){
				bankNameTip        = "<%=UC.lang(1671)%>";
				bankAccountName    = "<%=UC.lang(1672)%>";
				bankAccountNameTip = '<%=UC.lang(1674)%>';
				bankAccount        = "<%=UC.lang(1673)%>";
				bankAccountTip     = '<%=UC.lang(1675)%>';
				$("tr[name='bank_name_title']").show();
				$("tr[name='bank_account_name_title']").show();
				$("tr[name='bank_account_title']").show();
			}else if(bankType==2){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1676)%>";
				bankAccountNameTip = '<%=UC.lang(1678)%>';
				bankAccount        = "<%=UC.lang(1677)%>";
				bankAccountTip     = '<%=UC.lang(1679)%>';
				$("tr[name='bank_name_title']").hide();
				$("tr[name='bank_account_name_title']").show();
				$("tr[name='bank_account_title']").show();
			}else if(bankType==3){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1680)%>";
				bankAccountNameTip = '<%=UC.lang(1682)%>';
				bankAccount        = "<%=UC.lang(1681)%>";
				bankAccountTip     = '<%=UC.lang(1673)%>';
				$("tr[name='bank_name_title']").hide();
				$("tr[name='bank_account_name_title']").show();
				$("tr[name='bank_account_title']").show();
			};
			$("input[name='bank_name']").attr("placeholder",bankNameTip);
			$("input[name='bank_account_name']").attr("placeholder",bankAccountNameTip);
			$("input[name='bank_account']").attr("placeholder",bankAccountTip);
			$("span[name='bank_account_name_title']").html(bankAccountName);
			$("span[name='bank_account_title']").html(bankAccount);
		});
		$("select[name='bank_type']").change();
		//提交
		var orderId = "<%=V("order_id")%>",
		$saveForm   = $("#save_form");
		$saveForm.submit(function(){
			OW.parseFormInputValue({form:$saveForm});
			var $validForm = OWValidForm({form:$(this)});
			var check       = true,
			bankType        = OW.int($("select[name='bank_type']").val()),
			bankName        = $("input[name='bank_name']").val(),
			bankAccountName = $("input[name='bank_account_name']").val(),
			bankAccount     = $("input[name='bank_account']").val(),
			refundReason    = $("textarea[name='refund_reason']").val();
			if(bankType==1){
				if(OW.isNull(bankName)){if(check){OWDialog().alert('<%=UC.lang(1684)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1685)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1686)%>').position().timeout(2); check=false;};};
			}else if(bankType==2){
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1687)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1688)%>').position().timeout(2); check=false;};};
			};
			if(OW.isNull(refundReason)){if(check){OWDialog().alert('<%=UC.lang(1689)%>').position().timeout(2); check=false;};};
			if(check){
				var $dialog = UC.dialogPosting();
				var url = "?ctl=<%=CTL%>&act=<%=ACT%>&order_id="+orderId+"&save=true";
				$validForm.getFormData();
				OW.ajax({
					me:"",url:url,data:$validForm.formData,
					success:function(){
						$dialog.success("<%=UC.lang(1690)%>").position();
						OW.delay(2000,function(){
							OW.redirect("?ctl=<%=CTL%>&act=detail&order_id="+orderId+"");
						});
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(169)%>',msg).position().timeout(4);
						OW.setDisabled($("button[name='submit']"),false);
					}
				});
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function refundApplySave()
		dim result
		V("order_id")          = OW.parseOrderId(OW.getForm("get","order_id"))
		V("refund_money")      = OW.parseMoney(OW.getForm("post","refund_money"))
		V("bank_type")         = OW.int(OW.getForm("post","bank_type"))
		V("bank_name")         = OW.validClientDBData(OW.getForm("post","bank_name"),50)
		V("bank_account_name") = OW.validClientDBData(OW.getForm("post","bank_account_name"),100)
		V("bank_account")      = OW.validClientDBData(OW.getForm("post","bank_account"),32)
		V("refund_reason")     = OW.validClientDBData(OW.getForm("post","refund_reason"),250)
		V("ip")                = OW.getClientIP()
		'****
		if V("bank_type")=1 then
			if OW.isNul(V("bank_name")) then : call UC.errorSetting(UC.lang(1684)) : exit function : end if
			if OW.isNul(V("bank_account_name")) then : call UC.errorSetting(UC.lang(1685)) : exit function : end if
			if OW.isNul(V("bank_account")) then : call UC.errorSetting(UC.lang(1686)) : exit function : end if
		end if
		if V("bank_type")=2 then
			V("bank_name") = "支付宝"
			if OW.isNul(V("bank_account_name")) then : call UC.errorSetting(UC.lang(1687)) : exit function : end if
			if OW.isNul(V("bank_account")) then : call UC.errorSetting(UC.lang(1688)) : exit function : end if
		end if
		if not(OS.isOrderCanRefund(V("order_id"))) then
			call UC.errorSetting(UC.lang(1669))
		else
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"orders WHERE order_id='"& V("order_id") &"'")
			if not(rs.eof) then
				V("pay_status")   = OW.int(rs("pay_status"))
				V("ship_status")  = OW.int(rs("ship_status"))
				V("total_amount") = OW.parseMoney(rs("total_amount"))
				V("cost_freight") = OW.parseMoney(rs("cost_freight"))
				V("money_paid")   = OW.parseMoney(rs("money_paid"))
				V("money_refund") = OW.parseMoney(rs("money_refund"))
				V("is_book")      = OW.int(rs("is_book"))
			end if
			OW.DB.closeRs rs
			V("money_can_refund") = V("money_paid") - V("money_refund")
			if V("ship_status")>0 and V("is_book")=0 then
				V("money_can_refund") = V("money_can_refund") - V("cost_freight")
			end if
			if V("refund_money")>V("money_can_refund") then
				call UC.errorSetting(replace(UC.lang(1670),"{$money_can_refund}",V("money_can_refund"))) : exit function
			end if
			result = OW.DB.addRecord(DB_PRE &"order_refund_apply",array("site_id:"& SITE_ID,"order_id:"& V("order_id"),"uid:"& UID,"status:0","approved:0","refund_money:"& V("refund_money"),"refund_reason:"& V("refund_reason"),"bank_type:"& V("bank_type"),"bank_name:"& V("bank_name"),"bank_account:"& V("bank_account"),"bank_account_name:"& V("bank_account_name"),"reply:","reply_uid:0","ip:"& V("ip"),"date_apply:"& SYS_TIME))
			UC.actionFinishSuccess     = result
			UC.actionFinishSuccessText = array(UC.lang(1692),"")
			UC.actionFinishFailText    = array(UC.lang(1693),"")
			UC.actionFinishRun()
		end if
	end function
	
	private function refundAdminReplyHtml()
		dim sb,str : set sb = OW.stringBuilder()
		select case V("approved")
		case -1
			V("approved_text") = "<span style=""color:#d60000;"">"& UC.lang("refund_status_-1") &"</span>"
		case 0
			V("approved_text") = "<span style=""color:#3473c8;"">"& UC.lang("refund_status_0") &"</span>"
		case 1
			V("approved_text") = "<span style=""color:#21aa85;"">"& UC.lang("refund_status_1") &"</span>"
		case 2
			V("approved_text") = "<span style=""color:#2ba114;"">"& UC.lang("refund_status_2") &"</span>"
		end select
		sb.append "<div class=""refund-admin-reply""><div class=""tablegrid"">"
		sb.append "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"" class=""formtable"">"
		sb.append "<tr><td class=""titletd top"">"& UC.lang(1694) &"</td><td class=""infotd"">"& V("approved_text") &"</td></tr>"
		if V("approved")<>0 then
		sb.append "<tr><td class=""titletd top"">"& UC.lang(1695) &"</td><td class=""infotd"">"& V("reply") &"</td></tr>"
		sb.append "<tr><td class=""titletd top"">"& UC.lang(1696) &"</td><td class=""infotd"">"& V("date_reply") &"</td></tr>"
		end if
		sb.append "</table>"
		sb.append "</div></div>"
		str = sb.toString() : set sb = nothing
		refundAdminReplyHtml = str
	end function
	
	private function main()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1600)%></h1>
          <div class="section-orders" id="orders">
			  <div class="section">
			  <%
              OW.Pager.sql      = "select order_id,order_name,is_book,date_added,total_amount,money_paid,pay_status,status from "& DB_PRE &"orders where uid="& UID &" ORDER BY id DESC"
              OW.Pager.pageSize = 20
              OW.Pager.pageUrl  = "index.asp?ctl=orders&page={$page}"
              OW.Pager.loopHtml = "<tr><td field=""order_id"" value=""{$order_id}""><a href="""& UCENTER_HURL &"ctl=orders&act=detail&order_id={$order_id}"">{$order_id}</a></td><td field=""order_name"" value=""{$order_name}""><a href="""& UCENTER_HURL &"ctl=orders&act=detail&order_id={$order_id}"">{$order_name}</a></td><td field=""is_book"" value=""{$is_book}"">{$is_book}<td field=""date_added"" value=""{$date_added}"">{$date_added}</td><td field=""total_amount"" value=""{$total_amount}""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>{$total_amount}</b></span></td><td field=""money_paid"" value=""{$money_paid}""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>{$money_paid}</b></span></td><td field=""pay_status"" value=""{$pay_status}"">{$pay_status}</td><td field=""status"" value=""{$status}"">{$status}</td><td field=""opeation""><a href="""& UCENTER_HURL &"ctl=orders&act=detail&order_id={$order_id}"">"& UC.lang(1699) &"</a></td></tr>"
              OW.Pager.run()
              %>
              <table border="0" cellpadding="0" cellspacing="0" class="table table-striped table-bordered table-hover">
              <thead><tr><th><%=UC.lang(1603)%></th><th><%=UC.lang(1604)%></th><th><%=UC.lang(1605)%></th><th><%=UC.lang(1606)%></th><th><%=UC.lang(1607)%></th><th><%=UC.lang(1608)%></th><th><%=UC.lang(1609)%></th><th><%=UC.lang(1610)%></th><th><%=UC.lang(1698)%></th></tr></thead>
              <tbody><%=OW.Pager.loopHtmls%></tbody>
              </table>
              </div>
              <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//**交易类型
		$("#orders").find("td[field='total_amount'],td[field='money_paid']").each(function(){
			$(this).find("b").html(OW.parsePrice($(this).attr("value")));
		});
		//**支付状态
		$("#orders td[field='pay_status']").each(function(){
			var html,status = $(this).attr("value");
			if(status==0){
				html = '<span class="status-1"><%=UC.lang("pay_status_0")%></span>';
			}else if(status==1){
				html = '<span class="status-1"><%=UC.lang("pay_status_1")%></span>';
			}else if(status==2){
				html = '<span class="status-0"><%=UC.lang("pay_status_2")%></span>';
			};
			$(this).html(html);
		});
		//**订单状态
		$("#orders td[field='status']").each(function(){
			var html,status = $(this).attr("value");
			if(status==0){
				html = '<span class="status-0"><%=UC.lang("order_status_0")%></span>';
			}else if(status==1){
				html = '<span class="status-1"><%=UC.lang("order_status_1")%></span>';
			};
			$(this).html(html);
		});
		//**预订
		$("#orders td[field='is_book']").each(function(){
			var html="",status = $(this).attr("value");
			if(status==1){
				html = '<span class="is-book-0"><%=UC.lang(1605)%></span>';
			};
			$(this).html(html);
		});
		//**
		$("#orders td[field='order_name']").each(function(){
			var html = OW.leftString($(this).attr("value"),40);
			$(this).html(html);
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function

	private function orderDetail()
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1602)%></h1>
          <div class="section-order">
              <div class="order-header">
                  <div class="order-id-line">
                      <span class="fr">
                          <button type="button" class="btn btn-primary ml5" name="order_ship_receiving"><%=UC.lang(1651)%></button><button type="button" class="btn btn-danger btn-sm ml5" name="order_cancel"><%=UC.lang(1652)%></button>
                          <%=V("order_refund_link")%>
                      </span>
                      <span class="order-id"><%=UC.lang(1603)%>：<%=V("order_id")%></span><%=V("book_order_text")%><%=OW.iif(V("status")=1,"<span class=""order-cancelled"">"& UC.lang(1653) &"</span>","")%><%=OW.iif(OW.isNotNul(V("pay_refund_tip_text")),"<span class=""order-refund"">"& V("pay_refund_tip_text") &"</span>","")%><span class="order-add-time"><%=UC.lang(1606)%>：<%=V("date_added")%></span>
                  </div>
                  <div class="order-action"><%=V("buttons_pay_html")%></div>
                  <%=orderPayTimeTip()%>
              </div>
              <div class="order-process-section">
                  <ul class="order-process" name="order_process" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                      <%=orderProcess()%>
                  </ul>
                  <div class="order-process-detail" name="order_process_detail" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                      <h2 class="header"><%=UC.lang(1611)%></h2>
                      <div class="section">
                          <table cellspacing="0" cellpadding="0" border="0" class="table  table-bordered table-striped table-hover">
                          <thead><tr><th><%=UC.lang(1612)%></th><th><%=UC.lang(1613)%></th></tr></thead>
                          <tbody><%=orderProcessDetail("<tr><td class=""tdtitle"">{$time}</td><td>{$desc}</td></tr>")%></tbody>
                          </table>
                      </div>
                  </div>
                  <div class="order-process-detail" name="order_process_detail" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                      <h2 class="header"><%=UC.lang(1614)%></h2>
                      <div class="section">
                          <table cellspacing="0" cellpadding="0" border="0" class="table table-hover">
                          <colgroup><col class="col-xs-1"><col class="col-xs-7"></colgroup>
                          <thead><tr><th class="tdtitle"><%=UC.lang(1615)%></th><th><%=UC.lang(1616)%></th></tr></thead>
                          <tbody><%=orderShipInfo("<tr><td class=""tdtitle"">{$dly_corp_name}</td><td><a href=""http://www.baidu.com/baidu?wd={$dly_corp_name}+{$express_no}"" target=""_blank"">{$express_no}</a></td></tr>")%></tbody>
                          </table>
                      </div>
                  </div>
                  <div class="order-goods">
                      <h2 class="header"><%=UC.lang(1617)%></h2>
                      <div class="section">
                          <%=orderGoodsList(V("order_id"),"order")%>
                      </div>
                  </div>
                  <div class="order-info">
                      <h2 class="header"><%=UC.lang(1697)%></h2>
                      <div class="section" id="order_base_info">
						  <table border="0" cellpadding="0" cellspacing="0" class="table table-bordered table-hover">
                          <tbody>
                          <tr><td><%=UC.lang(1730)%></td><td><%=V("dly_name")%></td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1618)%></td><td><%=V("pay_name")%></td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1619)%></td><td>
                              <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_item"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1620)%></td><td>
                              <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_invoice"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1621)%></td><td>
                              <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_freight"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1622)%></td><td>
                              <span class="money font-14"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_pay"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1623)%></td><td>
                              <span class="money font-14"><em>-<%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_coupon"))%></b></span>
                              </td></tr>
                          <tr style="display:none;"><td class="tdtitle"><%=UC.lang(1624)%></td><td>
                              <span class="money font-14"><em>-<%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("discount"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><strong><%=UC.lang(1625)%></strong></td><td>
                              <span class="money total-amount"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("total_amount"))%></b></span>
                              </td></tr>
                          <% if V("is_book") then %>
                          <tr><td class="tdtitle"><%=UC.lang(1626)%></td><td>
                              <span class="money front-money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("book_front_money"))%></b></span>
                              <%
							  if OW.isValidDatetime(V("book_arrival_time")) then
								  if OW.dateDiff("d",V("date_added"),V("book_arrival_time"))>0 then
									  echo "<span class=""book-final-pay-time"">"& UC.lang(1627) &" "& OW.formatDateTime(V("book_arrival_time"),1) &"</span>"
								  end if
							  end if
                              %>
                              </td></tr>
                          <% end if%>
                          <tr><td class="tdtitle"><%=UC.lang(1628)%></td><td>
                              <span class="money money-paid"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_paid"))%></b></span>
                              </td></tr>
                          <tr><td class="tdtitle"><%=UC.lang(1629)%></td><td>
                              <span class="money need-pay"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_need_pay"))%></b></span>
                          </tbody>
                          </table>
                      </div>
                      <div class="section" id="order_formdata_info">
                          <% if V("offline_store_id")>0 then echo offlineStoreInfo() %>
                          <% if V("order_type")=0 then echo orderRegion() %>
						  <%=orderFormDataList("<div class=""order-form-data""><table cellspacing=""0"" cellpadding=""0"" border=""0"" class=""table table-bordered table-hover"" width=""100%""><tbody>{$tpl}</tbody></table></div>","<tr is_print=""{$is_print}""><td class=""tdtitle"">{$field_name}</td><td>{$field_value}</td></tr>")%>
                      </div>
                      <div class="section">
                          <div id="order_invoice">
							  <% if OW.isNotNul(V("invoice")) then %>
                              <div class="order-invoice">
                              <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table table-bordered table-hover">
                                  <thead>
                                      <tr><th colspan="2"><%=UC.lang(1631)%><span style="font-weight:normal; padding-left:5px;">(<%=OW.iif(OW.int(OW.getODataKeyValue(V("invoice"),"invoice_type"))=2,OS.lang(29),OS.lang(28))%>)</span></th></tr>
                                  </thead>
                                  <tbody>
                                      <tr><td class="tdtitle"><%=UC.lang(1632)%></td><td><%=OW.getODataKeyValue(V("invoice"),"invoice_title")%></td></tr>
                                      <tr><td class="tdtitle"><%=UC.lang(1635)%></td><td><%=OW.getODataKeyValue(V("invoice"),"invoice_code")%></td></tr>
                                      <tr><td class="tdtitle"><%=UC.lang(1633)%></td><td>
                                      <%
                                      if OW.int(OW.getODataKeyValue(V("invoice"),"invoice_content_type"))=1 then
                                          echo UC.lang(1634)
                                      else
                                          echo OW.getODataKeyValue(V("invoice"),"invoice_content")
                                      end if
                                      %>
                                      </td></tr>
                                      <%
                                      dim sb,str : set sb = OW.stringBuilder()
                                      if OW.int(OW.getODataKeyValue(V("invoice"),"invoice_type"))=2 then
                                          sb.append "<tr><td>"& UC.lang(1636) &"</td><td>"& OW.getODataKeyValue(V("invoice"),"invoice_address") &"</td></tr>"
                                          sb.append "<tr><td>"& UC.lang(1637) &"</td><td>"& OW.getODataKeyValue(V("invoice"),"invoice_phone") &"</td></tr>"
                                          sb.append "<tr><td>"& UC.lang(1638) &"</td><td>"& OW.getODataKeyValue(V("invoice"),"invoice_bank_name") &"</td></tr>"
                                          sb.append "<tr><td>"& UC.lang(1639) &"</td><td>"& OW.getODataKeyValue(V("invoice"),"invoice_bank_account") &"</td></tr>"
                                      end if
                                      str = sb.toString() : set sb = nothing
                                      echo str
                                      %>
                                  </tbody>
                              </table>
                              </div>
                              <% end if %>
                          </div>
                      </div>
                      <div class="section">
                          <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table table-bordered">
                              <tr><td class="tdtitle"><%=UC.lang(1640)%></td><td><%=V("remark")%></td></tr>
                          </table>
                      </div>
                  </div>
              </div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
	$(document).ready(function(){
		var $orderPay       = $("[name='order_pay']"),
		$editPayment        = $("[name='edit_payment']"),
		$orderShipReceiving = $("button[name='order_ship_receiving']"),
		$orderCancel        = $("button[name='order_cancel']"),
		orderId          = "<%=V("order_id")%>",
		orderApproved    = OW.int("<%=V("approved")%>"),
		orderStatus      = OW.int("<%=V("status")%>"),
		moneyPaid        = OW.parseMoney("<%=V("money_paid")%>"),
		moneyRefund      = OW.parseMoney("<%=V("money_refund")%>"),
		isPaid           = OW.int("<%=V("is_paid")%>"),
		isShipped        = OW.int("<%=V("is_shipped")%>"),
		payStatus        = OW.int("<%=V("pay_status")%>"),
		payRefundStatus  = OW.int("<%=V("pay_refund_status")%>"),
		shipStatus       = OW.int("<%=V("ship_status")%>"),
		shipRefundStatus = OW.int("<%=V("ship_refund_status")%>"),
		isPayOnline      = <%=V("is_pay_online")%>;
		//订单已确认或已取消
		if(payStatus>0 || shipStatus>0 || orderStatus==1){
			$orderCancel.remove();
		};
		//订单已支付或已取消
		if(isPaid==1 || orderStatus==1){
			$orderPay.remove();
			$editPayment.remove();
		};
		//订单已支付或已取消
		if(!(shipStatus==2)){
			$orderShipReceiving.remove();
		};
		if(shipStatus!=3){
			$("a[name='goods_comment']").hide();
		};
		//订单状态进程
		$orderProcess = $("ul[name='order_process']");
		$orderProcess.find("li:first").addClass("first");
		$orderProcess.find("li:last").addClass("last");
		//订单支付
		$orderPay.click(function(){
			var $dialog = OWDialog({
				id:OW.createDialogID(),close:false,
				content:"<%=UC.lang(1700)%>",
				fontSize:'14px',
				ok:function(){OW.refresh()},
				okValue:'<%=UC.lang(1701)%>',
				cancel:true,
				cancelValue:'<%=UC.lang(1702)%>'
			}).fontSize("16px");
		});
		$orderShipReceiving.click(function(){
			var $dialog = new OWDialog({
				id:OW.createDialogID(),cancel:true,follow:$(this),close:false,
				content:"<%=UC.lang(1703)%>",
				ok:function(){
					this.posting().button({id:'ok',remove:true},{id:'cancel',remove:true});
					OW.ajax({
						url:OW.sitePath +"ow-includes/ow.ajax.shop.asp?ctl=order&act=ship_receiving",
						data:"order_id="+escape(orderId),
						success:function(){
							$dialog.success("<%=UC.lang(1704)%>").timeout(2);
							OW.delay(1500,function(){OW.refresh()});
						},
						failed:function(msg){
							$dialog.error("<%=UC.lang(169)%>",msg).timeout(4);
						}
					});
					return false;
				}
			});
		});
		//订单取消
		$orderCancel.click(function(){
			var $dialog = new OWDialog({
				id:OW.createDialogID(),cancel:true,follow:$(this),close:false,
				content:"<%=UC.lang(1705)%>",
				ok:function(){
					this.posting("<%=UC.lang(1727)%>").button({id:'ok',remove:true},{id:'cancel',remove:true});
					OW.ajax({
						url:OW.sitePath +"ow-includes/ow.ajax.shop.asp?ctl=order&act=order_cancel",
						data:"order_id="+escape(orderId),
						success:function(){
							$dialog.success("<%=UC.lang(1706)%>").timeout(2);
							OW.delay(1500,function(){OW.refresh()});
						},
						failed:function(msg){
							$dialog.error("<%=UC.lang(169)%>",msg).timeout(4);
						}
					});
					return false;
				}
			});
		});
		
	});
	</script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function orderPayTimeTip()
		dim orderTime,orderOutTime,orderStatus,payStatus
		dim sb,str : set sb = OW.stringBuilder()
		orderTime   = V("date_added")
		orderStatus = OW.int(V("status"))
		payStatus   = OW.int(V("pay_status"))
		if OW.int(OW.config("order_cancel_time"))>0 and payStatus=0 and orderStatus=0 then
			timeStr      = "<b>"& OW.formatDateTime(OW.dateAdd("n",OW.int(OW.config("order_cancel_time")),orderTime),0) &"</b>"
			orderOutTime = OW.dateAdd("n",OW.config("order_cancel_time"),orderTime)
			sb.append "<div class=""order-paytime-tip"" name=""order_paytime_tip"">"& OW.reps(OS.lang(41),"{$time}",timeStr) &"</div>"
			sb.append "<script type=""text/javascript"">$(document).ready(function(){OW.timeOutTip({d:'"& OS.lang("time_d") &"',h:'"& OS.lang("time_h") &"',n:'"& OS.lang("time_n") &"',s:'"& OS.lang("time_s") &"',time:'"& orderOutTime &"',now:'"& SYS_TIME &"',section:$(""div[name='order_paytime_tip']"").find(""b"")})});</script>"
		end if
		str = sb.toString() : set sb = nothing
		orderPayTimeTip = str
	end function
	
	private function orderProcess()
		dim arr,arr2,css,i,pcsTime,tips,pcsType,process,updated
		dim sb,str : set sb = OW.stringBuilder()
		tpl = "<li class=""{$css}"" updated=""{$updated}""><span>{$i}</span><dl><dt>{$process}</dt><dd>{$time}</dd></dl><div class=""tips"">{$tips}</div></li>"
		arr = split(V("order_process_config"),"|")
		for i=0 to ubound(arr)
			pcsType = OW.int(OW.cLeft(arr(i),":"))
			process = OW.cRight(arr(i),":")
			arr2    = OW.DB.getFieldValueBySQL("SELECT process_tips,process_time FROM "& DB_PRE &"order_process WHERE order_id='"& V("order_id")&"' AND process_type="& pcsType &" AND "& OW.DB.auxSQL &"")
			tips    = OW.rs(arr2(0))
			pcsTime = OW.formatDateTime(arr2(1),0)
			if OW.isNul(pcsTime) then
				css = ""
				updated = 0
			else
				css = "current"
				updated = 1
			end if
			sb.append "<li class="""& css &""" updated="""& updated &"""><span>"& (i+1) &"</span><dl><dt>"& process &"</dt><dd>"& pcsTime &"</dd></dl><div class=""tips"">"& tips &"</div></li>"
		next
		str = sb.toString() : set sb = nothing
		orderProcess = str
	end function
	
	private function orderProcessDetail(byval tpl)
		dim desc,i,s,ss,time,tips
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_process_detail WHERE order_id='"& V("order_id") &"'")
		do while not rs.eof
			i    = i + 1
			desc = OW.rs(rs("process_desc"))
			time = OW.formatDateTime(rs("process_time"),0)
			s = tpl
			s = OW.reps(s,"{$time}",time)
			s = OW.reps(s,"{$desc}",desc)
			ss = ss & s
			rs.movenext
		loop
		OW.DB.closeRs rs
		orderProcessDetail = ss
	end function
	
	private function orderShipInfo(byval tpl)
		dim s,ss
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_ship_bill WHERE order_id='"& V("order_id") &"'")
		do while not rs.eof
			i = i + 1
			s = tpl
			s = OW.reps(s,"{$dly_corp_name}",OW.rs(rs("dly_corp_name")))
			s = OW.reps(s,"{$express_no}",OW.rs(rs("express_no")))
			ss = ss & s
			rs.movenext
		loop
		OW.DB.closeRs rs
		orderShipInfo = ss
	end function
	
	private function orderGoodsList(byval orderId,byval returnType)
		dim arr,n,rs,rs2,s,ss,sss
		dim amount,comment,gid,pid,goodsName,productSn,price,thumbnail,specValue,sum
		dim suitId,suitName,suitPrice,suitAmount,suitSum,suitDiscountType,suitDiscount
		dim sb : set sb = OW.stringBuilder()
		sb.append "<table border=""0"" cellpadding=""0"" cellspacing=""0"" class=""order-goods-table"">"
		sb.append "<thead><tr class=""thead""><th>"& UC.lang(1707) &"</th><th>"& UC.lang(1708) &"</th><th>"& UC.lang(1709) &"</th><th>"& UC.lang(1710) &"</th><th>"& UC.lang(1711) &"</th><th>"& UC.lang(1712) &"</th>"
		if returnType="order" then
			sb.append "<th>"& UC.lang(1713) &"</th>"
		end if
		sb.append "</tr></thead>"
		'**
		set rs2 = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_suit WHERE order_id='"& orderId &"' AND "& OW.DB.auxSQL &"")
		do while not rs2.eof
			suitId     = OW.int(rs2("suit_id"))
			suitName   = OW.rs(rs2("suit_name"))
			suitPrice  = OW.parsePrice(rs2("suit_price"))
			suitAmount = OW.int(rs2("suit_amount"))
			suitSum    = OW.parsePrice(rs2("suit_sum"))
			'**
			sb.append "<tbody class=""suit"">"
			'**
			s = "<tr class=""suit"">"
			s = s &"<td><div class=""item-gid""></div></td>"
			s = s &"<td><div class=""goods-item""><div class=""suit-name""><b>"& OS.lang(1010) &"</b><span>"& suitName &"<span></div></div></td>"
			s = s &"<td><div class=""item-product-sn"">"& productSn &"</div></td>"
			s = s &"<td><div class=""item-price""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& suitPrice &"</b></span></div></td>"
			s = s &"<td><div class=""item-amount"">"& suitAmount &"</div></td>"
			s = s &"<td><div class=""item-price""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& suitSum &"</b></span></div></td>"
			if returnType="order" then
			s = s &"<td></td>"
			end if
			s = s &"</tr>"
			sb.append s
			'**
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& orderId &"' AND suit_id="& suitId &" AND "& OW.DB.auxSQL &"")
			do while not rs.eof
				gid      = rs("gid")
				pid      = rs("pid")
				goodsName= rs("goods_name")
				specValue= rs("spec_value")
				price    = rs("goods_price")
				amount   = rs("goods_amount")
				sum      = rs("goods_sum")
				productSn= rs("product_sn")
				arr      = OW.DB.getFieldValueBySQL("SELECT thumbnail,rootpath,urlpath FROM "& OW.DB.Table.goods &" WHERE gid="& rs("gid") &" AND "& OW.DB.auxSQL &"")
				thumbnail= arr(0)
				rootpath = arr(1)
				urlpath  = arr(2)
				link     = OW.reps(OW.reps(OW.urlRewrite("c7"),"{$rootpath}",rootpath),"{$urlpath}",urlpath)
				comment  = "<a href="""& UCENTER_HURL &"ctl=orders&act=goods_comment&order_id="& orderId &"&gid="& gid &"&pid="& pid &""" name=""goods_comment"" gid="""& gid &""" pid="""& pid &""">"& UC.lang(1714) &"</a>"
				'**
				s = "<tr class=""goods"">"
				s = s &"<td><div class=""item-gid"">"& gid &"</div></td>"
				s = s &"<td><div class=""goods-item""><div class=""item-pic""><a href="""& link &""" target=""_blank""><img src="""& thumbnail &""" class=""pic""></a></div><div class=""item-info""><a target=""_blank"" href="""& link &""" class=""item-title"">"& goodsName &"</a><div class=""item-spec"">"& specValue &"</div></div></div></td>"
				s = s &"<td><div class=""item-product-sn"">"& productSn &"</div></td>"
				s = s &"<td><div class=""item-price""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(price) &"</b></span></div></td>"
				s = s &"<td><div class=""item-amount"">"& amount &"</div></td>"
				s = s &"<td><div class=""item-sum""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(sum) &"</b></span></div></td>"
				if returnType="order" then
				s = s &"<td><div class=""item-comment"">"& comment &"</div></td>"
				end if
				s = s &"</tr>"
				sb.append s
				'**
				rs.movenext
			loop
			OW.DB.closeRs rs
			sb.append "</tbody>"
			'**
			rs2.movenext
		loop
		OW.DB.closeRs rs2
		'**	
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& orderId &"' AND suit_id=0 AND "& OW.DB.auxSQL &"")
		do while not rs.eof
			gid      = rs("gid")
			pid      = rs("pid")
			goodsName= rs("goods_name")
			specValue= rs("spec_value")
			price    = rs("goods_price")
			amount   = rs("goods_amount")
			sum      = rs("goods_sum")
			productSn= rs("product_sn")
			arr      = OW.DB.getFieldValueBySQL("SELECT thumbnail,rootpath,urlpath FROM "& OW.DB.Table.goods &" WHERE gid="& rs("gid") &" AND "& OW.DB.auxSQL &"")
			thumbnail= arr(0)
			rootpath = arr(1)
			urlpath  = arr(2)
			link     = OW.reps(OW.reps(OW.urlRewrite("c7"),"{$rootpath}",rootpath),"{$urlpath}",urlpath)
			comment  = "<a href="""& UCENTER_HURL &"ctl=orders&act=goods_comment&order_id="& orderId &"&gid="& gid &"&pid="& pid &""" name=""goods_comment"" gid="""& gid &""" pid="""& pid &""">评价/晒单</a>"
			'**
			sb.append "<tbody>"
			s = "<tr class=""goods"">"
			s = s &"<td><div class=""item-gid"">"& gid &"</div></td>"
			s = s &"<td><div class=""goods-item""><div class=""item-pic""><a href="""& link &""" target=""_blank""><img src="""& thumbnail &""" class=""pic""></a></div><div class=""item-info""><a target=""_blank"" href="""& link &""" class=""item-title"">"& goodsName &"</a><div class=""item-spec"">"& specValue &"</div></div></div></td>"
			s = s &"<td><div class=""item-product-sn"">"& productSn &"</div></td>"
			s = s &"<td><div class=""item-price""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(price) &"</b></span></div></td>"
			s = s &"<td><div class=""item-amount"">"& amount &"</div></td>"
			s = s &"<td><div class=""item-sum""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(sum) &"</b></span></div></td>"
			if returnType="order" then
			s = s &"<td><div class=""item-comment"">"& comment &"</div></td>"
			end if
			s = s &"</tr>"
			sb.append s
			sb.append "</tbody>"
			'**
			rs.movenext
		loop
		OW.DB.closeRs rs
		'**
		
		sb.append "</table>"
		'**
		ss = sb.toString()
		set sb = nothing
		orderGoodsList = ss
	end function
	
	private function offlineStoreInfo()
		dim rs
		dim sb,str : set sb = OW.stringBuilder()
		if OW.int(V("offline_store_id"))>0 then
			sb.append "<div class=""section""><table cellspacing=""0"" cellpadding=""0"" border=""0"" class=""table table-bordered table-hover"" width=""100%""><tbody>"
			sb.append "<tr><td class=""tdtitle"">"& UC.lang(1630) &"</td><td>" 
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"offline_store WHERE store_id="& V("offline_store_id") &" AND "& OW.DB.auxSQL &"")
			if not rs.eof then
				sb.append rs("store_name") &"（"& rs("store_address") &"）"
			end if
			OW.DB.closeRs rs
			sb.append "</td></tr>"
			sb.append "</tbody></table></div>"
		end if
		str = sb.toString() : set sb = nothing
		offlineStoreInfo = str
	end function
	
	private function orderRegion()
		if OW.int(OW.config("is_region_open"))<>1 then exit function
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<div class=""order-form-data""><table cellspacing=""0"" cellpadding=""0"" border=""0"" class=""table table-bordered table-hover"" width=""100%""><tbody>"
		sb.append "<tr is_print=""{$is_print}""><td class=""tdtitle"">"& UC.lang(1730) &"</td><td>"& V("region_names") &"</td></tr>"
		sb.append "</tbody></table></div>"
		str = sb.toString() : set sb = nothing
		orderRegion = str
	end function
	
	private function orderFormDataList(byval tpls,byval tpl)
		dim rs1,rs,formId,formDBTable,formName,ss,formDataHtml
		dim fieldsCount,field,fieldName,fieldType,fieldValue,objValue
		set rs1 = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form WHERE is_shop=1 AND "& OW.DB.auxSQL &"")
		do while not rs1.eof
			formId       = OW.int(rs1("form_id"))
			formDBTable  = OW.DB.Table.orderFormPre & OW.rs(rs1("table"))
			formName     = OW.rs(rs1("name"))
			set objValue= server.createObject(OW.dictName)
			set rs      = OW.DB.getRecordBySQL("SELECT * FROM "& formDBTable &" WHERE order_id='"& V("order_id") &"'")
			fieldsCount = rs.fields.count-1
			if rs.eof then
				V("order_form_exist") = false
			else
				V("order_form_exist") = true
				for i=3 to fieldsCount
					objValue(rs.fields(i).name) = OW.rs(rs(rs.fields(i).name))
				next
			end if
			OW.DB.closeRs rs
			if V("order_form_exist") then
				ss     = ""
				set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& formId &" AND display_in_client=1 AND "& OW.DB.auxSQL &"")
				do while not rs.eof
					field      = OW.rs(rs("field"))
					fieldName  = OW.rs(rs("field_name"))
					fieldType  = OW.rs(rs("field_type"))
					fieldValue = objValue(field)
					if fieldType="attachment" then
						if not OW.isNul(objValue(field)) then
							fieldValue = "<a href="""& objValue(field) &""" title="""& UC.lang(1715) &""" target=""_blank"">"& UC.lang(1715) &"</a>"
						end if
					else
						fieldValue = objValue(field)
					end if
					s = tpl
					s = OW.reps(s,"{$field_name}",fieldName)
					s = OW.reps(s,"{$field_value}",fieldValue)
					ss= ss & s
					rs.movenext
				loop
				OW.DB.closeRs rs
				formDataHtml = formDataHtml & OW.reps(tpls,"{$tpl}",ss)
			end if
			set objValue = nothing
			'**
			rs1.movenext
		loop
		OW.DB.closeRs rs1
		orderFormDataList = formDataHtml
	end function
	
end class
%>

