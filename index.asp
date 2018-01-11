<!--#include file="ow-includes/ow.client.asp"-->
<!--#include file="ow-includes/ow.tpl.asp"-->
<%:if SYS_IS_INSTALL=0 then:response.write("网站还未安装，点击<a href='ow.install.asp'>开始安装</a>"):else:OS.urlRewrite = true:Client.init():Client.run():set Client = nothing:end if:%>