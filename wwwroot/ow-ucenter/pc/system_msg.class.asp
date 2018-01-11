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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(2107)%></h1>
          <div class="section-msg-detail">
			  <dl class="msg-title"><dt><%=UC.lang(2102)%></dt><dd><%=V("msg_title")%></dd></dl>
              <dl class="msg-time"><dt><%=UC.lang(2103)%></dt><dd><%=V("msg_time")%></dd></dl>
              <dl class="msg-content"><dt><%=UC.lang(2106)%></dt><dd><%=OW.dbDataDecode(V("msg_content"))%></dd></dl>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//评价初始化
		var $form = $("[name='comment_post_form']");
		UC.commentInit({
			orderId:"<%=V("order_id")%>",
			gid:"<%=V("gid")%>",
			pid:"<%=V("pid")%>",
			form:$form,
			content:$form.find("textarea[name='cmt_content']"),
			vcodeValue:$form.find("input[name='verifycode_value']"),
			verifycode:$form.find("span[name='verifycode']"),
			submit:$form.find("button[name='submit']")
		});
		$("[name='comment_data_reply']").each(function(){if(OW.isNull($(this).find("[name='reply_content']").html())){$(this).remove();}});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function main()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(2100)%></h1>
          <div class="section-orders" id="orders">
			  <div class="section">
			  <%
              OW.Pager.sql      = "select id,msg_title,msg_time,is_user_read from "& DB_PRE &"system_msg where uid="& UID &" AND is_user_delete=0 ORDER BY id DESC"
              OW.Pager.pageSize = 20
              OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&page={$page}"
              OW.Pager.loopHtml = "<tr><td field=""id"" value=""{$id}"">{$id}</td><td field=""msg_title"" value=""{$msg_title}""><a href="""& UCENTER_HURL &"ctl="& CTL &"&act=detail&id={$id}"">{$msg_title}</a></td><td field=""is_user_read"" value=""{$is_user_read}"">{$is_user_read}</td><td field=""msg_time"" value=""{$msg_time}"">{$msg_time}</td><td field=""opeation""><a href="""& UCENTER_HURL &"ctl="& CTL &"&act=detail&id={$id}"">"& UC.lang(2105) &"</a></td></tr>"
              OW.Pager.run()
              %>
              <table border="0" cellpadding="0" cellspacing="0" class="table table-bordered table-hover">
              <thead><tr><th>id</th><th><%=UC.lang(2102)%></th><th><%=UC.lang(2103)%></th><th><%=UC.lang(2104)%></th></tr></thead>
              <tbody><%=OW.Pager.loopHtmls%></tbody>
              </table>
              </div>
              <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//**已读
		$("#orders td[field='is_user_read']").each(function(){
			var html,read = $(this).attr("value"),
			$a = $(this).parent().find("td[field='msg_title']").find("a");
			if(read==0){
				$a.addClass("read-0");
			}else{
				$a.addClass("read-1");
			};
			$(this).remove();
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	
	
end class
%>

