<%
dim UC_COUPON
class UC_COUPON_CLASS
	
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
	dim sqlCondition
	V("status") = OW.regReplace(OW.getForm("get","status"),"[^a-z]","")
	if V("status")<>"used" and V("status")<>"invalid" then V("status") = "valid"
	'**
	select case V("status")
	case "valid"
		sqlCondition = " AND a.is_used=0 AND (b.is_use_timelimit=0 or (b.is_use_timelimit=1 and b.use_endtime>{$time})) "
	case "used"
		sqlCondition = " AND a.is_used=1 "
	case "invalid"
		sqlCondition = " AND a.is_used=0 AND b.is_use_timelimit=1 AND b.use_endtime<{$time} "
	end select
	sqlCondition = OW.createTimeSql(sqlCondition,SYS_TIME)
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody"> 
      <div id="container">
          <h1 class="header"><%=UC.lang(1100)%></h1>
          <div class="section-coupon" id="coupons">
              <div class="header">
                  <ul><li><a <%=OW.iif(V("status")="valid","class=""current""","")%> href="<%=UCENTER_HURL%>ctl=coupon&status=valid"><%=UC.lang(1101)%></a></li><li><a <%=OW.iif(V("status")="used","class=""current""","")%> href="<%=UCENTER_HURL%>ctl=coupon&status=used"><%=UC.lang(1102)%></a></li><li><a <%=OW.iif(V("status")="invalid","class=""current""","")%> href="<%=UCENTER_HURL%>ctl=coupon&status=invalid"><%=UC.lang(1103)%></a></li></ul>
              </div>
              <div class="section">
                  <%
				  OW.Pager.sql      = "SELECT a.coupon_id,a.coupon_code,b.coupon_name,b.coupon_money,b.use_min_money,b.is_use_timelimit,b.use_starttime,b.use_endtime FROM "& DB_PRE &"coupon_data a LEFT JOIN "& DB_PRE &"coupon b ON (b.coupon_id=a.coupon_id) WHERE a.uid="& UID &" AND a.site_id="& SITE_ID &" "& sqlCondition &" ORDER BY id DESC"
				  OW.Pager.pageSize = 20
				  OW.Pager.pageUrl  = "index.asp?ctl=coupon&status="& V("status") &"&page={$page}"
				  OW.Pager.loopHtml = "<div class=""coupon coupon-"& V("status") &"""><dl><dt><em class=""moneysb"">￥</em><span class=""money"">{$coupon_money}</span><span class=""coupon-name"">"& UC.lang(1104) &"</span></dt><dd><div class=""use-time"" name=""use_time"" is_use_timelimit=""{$is_use_timelimit}""><div class=""span-dt"">"& UC.lang(1105) &"</div><div class=""span-dd"" name=""use_time_show"">{$use_starttime} - {$use_endtime}</div></div><div class=""use-min-money"" use_min_money=""{$use_min_money}""><div class=""span-dt"">"& UC.lang(1106) &"</div><div class=""span-dd"">"& UC.lang(1107) &"</div></div></dd></dl></div>"
				  OW.Pager.run()
				  %>
                  <%=OW.Pager.loopHtmls%>
              </div>
              <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		var $coupons = $("#coupons");
		$coupons.find("div[name='use_time']").each(function(){
			if($(this).attr("is_use_timelimit")=="0"){
				$(this).find("div[name='use_time_show']").html('<%=UC.lang(1108)%>');
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

