<%
dim UC_POINT
class UC_POINT_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "do"
		case else
			call main()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function main()
	dim arr,myPoint,myPointAvailable,myPointFreeze
	arr = OS.getMemberPoint(UID)
	myPointTotal     = arr(0)
	myPointAvailable = arr(1)
	myPointFreeze    = arr(2)
	
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody"> 
      <div id="container">
          <h1 class="header"><%=UC.lang(1900)%></h1>
          <div class="section-fiance-point" id="point_log">
              <div class="ow-count-header">
                    <span class="text-grid total"><h4><%=UC.lang(1901)%></h4><p style="color:#333;"><%=myPointTotal%><%=OS.lang(200)%></p></span>
                    <span class="text-grid text-grid-2 available"><h4><%=UC.lang(1902)%></h4><p><%=myPointAvailable%><%=OS.lang(200)%></p></span>
                    <span class="text-grid text-grid-2 freeze" style="display:none;"><h4><%=UC.lang(1903)%></h4><p><%=myPointFreeze%><%=OS.lang(200)%></p></span>
              </div>
              <div class="section">
                  <%
				  OW.Pager.sql      = "select logid,time,sn,type,income,expend,point,remark from "& DB_PRE &"member_point_log where uid="& UID &" ORDER BY logid DESC"
				  OW.Pager.pageSize = 20
				  OW.Pager.pageUrl  = "index.asp?ctl=point&page={$page}"
				  OW.Pager.loopHtml = "<tr><td field=""logid"">{$logid}</td><td field=""time"">{$time}</td><td field=""sn"">{$sn}</td><td field=""type"" value=""{$type}"">{$type}</td><td field=""income"" value=""{$income}"">{$income}</td><td field=""expend"" value=""{$expend}"">{$expend}</td><td field=""point"" class=""point"" value=""{$point}"">{$point}</td><td field=""remark"">{$remark}</td></tr>"
				  OW.Pager.run()
				  %>
                  <table border="0" cellpadding="0" cellspacing="0" class="table table-striped table-bordered table-hover">
                  <thead><tr><th><%=UC.lang(1904)%></th><th><%=UC.lang(1905)%></th><th><%=UC.lang(1906)%></th><th><%=UC.lang(1907)%></th><th><%=UC.lang(1908)%></th><th><%=UC.lang(1909)%></th><th><%=OS.lang(200)%></th><th><%=UC.lang(1910)%></th></tr></thead>
                  <tbody><%=OW.Pager.loopHtmls%></tbody>
                  </table>
              </div>
              <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//**交易类型
		$("#point_log td[field='type']").each(function(){
			var type = parseInt($(this).attr("value"));
			var text = "";
			if(type==1){
				text = '<font class="color-income"><%=UC.lang(1908)%><font>';
			}else if(type==2){
				text = '<font class="color-expend"><%=UC.lang(1909)%><font>';
			};
			$(this).html(text);
		});
		//**收入
		$("#point_log td[field='income']").each(function(){
			var income = parseFloat($(this).attr("value"));
			var text   = "";
			if(income>0){text = '<font class="color-income">'+income+'<font>';};
			$(this).html(text);
		});
		//**支出
		$("#point_log td[field='expend']").each(function(){
			var expend = parseFloat($(this).attr("value"));
			var text   = "";
			if(expend>0){text = '<font class="color-expend">-'+expend+'<font>';};
			$(this).html(text);
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function

end class
%>

