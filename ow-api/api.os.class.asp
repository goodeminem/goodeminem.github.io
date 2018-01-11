<%
'**
'api接口文件
'这里定义接口函数
'**
dim APIOS
set APIOS = new APIOS_Class
class APIOS_Class
	
	private apiSecretKey,timespan,sign
	
	private sub class_initialize()
	end sub
	
	private sub class_terminate()
	end sub
	
	public sub init()
	end sub
	
	public function ucenterPCAuxMenu()
		dim sb,str : set sb = OW.stringBuilder()
		'sb.append "<ul>"
		'sb.append "<li class=""menu1"" name=""menu1""><a href="""& UCENTER_HURL &"ctl=menu1""><i></i>菜单1</a></li>"
		'sb.append "</ul>"
		str = sb.toString() : set sb = nothing
		ucenterPCAuxMenu = str
	end function
	
	public function ucenterMobAuxMenu()
		dim sb,str : set sb = OW.stringBuilder()
		'sb.append "<ul>"
		'sb.append "<li class=""menu1"" name=""menu1""><a href="""& UCENTER_HURL &"ctl=menu1""><i></i>菜单1</a></li>"
		'sb.append "</ul>"
		str = sb.toString() : set sb = nothing
		ucenterMobAuxMenu = str
	end function
	
	public function ucenterPCIndexDestop()
		dim sb,str : set sb = OW.stringBuilder()
		'sb.append "<div>"
		'sb.append "内容"
		'sb.append "</div>"
		str = sb.toString() : set sb = nothing
		ucenterPCIndexDestop = str
	end function
	
	public function ucenterMobIndexDestop()
		dim sb,str : set sb = OW.stringBuilder()
		'sb.append "<div>"
		'sb.append "内容"
		'sb.append "</div>"
		str = sb.toString() : set sb = nothing
		ucenterMobIndexDestop = str
	end function
	
	'**订单下单成功后调用此方法
	public function orderSuccess(byval orderId)
		on error resume next
		'**
		
		'**
		if err.number<>0 then
			err.clear
		end if
	end function
	
	'**订单所有费用支付完毕后调用此方法
	public function orderPayFinish(byval orderId)
	end function
	
	'**会员充值支付完毕后调用此方
	public function memberChargeFinish(byval uid,byval amount,byval tradeNo)
		on error resume next
		'**
		
		'**
		if err.number<>0 then
			err.clear
		end if
	end function
	
	'**会员登录成功后调用此方法
	public function memberLogin(byval uid)
		
	end function
	
	'**会员注册成功后调用此方法
	public function memberReg(byval uid)
		
	end function
	
end class
%>
