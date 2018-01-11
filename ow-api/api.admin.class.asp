<%
'**
'api接口文件
'这里定义接口函数
'**
dim APIAdmin
set APIAdmin = new APIAdmin_Class
class APIAdmin_Class
	
	private sub class_initialize()
	end sub
	private sub class_terminate()
	end sub
	
	public sub init()
	end sub
	
	public function topAuxMenu()
	end function
	
	public function destopAuxGrid()
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<div class=""section"">"
		sb.append "<div class=""section-header section-header-important"">常用管理工具</div>"
		sb.append "<div class=""section-body"">"
		sb.append "<div class=""links"">"
		sb.append "<a href=""index.asp?ctl=setting&act=edit"">系统设置</a>"
		sb.append "<a href=""index.asp?ctl=setting&act=edit_site_info"">网站信息设置</a>"
		sb.append "<a href=""index.asp?ctl=category&act=list"">内容栏目管理</a>"
		if OS.versionType="x" then
		sb.append "<a href=""index.asp?ctl=shop_category&act=list"">商品栏目管理</a>"
		end if
		sb.append "<a href=""index.asp?ctl=navigator&act=list"">网站导航管理</a>"
		sb.append "<a href=""index.asp?ctl=ad&act=list"">广告管理</a>"
		sb.append "<a href=""index.asp?ctl=service_online&act=list"">在线客服</a>"
		sb.append "<a href=""index.asp?ctl=links&act=list"">友情链接</a>"
		sb.append "<a href=""index.asp?ctl=backup&act=list"">数据库备份</a>"
		sb.append "<a href="""& SITE_URL &""">网站预览</a>"
		sb.append "</div>"
		sb.append "</div>"
		sb.append "</div>"
		str = sb.toString() : set sb = nothing
		destopAuxGrid = str
	end function
	
end class
%>
