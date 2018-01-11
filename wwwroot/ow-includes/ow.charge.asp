<!--#include file="ow.client.asp"-->
<%
'****
'**支付
'****
call Client.init()
call chargePay()
set Client = nothing

function chargePay()
	dim rs
	V("id")= OW.int(OW.getForm("get","id"))
	set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"pay_trade_log WHERE id="& V("id") &" AND "& OW.DB.auxSQL &"")
	if rs.eof then
		V("pay_trade_log_exist") = false
	else
		V("pay_trade_log_exist") = true
		V("uid")         = OW.int(rs("uid"))
		V("trade_money") = OW.parseMoney(rs("trade_money"))
		V("pay_id")      = OW.int(rs("pay_id"))
		V("trade_status")= lcase(rs("trade_status"))
	end if
	OW.DB.closeRs rs
	'**不存在/已支付
	if not(V("pay_trade_log_exist")) or not(V("trade_money")>0) or V("trade_status")="success" then
		redirect(""& UCENTER_HURL &"ctl=finance") : exit function
	end if
	'**支付方式不存在
	set rs = OW.DB.getRecordBySQL("SELECT is_mobile,pay_code,pay_name FROM "& DB_PRE &"payment WHERE pay_id="& V("pay_id") &" AND "& OW.DB.auxSQL &"")
	if rs.eof then
		V("payment_exist") = false
	else
		V("payment_exist") = true
		V("is_mobile")     = OW.int(rs("is_mobile"))
		V("pay_code")      = OW.rs(rs("pay_code"))
	end if
	if not V("payment_exist") then
		redirect(""& UCENTER_HURL &"ctl=finance") : exit function
	end if
	'****
	V("para_string") = "ctl=charge&id="& V("id") &"&ran="& OW.randsn(10) &""
	select case V("pay_code")
	case "alipay"
		redirect(SITE_URL &"ow-includes/module/pay/"& V("pay_code") &"/index.asp?"& V("para_string") &"")
	case "weixin"
		if V("is_mobile")=1 then
			redirect(SITE_URL &"ow-includes/module/pay/"& V("pay_code") &"/index.asp?"& V("para_string") &"&showwxpaytitle=1")
		else
			redirect(SITE_URL &"ow-includes/module/pay/"& V("pay_code") &"/index.pc.asp?"& V("para_string") &"")
		end if
	case "passpay"
		redirect(SITE_URL &"ow-includes/module/pay/"& V("pay_code") &"/index.asp?"& V("para_string") &"")
	case else
		redirect(""& UCENTER_HURL &"ctl=finance")
	end select
end function
%>