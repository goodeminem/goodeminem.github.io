<%
dim UC_INDEX
class UC_INDEX_CLASS
	
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
	dim myDeposit,myPoint,myCoupons,myMsgs,myMGroupName,mySMGroupName,myMGroupColor,mySMGroupColor,lastLoginTime
	call UC.echoHeader()
	myDeposit = OS.getMemberDeposit(UID)(0)
	myPoint   = OS.getMemberPoint(UID)(0)
	if OS.versionType="x" then
	myCoupons = OS.getMemberValidCoupon(UID)
	end if
	myMsgs    = OS.getMemberUnReadMsg(UID)
	myMGroupName  = OS.getGroupName(GROUP_ID)
	mySMGroupName = OS.getGroupName(SPECIAL_GROUP_ID)
	myMGroupColor = OW.DB.getFieldValueBySQL("SELECT group_color FROM "& DB_PRE &"member_group WHERE group_id="& GROUP_ID &"")
	mySMGroupColor= OW.DB.getFieldValueBySQL("SELECT group_color FROM "& DB_PRE &"member_group WHERE group_id="& SPECIAL_GROUP_ID &"")
	lastLoginTime = OW.DB.getFieldValueBySQL("SELECT last_login_time FROM "& DB_PRE &"member WHERE uid="& UID &"")
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody"> 
      <div id="container">
        <div class="uc-userinfo">
          <div class="avatar" id="uc_avatar"><img class="avatar" src="<%=AVATAR%>"><a class="upload" href="<%=UCENTER_HURL%>ctl=setting&act=avatar" style="display:none;"><%=UC.lang(110)%></a></div>
          <div class="baseinfo"><span class="nickname"><%=OW.iif(NICKNAME="",USERNAME,NICKNAME)%></span><span class="mobile"><%=MOBILE%></span></div>
          <div class="account">
              <span class="username"><%=UC.lang(111)%><b><%=USERNAME%></b></span><span class="email"><%=EMAIL%></span><span class="last-login-time"><%=UC.lang(112)%><%=lastLoginTime%></span>
          </div>
          <div class="auxinfo">
              <span class="group"><%=UC.lang(113)%><a href="javascript:;" style="color:<%=myMGroupColor%>"><%=myMGroupName%></a></span><span class="sep">|</span><span class="special-group" style="color:<%=mySMGroupColor%>"><%=mySMGroupName%></span>
          </div>
        </div>
        <div class="account-info">
          <% if OS.versionType="x" then %>
          <dl>
            <dt><%=UC.lang(114)%></dt>
            <dd><a href="<%=UCENTER_HURL%>ctl=finance"><strong><%=myDeposit%></strong><span><%=UC.lang(115)%></span></a><a class="btn btn-primary btn-charge" href="<%=UCENTER_HURL%>ctl=finance&act=charge"><%=UC.lang(116)%></a></dd>
          </dl>
          <% end if %>
          <dl>
            <dt><%=OS.lang(200)%></dt>
            <dd><a href="<%=UCENTER_HURL%>ctl=point"><strong><%=myPoint%></strong><span><%=OS.lang(200)%></span></a></dd>
          </dl>
          <% if OS.versionType="x" then %>
          <dl>
            <dt><%=UC.lang(117)%></dt>
            <dd><a href="<%=UCENTER_HURL%>ctl=coupon"><strong><%=myCoupons%></strong><span><%=UC.lang(118)%></span></a></dd>
          </dl>
          <% end if %>
          <dl>
            <dt><%=UC.lang(120)%></dt>
            <dd><a href="<%=UCENTER_HURL%>ctl=system_msg"><strong><%=myMsgs%></strong><span><%=UC.lang(121)%></span></a></dd>
          </dl>
        </div>
        <!--近期交易记录{-->
        <div class="consume-latest"></div>
        <!--}-->
        <!--api{-->
        <%=APIOS.ucenterPCIndexDestop()%>
        <!--}-->
      </div>
    </div>
    <script type="text/javascript">
	$(document).ready(function(){
		$("#uc_avatar").hover(function(){$(this).find(".upload").show();},function(){$(this).find(".upload").hide();});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
end class
%>

