<%
'**
'站点管理
'**
dim PLUGIN_FIREWALL_WORDS_INSTALL
class PLUGIN_FIREWALL_WORDS_INSTALL_CLASS
	
	public result
	
	private sub class_initialize()
	end sub
	
	private sub class_terminate()
	end sub
	
	public sub init()
		result = false '安装结果，安装成功返回true
	end sub
	
	public function install()
		result = true
	end function

end class
%>