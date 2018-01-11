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
	dim myDeposit,myPoint,myCoupons,myOrdersCount,myMsgs,myMGroupName,mySMGroupName,myMGroupColor,mySMGroupColor,lastLoginTime
	call UC.echoHeader()
	myDeposit     = OS.getMemberDeposit(UID)(0)
	myPoint       = OS.getMemberPoint(UID)(0)
	if OS.versionType="x" then
	myCoupons     = OS.getMemberValidCoupon(UID)
	myOrdersCount = OW.DB.getFieldValueBySQL("SELECT count(*) FROM "& DB_PRE &"orders WHERE uid="& UID &" AND "& OW.DB.auxSQL &"")
	end if
	myMsgs        = OS.getMemberUnReadMsg(UID)
	myMGroupName  = OS.getGroupName(GROUP_ID)
	mySMGroupName = OS.getGroupName(SPECIAL_GROUP_ID)
	myMGroupColor = OW.DB.getFieldValueBySQL("SELECT group_color FROM "& DB_PRE &"member_group WHERE group_id="& GROUP_ID &"")
	mySMGroupColor= OW.DB.getFieldValueBySQL("SELECT group_color FROM "& DB_PRE &"member_group WHERE group_id="& SPECIAL_GROUP_ID &"")
	lastLoginTime = OW.DB.getFieldValueBySQL("SELECT last_login_time FROM "& DB_PRE &"member WHERE uid="& UID &"")
%>
	<%=UC.htmlHeaderMobile("<a href="""& SITE_URL &""" class=""home""></a>",UC.lang(100))%>
    <section id="mbody">
    <div class="om-ucenter">
        <div class="ow-myheader">
            <div class="ow-myheader-in">
                <div class="avatar"><a href="<%=UCENTER_HURL%>ctl=setting&act=avatar"><img class="avatar" src="<%=AVATAR%>" /></a></div>
                <div class="member-name"><span class="username"><%=USERNAME%></span><%=OW.iif(OW.rs(USERNAME)=OW.rs(NICKNAME),"","<span class=""nickname"">"& NICKNAME &"</span>")%></div>
                <div class="member-group"><span class="mgroup"><%=myMGroupName%></span><%=OW.iif(OW.isNul(mySMGroupName),"","<span class=""sgroup"">"& mySMGroupName &"</span>")%></div>
            </div>
        </div>
        <div class="menulist">
            <%=APIOS.ucenterMobIndexDestop()%>
			<%=APIOS.ucenterMobAuxMenu()%>
            <ul>
                <% if OS.versionType="x" then %>
                <li><a href="<%=UCENTER_HURL%>ctl=orders"><i class="icon-orders"></i><b><%=UC.lang(6)%></b><span><%=myOrdersCount%> <%=UC.lang(123)%></span></a></li>
                <li><a href="<%=UCENTER_HURL%>ctl=finance"><i class="icon-finance"></i><b><%=UC.lang(2)%></b><span><%=myDeposit%> <%=UC.lang(115)%></span></a></li>
                <% end if %>
                <li><a href="<%=UCENTER_HURL%>ctl=point"><i class="icon-point"></i><b><%=UC.lang(3)%></b><span><%=myPoint%> <%=OS.lang(200)%></span></a></li>
                <% if OS.versionType="x" then %>
                <li><a href="<%=UCENTER_HURL%>ctl=coupon"><i class="icon-coupon"></i><b><%=UC.lang(7)%></b><span><%=myCoupons%> <%=UC.lang(119)%></span></a></li>
                <% if OW.config("is_fenxiao_open")=1 then %>
                <li><a href="<%=UCENTER_HURL%>ctl=fenxiao"><i class="icon-fenxiao"></i><b><%=UC.lang(10)%></b></a></li>
                <% end if %>
                <li><a href="<%=UCENTER_HURL%>ctl=favorite"><i class="icon-favorite"></i><b><%=UC.lang(8)%></b></a></li>
                <li><a href="<%=UCENTER_HURL%>ctl=order_form_data"><i class="icon-order-form-data"></i><b><%=UC.lang(9)%></b></a></li>
                <% end if %>
            </ul>
            <ul>
                <li><a href="<%=UCENTER_HURL%>ctl=system_msg"><i class="icon-system-msg"></i><b><%=UC.lang(5)%></b><span><%=myMsgs%> <%=UC.lang(121)%></span></a></li>
                <li><a href="<%=UCENTER_HURL%>ctl=setting"><i class="icon-setting"></i><b><%=UC.lang(4)%></b></a></li>
                <li><a href="<%=UCENTER_HURL%>ctl=password"><i class="icon-password"></i><b><%=UC.lang(11)%></b></a></li>
            </ul>
            <ul>
                <li><a href="<%=OW.urlRewrite("l2")%>"><i class="icon-logout"></i><b><%=UC.lang(12)%></b></a></li>
            </ul>
        </div>
    </div>
    </section>
    <script type="text/javascript">
	$(document).ready(function(){
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
end class
%>

