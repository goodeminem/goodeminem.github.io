<!--#include file="../ow-includes/ow.client.asp"-->
<!--#include file="ow.ucenter.asp"-->
<%
dim regBoot
set regBoot = new regBoot_Class
call Client.init()
if LOGINED then
	call regBoot.init()
else
	if CTL="regsuccess" then
		Client.actionLink = "返回首页>"& SITE_URL &""
		Client.actionSetting("您已注册成功，但会员账号尚未通过审核，请等待管理员审核。")
		Client.actionDisplay()
	else
		Client.errorLink = "立即登录>"& OW.urlRewrite("l1") &""
		Client.errorSetting("您还未登录，请先登录！")
		Client.errorDisplay()
	end if
end if
set regBoot= nothing
set Client = nothing
set UC     = nothing

class regBoot_Class
	public headerEchoCount,footerEchoCount
	public scodeName
	private sHtml
	
	private sub class_initialize()
		headerEchoCount = 0
		footerEchoCount = 0
	end sub
	
	public sub init()
		select case CTL
		case "set_mob_and_pw"
			if OW.config("is_user_mobile_open")=1 and OW.isNul(MOBILE) then
				call setMobAndPassword()
			else
				call redirect(SITE_URL &"ow-ucenter/")
			end if
		case else
			call regSuccrss()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	public function header()
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<!DOCTYPE HTML>"
		sb.append "<html>"
		sb.append "<head>"
		if OW.isMobile then
			sb.append "<meta charset=""UTF-8"">"
		else
			sb.append "<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"">"
		end if
		sb.append "<title>用户中心 - "& SITE_NAME &"</title>"
		sb.append "<meta name=""keywords"" content=""用户中心"" />"
		sb.append "<meta name=""description"" content=""用户中心"" />"
		if OW.isMobile then
			sb.append "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no""/>"
			sb.append "<meta name=""format-detection"" content=""telephone=no, email=no"">"
			sb.append "<meta name=""apple-mobile-web-app-title"" content="""& SITE_NAME &""" />"
		end if
		sb.append "<meta name=""generator"" content=""OpenWBS"" />"
		sb.append "<meta name=""author"" content=""OpenWBS Team"" />"
		sb.append "<meta name=""copyright"" content=""2008-2020 OpenWBS Inc."" />"
		if OW.isMobile then
			sb.append "<link rel=""stylesheet"" href=""css/mobile.css"" />"
			sb.append "<link rel=""stylesheet"" href=""css/mobile.ucenter.css"" />"
			sb.append "<link rel=""stylesheet"" href=""css/mobile.regboot.css"" />"
			sb.append "<script type=""text/javascript"" src=""../ow-content/js/mobile/jquery.js""></script>"
			sb.append "<script type=""text/javascript"" src=""../ow-content/js/mobile/ow.js""></script>"
			sb.append "<script type=""text/javascript"" src=""js/mobile.ucenter.js""></script>"
		else
			sb.append "<link rel=""stylesheet"" href=""css/pc.ucenter.css"" />"
			sb.append "<link rel=""stylesheet"" href=""css/pc.regboot.css"" />"
			sb.append "<script type=""text/javascript"" src=""../ow-content/js/pc/jquery.js""></script>"
			sb.append "<script type=""text/javascript"" src=""../ow-content/js/pc/ow.js""></script>"
			sb.append "<script type=""text/javascript"" src=""js/pc.ucenter.js""></script>"
		end if
		sb.append "<script type=""text/javascript"">"
		sb.append "OW.debug    = """& lcase(DEBUG) &"""==""true"" ? true : false;"
		sb.append "OW.logined  = """& lcase(LOGINED) &"""==""true"" ? true : false;"
		sb.append "OW.sitePath = """& SITE_PATH &""";"
		sb.append "OW.siteUrl  = """& SITE_URL &""";"
		sb.append "OW.siteHurl = """& SITE_HURL &""";"
		sb.append "OW.siteHtmlFileSuffix  = """& SITE_HTML_FILE_SUFFIX &""";"
		sb.append "OW.ucenterHurl = """& UCENTER_HURL &""";"
		sb.append "OW.cookie.cookiePre    = """& COOKIE_PRE &""";"
		sb.append "OW.cookie.cookieDomain = """& COOKIE_DOMAIN &""";"
		sb.append "OW.cookie.cookiePath   = """& COOKIE_PATH &""";"
		sb.append "UC.ctl = """& CTL &""";"
		sb.append "UC.act = """& ACT &""";"
		sb.append "</script>"
		sb.append "</head>"
		sb.append "<body>"
		str = sb.toString() : set sb = nothing
		header = str
	end function
	
	public function footer()
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<div class=""ow-regboot-footer""><div class=""wrapper""><a href="""& SITE_URL &""">"& SITE_NAME &"</a></div></div>"
		sb.append "</body>"
		sb.append "</html>"
		str = sb.toString() : set sb = nothing
		footer = str
	end function
	
	public function echoHeader()
		if headerEchoCount<1 then
			headerEchoCount = 1
			echo header()
		end if
	end function
	
	public function echoFooter()
		if footerEchoCount<1 then
			footerEchoCount = 1
			echo footer()
		end if
	end function
	
	public function regSuccrss()
		if OW.isMobile then
			regBootMobile()
		else
			regBootPC()
		end if
	end function
	
	public function setMobAndPassword()
		if OW.isMobile then
			call setMobAndPassword_mobile()
		else
			call setMobAndPassword_pc()
		end if
	end function
	
	public function setMobAndPassword_pc()
	call echoHeader()
	scodeName = OS.createMobileSecurityCode()
%>
    <div class="ow-account-set">
        <div class="left-section">
            <div class="logo"><a href="<%=SITE_URL%>"><img src="<%=OW.config("site_logo")%>"></a></div>
            <div class="avatar-section">
                <div class="avatar"><img src="<%=AVATAR%>" /></div>
                <div class="userinfo">
                    <div class="nickname"><%=NICKNAME%></div>
                    <div class="username"><% if OW.isNotNul(USERNAME) then echo "用户名："& USERNAME &"" : end if %></div>
                </div>
            </div>
        </div>
        <div class="right-section">
            <h1>补充完善您的账号信息</h1>
            <div class="ow-formset-section">
				<%=mobileAndPasswordSetHtml()%>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(document).ready(function(){
		UC.mobileAndPasswordSet({form:$("form[name='form_set']")});
	});
    </script>
<%
	call echoFooter()
	end function
	
	public function setMobAndPassword_mobile()
	call echoHeader()
	scodeName = OS.createMobileSecurityCode()
%>
    <div class="ow-header"><a class="goback" href="<%=SITE_URL%>"></a><div class="title">补充完善您的账号信息</div></div>
    <div class="ow-regboot-mbody">
        <div class="ow-formset">
            <div class="avatar-section">
                <div class="avatar"><img src="<%=AVATAR%>" /></div>
                <div class="userinfo">
                    <div class="nickname"><%=NICKNAME%></div>
                    <div class="username">用户名：<%=USERNAME%></div>
                </div>
            </div>
        </div>
        <div class="owui-form" id="set_mobile_password">
            <%=mobileAndPasswordSetHtml()%>
        </div>
    </div>
    <script type="text/javascript">
    $(document).ready(function(){
		UC.mobileAndPasswordSet({form:$("form[name='form_set']")});
	});
    </script>
<%
	call echoFooter()
	end function
	
	public function mobileAndPasswordSetHtml()
		dim data,scodeName,userMobile,sb,str : set sb = OW.stringBuilder()
		dim vcodeOpen
		if OW.config("is_user_mobile_open") then scodeName = OS.createMobileSecurityCode() : end if
		if OS.versionType="x" then
			data = OW.DB.getFieldValueBySQL("SELECT top 1 data FROM "& DB_PRE &"order_form_data WHERE uid="& UID &" AND "& OW.DB.auxSQL &" ORDER BY id DESC")
		end if
		if OW.isNotNul(data) then
			userMobile = OW.getODataKeyValue(data,"mobile")
			if OW.isNul(userMobile) then
				userMobile = OW.getODataKeyValue(data,"tel")
			end if
		end if
		if OW.isMobile then
			vcodeOpen = OW.int(OW.config("user_set_vcode_open_mb"))
		else
			vcodeOpen = OW.int(OW.config("user_set_vcode_open_pc"))
		end if
		sb.append "<form class=""form-set"" name=""form_set"" action=""javascript:;"" vcode_open="""& vcodeOpen &""">"
		if OW.isMobile then
			sb.append "<div class=""owui-cells"">"
			sb.append "<div class=""owui-cell"">"
			sb.append "<div class=""owui-cell-hd""><label class=""owui-label"">"& OS.lang(100) &"</label></div>"
			sb.append "<div class=""owui-cell-bd""><input type=""tel"" class=""owui-input"" maxlength=""11"" name=""mobile"" placeholder="""& OS.lang(100) &""" scode_name="""& scodeName &""" value="""& userMobile &""" /></div>"
			sb.append "</div>"
			if vcodeOpen then
				sb.append "<div class=""owui-cell owui-cell-vcode"">"
				sb.append "<div class=""owui-cell-hd""><label class=""owui-label"">"& OS.lang(6) &"</label></div>"
				sb.append "<div class=""owui-cell-bd""><input type=""number"" class=""owui-input"" maxlength=""5"" name=""verifycode_value"" placeholder="""& OS.lang(6) &""" ></div>"
				sb.append "<div class=""owui-cell-ft""><span class=""verifycode"" name=""set_verifycode""></span></div>"
				sb.append "</div>"
			end if
			sb.append "<div class=""owui-cell owui-cell-vcode"">"
			sb.append "<div class=""owui-cell-hd""><label class=""owui-label"">"& OS.lang(101) &"</label></div>"
			sb.append "<div class=""owui-cell-bd""><input type=""number"" class=""owui-input text-mobile-code"" maxlength=""6"" name=""mobile_code"" placeholder="""& OS.lang(101) &""" ></div>"
			sb.append "<div class=""owui-cell-ft""><button type=""button"" class=""get-mobile-code"" name=""get_mobile_code"" timeout="""& OW.config("mobile_interval_time") &""">"& OS.lang(106) &"</button></div>"
			sb.append "</div>"
			sb.append "<div class=""owui-cell"">"
			sb.append "<div class=""owui-cell-hd""><label class=""owui-label"">"& OS.lang(104) &"</label></div>"
			sb.append "<div class=""owui-cell-bd""><input type=""text"" class=""owui-input text-pssword"" maxlength=""32"" name=""password"" placeholder="""& OS.lang(104) &""" ></div>"
			sb.append "</div>"
			sb.append "</div>"
			sb.append "<div class=""owui-btn-area""><a class=""owui-btn owui-btn-primary"" href=""javascript:"" id=""submit"">确定保存</a></div>"
		else
			sb.append "<dl class=""mobile""><dt>"& OS.lang(100) &"</dt><dd><input type=""text"" class=""text text-mobile"" maxlength=""11"" name=""mobile"" placeholder="""& OS.lang(100) &""" scode_name="""& scodeName &""" value="""& userMobile &""" /></dd></dl>"
			if vcodeOpen then
			sb.append "<dl class=""verifycode""><dt>"& OS.lang(6) &"</dt><dd><input type=""text"" class=""text text-verifycode"" maxlength=""5"" name=""verifycode_value"" placeholder="""& OS.lang(6) &""" ><span class=""verifycode"" name=""set_verifycode""></span></dd></dl>"
			end if
			sb.append "<dl class=""mobile-code""><dt>"& OS.lang(101) &"</dt><dd><input type=""text"" class=""text text-mobile-code"" maxlength=""6"" name=""mobile_code"" placeholder="""& OS.lang(101) &""" ><button type=""button"" class=""get-mobile-code"" name=""get_mobile_code"" timeout="""&  OW.config("mobile_interval_time") &""">"& OS.lang(106) &"</button></dd></dl>"
			sb.append "<dl class=""pssword""><dt>"& OS.lang(104) &"</dt><dd><input type=""password"" class=""text text-pssword"" maxlength=""32"" name=""password"" placeholder="""& OS.lang(104) &""" ></dd></dl>"
			sb.append "<dl class=""button""><dt></dt><dd><button type=""button"" class=""btn btn-large btn-primary btn-set"" id=""submit"">"& OS.lang(5) &"</button></dd></dl>"
		end if
		sb.append "</form>"
		str = sb.toString() : set sb = nothing
		mobileAndPasswordSetHtml = str
	end function
	
	function regBootMobile()
	call echoHeader()
%>
    <header class="ow-header"><div class="title">会员注册</div></header>
    <section class="ow-reg-success">
        <h1><%=USERNAME%></h1>
        <div class="section">
            <p>恭喜，注册成功！<span id="redirect_timeout"></span> 秒后将进入用户中心页面</p>
            <div class="do-line">
                <button type="button" class="btn btn-primary" onClick="OW.redirect('index.asp',0)">进入用户中心</button>
                <button type="button" class="btn" onClick="OW.redirect('<%=SITE_URL%>',0)">返回首页</button>
            </div>
        </div>
    </section>
    <footer class="ow-regboot-footer"></footer>
    <script type="text/javascript">
    $(document).ready(function(){
        OW.redirect("index.asp",4);
    });
    </script>
    </body>
    </html>
<%
	end function

	private function regBootPC()
		call echoHeader()
%>
    <div class="ow-reg-success">
        <h1>恭喜，注册成功！</h1>
        <div class="section">
            <p><%=USERNAME%></p>
            <p>亲，恭喜您成功注册成为我们的会员，<span id="redirect_timeout"></span> 秒后将进入用户中心页面 </p>
            <div class="do-line">
                <button type="button" class="btn btn-primary mr10" onClick="OW.redirect('index.asp',0)">进入用户中心</button><button type="button" class="btn" onClick="OW.redirect('<%=SITE_URL%>',0)">返回首页</button>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(document).ready(function(){
        OW.redirect("index.asp",5);
    });
    </script>
<%
		call echoFooter()
	end function
end Class
%>
