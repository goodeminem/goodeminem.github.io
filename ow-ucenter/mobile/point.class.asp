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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1900))%>
    <section id="mbody">
        <div class="section-fiance-point" id="point_log">
            <div class="ow-count-header">
                <span class="text-grid"><h4><%=UC.lang(1901)%></h4><p><%=myPointTotal%> <%=OS.lang(200)%></p></span>
                <span class="text-grid text-grid-2"><h4><%=UC.lang(1902)%></h4><p><%=myPointAvailable%> <%=OS.lang(200)%></p></span>
                <span class="text-grid text-grid-3" style="display:none;"><h4><%=UC.lang(1903)%></h4><p><%=myPointFreeze%> <%=OS.lang(200)%></p></span>
            </div>
            <div class="section" id="list_section">
                <%
                OW.Pager.sql      = "select logid,time,sn,type,income,expend,point,remark from "& DB_PRE &"member_point_log where uid="& UID &" ORDER BY logid DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl=point&page={$page}"
				OW.Pager.pageTpl  = "{prev}{current}{next}"
				OW.Pager.loopHtml = "<section><div class=""header""><span class=""logid"">{$logid}</span><span class=""time"">{$time}</span><span class=""type"" field=""type"" value=""{$type}"">{$type}</span><span class=""income"" field=""income"" value=""{$income}"">{$income}</span><span class=""expend"" field=""expend"" value=""{$expend}"">{$expend}分</span><a class=""detail"" href=""javascript""></a></div><div class=""section""><table border=""0"" cellpadding=""0"" cellspacing=""0"" class=""table table-striped table-bordered table-hover""><tbody><tr><td>"& UC.lang(1905) &"</td><td field=""time"">{$time}</td></tr><tr><td>"& UC.lang(1906) &"</td><td field=""sn"">{$sn}</td></tr><tr><td>"& UC.lang(1907) &"</td><td field=""type"" value=""{$type}"">{$type}</td></tr><tr><td>"& UC.lang(1908) &"</td><td field=""income"" value=""{$income}"">{$income}</td></tr><tr><td>"& UC.lang(1909) &"</td><td field=""expend"" value=""{$expend}"">{$expend}</td></tr><tr><td>"& OS.lang(200) &"</td><td field=""point"" class=""point"" value=""{$point}"">{$point}</td></tr><tr><td field=""remark"">"& UC.lang(1910) &"</td><td>{$remark}</td></tr></tbody></table></div></section>"
				OW.Pager.loopExecute= "if fieldName=""time"" then fieldValue = OW.formatDateTime(fieldValue,0)"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
            </div>
            <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		//**交易类型
		$("#list_section td[field='type']").each(function(){
			var type = parseInt($(this).attr("value"));
			var text = "";
			if(type==1){
				text = '<font class="color-income"><%=UC.lang(1908)%></font>';
			}else if(type==2){
				text = '<font class="color-expend"><%=UC.lang(1909)%></font>';
			};
			$(this).html(text);
		});
		$("#list_section span[field='type']").each(function(){
			var type = parseInt($(this).attr("value"));
			var text = "";
			if(type==1){
				text = '<font class="color-income">+</font>';
			}else if(type==2){
				text = '<font class="color-expend">-</font>';
			};
			$(this).html(text);
		});
		//**收入
		$("#list_section td[field='income']").each(function(){
			var income = parseFloat($(this).attr("value"));
			var text   = "";
			if(income>0){text = '<font class="color-income">'+income+'<font>';};
			$(this).html(text);
		});
		$("#list_section span[field='income']").each(function(){
			var income = parseFloat($(this).attr("value"));
			if(!(income>0)){
				$(this).remove();
			};
		});
		//**支出
		$("#list_section td[field='expend']").each(function(){
			var expend = parseFloat($(this).attr("value"));
			var text   = "";
			if(expend>0){text = '<font class="color-expend">-'+expend+'<font>';};
			$(this).html(text);
		});
		$("#list_section span[field='expend']").each(function(){
			var expend = parseFloat($(this).attr("value"));
			if(!(expend>0)){
				$(this).remove();
			};
		});
		//
		$("#list_section div.header").toggle(
			function(){
				$(this).addClass("header-drop");
				$(this).next().show(100);
			},
			function(){
				$(this).removeClass("header-drop");
				$(this).next().hide(100);
			}
		);
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function

end class
%>

