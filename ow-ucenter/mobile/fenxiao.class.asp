<%
dim UC_FENXIAO
class UC_FENXIAO_CLASS
	
	private oRs,sSQL,sString
	private myMGroupName,mySMGroupName,myRecommendUid
	
	private sub class_initialize()
		myMGroupName  = OS.getGroupName(GROUP_ID)
		mySMGroupName = OS.getGroupName(SPECIAL_GROUP_ID)
		myRecommendUid= OW.int(OW.DB.getFieldValueBySQL("SELECT recommend_uid FROM "& DB_PRE &"member WHERE uid="& UID &""))
	end sub
	
	public sub init()
		call OS.commissionProcessInit("my",UID)
		if OS.isValidCommissionMemberGroup() then
			select case SUBCTL
			case "recommender"
				if ACT="edit" then
					if myRecommendUid=0 then
						if SAVE then
							call recommenderEditSave()
						else
							call recommenderEditHtml()
						end if
					end if
				else
					call recommenderHtml()
				end if
			case "commission"
				call commissionHtml()
			case "drawcash"
				if ACT="apply" then
					if SAVE then
						call drawcashApplySave()
					else
						call drawcashApply()
					end if
				else
					call drawcashListHtml()
				end if
			case "mylink"
				call mylinkHtml()
			case "goods"
				call goodsListHtml()
			case "talent"
				call talentListHtml()
			case else
				call main()
			end select
		else
			select case SUBCTL
			case "apply"
				if SAVE then
					call applySave()
				else
					call applyHtml()
				end if
			case else
				call applyTipHtml()
			end select
		end if
	end sub
	
	private sub class_terminate()
	end sub
	
	private function getMyCommission()
		set oRs = OW.DB.getRecordBySQL("SELECT commission_count,commission_valid FROM "& DB_PRE &"member WHERE uid="& UID &"")
		if not oRs.eof then
			V("commission_count") = oRs("commission_count")
			V("commission_valid") = oRs("commission_valid")
		end if
		OW.DB.closeRs oRs
		V("commission_count") = OW.parseMoney(V("commission_count"))
		V("commission_valid") = OW.parseMoney(V("commission_valid"))
	end function
	
	private function pageNavHtml()
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<ul>"
		sb.append "<li class=""recommender li1""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=recommender""><i></i><span>"& UC.lang(1301) &"</span></a></li>"
		sb.append "<li class=""commission li2""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=commission""><i></i><span>"& UC.lang(1303) &"</span></a></li>"
		sb.append "<li class=""drawcash li3""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=drawcash&act=list""><i></i><span>"& UC.lang(1304) &"</span></a></li>"
		sb.append "<li class=""myrlink li4""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=mylink""><i></i><span>"& UC.lang(1302) &"</span></a></li>"
		sb.append "<li class=""goods li5""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=goods&act=list""><i></i><span>"& UC.lang(1305) &"</span></a></li>"
		sb.append "<li class=""talent li6""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=talent&act=list""><i></i><span>"& UC.lang(1306) &"</span></a></li>"
		sb.append "</ul>"
        str = sb.toString() : set sb = nothing
		pageNavHtml = str
	end function
	
	private function applyTipHtml()
	call UC.echoHeader()
	dim heroUrl,heroHtml
	if OW.int(OW.config("is_commission_can_apply"))=1 then
		heroUrl = UCENTER_HURL &"ctl=fenxiao&subctl=apply"
		if OW.isNotNul(OW.config("commission_apply_hero")) then
			heroHtml = "<div class=""ow-commission-apply-hero""><a href="""& heroUrl &"""><img src="""& OW.config("commission_apply_hero") &""" /></a></div>"
		end if
		heroHtml = heroHtml &"<div class=""ow-commission-apply-btn-area""><a class=""owui-btn owui-btn-primary"" href="""& heroUrl &""">"& UC.lang(1376) &"</a></div>"
	else
		heroHtml = "<div class=""ow-commission-cannot-apply-tip"">"& UC.lang(1377) &"</div>"
	end if
	%>
    <%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1300))%>
    <section id="mbody">
        <div class="ow-myheader">
            <div class="ow-myheader-in">
                <div class="avatar"><a href="<%=UCENTER_URL%>"><img class="avatar" src="<%=AVATAR%>" /></a></div>
                <div class="member-name"><span class="username"><%=USERNAME%></span><%=OW.iif(OW.rs(USERNAME)=OW.rs(NICKNAME),"","<span class=""nickname"">"& NICKNAME &"</span>")%></div>
                <div class="member-group"><span class="mgroup"><%=myMGroupName%></span><%=OW.iif(OW.isNul(mySMGroupName),"","<span class=""sgroup"">"& mySMGroupName &"</span>")%></div>
            </div>
        </div>
        <%=heroHtml%>
    </section>
    <%=UC.htmlFooter()%>
    <%
	call UC.echoFooter()
	end function
	
	private function main()
	call UC.echoHeader()
	call getMyCommission()
	%>
    <%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1300))%>
    <section id="mbody">
        <div class="ow-myheader">
            <div class="ow-myheader-in">
                <div class="avatar"><a href="<%=UCENTER_HURL%>ctl=fenxiao"><img class="avatar" src="<%=AVATAR%>" /></a></div>
                <div class="member-name"><span class="username"><%=USERNAME%></span><%=OW.iif(OW.rs(USERNAME)=OW.rs(NICKNAME),"","<span class=""nickname"">"& NICKNAME &"</span>")%></div>
                <div class="member-group"><span class="mgroup"><%=myMGroupName%></span><%=OW.iif(OW.isNul(mySMGroupName),"","<span class=""sgroup"">"& mySMGroupName &"</span>")%></div>
            </div>
        </div>
        <div class="ow-main-commission-grid">
            <span class="text-grid"><h4><%=UC.lang(1322)%></h4><p><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></p></span>
            <span class="text-do-grid"><%=UC.lang(1375)%><a href="<%=UCENTER_HURL%>ctl=fenxiao&subctl=commission"><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></a><span class="arrow">></span></span>
        </div>
        <div class="ow-pagenav"><%=pageNavHtml()%></div>
    </section>
    <%=UC.htmlFooter()%>
    <%
	call UC.echoFooter()
	end function
	
	private function recommenderHtml()
	call UC.echoHeader()
	dim dataArr,myRecommendUsername,myRecommendNickname,myRecommendAvatar,myRecommendHtml
	myRecommendHtml = UC.lang(1311)
	if myRecommendUid>0 then
		dataArr             = OW.DB.getFieldValueBySQL("SELECT username,nickname,avatar FROM "& DB_PRE &"member WHERE uid="& myRecommendUid &"")
		myRecommendUsername = dataArr(0)
		myRecommendNickname = dataArr(1)
		myRecommendAvatar   = dataArr(2)
		myRecommendAvatar   = OW.iif(OW.isNotNul(myRecommendAvatar),myRecommendAvatar,SITE_PATH &"ow-content/images/avatar.jpg")
		myRecommendHtml     = myRecommendHtml &"<img src="""& myRecommendAvatar &"""><span class=""username"">"& OW.iif(OW.isNotNul(myRecommendNickname),myRecommendNickname,myRecommendUsername) &"</span>"
	else
		myRecommendHtml     = myRecommendHtml &"<span class=""none"">"& UC.lang(1312) &"</span><a class=""edit"" href="""& UCENTER_HURL &"ctl=fenxiao&subctl=recommender&act=edit""><i class=""icon""></i>"& UC.lang(154) &"</a>"
	end if
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_HURL &"ctl=fenxiao"" class=""goback""></a>",UC.lang(10))%>
    <section id="mbody">
      <div id="fenxiao">
          <div class="ow-my-recommender">
              <%=myRecommendHtml%>
          </div>
          <div class="ow-recommenders">
              <div class="header"><%=UC.lang(1313)%></div>
              <ul class="ow-userlist">
              <%
              OW.Pager.sql      = "SELECT username,nickname,avatar,reg_time FROM "& DB_PRE &"member WHERE recommend_uid="& UID &" ORDER BY uid DESC"
              OW.Pager.pageSize = 20
              OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
              OW.Pager.pageTpl  = "{prev}{current}{next}"
              OW.Pager.loopHtml = "<li><div class=""avatar""><img name=""avatar"" src=""{$avatar}"" /></div><div class=""info""><div class=""username"" username=""{$username}"" nickname=""{$nickname}"">{$nickname}</div><div class=""regtime"">"& UC.lang(1318) &"{$reg_time}</div></div></li>"
              OW.Pager.run()
              %>
              <%=OW.Pager.loopHtmls%>
              </ul>
          </div>
          <div class="ow-pager-section"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
      </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		var $avatar = $("img[name='avatar']"),
		$nickname   = $("div[name='nickname']");
		$avatar.each(function(){
			if($(this).attr("src")==""){
				$(this).attr("src","<%=SITE_PATH%>ow-content/images/avatar.jpg");
			};
		});
		$nickname.each(function(){
			var username = $(this).attr("username");
			if(OW.isNull(nickname)){
				$(this).html(username);
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function recommenderEditHtml()
	call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1314))%>
    <section id="mbody">
        <div class="owui-form">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
            <div class="owui-cells">
                <div class="owui-cell">
                    <div class="owui-cell-hd"><label class="owui-label"><%=OS.lang(118)%></label></div>
                    <div class="owui-cell-bd">
                        <input type="text" class="owui-input" name="recommend_user" placeholder="<%=OS.lang(119)%>" value="" />
                    </div>
                </div>
            </div>
            <div class="owui-btn-area">
                <a class="owui-btn owui-btn-primary" href="javascript:" id="submit"><%=UC.lang(155)%></a>
            </div>
            </form>
        </div>
    </section>
    <script type="text/javascript">
    $(document).ready(function(){
		$("#submit").click(function(){
			OW.setDisabled($("button[name='btn_save']"),true);
			var errMsg,
			url       = OW.ucenterHurl+"ctl=<%=CTL%>&subctl=<%=SUBCTL%>&act=edit&save=true",
			valid     = true,
			$dialog   = OWDialog().posting().position(),
			$recommendUser = $("input[name='recommend_user']"),
			recommendUser  = $recommendUser.val();
			if(recommendUser=="" && valid){
				valid = false;
				$recommendUser.addClass("text-err").focus();
			}else{
				$recommendUser.removeClass("text-err");
			};
			if(valid){
				OW.ajax({
					me:"",url:url,data:"recommend_user="+escape(recommendUser),
					success:function(){
						$dialog.success("<%=UC.lang(156)%>").position();
						OW.setDisabled($("button[name='btn_save']"),false);
						OW.openPage(OW.ucenterHurl+"ctl=<%=CTL%>&subctl=<%=SUBCTL%>");
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(157)%>',msg).position().timeout(3);
						OW.setDisabled($("button[name='btn_save']"),false);
					}
				});
			}else{
				$dialog.close();
				OW.setDisabled($("button[name='btn_save']"),false);
			};
		});
	});
    </script>
    <%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function recommenderEditSave()
		dim dbResult,recommendUid,recommendUser,sqlCondition,valid : valid = true
		recommendUser = OW.validClientDBData(OW.getForm("post","recommend_user"),64)
		recommendUid  = 0
		if OW.isNul(recommendUser) then
			UC.errorSetting(UC.lang(1315))
			valid = false
		else
			if OW.isValidMobile(recommendUser) then
				sqlCondition = "mobile='"& recommendUser &"'"
			else
				if OW.isValidUid(recommendUser) then
					sqlCondition = "uid="& recommendUser &""
				else
					sqlCondition = "username='"& OW.parseUsername(recommendUser) &"'"
				end if
			end if
			recommendUid = OW.int(OW.DB.getFieldValueBySQL("SELECT top 1 uid FROM "& OW.DB.Table.member &" WHERE "& sqlCondition &""))
			if recommendUid=0 then
				call UC.errorSetting(UC.lang(1316))
				valid = false
			end if
			if UID=recommendUid then
				call UC.errorSetting(UC.lang(1317))
				valid = false
			end if
		end if
		if valid then
			OW.DB.auxSQLValid = false
			dbResult = OW.DB.updateRecord(DB_PRE &"member",array("recommend_uid:"& recommendUid),array("uid:"& UID))
			OW.DB.auxSQLValid = true
			UC.actionFinishSuccess     = dbResult
			UC.actionFinishSuccessText = array(UC.lang(158),"")
			UC.actionFinishFailText    = array(UC.lang(159),"")
			UC.actionFinishRun()
		end if
	end function
	
	private function commissionHtml()
	call UC.echoHeader()
	call getMyCommission()
	dim myRecommendUid,myRecommendUsername
	myRecommendUid     = OW.int(OW.DB.getFieldValueBySQL("SELECT recommend_uid FROM "& DB_PRE &"member WHERE uid="& UID &""))
	myRecommendUsername = OW.DB.getFieldValueBySQL("SELECT username FROM "& DB_PRE &"member WHERE uid="& myRecommendUid &"")
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_HURL &"ctl=fenxiao"" class=""goback""></a>",UC.lang(10))%>
    <section id="mbody">
        <div class="ow-commission-header">
            <span class="text-grid"><h4><%=UC.lang(1321)%></h4><p><%=OW.parsePrice(V("commission_count"))%><%=UC.lang(115)%></p></span>
            <span class="text-grid text-grid-2"><h4><%=UC.lang(1322)%></h4><p><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></p></span>
            <span class="text-do-grid"><a class="btn btn-primary" href="javascript:;" id="drawcash"><%=UC.lang(1323)%></a></span>
        </div>
        <div class="ow-commission-list">
            <div class="owui-panel">
                <div class="owui-panel-hd"><a class="fr" href="?ctl=fenxiao&subctl=drawcash&act=list"><%=UC.lang(1330)%></a><%=UC.lang(1329)%></div>
                <div class="owui-panel-bd">
                <%
                OW.Pager.sql      = "SELECT logid,logtime,goods_name,goods_price,goods_amount,goods_sum,commission_money,commission_status,commission_charge_time FROM "& DB_PRE &"member_commission_log a WHERE commission_uid="& UID &" ORDER BY logid DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<a href=""javascript:void(0);"" class=""owui-media-box owui-media-box-appmsg""><div class=""owui-media-box-hd""><div class=""owui-media-box-hd-datetime"" name=""datetime"" value=""{$logtime}"">{$logtime}</div></div><div class=""owui-media-box-bd""><h4 class=""owui-media-box-title"">+{$commission_money}"& UC.lang(115) &"<span class=""owui-media-box-subtitle"" name=""commission_status"" value=""{$commission_status}"" commission_charge_time=""{$commission_charge_time}"">{$commission_status}</span></h4><p class=""owui-media-box-desc"">{$goods_name}</p></div></a>"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
                </div>
            </div>
            <div class="ow-pager-section"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$("span[name='commission_status']").each(function(){
			var status = parseInt($(this).attr("value")),
			chargeTime = $(this).attr("commission_charge_time"),
			text = "";
			if(status==0){
				text = '<font><%=UC.lang(1332)%></font><font class="subtext"><%=UC.lang(1333)%>'+OW.formatDateTime(chargeTime,0)+'</font>';
			}else if(status==1){
				text = '<font><%=UC.lang(1331)%></font>';
			};
			$(this).html(text);
		});
		$("div[name='datetime']").each(function(){
			var time = $(this).attr("value");
			$(this).html('<span class="date">'+OW.formatDateTime(time,2)+'</span><span class="time">'+OW.formatDateTime(time,3)+'</span>');
		});
		var $drawcash   = $("#drawcash"),
		commissionValid = <%=OW.parseMoney(V("commission_valid"))%>;
		$drawcash.click(function(){
			if(commissionValid>0){
				OW.openPage("?ctl=fenxiao&subctl=drawcash&act=apply");
			}else{
				alert("<%=UC.lang(1334)%>");
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function drawcashApply()
		call getMyCommission()
		if OW.parseMoney(V("commission_valid"))>=OW.parseMoney(OW.config("drawcash_limit")) then
			call drawcashApplyHtml()
		else
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("drawcash_limit"))))
		end if
	end function
	
	private function drawcashApplyHtml()
		call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1336))%>
    <section id="mbody">
        <div class="om-drawcash">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
            <div class="owui-cells owui-cells-first">
                <div class="owui-cell">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1339)%></label></div>
                    <div class="owui-cell-bd"><b style="color:#c60000; font-size:18px; font-weight:normal;"><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></b><input type="hidden" class="owui-input owui-input-writeable" name="drawcash_money" placeholder="" value="<%=V("commission_valid")%>" /></div>
                </div>
                <div class="owui-cell owui-cell-select owui-cell-select-after">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1340)%></label></div>
                    <div class="owui-cell-bd"><select class="owui-select" name="bank_type"><%=OS.createOptions(array("0:"& UC.lang("bank_type_0") &"","1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></div>
                </div>
                <div class="owui-cell" name="bank_name_title">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1341)%></label></div>
                    <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_name" placeholder="" value="<%=V("bank_name")%>" /></div>
                </div>
                <div class="owui-cell"  name="bank_account_name_title">
                    <div class="owui-cell-hd"><label class="owui-label" name="bank_account_name_title"><%=UC.lang(1343)%></label></div>
                    <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_account_name" placeholder="" value="<%=V("bank_account_name")%>" /></div>
                </div>
                <div class="owui-cell" name="bank_account_title">
                    <div class="owui-cell-hd"><label class="owui-label" name="bank_account_title"><%=UC.lang(1345)%></label></div>
                    <div class="owui-cell-bd"><input type="text" class="owui-input" name="bank_account" placeholder="" value="<%=V("bank_account")%>" /></div>
                </div>
            </div>
            <div class="owui-btn-area">
                <button type="submit" class="owui-btn owui-btn-primary" name="submit"><%=UC.lang(160)%></button>
            </div>
            </form>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$("select[name='bank_type']").change(function(){
			var bankNameTip,bankAccountName,bankAccountNameTip,bankAccount,bankAccountTip,
			bankType = OW.int($(this).val());
			if(bankType==0){
				bankNameTip        = "";
				bankAccountName    = "";
				bankAccountNameTip = '';
				bankAccount        = "";
				bankAccountTip     = '';
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").hide();
				$("div[name='bank_account_title']").hide();
			}else if(bankType==1){
				bankNameTip        = "<%=UC.lang(1342)%>";
				bankAccountName    = "<%=UC.lang(1343)%>";
				bankAccountNameTip = '<%=UC.lang(1344)%>';
				bankAccount        = "<%=UC.lang(1345)%>";
				bankAccountTip     = '<%=UC.lang(1346)%>';
				$("div[name='bank_name_title']").show();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			}else if(bankType==2){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1347)%>";
				bankAccountNameTip = '<%=UC.lang(1348)%>';
				bankAccount        = "<%=UC.lang(1349)%>";
				bankAccountTip     = '<%=UC.lang(1350)%>';
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			}else if(bankType==3){
				bankNameTip        = "";
				bankAccountName    = "<%=UC.lang(1351)%>";
				bankAccountNameTip = '<%=UC.lang(1352)%>';
				bankAccount        = "<%=UC.lang(1353)%>";
				bankAccountTip     = '<%=UC.lang(1354)%>';
				$("div[name='bank_name_title']").hide();
				$("div[name='bank_account_name_title']").show();
				$("div[name='bank_account_title']").show();
			};
			$("input[name='bank_name']").attr("placeholder",bankNameTip);
			$("input[name='bank_account_name']").attr("placeholder",bankAccountNameTip);
			$("input[name='bank_account']").attr("placeholder",bankAccountTip);
			$("label[name='bank_account_name_title']").html(bankAccountName);
			$("label[name='bank_account_title']").html(bankAccount);
		});
		$("select[name='bank_type']").change();
		//提交
		var $saveForm = $("#save_form");
		$saveForm.submit(function(){
			OW.parseFormInputValue({form:$saveForm});
			var $validForm = OWValidForm({form:$(this)});
			var check       = true,
			bankType        = OW.int($("select[name='bank_type']").val()),
			bankName        = $("input[name='bank_name']").val(),
			bankAccountName = $("input[name='bank_account_name']").val(),
			bankAccount     = $("input[name='bank_account']").val();
			if(bankType==1){
				if(OW.isNull(bankName)){if(check){OWDialog().alert('<%=UC.lang(1355)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1356)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1357)%>').position().timeout(2); check=false;};};
			}else if(bankType==2){
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1358)%>').position().timeout(2); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1359)%>').position().timeout(2); check=false;};};
			};
			if(check){
				var $dialog = UC.dialogPosting();
				var url = "?ctl=<%=CTL%>&subctl=<%=SUBCTL%>&act=apply&save=true";
				$validForm.getFormData();
				OW.ajax({
					me:"",url:url,data:$validForm.formData,
					success:function(){
						var logid = 0;
						$dialog.success("<%=UC.lang(1360)%>").position();
						OW.delay(2000,function(){
							OW.redirect("?ctl=<%=CTL%>&subctl=drawcash");
						});
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(1361)%>',msg).position().timeout(3);
						OW.setDisabled($("button[name='submit']"),false);
					}
				});
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function drawcashApplySave()
		dim result
		call getMyCommission()
		V("drawcash_money")    = OW.parseMoney(OW.getForm("post","drawcash_money"))
		V("bank_type")         = OW.int(OW.getForm("post","bank_type"))
		V("bank_name")         = OW.validClientDBData(OW.getForm("post","bank_name"),50)
		V("bank_account_name") = OW.validClientDBData(OW.getForm("post","bank_account_name"),100)
		V("bank_account")      = OW.validClientDBData(OW.getForm("post","bank_account"),32)
		V("ip")                = OW.getClientIP()
		'****
		if OW.parseMoney(V("commission_valid"))<OW.parseMoney(OW.config("drawcash_limit")) then
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("drawcash_limit"))))
			exit function
		end if
		if OW.parseMoney(V("drawcash_money"))>OW.parseMoney(V("commission_valid")) then
			call UC.errorSetting(UC.lang(1362))
			exit function
		end if
		if OW.parseMoney(V("drawcash_money"))<OW.parseMoney(OW.config("drawcash_limit")) then
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("drawcash_limit"))))
			exit function
		end if
		if V("bank_type")=1 then
			if OW.isNul(V("bank_name")) then : call UC.errorSetting(UC.lang(1355)) : exit function : end if
			if OW.isNul(V("bank_account_name")) then : call UC.errorSetting(UC.lang(1356)) : exit function : end if
			if OW.isNul(V("bank_account")) then : call UC.errorSetting(UC.lang(1357)) : exit function : end if
		end if
		if V("bank_type")=2 then
			V("bank_name") = UC.lang("bank_type_2")
			if OW.isNul(V("bank_account_name")) then : call UC.errorSetting(UC.lang(1358)) : exit function : end if
			if OW.isNul(V("bank_account")) then : call UC.errorSetting(UC.lang(1359)) : exit function : end if
		end if
		result = OW.DB.addRecord(DB_PRE &"member_commission_drawcash",array("site_id:"& SITE_ID,"uid:"& UID,"status:0","approved:0","drawcash_money:"& V("drawcash_money"),"bank_type:"& V("bank_type"),"bank_name:"& V("bank_name"),"bank_account:"& V("bank_account"),"bank_account_name:"& V("bank_account_name"),"ip:"& V("ip"),"date_apply:"& SYS_TIME))
		if result then
			call OS.memberCommissionExpend(UID,V("drawcash_money"))
		end if
		'****
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(1364),"")
		UC.actionFinishFailText    = array(UC.lang(1365),"")
		UC.actionFinishRun()
	end function
	
	private function drawcashListHtml()
	call UC.echoHeader()
	call getMyCommission()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1330))%>
    <section id="mbody">
    <div class="ow-commission-list">
            <div class="owui-panel">
                <div class="owui-panel-bd">
                <%
                OW.Pager.sql      = "SELECT logid,date_apply,drawcash_money,bank_type,bank_name,bank_account,bank_account_name,approved,status FROM "& DB_PRE &"member_commission_drawcash a WHERE uid="& UID &" ORDER BY logid DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<a href=""javascript:void(0);"" class=""owui-media-box owui-media-box-appmsg""><div class=""owui-media-box-hd""><div class=""owui-media-box-hd-datetime"" name=""datetime"" value=""{$date_apply}"">{$date_apply}</div></div><div class=""owui-media-box-bd""><h4 class=""owui-media-box-title""><span name=""drawcash_money"" value=""{$drawcash_money}"">{$drawcash_money}</span>"& UC.lang(115) &"<span class=""owui-media-box-subtitle"" name=""status"" value=""{$status}"">{$status}</span></h4><p class=""owui-media-box-desc owui-media-box-desc-spans""><span name=""bank_type"" value=""{$bank_type}"">{$bank_type}</span><span name=""bank_name"">{$bank_name}</span><span name=""bank_account_name"">{$bank_account_name}</span><span name=""bank_account"">{$bank_account}</span></p></div></a>"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
                </div>
            </div>
            <div class="ow-pager-section"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$("div[name='datetime']").each(function(){
			var time = $(this).attr("value");
			$(this).html('<span class="date">'+OW.formatDateTime(time,2)+'</span><span class="time">'+OW.formatDateTime(time,3)+'</span>');
		});
		$("span[name='drawcash_money']").each(function(){
			$(this).html(OW.parsePrice($(this).attr("value")));
		});
		$("span[name='bank_type']").each(function(){
			var bankType     = OW.int($(this).attr("value")),
			$bankName        = $(this).parent().find("span[name='bank_name']"),
			$bankAccountName = $(this).parent().find("span[name='bank_account_name']"),
			$bankAccount     = $(this).parent().find("span[name='bank_account']");
			if(bankType==0){
				$(this).html('<%=UC.lang("bank_type_0")%>');
				$bankName.hide();
				$bankAccountName.hide();
				$bankAccount.hide();
			}else if(bankType==1){
				$(this).html('<%=UC.lang("bank_type_1")%>');
			}else if(bankType==2){
				$(this).html('<%=UC.lang("bank_type_2")%>');
				$bankName.hide();
			};
		});
		
		$("span[name='status']").each(function(){
			var status = OW.int($(this).attr("value"));
			if(status==0){
				$(this).html('<span class="status-text-default"><%=UC.lang(1370)%></span>');
			}else if(status==1){
				$(this).html('<span class="status-text-success"><%=UC.lang(1371)%></span>');
			}else if(status==-1){
				$(this).html('<span class="status-text-warning"><%=UC.lang(1372)%></span>');
			};
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function mylinkHtml()
	call UC.echoHeader()
	dim myrlink : myrlink = SITE_URL &"?rid="& UID
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_HURL &"ctl=fenxiao"" class=""goback""></a>",UC.lang(10))%>
    <script type="text/javascript" src="js/qrcode.js"></script>
    <section id="mbody">
        <div class="section-mytlink">
            <dl class="ow-mytlink-qrcode">
                <dt><%=UC.lang(1319)%></dt>
                <dd><div class="qrcode" id="qrcode"></div></dd>
            </dl>
            <dl class="ow-mytlink">
                <dt><%=UC.lang(1320)%></dt>
                <dd><input type="text" name="myrlink" readonly="readonly" value="<%=myrlink%>" /></dd>
            </dl>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		var $qrcode = new QRCode(document.getElementById("qrcode"),{width:200,height:200});
		$qrcode.makeCode("<%=myrlink%>");
		$("input[name='myrlink']").focus(function(){
			$(this).select();
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function goodsListHtml()
	call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1305))%>
    <section id="mbody">
        <div class="ow-commission-list">
            <div class="owui-panel">
                <%
                OW.Pager.sql      = "SELECT gid,rootpath,urlpath,title,price,thumbnail,commission_rate,commission_type FROM "& DB_PRE &"goods a WHERE status=0 AND commission_rate>0 ORDER BY sales DESC,price DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<a href="""& SITE_HURL &"{$rootpath}/{$urlpath}"& SITE_HTML_FILE_SUFFIX &""" class=""owui-media-box owui-media-box-appmsg""><div class=""owui-media-box-hd""><img class=""owui-media-box-thumb"" src=""{$thumbnail}""></div><div class=""owui-media-box-bd""><h4 class=""owui-media-box-title owui-media-box-stitle"">{$title}</h4><p class=""owui-media-box-desc owui-media-box-desc-default""><span class=""money"" name=""price"" price=""{$price}"">{$price}</span><span class=""owui-media-box-subtitle owui-media-box-sub-valid commission"" name=""commission"" commission_type=""{$commission_type}"" commission_rate=""{$commission_rate}"" price=""{$price}""></span></p></div></a>"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
            </div>
            <div class="ow-pager-section"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$("span[name='price']").each(function(){
			$(this).html('<em>￥</em><b>'+OW.parsePrice($(this).attr("price"))+'</b>');
		});
		$("span[name='commission']").each(function(){
			var type = OW.int($(this).attr("commission_type")),
			rate     = OW.parseMoney($(this).attr("commission_rate")),
			price    = OW.parseMoney($(this).attr("price")),
			money    = 0;
			if(type==0){
				money = rate;
			}else if(type==1){
				money = price*rate/100;
			};
			$(this).html('<%=UC.lang(1373)%><b>'+OW.parsePrice(money)+'</b><%=UC.lang(115)%>');
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function talentListHtml()
	call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1306))%>
    <section id="mbody">
        <div class="ow-commission-list">
            <div class="owui-panel">
                <ul class="ow-userlist-horizlist">
				<%
                OW.Pager.sql      = "SELECT top 20 username,nickname,avatar,commission_count FROM "& DB_PRE &"member a WHERE status=0 AND commission_count>0 ORDER BY commission_count DESC,commission_valid DESC"
                OW.Pager.pageSize = 20
                OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
               OW.Pager.pageTpl  = "{prev}{current}{next}"
                OW.Pager.loopHtml = "<li><div class=""orderi""><i name=""i""></i></div><div class=""avatar""><img name=""avatar"" src=""{$avatar}"" /></div><div class=""info""><div class=""title""><span class=""username"" name=""username"" username=""{$username}"" nickname=""{$nickname}"">{$nickname}</span></div><div class=""subtitle""><span class=""commission"" name=""commission"" commission_count=""{$commission_count}""></span></div></div></li>"
                OW.Pager.run()
                %>
                <%=OW.Pager.loopHtmls%>
                </ul>
            </div>
            <div class="ow-pager-section"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$(".ow-userlist-horizlist").find("i").each(function(i){
			$(this).html(i+1);
		});
		$("span[name='username']").each(function(){
			var nickname = $(this).attr("nickname");
			if(nickname==""){
				nickname = $(this).attr("username");
			};
			$(this).html(nickname);
		});
		$("img[name='avatar']").each(function(){
			if($(this).attr("src")==""){
				$(this).attr("src",OW.siteUrl+"ow-content/images/avatar.jpg");
			};
		});
		$("span[name='commission']").each(function(){
			var money = OW.parseMoney($(this).attr("commission_count"));
			$(this).html('<%=UC.lang(1374)%><b>'+OW.parsePrice(money)+'</b><%=UC.lang(115)%>');
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	

end class
%>

