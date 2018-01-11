<!--#include file="setup.db.table.asp"-->
<!--#include file="setup.db.data.asp"-->
<%
'**
'安装OpenWBS
'**
Class SETUP_CLASS

	public isAutoInstall
	private sStep
	private bCanDoNext,sDBAccessName,sConnStr,sCreateNewDBConnStr
	private sEmail,sUsername,sPassword
	
	private sub class_initialize()
		isAutoInstall = false
		bCanDoNext = true
		SITE_NAME  = "又一个新的OpenWBS站点"
	end sub
	private sub class_terminate()
		
	end sub
	
	public sub init()
		'**
		call OW.Cache.clearAllRamCache()
		'**
		SITE_PATH = OW.getSitePath(OW.getSiteURL())
		call OS.includeLanguageFile("os.lang.asp")
		'**
		echo header()
		sStep = cstr(OW.regReplace(OW.getForm("get","step"),"[^0-9]",""))
		isAutoInstall = CBool(lcase(OW.regReplace(OW.getForm("get","is_auto_install"),"[^a-z]",""))="true")
		If OW.FSO.fileExists("ow-content/data/install.lock") and sStep<>"5" then
			echo "<div id=""mbody""><div class=""cuebox"">系统已经安装，若要重新安装请先删除ow-content/data/install.lock文件。</div></div>"
		else
			select case sStep
			case "1" : setup()
			case "2" : setup_2()
			case "3"
				DB_ACCESS_PATH = "db_"& OW.formatDateTime(SYS_TIME,9) & OW.random(6) &".asp"
				setup_3()
			case "4" : setup_4()
			case "5" : setup_5()
			case else : setup()
			end select
		end if
		echo footer()
	end sub
	
	sub alert(byval str, byval url)
		dim u
		if url &""<>"" then
			if url = "goback" then
				u = "history.go(-1);"
			else
				u = "location.href='"& url &"';"
			end if
		end if
		if str &""<>"" then
			str = "alert("""& str &""");"
			echo("<script type=""text/javascript"">"& str & u &"</script>")
		else
			echo("<script type=""text/javascript"">"& str &"</script>")
		end if
	end sub

	function OK()
		echo "<span class=""cue_ok"">支持</span>"
	end function
	
	function unSupport()
		echo "<span class=""cue_err"">不支持</span>"
	end function
	
	function writeable()
		echo "<span class=""cue_ok"">可读写</span>"
	end function
	function unWriteable()
		echo "<span class=""cue_err"">不能写入</span>"
	end function
	
	sub createSuccess(ByVal dbTable)
		echo "创建数据表 "& dbTable &" ... 成功<br>" : response.flush()
	end sub
	sub createFailed(ByVal dbTable)
		bCanDoNext = false
		echo "<font style='color:#FF0000;'>创建数据表 "& dbTable &" ... 失败</font><br>" : response.flush()
	end sub
	
	function header()
		dim s
		s = "<!DOCTYPE HTML>"&vbCrLf
		s = s &"<html>"&vbCrLf
		s = s &"<head>"&vbCrLf
		s = s &"<meta http-equiv=""Content-Type"" content=""text/html; charset="& SYS_CHARSET &""">"&vbCrLf
		s = s &"<title>OpenWBS系统安装向导</title>"&vbCrLf
		s = s &"<link rel=""stylesheet"" href=""ow-content/install/css/ow.setup.css"" />"&vbCrLf
		s = s &"<script type=""text/javascript"" src=""ow-content/js/pc/jquery.js""></script>"&vbCrLf
		s = s &"<script type=""text/javascript"" src=""ow-content/js/pc/ow.js""></script>"&vbCrLf
		s = s &"</head>"&vbCrLf
		s = s &"<body><div id=""header""><div><a href=""http://www.openwbs.com/"" target=""_blank""><img src=""ow-content/install/images/logo.gif"" /></a></div></div>"&vbCrLf
		header = s
	end function
	
	function footer()
		dim s
		s = "</body>"
		s = s &"</html>"
		footer = s
	end function
	
	'开始
	sub setup()
	%>
		<div id="mbody">
            <div class="leftpanel">
                <ul class="step">
                <li class="installing"><b></b>阅读安装协议</li>
                <li><b></b>系统环境检测</li>
                <li><b></b>填写网站信息</li>
                <li><b></b>安装结束</li>
                </ul>
            </div>
            <div class="mainpanel">
                <div class="rightpanel">
                    <div class="licensebox">
                        <div class="license">
                        <h1>OpenWBS 使用协议</h1>
                        <div>
                        <p>感谢您选择OpenWBS 第二代商业软件， 希望我们的努力能为您提供一个便易、快速、高效和强大的网站解决方案。</p>
                        <p>OpenWBS企业建站系统（以下简称OpenWBS）为林晓东独立开发软件，林晓东依法享有该软件之版权和著作权:</p>
                        <p>中国国家版权局著作权登记号2012SR105903</p>
                        <p>OpenWBS官方网站为 <a href="http://www.openwbs.com/" target="_blank">http://www.openwbs.com/</a></p>
                        <p>官方论坛为 <a href="http://bbs.openwbs.com/" target="_blank">http://bbs.openwbs.com/</a></p>
                        <p>您可以在完全遵守本最终用户授权协议的基础上使用本软件，但该软件的授权使用者（含个人、法人或其它组织）必须遵守以下协议：</p>
                        <p>1. 未获商业授权之前，不得将本软件用于商业用途<br />
                              "商业用途"定义：指个人用于任何商业目的或者团体机构（例如公司、政府、学校、军队、社会团体 商业用途" 等各类组织）出于任何目的使用本"软件" ，任何目的包括（商业目的或非盈利目的）。</p>
                        <p>2. 不得对本软件或与之关联的商业授权进行出租、出售、抵押或发放子许可证。</p>
                        <p>3. OpenWBS将本软件提供给授权用户，同时提供软件的安装说明、使用说明等文档，授权网站和用户依法享有该软件的使用权。</p>
                        <p>4. 授权用户拥有其系统内全部会员资料、商品资料、订单资料及相关信息的所有权，并独立承担相关法律义务。</p>
                        <p>5. 利用本授权软件发生的商业行为均由授权用户自行负责，利用本软件进行商业行为所产生的一切纠纷均与OpenWBS无关；</p>
                        <p>6. 为方便用户使用，软件内置了譬如网上支付网关等诸多第三方系统。但您应自行评估使用这些系统的风险。这些系统的具体开通与服务由相应第三方公司提供，由此而产生的任何商业纠纷，均与OpenWBS无关；</p>
                        <p>7. 授权用户可免费获得并安装使用最新的OpenWBS软件；依据所购买的服务类型中确定的技术支持期限、技术支持方式和技术支持内容在技术支持期限内通过指定的方式获得指定范围内的技术支持。被授权用户享有反映和提出意见的权力，相关意见将被作为首要考虑，但没有一定被采纳的承诺或保证。</p>
                        <p>8. 软件的收费服务是指对购买付费技术支持的用户在相应年限内对许可软件提供必要的支持，支持范围包括软件安装、调试、升级和使用过程中出现的问题，或是因为软件本身的错误引起的问题提供必要的支持。收费技术支持的内容并不包括授权用户因为自身需要而要求调整、增加或者定制功能的内容，授权用户如有这方面的需要，可另行和OpenWBS共同制定一个双方都同意的补充协议。</p>
                        <p>9. 授权软件升级前授权用户应自行备份数据，升级过程中造成的授权用户数据丢失的OpenWBS不负担责任。对于授权软件使用过程出现问题需要重新安装或修复者，OpenWBS将提供予必要的支持，但此修复或重新安装不能保证软件恢复到损坏前的状态，所造成的数据丢失OpenWBS不承担责任。</p>
                        <p>10. OpenWBS不对因授权软件使用错误、软件错误等问题所引起的授权用户损失而承担任何责任，但OpenWBS将尽量避免此类情况的发生且对付费授权用户在出现此类问题的情况下提供必要的支持服务。</p>
                        <p>11. 未经OpenWBS书面授权许可，授权用户不得向任何第三方提供为适应自身需要而改进的OpenWBS软件。如果为授权用户所进行的这种改进涉及到许可软件，则OpenWBS将有权对该改进进行再发展的非独占权，以及将其产品投放市场或许可给第三方的优先取舍权。</p>
                        <p>12. 有关OpenWBS软件授权包含的服务范围，服务付费方式等，OpenWBS官方网站提供惟一的解释和官方价目表。OpenWBS拥有在不事先通知的情况下，修改授权协议和价目表的权力，修改后的协议或价目表对自改变之日起的新授权用户生效。</p>
                        <p>13. 您必须充分了解使用本软件的用途和风险。十分必要时，OpenWBS所承担的责任仅限于软件版本的升级。</p>
                        <p>14. 您不得私自去除OpenWBS软件前台、后台版权，如有以上行为发生，OpenWBS将保留起诉、追究法律责任并要求获得赔偿的权利；</p>
                        <p>15. 电子文本形式的授权协议如同双方书面签署的协议一样，具有完全的和等同的法律效力。您一旦开始安装 OpenWBS软件，即被视为完全理解并接受本协议的各项条款，在享有上述条款授予的权力的同时，受到相关的约束和限制。协议许可范围以外的行为，将直接违反本授权协议并构成侵权，我们有权随时终止授权，责令停止损害，并保留追究相关责任的权力。</p>
                        <p>16. OpenWBS有权在部分功能实现所需的情况下获取用户软件使用数据。</p>
                        <p>17. 不得有其他侵犯OpenWBS软件版权或权益之行为。</p>
                        <p>18. 如果授权用户未能遵守本协议的条款，授权用户的授权将被终止，所被许可的权利将被收回。 </p>
                        <p>对违反此授权协议行为的个人、法人或其它组织，必须立即停止其行为造成的一切不良后果承担全部责任。对此前，尤其是此后的行为，将依据《著作权法》、《计算机软件保护条例》等相关法律、法规追究其经济和法律责任。</p>
                        <p>OpenWBS保留对此协议的最终解释权，任何站点使用本软件则表示默认接受此协议。</p> 
                        </div>
                        
                        </div>
                    </div>
                </div>
                <div class="submitarea">
                <button class="button button-basic" onclick="window.location.href='?step=2'">同意协议，开始安装</button>
                </div>
            </div>
        </div>
	<%
	end sub
	
	'安装第2步
	sub setup_2()
		on error resume next
		dim wshShell,wshSysEnv,os,cpu,cpus
		Set wshShell  = server.createObject("WScript.Shell")
		Set wshSysEnv = wshShell.Environment("SYSTEM")
		os   = cstr(wshSysEnv("OS"))
		cpus = cstr(wshSysEnv("PROCESSOR_IDENTIFIER"))
		cpus = cstr(wshSysEnv("NUMBER_OF_PROCESSORS"))
		if isempty(cpus) then
		  cpus = Request.ServerVariables("NUMBER_OF_PROCESSORS")
		end if
		if cpus & "" = "" then cpus = "(未知)"
		if os & "" = "" then os = "(未知)"
		if Err then Err.clear
	%>
		<div id="mbody">
            <div class="leftpanel">
                <ul class="step">
                <li class="installed"><b></b>阅读安装协议</li>
                <li class="installing"><b></b>系统环境检测</li>
                <li><b></b>填写网站信息</li>
                <li><b></b>安装结束</li>
                </ul>
            </div>
            <div class="mainpanel">
                <div class="rightpanel">
                    <div>
                    <table border="0" cellpadding="0" cellspacing="0" class="listTable">
                    <tr class="top"><th colspan="2">服务器信息</th></tr>
                    <tr class="data"><td class="first"><div style="width:121px;">操作系统</div></td><td><div style="width:480px;"><%=os%></div></td></tr>
                    <tr class="data"><td class="first">web 服务器</td><td><%=Request.ServerVariables("SERVER_SOFTWARE")%></td></tr>
                    <tr class="data"><td class="first">服务器地址</td>
                                     <td><%=OW.getDomain("") &":"& OW.getPort()%> (IP:<%=OW.getServerIP()%>)</td>
                    </tr>
                    <tr class="data"><td class="first">服务器时间</td><td><%=SYS_TIME%></td>
                    </tr>
                    <tr class="data"><td class="first">脚本超时时间</td><td><%=Server.ScriptTimeout%> 秒</td>
                    </tr>
                    <tr class="data"><td class="first">服务器脚本引擎</td>
                                     <td><%=ScriptEngine & "/"& ScriptEngineMajorVersion &"."&ScriptEngineMinorVersion&"."& ScriptEngineBuildVersion %></td>
                    </tr>
                    <tr class="data"><td class="first">服务器CPU通道数</td><td><%=cpus%> 个</td>
                    </tr>
                    </table>
                    </div>
                    <div style="margin-top:5px;">
                        <table border="0" cellpadding="0" cellspacing="0" class="listTable">
                        <tr class="top"><th><div style="width:320px;">系统组件</div></th>
                                        <th><div style="width:100px;">当前状态</div></th>
                                        <th><div style="width:170px;">所需状态</div></th>
                                        </tr>
                        <tr class="data"><td class="first">Adodb.Recordset</td>
                                         <td><% if OW.isObjInstalled("Adodb.Recordset") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td class="first">Adodb.Connection<p class="exinfo">(ADO 数据对象)</p></td>
                                         <td><% if OW.isObjInstalled("Adodb.Connection") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td class="first">Adodb.Stream<p class="exinfo">(ADO 数据流对象,常见被用在无组件上传程序中)</p></td>
                                         <td><% if OW.isObjInstalled("Adodb.Stream") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td class="first">Scripting.Dictionary<p class="exinfo">(保存数据键和项目对的对象)</p></td>
                                         <td><% if OW.isObjInstalled("Scripting.Dictionary") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td class="first">Microsoft.XMLHTTP<p class="exinfo">(Http 组件, 在采集系统中必须用到)</p></td>
                                         <td><% if OW.isObjInstalled("Microsoft.XMLHTTP") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td class="first">Scripting.FileSystemObject<p class="exinfo">(FSO 文件系统管理、文本文件读写)</p></td>
                                         <td><% if OW.isObjInstalled("Scripting.FileSystemObject") then OK : Else bCanDoNext=false : unSupport : end if %></td>
                                         <td>必须支持</td>
                        </tr>
                        <tr class="data"><td><div class="p5">JMail.SmtpMail<p class="exinfo">(Dimac JMail 邮件发送)</p></div></td>
                                             <td><% if OW.isObjInstalled("JMail.SmtpMail") then OK : Else unSupport : end if %></td>
                                             <td>建议支持</td>
                        </tr>
                        <tr class="data"><td><div class="p5">Persits.Jpeg<p class="exinfo">(ASPJpeg 图片水印)</p></div></td>
                                             <td><% if OW.isObjInstalled("Persits.Jpeg") then OK : Else unSupport : end if %></td>
                                             <td>建议支持</td>
                        </tr>
                        </table>
                    </div>
                    <div style="margin-top:5px;">
                    <table border="0" cellpadding="0" cellspacing="0" class="listTable">
                    <tr class="top"><th><div style="width:320px;">目录文件</div></th>
                                    <th><div style="width:100px;">当前状态</div></th>
                                    <th><div style="width:170px;">所需状态</div></th>
                                    </tr>
                    <tr class="data"><td class="first">ow-content/cache/html/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/cache/html/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/cache/sys/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/cache/sys/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/cache/tpl/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/cache/tpl/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/data/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/data/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/data/backup/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/data/backup/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/plugins/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/plugins/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/templates/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/templates/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow-content/uploads/</td>
                                     <td><% if OW.FSO.folderWriteable(OW.serverMapPath("ow-content/uploads/")) then writeable : Else bCanDoNext=false : unWriteable : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    <tr class="data"><td class="first">ow.config.asp</td>
                                     <td><% if OW.FSO.fileWriteable(OW.serverMapPath("ow.config.asp")) then writeable : Else bCanDoNext=false : unWriteable : echo "<a href=""http://www.openwbs.com/doc/204.html"">查看解决方法</a>" : end if %></td>
                                     <td>必须可读写</td>
                    </tr>
                    </table>
                    </div>
                </div>
                <div class="submitarea">
                <button type="button" class="button button-basic" onclick="window.location.href='?step=0'">返回</button>
				<% if bCanDoNext then %>
				<button type="button" class="button button-basic" onclick="window.location.href='?step=3'">继续，下一步</button>
				<% Else %>
				<button type="button" class="button button-basic" onclick="window.location.href='?step=2'">刷新，重新检测</button>
				<% end if %>
                </div>
            </div>
        </div>
    <%
	end sub
	
	'安装第3步
	sub setup_3()
	%>
		<div id="mbody">
            <div class="leftpanel">
                <ul class="step">
                <li class="installed"><b></b>阅读安装协议</li>
                <li class="installed"><b></b>系统环境检测</li>
                <li class="installing"><b></b>填写网站信息</li>
                <li><b></b>安装结束</li>
                </ul>
            </div>
            <div class="mainpanel">
                <form name="submitForm" action="?step=4" method="post">
                <div class="rightpanel">
                    <div class="step4_box">
                        <div class="cuetitle">填写网站基本信息<span style="font-weight:normal;">(系统会自动获取，如有错再自行修改。)</span></div>
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable">
                        <tr><td class="titletd">网站名称</td><td class="infotd">
                            <input type="text" class="text" name="site_name" value="<%=SITE_NAME%>" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        <tr><td class="titletd">网站域名</td><td class="infotd">
                            <input type="text" class="text" name="site_domain" value="<%=OW.getSiteDomain()%>" />
                            <label class="normal">例 www.openwbs.com</label>
                            </td>
                        </tr>
                        <tr><td class="titletd">网站网址</td><td class="infotd">
                            <input type="text" class="text" name="site_url" value="<%=OW.getSiteURL()%>" />
                            <label class="normal">以http开头，后面以"/"结束 例： http://www.openwbs.com/</label>
                            </td>
                        </tr>
                        </table>
                    </div>
                    <div class="step4_box">
                        <div class="cuetitle">填写数据库信息</div>
                        <div id="db_type">
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable">
                        <tr><td class="titletd">选择数据库类型</td><td class="infotd">
                            <span class="db_type_1"><input type="radio" name="db_type" id="db_type_0" checked="checked" value="0" /><label for="db_type_0" style="padding-left:3px;">Microsoft Access</label></span>
                            <span class="db_type_2"><input type="radio" name="db_type" id="db_type_1" value="1" /><label for="db_type_1" style="padding-left:3px;">Microsoft SQL Server</label></span>
                            </td>
                        </tr>
                        </table>
                        </div>
                        <div id="db_0">
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable">
                        <tr><td class="titletd">Access文件名</td><td class="infotd">
                            <input type="text" class="text" name="db_access_name" onblur="OW.onblur(this,{rep:'/[^0-9a-zA-Z-_.#$]*/g',length:50})" maxlength="50" value="<%=DB_ACCESS_PATH%>" />
                            <label class="normal">Access数据库文件名，默认在data文件夹下</label>
                            </td>
                        </tr>
                        </table>
                        </div>
                        <div id="db_1" style="display:none;">
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable">
                        <tr><td class="titletd">数据库服务器</td><td class="infotd">
                            <input type="text" class="text" name="db_server" value="<%=DB_SERVER%>" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        <tr><td class="titletd">数据库端口号</td><td class="infotd">
                            <input type="text" class="text" name="db_port" value="<%=DB_PORT%>" style="width:80px;" />
                            <label class="normal">针对特殊端口号则须填写，一般不用填写</label>
                            </td>
                        </tr>
                        <tr><td class="titletd">数据库名称</td><td class="infotd">
                            <input type="text" class="text" name="db_name" value="<%=DB_NAME%>" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        <tr><td class="titletd">数据库帐号</td><td class="infotd">
                            <input type="text" class="text" name="db_username" value="<%=DB_USERNAME%>" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        <tr><td class="titletd">数据库密码</td><td class="infotd">
                            <input type="text" class="text" name="db_password" value="<%=DB_PASSWORD%>" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        </table>
                        </div>
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable" style="display:none;">
                        <tr><td class="titletd">数据表前缀</td><td class="infotd">
                            <input type="text" class="text" name="db_pre" onblur="OW.onblur(this,{rep:'/[^0-9a-zA-Z_]*/g',length:6})" maxlength="6" value="ow_" />
                            <label class="normal">必须以字母开头，非必要请保持默认ow_</label>
                            </td>
                        </tr>
                        </table>
                    </div>
                    <div class="step4_box">
                        <div class="cuetitle">填写管理员信息</div>
                        <table border="0" cellpadding="0" cellspacing="0" class="infoTable">
                        <tr><td class="titletd">管理员Email</td><td class="infotd">
                            <input type="text" class="text" name="email" maxlength="50" value="" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        <tr><td class="titletd">管理员用户名</td><td class="infotd">
                            <input type="text" class="text" name="username" maxlength="20" value="" />
                            <label class="normal">0到20个字符，不含非法字符！</label>
                            </td>
                        </tr>
                        <tr><td class="titletd">管理员密码</td><td class="infotd">
                            <input type="password" class="text" name="password" maxlength="20" value="" />
                            <label class="normal">6到20个字符</label>
                            </td>
                        </tr>
                        <tr><td class="titletd">确认密码</td><td class="infotd">
                            <input type="password" class="text" name="re-password" maxlength="20" value="" />
                            <label class="normal"></label>
                            </td>
                        </tr>
                        </table>
                    </div>
                </div>
                <div class="submitarea" style="padding: 30px 0px 20px 110px;">
                <button type="button" class="button button-basic" onclick="window.location.href='?step=2'">返回</button>
				<button type="button" class="button button-basic" id="submitinput" onclick="formSubmit();">填写完毕，下一步</button>
                </div>
                </form>
            </div>
        </div>
        <script type="text/javascript">
		$("#db_type_0").click(function(){
			if($(this).attr("checked")){
				$("#db_0").show("fast");
				$("#db_1").hide("fast");
			};
		});
		$("#db_type_1").click(function(){
			if($(this).attr("checked")){
				$("#db_1").show("fast");
				$("#db_0").hide("fast");
			};
		});
		function inputCheck(check,inputName,tips){
			if(check){
				if($.trim($("input[name='"+inputName+"']").val())==""){
					check = false;
					OWDialog({
						content:tips,
						padding:"30px 60px",
						close:false,
						beforeClose:function(){$("input[name='"+inputName+"']").focus();},
						ok:true,
						okValue:"我知道了，立即去填写",
						timeout:8
					});
				};
			};
			return check;
		}
		OW.enterClick(function(){
			formSubmit();
		});
		function formSubmit(){

			var $dbType     = $("#db_type").find("input:checked");

			var temp,check = true;
			
			check = inputCheck(check,"site_name","您忘记填写<b>网站名称</b>了哦！");
			check = inputCheck(check,"site_domain","您忘记填写<b>网站域名</b>了哦！");
			check = inputCheck(check,"site_url","您忘记填写<b>网站网址</b>了哦！");
			check = inputCheck(check,"db_pre","您忘记填写<b>数据表前缀</b>了哦，你可以填写默认的“ow_”！");
			if(check){
				var $dbPre = $("input[name='db_pre']");
				temp = $dbPre.val().substr(0,1);
				temp = temp.replace(eval('/[^a-zA-Z]*/g'),"");
				if(temp==""){
					check = false;
					OWDialog({
						content:"数据表前缀必须以字母开头的哦!",
						padding:"30px 60px",
						close:false,
						beforeClose:function(){$dbPre.focus();},
						ok:true,
						okValue:"我知道了，立即改正",
						timeout:8
					});
				};
			};
			check = inputCheck(check,"email","您忘记填写<b>管理员Email</b>了哦！");
			if(check){
				if(!OW.isEmail($("input[name='email']").val())){
					check = false;
					OWDialog({
						content:"管理员Email不正确哦！",
						padding:"30px 60px",
						close:false,
						beforeClose:function(){$("input[name='email']").focus();},
						ok:true,
						okValue:"我知道了，立即改正",
						timeout:8
					});
				};
			}
			check = inputCheck(check,"username","您忘记填写<b>管理员用户名</b>了哦！");
			check = inputCheck(check,"password","您忘记填写<b>管理员密码</b>了哦！");
			check = inputCheck(check,"re-password","您忘记填写<b>确认密码</b>了哦！");
			if(check){
				if($.trim($("input[name='password']").val()).length<6){
					check = false;
					OWDialog({
						content:"密码长度不能少于6位哦！",
						padding:"30px 60px",
						close:false,
						beforeClose:function(){$("input[name='password']").focus();},
						ok:true,
						okValue:"我知道了，立即改正",
						timeout:8
					});
				};
			}
			if(check){
				if($.trim($("input[name='password']").val())!=$.trim($("input[name='re-password']").val())){
					check = false;
					OWDialog({
						content:"您两次填写的密码不一致哦！",
						padding:"30px 60px",
						close:false,
						beforeClose:function(){$("input[name='re-password']").focus();},
						ok:true,
						okValue:"我知道了，立即改正",
						timeout:8
					});
				};
			};
			if(check){
				$("form[name='submitForm']").submit();
			};
		};
        </script>
    <%
	end sub
	
	'安装第4步
	sub setup_4()
	%>
		<script type="text/javascript">
		OW.bodyScroll();
        </script>
		<div id="mbody">
            <div class="leftpanel">
                <ul class="step">
                <li class="installed"><b></b>阅读安装协议</li>
                <li class="installed"><b></b>系统环境检测</li>
                <li class="installing"><b></b>安装结果信息</li>
                <li><b></b>安装结束</li>
                </ul>
            </div>
            <div class="mainpanel">
                <div class="rightpanel">
                   <% call databaseSetup() %>
                </div>
                <div class="submitarea">
                <% if bCanDoNext then %>
				<button type="button" class="button button-basic" id="submitinput" onclick="window.location.href='?step=5'">安装完毕</button>
                <% Else %>
				<input type="button" class="button" onclick="window.location.href='?step=3'" value="返回重新安装" />
				<% end if %>
                </div>
            </div>
        </div>
        <script type="text/javascript">
		OW.redirect("?step=5");
		OW.bodyScrollClose=true;
        </script>
	<%
	end sub
	
	'安装完成
	sub setup_5()
	%>
		<div id="mbody">
            <div class="leftpanel">
                <ul class="step">
                <li class="installed"><b></b>阅读安装协议</li>
                <li class="installed"><b></b>系统环境检测</li>
                <li class="installing"><b></b>安装结果信息</li>
                <li class="installing"><b></b>安装结束</li>
                </ul>
            </div>
            <div class="mainpanel">
                <div class="rightpanel">
                   <p>您已成功完成了OpenWBS的安装<br /><br /></p>
                   <p style="font-size:14px; font-weight:bold; padding-bottom:20px;"><a href="index.asp" target="_self">进入 > 网站首页</a><br /></p>
                   <p style="font-size:14px; font-weight:bold;"><a href="ow-admin/login.asp" target="_self">进入 > 网站管理后台</a></p>
                </div>
                <div class="submitarea">
                    <button type="button" class="button button-basic" id="submitinput" onclick="window.location.href='/ow-admin/'">安装完毕</button>
                </div>
            </div>
        </div>
	<%
	end sub
	
	'创建数据库
	private function databaseSetup()
		'**
		'检查信息是否正确
		'**
		dim siteDomain2,siteDomain3
		SITE_NAME     = OW.htmlEncode(OW.getForm("both","site_name"))
		SITE_DOMAIN   = OW.regReplace(OW.getForm("both","site_domain"),"[^0-9a-zA-Z:\.\-\_]","")
		SITE_URL      = OW.htmlEncode(OW.getForm("both","site_url"))
		SITE_PATH     = OW.getSitePath(SITE_URL)
		siteDomain2   = OW.regReplace(OW.getForm("both","site_domain2"),"[^0-9a-zA-Z:\.\-\_]","")
		siteDomain3   = OW.regReplace(OW.getForm("both","site_domain3"),"[^0-9a-zA-Z:\.\-\_]","")
		
		DB_TYPE       = OW.clng(OW.getForm("both","db_type"))
		sDBAccessName = replace(replace(OW.getForm("both","db_access_name")," ",""),chr(32),"")
		DB_ACCESS_PATH= "ow-content/data/"& sDBAccessName
		DB_SERVER     = OW.getForm("both","db_server")
		DB_PORT       = OW.getForm("both","db_port")
		DB_NAME       = OW.getForm("both","db_name")
		DB_USERNAME   = OW.getForm("both","db_username")
		DB_PASSWORD   = OW.getForm("both","db_password")
		DB_PRE        = OW.getForm("both","db_pre")
		
		sEmail        = OW.getForm("both","email")
		sUsername     = OW.getForm("both","username")
		sPassword     = OW.getForm("both","password")
		
		'**
		'检查信息是否正确
		'**
		if OW.isNul(SITE_NAME) then alert "您忘记填写网站名称，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		if OW.isNul(SITE_DOMAIN) then alert "您忘记填写网站域名，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		if OW.isNul(SITE_URL) then alert "您忘记填写网站网址，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		if OW.isNul(SITE_PATH) then alert "您忘记填写系统路径，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		
		if DB_TYPE=0 then
			if OW.isNul(sDBAccessName) then alert "您忘记填写Access文件名，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		else
			if OW.isNul(DB_SERVER) then alert "您忘记填写数据库服务器地址，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
			if OW.isNul(DB_NAME) then alert "您忘记填写数据库名称，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		end if
		
		if OW.isNul(sEmail) then alert "您忘记填写管理员Email，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		if not(OW.isEmail(sEmail)) then alert "您填写的管理员Email格式不正确，这个很重要哦，回去修正一下吧！","goback" : bCanDoNext = false : exit function
		if OW.isNul(sUsername) then alert "您忘记填写管理员用户名，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		if OW.isNul(sPassword) then alert "您忘记设置管理员密码，这个很重要哦，回去填写一下吧！","goback" : bCanDoNext = false : exit function
		
		if not(bCanDoNext) then exit function
		'**
		'全新创建一个空数据库
		'**
		call checkDataBase()
		
		if not(bCanDoNext) then exit function
		
		'**
		'保存配置
		'**
		if not isAutoInstall then
			call saveConfig()
		end if
		
		Server.ScriptTimeOut = 1200
		OW.DB.SitePath    = SITE_PATH
		OW.DB.dbType     = DB_TYPE
		select case DB_TYPE
		case 0
		OW.DB.dbServer   = DB_ACCESS_PATH
		case 1
		OW.DB.dbServer   = DB_SERVER
		end select
		OW.DB.dbPort     = DB_PORT
		OW.DB.dbName     = DB_NAME
		OW.DB.dbUsername = DB_USERNAME
		OW.DB.dbPassword = DB_PASSWORD
		'**
		'开始创建表
		'**
		dim STDBTable
		set STDBTable  = new STDBTable_Class
		    STDBTable.init()
	   	    bCanDoNext = STDBTable.canDoNext
		set STDBTable  = nothing
		if not(bCanDoNext) then exit function
		'**
		if OS.versionType="x" then
			call OW.include("ow-content/install/setup.shop.db.table.asp")
			dim STSHOPDBTable
			set STSHOPDBTable = new STSHOPDBTable_Class
			    STSHOPDBTable.init()
			    bCanDoNext    = STSHOPDBTable.canDoNext
			set STSHOPDBTable = nothing
		    if not(bCanDoNext) then exit function
		end if
		'**
		'开始添加系统数据
		'**
		echo "开始安装数据<br>" : response.flush()
		sPassword = OW.parsePassWord(sPassword)
		dim STDBData
		set STDBData      = new SetupDBData_Class
		STDBData.username = sUsername
		STDBData.password = sPassword
		STDBData.email    = sEmail
		STDBData.siteDomain2 = siteDomain2
		STDBData.siteDomain3 = siteDomain3
		STDBData.init()
		  bCanDoNext = STDBData.canDoNext
		set STDBData = nothing
		if not(bCanDoNext) then exit function
		'**
		if OS.versionType="x" then
			call OW.include("ow-content/install/setup.shop.db.data.asp")
			dim STSHOPDBData
			set STSHOPDBData = new STSHOPDBData_Class
			    STSHOPDBData.init()
			    bCanDoNext    = STSHOPDBData.canDoNext
			set STSHOPDBData = nothing
		    if not(bCanDoNext) then exit function
		end if
		'**
		call OW.Cache.clearRamCache("ow.config.1")
		call OW.Cache.clearRamCache("ow.config.2")
		call OW.Cache.clearRamCache("ow.config.3")
		'**
		'安装结束
		'**
		if bCanDoNext then call OW.FSO.SaveTextFile(OW.serverMapPath(SITE_PATH &"ow-content/data/install.lock"),"install_lock")
		'**
		echo "<br>系统数据安装结束.<br>"
		echo "<script type=""text/javascript"">OW.redirect(""?step=5"");</script>"
		response.flush()
	end function
	
	private function checkDataBase()
		on error resume next
		dim conn,dbServer,naError,connErrors,errorString
		select case DB_TYPE
			case 0
				if not(OW.FSO.fileExists(OW.serverMapPath(SITE_PATH & DB_ACCESS_PATH))) then
				'如果数据库文件不存在则创建一个
					if not(createDataBase()) then
						if OW.getFileExName(DB_ACCESS_PATH)="mdb" or OW.getFileExName(DB_ACCESS_PATH)="accdb" then
							echo "<div style='color:#fff; padding:20px;'>无法创建Access数据库文件"& SITE_PATH & DB_ACCESS_PATH &"，请确认您的服务器是否支持Access并且有创建Access数据库的权限，如还有问题请去<a href='http://www.openwbs.com/' target='_blank'>OpenWBS官方</a>寻求帮助！</div>" : response.flush()
							alert "无法创建Access数据库文件"& SITE_PATH & DB_ACCESS_PATH &"，请确认您的服务器是否支持Access并且有创建Access数据库的权限，如还有问题请去OpenWBS官方寻求帮助！","goback"
						Else
							echo "<div style='color:#fff; padding:20px;'>无法创建Access数据库文件"& SITE_PATH & DB_ACCESS_PATH &"，请将Access文件名改为.mdb或.accdb后缀(如:"& OW.replaceString(sDBAccessName,".asp",".mdb") &")再试试！</div>" : response.flush()
							alert "无法创建Access数据库文件"& SITE_PATH & DB_ACCESS_PATH &"，请将Access文件名改为.mdb或.accdb后缀(如:"& OW.replaceString(sDBAccessName,".asp",".mdb")&")再试试！","goback"
						end if
						bCanDoNext = false
						exit function
					end if
				end if
			case 1
				if OW.isNul(DB_PORT) then
					dbServer = DB_SERVER
				else
					dbServer = DB_SERVER &","& DB_PORT
				end if
				if OW.isNul(DB_USERNAME) then
					sConnStr            = "Provider=SQLOLEDB;Data Source="& dbServer &";Initial Catalog="& DB_NAME &";Integrated Security=SSPI;"
					sCreateNewDBConnStr = "Provider=SQLOLEDB;Data Source="& dbServer &";Initial Catalog=;Integrated Security=SSPI;"
				Else
					sConnStr            = "Provider=SQLOLEDB;Data Source="& dbServer &";Initial Catalog="& DB_NAME &";User Id="& DB_USERNAME &";Password="& DB_PASSWORD &";"
					sCreateNewDBConnStr = "Provider=SQLOLEDB;Data Source="& dbServer &";Initial Catalog=;User Id="& DB_USERNAME &";Password="& DB_PASSWORD &";"
				end if
				Set conn=server.createObject("ADODB.Connection")
				conn.ConnectionTimeout=3
				conn.Open sConnStr
				
				if conn.Errors.count>0 then
					Set connErrors = conn.Errors(0)
					errorString = "\n\n错误信息：\n"
					errorString = errorString &"Error.Description:"& connErrors.Description &"\n"
					errorString = errorString &"Error.HelpContext:"& connErrors.HelpContext &"\n"
					errorString = errorString &"Error.HelpFile:"& connErrors.HelpFile &"\n"
					errorString = errorString &"Error.NativeError:"& connErrors.NativeError &"\n"
					errorString = errorString &"Error.number:"& connErrors.number &"\n"
					errorString = errorString &"Error.Source:"& connErrors.Source &"\n"
					errorString = errorString &"Error.SQLState:"& connErrors.SQLState &"\n"
					errorString = OW.replaceString(errorString,"""","\""")
					naError=OW.CLng(conn.Errors(0).NativeError)
					Set connErrors = Nothing
					conn.Close
					Set conn = Nothing
					select case naError
						case "17"
							alert "无法连接 SQL Server 数据库服务器 "& dbServer &"，请检查数据库服务器地址是否正确。"& errorString,"goback"
							bCanDoNext = false
							exit function
						case "4060"
						'数据库名称不存在
							if not(createDataBase()) then
								alert "无法创建数据库["& DB_NAME &"]"& errorString,"goback"
								bCanDoNext = false
								exit function
							end if
						case "18456"
						'用户无法登陆
							alert "无法连接 SQL Server 数据库服务器 "& dbServer &"，请检查数据库帐号或密码是否正确。"& errorString,"goback"
							bCanDoNext = false
							exit function
						case Else
							alert "无法连接 SQL Server 数据库服务器 "& dbServer &"，请检查 SQL Server 数据库是否已正确安装。"& errorString,"goback"
							bCanDoNext = false
							exit function
					end select
				Else
					conn.close
					set conn = Nothing
				end if
		end select
		if Err.number <> 0 then
			Err.clear
		end if
	end function
	
	'创建一个数据库
	private function createDataBase()
		on error resume next
		dim conn,result
		result = true
		select case DB_TYPE
			case 0
				set conn = server.createObject("ADOX.Catalog")
				conn.create "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & OW.serverMapPath(SITE_PATH & DB_ACCESS_PATH)
				set conn = nothing
				if Err.number <> 0 then
					'创建不了的话就复制一个
					Err.clear
					result = OW.FSO.fileCopy("ow-content/data/setup_temp_db.mdb",DB_ACCESS_PATH)
				end if
			case 1
				set conn=server.createObject("ADODB.Connection")
				conn.ConnectionTimeout=3
				conn.Open sCreateNewDBConnStr
				conn.Execute "IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'"& DB_NAME &"') DROP DATABASE ["& DB_NAME &"]"
				conn.Execute "CREATE DATABASE ["& DB_NAME &"]"
				conn.Close
				set conn = nothing
				if Err.number <> 0 then 
					Err.clear
					result = false
				end if
		end select
		createDataBase = result
	end function
	
	'保存配置
	function saveConfig()
		dim text
		text = OW.read("ow.config.asp")
		text = OW.RegReplace(text,"SYS_IS_INSTALL([\s]*?)=([\s]*?)(\d+?)","SYS_IS_INSTALL = 1")		
		text = OW.RegReplace(text,"SITE_URL([\s]*?)=([\s]*?)(""\S*"")","SITE_URL = """& SITE_URL &"""")
		text = OW.RegReplace(text,"SITE_DOMAIN([\s]*?)=([\s]*?)(""\S*"")","SITE_DOMAIN = """& SITE_DOMAIN &"""")
		text = OW.RegReplace(text,"SITE_PATH([\s]*?)=([\s]*?)(""\S*"")","SITE_PATH = """& SITE_PATH &"""")
		
		text = OW.RegReplace(text,"DB_TYPE([\s]*?)=([\s]*?)(\d+?)","DB_TYPE = "& DB_TYPE &"")
		text = OW.RegReplace(text,"DB_ACCESS_PATH([\s]*?)=([\s]*?)(""\S*"")","DB_ACCESS_PATH = """& DB_ACCESS_PATH &"""")
		text = OW.RegReplace(text,"DB_SERVER([\s]*?)=([\s]*?)(""\S*"")","DB_SERVER = """& DB_SERVER &"""")
		text = OW.RegReplace(text,"DB_PORT([\s]*?)=([\s]*?)(""\S*"")","DB_PORT = """& DB_PORT &"""")
		text = OW.RegReplace(text,"DB_NAME([\s]*?)=([\s]*?)(""\S*"")","DB_NAME = """& DB_NAME &"""")
		text = OW.RegReplace(text,"DB_USERNAME([\s]*?)=([\s]*?)(""\S*"")","DB_USERNAME = """& DB_USERNAME &"""")
		text = OW.RegReplace(text,"DB_PASSWORD([\s]*?)=([\s]*?)(""\S*"")","DB_PASSWORD = """& DB_PASSWORD &"""")
		text = OW.RegReplace(text,"DB_PRE([\s]*?)=([\s]*?)(""\S*"")","DB_PRE = """& DB_PRE &"""")
		
		if OW.FSO.saveFile("ow.config.asp",text)=true then
			bCanDoNext = true
		Else
			bCanDoNext = false
			alert "无法保存配置信息, 请检查ow.config.asp是否有写入权限。","goback" : bCanDoNext = false : exit function
		end if
	end function
	
end Class
%>
