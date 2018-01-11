<!--#include file="ow.client.asp"-->
<%
call Client.init()
dim AjaxMain
set AjaxMain = new AjaxMain_Class
	AjaxMain.init()
set AjaxMain = nothing
set Client = nothing
class AjaxMain_Class
	
	private aArr,iI,iCateId,iIsShop
	private dataType
	
	private sub class_initialize()
	end sub
	
	public sub init()
		iCateId  = OW.int(OW.getForm("get","cate_id"))
		iIsShop  = OW.int(OW.getForm("get","is_shop"))
		dataType = OW.regReplace(OW.getForm("get","data_type"),"[^a-z]","")
		if dataType="html" then
			call getCategoryHtml()
		else
			call getCategoryData()
		end if
		call Client.ajaxFinishRun()
	end sub
	
	private sub class_terminate()
	end sub
	
	public function getCategoryData()
		dim arr,fieldsCount,i,j,rs,s,ss,fieldName,fieldValue
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "["
		set rs = OW.DB.getRecordBySQL("SELECT cate_id,depth,children,name,subname,root_id,rootpath,urlpath,icon,image FROM "& DB_PRE &"category WHERE is_shop="& iIsShop &" AND parent_id="& iCateId &" AND status=0 ORDER BY sequence ASC")
		fieldsCount = rs.fields.count-1
		do while not rs.eof
			j = j+1
			for i=1 to fieldsCount
				fieldName = rs.fields(i).name
				fieldValue= OW.rs(rs(rs.fields(i).name))
				if fieldName="name" or fieldName="subname" then
					fieldValue = OW.escape(fieldValue)
				end if
				s = """"& fieldName &""":"""& fieldValue &""""
				if i=1 then
					ss = s
				else
					ss = ss &","& s
				end if
			next
			'****
			if OW.int(rs("children"))>0 then
				ss = ss &","&"""sub"":"& getSubCategoryData(rs("cate_id")) &""
			end if
			'****
			if j>1 then
				sb.append ","
			end if
			sb.append "{"& ss &"}"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "]"
		'****
		str = sb.toString() : set sb = nothing
		json    = """category"":"& str &""
		Client.auxJson = json
		call Client.ajaxSuccess("")
	end function
	
	public function getSubCategoryData(byval parentId)
		dim arr,fieldsCount,i,j,rs,s,ss,fieldName,fieldValue
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "["
		set rs = OW.DB.getRecordBySQL("SELECT cate_id,depth,children,name,subname,root_id,rootpath,urlpath,icon,image FROM "& DB_PRE &"category WHERE is_shop="& iIsShop &" AND parent_id="& parentId &" AND status=0 ORDER BY sequence ASC")
		fieldsCount = rs.fields.count-1
		do while not rs.eof
			j = j+1
			for i=1 to fieldsCount
				fieldName = rs.fields(i).name
				fieldValue= OW.rs(rs(rs.fields(i).name))
				if fieldName="name" or fieldName="subname" then
					fieldValue = OW.escape(fieldValue)
				end if
				s = """"& fieldName &""":"""& fieldValue &""""
				if i=1 then
					ss = s
				else
					ss = ss &","& s
				end if
			next
			'****
			if OW.int(rs("children"))>0 then
				ss = ss &","&"""sub"":"& getSubCategoryData(rs("cate_id")) &""
			end if
			'****
			if j>1 then
				sb.append ","
			end if
			sb.append "{"& ss &"}"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "]"
		str = sb.toString() : set sb = nothing
		getSubCategoryData = str
	end function
	
	public function getCategoryHtml()
		dim i,rs,cateLink,cateName
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<ul id=""ow_shop_cate"">"
		set rs = OW.DB.getRecordBySQL("SELECT cate_id,depth,children,name,subname,root_id,rootpath,urlpath,icon,image FROM "& DB_PRE &"category WHERE is_shop="& iIsShop &" AND parent_id="& iCateId &" AND status=0 ORDER BY sequence ASC")
		do while not rs.eof
			i = i+1
			if OW.int(rs("depth"))=1 then
				cateLink = replace(OW.urlRewrite("c1"),"{$urlpath}",rs("urlpath"))
			else
				cateLink = replace(OW.urlRewrite("c3"),"{$rootpath}",rs("rootpath"))
				cateLink = replace(cateLink,"{$urlpath}",rs("urlpath"))
			end if
			cateName = rs("name")
			sb.append "<li class=""li"& i &"""><h3><a href="""& cateLink &""" target=""_blank"">"& cateName &"</a></h3><div class=""sub""></div>"
			'****
			if OW.int(rs("children"))>0 then
				sb.append getSubCategoryHtml(i,rs("cate_id"))
			end if
			'****
			sb.append "</li>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "</ul>"
		'****
		str = sb.toString() : set sb = nothing
		json= """category"":"""& OW.escape(str) &""""
		Client.auxJson = json
		call Client.ajaxSuccess("")
	end function
	
	public function getSubCategoryHtml(byval i,byval parentId)
		dim rs,cateLink,cateName
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<div class=""sub2-nav sub2-nav-"& i &""">"
		sb.append "<table border=""0"" cellpadding=""0"" cellspacing=""0"">"
		set rs = OW.DB.getRecordBySQL("SELECT cate_id,depth,children,name,subname,root_id,rootpath,urlpath,icon,image FROM "& DB_PRE &"category WHERE is_shop="& iIsShop &" AND parent_id="& parentId &" AND status=0 ORDER BY sequence ASC")
		do while not rs.eof
			cateLink = replace(OW.urlRewrite("c3"),"{$rootpath}",rs("rootpath"))
			cateLink = replace(cateLink,"{$urlpath}",rs("urlpath"))
			cateName = rs("name")
			sb.append "<tr>"
			sb.append "<td class=""dt""><a href="""& cateLink &""" target=""_blank"">"& cateName &"</a></td><td class=""i""><i>></i></td><td class=""dd""><div class=""cate3-section"">"
			'****
			if OW.int(rs("children"))>0 then
				sb.append getSub3CategoryHtml(rs("cate_id"))
			end if
			'****
			sb.append "</div></td></tr>"
			sb.append "</tr>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "</table></div>"
		str = sb.toString() : set sb = nothing
		getSubCategoryHtml = str
	end function
	
	public function getSub3CategoryHtml(byval parentId)
		dim rs,cateLink,cateName
		dim sb,str : set sb = OW.stringBuilder()
		set rs = OW.DB.getRecordBySQL("SELECT cate_id,depth,children,name,subname,root_id,rootpath,urlpath,icon,image FROM "& DB_PRE &"category WHERE is_shop="& iIsShop &" AND parent_id="& parentId &" AND status=0 ORDER BY sequence ASC")
		do while not rs.eof
			cateLink = replace(OW.urlRewrite("c3"),"{$rootpath}",rs("rootpath"))
			cateLink = replace(cateLink,"{$urlpath}",rs("urlpath"))
			cateName = rs("name")
			sb.append "<a href="""& cateLink &""" target=""_blank"">"& cateName &"</a>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		str = sb.toString() : set sb = nothing
		getSub3CategoryHtml = str
	end function
	
	
end class
%>