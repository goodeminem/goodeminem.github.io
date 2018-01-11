<%
dim UC_SYSTEM_MSG
class UC_SYSTEM_MSG_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "do"
		case "detail"
			call getMsgDetail()
			if V("msg_exist") then
				call msgDetail()
			else
				UC.errorLink = array(UC.lang(2101) &">"& UCENTER_HURL &"ctl=system_msg",OS.lang(75) &">javascript:OW.goBack();")
				call UC.errorSetting(UC.lang(2108))
			end if
		case "delete"
			
		case else
			call main()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function getMsgDetail()
		dim arr,fieldsCount
		V("msg_id") = OW.int(OW.getForm("get","id"))
		set oRs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"system_msg WHERE id="& V("msg_id") &" AND uid="& UID &" AND "& OW.DB.auxSQL &"")
		fieldsCount = oRs.fields.count-1
		if oRs.eof then
			V("msg_exist") = false
		else
			V("msg_exist") = true
			for i=1 to fieldsCount
				V(oRs.fields(i).name) = OW.rs(oRs(oRs.fields(i).name))
			next
			call OW.DB.execute("UPDATE "& DB_PRE &"system_msg SET is_user_read=1 WHERE id="& V("msg_id") &"")
		end if
		OW.DB.closeRs oRs
	end function
	
	private function msgDetail()
		call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(2101))%>
    <section id="mbody">
      <div class="section-system-msg-detail">
          <dl class="msg-time"><dt><%=UC.lang(2102)%></dt><dd><%=V("msg_time")%></dd></dl>
          <dl class="msg-title"><dt><%=UC.lang(2103)%></dt><dd><%=V("msg_title")%></dd></dl>
          <dl class="msg-content"><dt><%=UC.lang(2106)%></dt><dd><%=OW.dbDataDecode(V("msg_content"))%></dd></dl>
      </div>
    </section>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function main()
		call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(2100))%>
    <section id="mbody">
        <div class="section-system-msg" id="system_msg">
			<div class="section">
				<%
                OW.Pager.sql      = "select id,msg_title,msg_time,is_user_read from "& DB_PRE &"system_msg where uid="& UID &" AND is_user_delete=0 ORDER BY id DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<dl is_user_read=""{$is_user_read}""><dt><a href="""& UCENTER_HURL &"ctl="& CTL &"&act=detail&id={$id}"">{$msg_title}</a></dt></dl>"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
            </div>
            <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		//**已读
		$("#system_msg dl").each(function(){
			var html,read = $(this).attr("is_user_read"),
			$a = $(this).find("a");
			if(read==0){
				$a.addClass("read-0");
			}else{
				$a.addClass("read-1");
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	
	
end class
%>

