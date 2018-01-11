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
	<%=UC.htmlHeaderMobile("<a href=""javascript:OW.goBack();"" class=""goback""></a>",UC.lang(1722))%>
    <section id="mbody">
        <div class="om-goods-comment" id="goods_commemt">
            <div class="section-goods" id="goods">
                <div class="img"><a href="<%=V("link")%>"><img src="<%=V("thumbnail")%>"></a></div>
                <div class="info">
                    <p class="title"><a class="item-title" href="<%=V("link")%>"><%=V("goods_name")%></a></p>
                    <p name="item_spec" class="item-spec"><%=UC.lang(1716)%><span><%=V("spec_value")%></span></p>
                    <p class="item-sn"><%=UC.lang(1707)%>：<span><%=V("goods_sn")%></span></p>
                    <p class="item-amount"><%=UC.lang(1326)%>：<span><%=V("goods_amount")%></span></p>
                </div>
            </div>
            <div class="post-section" name="comment_post_form">
                <form class="form-horizontal" name="form_comment" action="javascript:;">
                    <div class="control-group">
                        <label for="username" class="control-label"><%=UC.lang(1718)%></label>
                        <div class="controls controls-label">
                        <label><input type="radio" name="cmt_type" checked="checked" value="10"><%=OS.SHOP.commentType(10)%></label>
                        <label><input type="radio" name="cmt_type" value="7"><%=OS.SHOP.commentType(7)%></label>
                        <label><input type="radio" name="cmt_type" value="4"><%=OS.SHOP.commentType(4)%></label>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="password" class="control-label"><%=UC.lang(1724)%></label>
                        <div class="controls controls-textarea">
                        <textarea class="textarea" name="cmt_content"></textarea><span name="t_cmt_content" class="t-normal"></span>
                        </div>
                    </div>
                    <div class="control-group">
                        <label for="verifycode_value" class="control-label"><%=OS.lang(6)%></label>
                        <div class="controls">
                        <input type="type" class="text text-large text-verifycode" name="verifycode_value" placeholder="<%=OS.lang(7)%>" /><span class="verifycode" name="verifycode"></span>
                        </div>
                    </div>
                    <div class="control-textline">
                        <div class="controls"><label><input type="checkbox" name="is_anonymous" value="true"><%=OS.lang(210)%></label></div>
                    </div>
                    <div class="control-button">
                        <div class="controls"><button type="button" class="btn btn-large btn-primary" name="submit"><%=UC.lang(1725)%></button></div>
                    </div>
                </form>
            </div>
            <div class="section-comment-list" id="comment_list">
                <div class="header"><%=UC.lang(1726)%></div>
                <div class="section">
                    <%=getComment()%>
                </div>
            </div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		//评价初始化
		var $form        = $("[name='comment_post_form']"),
		$vcodeValue = $form.find("input[name='verifycode_value']"),
		$verifycode      = $form.find("span[name='verifycode']");
		OW.verifyCode({boxer:$verifycode});
		OW.verifyCodeValueBlur($vcodeValue);
		OW.verifyCodeValueFocus($vcodeValue,$verifycode);
		UC.commentInit({
			orderId:"<%=V("order_id")%>",
			gid:"<%=V("gid")%>",
			pid:"<%=V("pid")%>",
			form:$form,
			content:$form.find("textarea[name='cmt_content']"),
			vcodeValue:$vcodeValue,
			verifycode:$verifycode,
			submit:$form.find("button[name='submit']")
		});
		$("[name='comment_data_reply']").each(function(){if(OW.isNull($(this).find("[name='reply_content']").html())){$(this).remove();}});
		//
		$("p[name='item_spec']").each(function(){
			if(OW.isNull($(this).find("span").html())){
				$(this).remove();
			};
		});
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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1650))%>
    <section id="mbody">
        <div class="section-refund-apply">
            <div class="goods-section" style="display:none;">
                <div class="order-goods"><%=orderGoodsList(V("order_id"),"refund")%></div>
            </div>
            <div class="refund-apply">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
                <div class="owui-cells owui-cells-first">
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1603)%></label></div>
                        <div class="owui-cell-bd"><%=V("order_id")%><span class="ship-status"><%=OW.iif(V("ship_status")>0,OS.SHOP.orderShipStatus(V("ship_status")),"")%></span></div>
                    </div>
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1641)%></label></div>
                        <div class="owui-cell-bd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("total_amount"))%></b></span></div>
                    </div>
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1642)%></label></div>
                        <div class="owui-cell-bd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_paid"))%></b></span></div>
                    </div>
                    <% if V("ship_status")>0 then %>
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1643)%></label></div>
                        <div class="owui-cell-bd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_freight"))%></b></span></div>
                    </div>
                    <% end if %>
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1644)%></label></div>
                        <div class="owui-cell-bd"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_refund"))%></b></span></div>
                    </div>
                    <div class="owui-cell">
                        <div class="owui-cell-hd"><label class="owui-label"><%=OW.iif(SUBACT="view",UC.lang(1663),UC.lang(1664))%></label></div>
                        <div class="owui-cell-bd"><input type="text" class="owui-input" name="refund_money" readonly="readonly" value="<%=OW.config("money_sb")%><%=OW.parsePrice(V("money_can_refund"))%>" /></div>
                    </div>
                    <div class="owui-cell owui-cell-select owui-cell-select-after">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1667)%></label></div>
                        <div class="owui-cell-bd"><select class="owui-select" name="bank_type"><%=OS.createOptions(array("0:"& UC.lang("bank_type_0") &"","1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></div>
                    </div>
                    <div class="owui-cell" name="bank_name_title">
                        <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1671)%></label></div>
                        <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_name" value="<%=V("bank_name")%>" /></div>
                    </div>
                    <div class="owui-cell" name="bank_account_name_title">
                        <div class="owui-cell-hd"><label class="owui-label" name="bank_account_name_title"><%=UC.lang(1672)%></label></div>
                        <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_account_name" maxlength="100" value="<%=V("bank_account_name")%>" /></div>
                    </div>
                    <div class="owui-cell" name="bank_account_title">
                        <div class="owui-cell-hd"><label class="owui-label" name="bank_account_title"><%=UC.lang(1673)%></label></div>
                        <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_account" maxlength="100" value="<%=V("bank_account")%>" /></div>
                    </div>
                </div>
                <div class="owui-cells-title"><%=UC.lang(1665)%></div>
                <div class="owui-cells owui-cells-form">
                    <div class="owui-cell">
                        <div class="owui-cell-bd">
                            <textarea class="owui-textarea" name="refund_reason" errmsg="<%=UC.lang(1666)%>" placeholder="<%=UC.lang(1666)%>" datatype="*" tips="" datasize="250" maxlength="250"><%=V("refund_reason")%></textarea>
                        </div>
                    </div>
                </div>
                <% if SUBACT="view" and V("reply_uid")>0 then echo refundAdminReplyHtml()%>
                <% if SUBACT<>"view" then %>
                <div class="owui-btn-area">
                    <button type="submit" class="owui-btn owui-btn-primary" name="submit"><%=UC.lang(155)%></button>
                </div>
                <% end if %>
            </form>
            </div>
        </div>
    </section>
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
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").hide();
				$("div[name='bank_account_title']").hide();
			}else if(bankType==1){
				bankNameTip        = "<%=UC.lang(1671)%>";
				bankAccountName    = "<%=UC.lang(1672)%>";
				bankAccountNameTip = '<%=UC.lang(1674)%>';
				bankAccount        = "<%=UC.lang(1673)%>";
				bankAccountTip     = '<%=UC.lang(1675)%>';
				$("div[name='bank_name_title']").show();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			}else if(bankType==2){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1676)%>";
				bankAccountNameTip = '<%=UC.lang(1678)%>';
				bankAccount        = "<%=UC.lang(1677)%>";
				bankAccountTip     = '<%=UC.lang(1679)%>';
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			}else if(bankType==3){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1680)%>";
				bankAccountNameTip = '<%=UC.lang(1682)%>';
				bankAccount        = "<%=UC.lang(1681)%>";
				bankAccountTip     = '<%=UC.lang(1673)%>';
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			};
			$("input[name='bank_name']").attr("placeholder",bankNameTip);
			$("input[name='bank_account_name']").attr("placeholder",bankAccountNameTip);
			$("input[name='bank_account']").attr("placeholder",bankAccountTip);
			$("label[name='bank_account_name_title']").html(bankAccountName);
			$("label[name='bank_account_title']").html(bankAccount);
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
		sb.append "<div class=""refund-admin-reply"">"
		sb.append "<form class=""form-horizontal"" action=""javascript:;"" method=""post"">"
		sb.append "<div class=""control-group""><label class=""control-label"">"& UC.lang(1694) &"</label><div class=""controls controls-text"">"& V("approved_text") &"</div></div>"
		if V("approved")<>0 then
		sb.append "<div class=""control-group""><label class=""control-label"">"& UC.lang(1695) &"</label><div class=""controls controls-text"">"& V("reply") &"</div></div>"
		sb.append "<div class=""control-group""><label class=""control-label"">"& UC.lang(1696) &"</label><div class=""controls controls-text"">"& V("date_reply") &"</div></div>"
		end if
		sb.append "</form>"
		sb.append "</div>"
		str = sb.toString() : set sb = nothing
		refundAdminReplyHtml = str
	end function
	
	private function main()
		call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1600))%>
    <section id="mbody">
        <div class="om-orders" id="orders">
            <div class="section">
				<%
                OW.Pager.sql      = "select order_id,order_name,is_book,date_added,total_amount,money_paid,pay_status,status from "& DB_PRE &"orders where uid="& UID &" ORDER BY id DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl=orders&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<section><a href="""& UCENTER_HURL &"ctl=orders&act=detail&order_id={$order_id}""><div class=""order-id"">"& UC.lang(1603) &"：{$order_id}<span class=""is-book"" field=""is_book"" value=""{$is_book}"">{$is_book}</span><span class=""status"" field=""status"" value=""{$status}"">{$status}</span></div><div class=""order-money"">"& UC.lang(1607) &"：<span class=""money"" field=""total_amount"" value=""{$total_amount}""><em>"& OW.config("money_sb") &"</em><b>{$total_amount}</b></span><span class=""pay-status"" field=""pay_status"" value=""{$pay_status}"">{$pay_status}</span></div><div class=""order-name"">{$order_name}</div><div class=""order-time"">{$date_added}</div></a></section>"
                OW.Pager.loopExecute= "if fieldName=""date_added"" then fieldValue = OW.formatDateTime(fieldValue,0)"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
            </div>
            <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		//**交易类型
		$("#orders").find("span[field='total_amount'],span[field='money_paid']").each(function(){
			$(this).find("b").html(OW.parsePrice($(this).attr("value")));
		});
		//**支付状态
		$("#orders span[field='pay_status']").each(function(){
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
		$("#orders span[field='status']").each(function(){
			var html,status = $(this).attr("value");
			if(status==0){
				$(this).remove();
			}else if(status==1){
				html = '<span class="status-1"><%=UC.lang("order_status_0")%></span>';
				$(this).html(html);
			};
		});
		//**预订
		$("#orders span[field='is_book']").each(function(){
			var html="",status = $(this).attr("value");
			if(status==1){html = '<%=UC.lang(1605)%>';};
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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_HURL &"ctl=orders"" class=""goback""></a>",UC.lang(1602))%>
    <section id="mbody">
        <div class="om-order">
            <div class="order-header">
                <div class="order-id">
                    <%=UC.lang(1603)%>：<%=V("order_id")%><%=V("book_order_text")%><%=OW.iif(V("status")=1,"<span class=""order-cancelled"">("& UC.lang(1653) &")</span>","")%><%=OW.iif(OW.isNotNul(V("pay_refund_tip_text")),"<span class=""order-refund"">"& V("pay_refund_tip_text") &"</span>","")%>
                    <span class="order-do-link">
                        <a name="order_ship_receiving" href="javascript:;"><%=UC.lang(1651)%></a><a name="order_cancel" href="javascript:;"><%=UC.lang(1652)%></a><%=V("order_refund_link")%>
                    </span>
                </div>
                <div class="order-add-time"><%=UC.lang(1606)%>：<%=V("date_added")%></div>
                <div class="order-action"><%=V("buttons_pay_html")%></div>
                <%=orderPayTimeTip()%>
            </div>
            <div class="order-process-section">
                <ul class="order-process" name="order_process" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                    <%=orderProcess()%>
                </ul>
                <div class="clear"></div>
                <div class="order-process-detail" name="order_process_detail" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                    <h2 class="header"><%=UC.lang(1611)%></h2>
                    <div class="section">
                        <%=orderProcessDetail("<dl><dd>{$desc}</dd><dt>{$time}</dt></dl>")%>
                    </div>
                </div>
                <div class="clear"></div>
                <div class="order-process-detail" name="order_process_detail" <%=OW.iif(V("order_type")>0,"style=""display:none;""","")%>>
                    <h2 class="header"><%=UC.lang(1614)%></h2>
                    <div class="section">
                        <%=orderShipInfo("<dl><dd><a href=""http://m.baidu.com/s?word={$dly_corp_name}+{$express_no}"" target=""_blank"">{$dly_corp_name} {$express_no}</a></dd></dl>")%>
                    </div>
                </div>
                <div class="order-goods">
                    <h2 class="header"><%=UC.lang(1617)%></h2>
                    <div class="section">
                        <%=orderGoodsList(V("order_id"),"order")%>
                    </div>
                </div>
                <div class="order-base-info" id="order_base_info">
                    <table border="0" cellpadding="0" cellspacing="0" class="table table-bordered table-hover">
                    <tbody>
                    <tr><td><%=UC.lang(1730)%></td><td><%=V("dly_name")%></td></tr>
                    <tr><td><%=UC.lang(1618)%></td><td><%=V("pay_name")%></td></tr>
                    <tr><td><%=UC.lang(1619)%></td><td>
                        <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_item"))%></b></span>
                        </td></tr>
                    <tr><td><%=UC.lang(1620)%></td><td>
                        <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_invoice"))%></b></span>
                        </td></tr>
                    <tr><td><%=UC.lang(1621)%></td><td>
                        <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_freight"))%></b></span>
                        </td></tr>
                    <tr><td><%=UC.lang(1622)%></td><td>
                        <span class="money font-14"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_pay"))%></b></span>
                        </td></tr>
                    <tr><td><%=UC.lang(1623)%></td><td>
                        <span class="money font-14"><em>-<%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("cost_coupon"))%></b></span>
                        </td></tr>
                    <tr style="display:none;"><td><%=UC.lang(1624)%></td><td>
                        <span class="money font-14"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("discount"))%></b></span>
                        </td></tr>
                    <tr><td><strong><%=UC.lang(1625)%></strong></td><td>
                        <span class="money total-amount"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("total_amount"))%></b></span>
                        </td></tr>
                    <% if V("is_book") then %>
                    <tr><td><%=UC.lang(1626)%></td><td>
                        <span class="money"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("book_front_money"))%></b></span>
                        <%
						if OW.isValidDatetime(V("book_arrival_time")) then
							if OW.dateDiff("d",V("date_added"),V("book_arrival_time"))>0 then
								echo "<span class=""book-final-pay-time"">"& UC.lang(1627) &" "& OW.formatDateTime(V("book_arrival_time"),1) &"</span>"
							end if
						end if
						%>
                        </td></tr>
                    <% end if %>
                    <tr><td><%=UC.lang(1628)%></td><td>
                        <span class="money money-paid"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_paid"))%></b></span>
                        </td></tr>
                    <tr><td class="tdtitle"><%=UC.lang(1629)%></td><td>
                        <span class="money need-pay"><em><%=OW.config("money_sb")%></em><b><%=OW.parsePrice(V("money_need_pay"))%></b></span>
                    </tbody>
                    </table>
                </div>
                <% if V("offline_store_id")>0 then echo offlineStoreInfo() %>
                <div class="order-info" id="order_formdata_info">
                    <h2 class="header"><%=UC.lang(1697)%></h2>
                    <div class="section">
						<% if V("order_type")=0 then echo orderRegion() : end if %>
						<%=orderFormDataList("{$tpl}","<dl is_print=""{$is_print}""><dt>{$field_name}</dt><dd>{$field_value}</dd></dl>")%>
                    </div>
                </div>
                <% if OW.isNotNul(V("invoice")) then %>
                <div class="order-base-info" id="order_invoice">
                    <table width="100%" cellspacing="0" cellpadding="0" border="0" class="table table-bordered table-hover">
                    <thead>
                        <tr><th colspan="2"><%=UC.lang(1631)%><span style="font-weight:normal; padding-left:5px;">(<%=OW.iif(OW.int(OW.getODataKeyValue(V("invoice"),"invoice_type"))=2,OS.lang(29),OS.lang(28))%>)</span></th></tr>
                    </thead>
                    <tbody>
                        <tr><td><%=UC.lang(1632)%></td><td><%=OW.getODataKeyValue(V("invoice"),"invoice_title")%></td></tr>
                        <tr><td><%=UC.lang(1635)%></td><td><%=OW.getODataKeyValue(V("invoice"),"invoice_code")%></td></tr>
                        <tr><td><%=UC.lang(1633)%></td><td>
                        <%
                        if OW.int(OW.getODataKeyValue(V("invoice"),"invoice_content_type"))=1 then
                            echo UC.lang(1634)
                        else
                            echo OW.getODataKeyValue(V("invoice"),"invoice_content")
                        end if
                        %>
                        </td></tr>
                        <%
                        '**
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
                <div class="order-remark" name="order_remark">
                    <h2 class="header"><%=UC.lang(1640)%></h2>
                    <div class="section"><%=V("remark")%></div>
                </div>
            </div>
        </div>
    </section>
    <script type="text/javascript">
	$(document).ready(function(){
		var $orderPay       = $("[name='order_pay']"),
		$editPayment        = $("[name='edit_payment']"),
		$orderShipReceiving = $("[name='order_ship_receiving']"),
		$orderCancel        = $("[name='order_cancel']"),
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
		isPayOnline      = <%=lcase(OS.SHOP.isPayOnline(V("pay_id")))%>;
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
			}).fontSize("14px").position();
		});
		$orderShipReceiving.click(function(){
			var $dialog = new OWDialog({
				id:OW.createDialogID(),cancel:true,close:false,
				content:"<%=UC.lang(1703)%>",
				ok:function(){
					this.posting().button({id:'ok',remove:true},{id:'cancel',remove:true});
					OW.ajax({
						url:OW.sitePath +"ow-includes/ow.ajax.shop.asp?ctl=order&act=ship_receiving",
						data:"order_id="+escape(orderId),
						success:function(){
							$dialog.success("<%=UC.lang(1704)%>").position().timeout(2);
							OW.delay(1500,function(){OW.refresh()});
						},
						failed:function(msg){
							$dialog.error("<%=UC.lang(169)%>",msg).position().timeout(4);
						}
					});
					return false;
				}
			}).padding("15px 20px").position();
		});
		//订单取消
		$orderCancel.click(function(){
			var $dialog = new OWDialog({
				id:OW.createDialogID(),cancel:true,cancelValue:"<%=OS.lang(4)%>",close:false,
				content:"<%=UC.lang(1705)%>",
				ok:function(){
					this.posting("<%=UC.lang(1727)%>").button({id:'ok',remove:true},{id:'cancel',remove:true});
					OW.ajax({
						url:OW.sitePath +"ow-includes/ow.ajax.shop.asp?ctl=order&act=order_cancel",
						data:"order_id="+escape(orderId),
						success:function(){
							$dialog.success("<%=UC.lang(1706)%>").position().timeout(2);
							OW.delay(1500,function(){OW.refresh()});
						},
						failed:function(msg){
							$dialog.error("<%=UC.lang(169)%>",msg).position().timeout(4);
						}
					});
					return false;
				}
			}).padding("15px 20px").position();
		});
		//
		$("p[name='item_spec']").each(function(){
			if(OW.isNull($(this).find("span").html())){
				$(this).remove();
			};
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
		dim arr,arr2,css,i,s,ss,pcsTime,tips,pcsType,process,updated
		tpl = "<li class=""{$css}"" updated=""{$updated}""><span></span><dl><dt>{$process}</dt><dd>{$time}</dd></dl><div class=""tips"">{$tips}</div></li>"
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
			s = tpl
			s = OW.reps(s,"{$css}",css)
			s = OW.reps(s,"{$updated}",updated)
			s = OW.reps(s,"{$process}",process)
			s = OW.reps(s,"{$tips}",tips)
			s = OW.reps(s,"{$time}",pcsTime)
			ss = ss & s
		next
		orderProcess = ss
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
		'**
		set rs2 = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_suit WHERE order_id='"& V("order_id") &"' AND "& OW.DB.auxSQL &"")
		do while not rs2.eof
			suitId     = OW.int(rs2("suit_id"))
			suitName   = OW.rs(rs2("suit_name"))
			suitPrice  = OW.parsePrice(rs2("suit_price"))
			suitAmount = OW.int(rs2("suit_amount"))
			suitSum    = OW.parsePrice(rs2("suit_sum"))
			'**
			sb.append "<ul class=""suit"">"
			sb.append "<li class=""item-suit"">"
			sb.append "<div class=""col-suit-name""><b>"& OS.lang(1010) &"</b><span>"& suitName &"<span></div>"
			sb.append "<div class=""col-suit-info"">"
			sb.append "<span class=""suit-price""><span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(suitPrice) &"</b></span></span>"
			sb.append "<span class=""suit-amount"">X"& suitAmount &"</span>"
			sb.append "<span class=""suit-sum""><span class=""money""><em>"& OW.config("money_sb") &"</em><b name=""item_sum"">"& OW.parsePrice(suitSum) &"</b></span></span>"
			sb.append "</div>"
			sb.append "</li>"
			'**
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& V("order_id") &"' AND suit_id="& suitId &" AND "& OW.DB.auxSQL &"")
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
				'**
				comment  = "<a href="""& UCENTER_HURL &"ctl=orders&act=goods_comment&order_id="& V("order_id") &"&gid="& gid &"&pid="& pid &""" name=""goods_comment"" gid="""& gid &""" pid="""& pid &""">评价/晒单</a>"
				'**
				sb.append "<li class=""item-goods"">"
				sb.append "<div class=""col-pic""><a href="""& link &"""><img class=""thumbnail"" src="""& thumbnail &"""></a></div>"
				sb.append "<div class=""col-info"">"
				sb.append "<div class=""item-title""><a href="""& link &""">"& goodsName &"</a></div>"
				if OW.isNotNul(specValue) then
				sb.append "<div class=""item-spec"">"& specValue &"</div>"
				end if
				sb.append "<div class=""item-gid"">"& UC.lang(1707) &"："& gid &"</div>"
				sb.append "<div class=""item-product-sn"">"& UC.lang(1709) &"："& productSn &"</div>"
				sb.append "<div class=""item-price"">"& UC.lang(1710) &"：<span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(price) &"</b></span></div>"
				sb.append "<div class=""item-amount"">"& UC.lang(1711) &"："& amount &"</span>"
				sb.append "<div class=""item-sum"">"& UC.lang(1712) &"：<span class=""money""><em>"& OW.config("money_sb") &"</em><b name=""item_sum"">"& OW.parsePrice(sum) &"</b></span></div>"
				sb.append "<div class=""item-comment"">"& comment &"</span>"
				sb.append "</div>"
				sb.append "</li>"
				'**
				rs.movenext
			loop
			OW.DB.closeRs rs
			sb.append "</ul>"
			'**
			rs2.movenext
		loop
		OW.DB.closeRs rs2
		'**	
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& V("order_id") &"' AND suit_id=0 AND "& OW.DB.auxSQL &"")
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
			comment  = "<a href="""& UCENTER_HURL &"ctl=orders&act=goods_comment&order_id="& V("order_id") &"&gid="& gid &"&pid="& pid &""" name=""goods_comment"" gid="""& gid &""" pid="""& pid &""">评价/晒单</a>"
			'**
			sb.append "<ul class=""goods"">"
			sb.append "<li class=""item-goods"">"
			sb.append "<div class=""col-pic""><a href="""& link &"""><img class=""thumbnail"" src="""& thumbnail &"""></a></div>"
			sb.append "<div class=""col-info"">"
			sb.append "<div class=""item-title""><a href="""& link &""">"& goodsName &"</a></div>"
			if OW.isNotNul(specValue) then
			sb.append "<div class=""item-spec"">"& specValue &"</div>"
			end if
			sb.append "<div class=""item-gid"">"& UC.lang(1707) &"："& gid &"</div>"
			sb.append "<div class=""item-product-sn"">"& UC.lang(1709) &"："& productSn &"</div>"
			sb.append "<div class=""item-price"">"& UC.lang(1710) &"：<span class=""money""><em>"& OW.config("money_sb") &"</em><b>"& OW.parsePrice(price) &"</b></span></div>"
			sb.append "<div class=""item-amount"">"& UC.lang(1711) &"："& amount &"</span>"
			sb.append "<div class=""item-sum"">"& UC.lang(1712) &"：<span class=""money""><em>"& OW.config("money_sb") &"</em><b name=""item_sum"">"& OW.parsePrice(sum) &"</b></span></div>"
			sb.append "<div class=""item-comment"">"& comment &"</span>"
			sb.append "</div>"
			sb.append "</li>"
			sb.append "<tbody>"
			sb.append "</ul>"
			'**
			rs.movenext
		loop
		OW.DB.closeRs rs
		'**
		ss = sb.toString()
		set sb = nothing
		orderGoodsList = ss
	end function
	
	private function orderGoodsList_(byval tpls,byval tpl)
		dim arr,n,rs,s,ss,sss
		dim amount,comment,goodsName,productSn,price,thumbnail,specValue,sum
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_goods WHERE order_id='"& V("order_id") &"'")
		do while not rs.eof
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
			comment  = "<a href="""& UCENTER_HURL &"ctl=orders&act=goods_comment&order_id="& V("order_id") &"&gid={$gid}&pid={$pid}"" name=""goods_comment"" gid=""{$gid}"" pid=""{$pid}"">"& UC.lang(1714) &"</a>"
			s = tpl
			s = OW.reps(s,"{$comment}",comment)
			s = OW.reps(s,"{$moneysb}",OW.config("money_sb"))
			s = OW.reps(s,"{$gid}",rs("gid"))
			s = OW.reps(s,"{$pid}",rs("pid"))
			s = OW.reps(s,"{$product_sn}",productSn)
			s = OW.reps(s,"{$name}",goodsName)
			s = OW.reps(s,"{$link}",link)
			s = OW.reps(s,"{$thumbnail}",thumbnail)
			s = OW.reps(s,"{$spec_value}",specValue)
			s = OW.reps(s,"{$price}",OW.parsePrice(price))
			s = OW.reps(s,"{$amount}",amount)
			s = OW.reps(s,"{$sum}",OW.parsePrice(sum))
			ss = OW.iif(OW.isNul(ss),s,ss & s)
			rs.movenext
		loop
		OW.DB.closeRs rs
		if not OW.isNul(ss) then
			sss = OW.reps(tpls,"{$tpl}",ss)
		end if
		orderGoodsList_ = sss
	end function
	
	private function offlineStoreInfo()
		dim rs
		dim sb,str : set sb = OW.stringBuilder()
		if OW.int(V("offline_store_id"))>0 then
			sb.append "<div class=""order-base-info""><table cellspacing=""0"" cellpadding=""0"" border=""0"" class=""table table-bordered table-hover"" width=""100%""><colgroup><col class=""col-xs-1""><col class=""col-xs-7""></colgroup><tbody>"
			sb.append "<tr><td>"& UC.lang(1630) &"</td><td>" 
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
		sb.append "<dl><dt>"& UC.lang(1730) &"</dt><dd>"& V("region_names") &"</dd></dl>"
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
					field             = OW.rs(rs("field"))
					fieldName         = OW.rs(rs("field_name"))
					fieldType         = OW.rs(rs("field_type"))
					fieldValue        = objValue(field)
					if fieldType="attachment" then
						if not OW.isNul(objValue(field)) then
							fieldValue = "<a href="""& objValue(field) &""" title="""& UC.lang(1715) &""" target=""_blank"">"& UC.lang(1715) &"</a>"
						end if
					else
						fieldValue = objValue(field)
					end if
					s = tpl
					s = OW.reps(s,"{$is_print}",0)
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

