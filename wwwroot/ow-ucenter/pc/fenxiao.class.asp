<%
dim UC_FENXIAO
class UC_FENXIAO_CLASS
	
	private oRs,sSQL,sString
	private myRecommendUid
	
	private sub class_initialize()
		myRecommendUid = OW.int(OW.DB.getFieldValueBySQL("SELECT recommend_uid FROM "& DB_PRE &"member WHERE uid="& UID &""))
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
		sb.append "<li class="""& OW.iif(SUBCTL="recommender","recommender current","recommender") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=recommender""><i></i>"& UC.lang(1301) &"</a></li>"
		sb.append "<li class="""& OW.iif(SUBCTL="mylink","mylink current","mylink") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=mylink""><i></i>"& UC.lang(1302) &"</a></li>"
		sb.append "<li class="""& OW.iif(SUBCTL="commission","commission current","commission") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=commission""><i></i>"& UC.lang(1303) &"</a></li>"
		sb.append "<li class="""& OW.iif(SUBCTL="drawcash","drawcash current","drawcash") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=drawcash&act=list""><i></i>"& UC.lang(1304) &"</a></li>"
		sb.append "<li class="""& OW.iif(SUBCTL="goods","goods current","goods") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=goods&act=list""><i></i>"& UC.lang(1305) &"</a></li>"
		sb.append "<li class="""& OW.iif(SUBCTL="talent","talent current","talent") &"""><a href="""& UCENTER_HURL &"ctl=fenxiao&subctl=talent&act=list""><i></i>"& UC.lang(1306) &"</a></li>"
		sb.append "</ul>"
        str = sb.toString() : set sb = nothing
		pageNavHtml = str
	end function
	
	private function main()
	call UC.echoHeader()
	%>
    <%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1300)%></h1>
      </div>
    </div>
    <%=UC.htmlFooter()%>
    <%
	call UC.echoFooter()
	end function
	
	private function applyTipHtml()
	call UC.echoHeader()
	dim heroUrl,heroHtml
	if OW.int(OW.config("is_commission_can_apply"))=1 then
		heroUrl = UCENTER_HURL &"ctl=fenxiao&subctl=apply"
		if OW.isNotNul(OW.config("commission_apply_hero")) then
			heroHtml = "<div class=""ow-commission-apply-hero""><a href="""& heroUrl &"""><img src="""& OW.config("commission_apply_hero") &""" /></a></div>"
		end if
		heroHtml = heroHtml &"<div class=""ow-commission-apply-btn-area""><a class=""btn btn-primary"" href="""& heroUrl &""">"& UC.lang(1376) &"</a></div>"
	else
		heroHtml = "<div class=""ow-commission-cannot-apply-tip"">"& UC.lang(1377) &"</div>"
	end if
	%>
    <%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1300)%></h1>
          <div class="section-fenxiao" id="fenxiao">
              <%=heroHtml%>
          </div>
      </div>
    </div>
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(10)%></h1>
          <div class="section-fenxiao" id="fenxiao">
              <div class="ow-pagenav"><%=pageNavHtml()%></div>
              <div class="ow-my-recommender">
                  <%=myRecommendHtml%>
              </div>
              <div class="section-recommenders">
                  <div class="section-header"><%=UC.lang(1313)%></div>
                  <ul class="ow-userlist">
				  <%
				  OW.Pager.sql      = "SELECT username,nickname,avatar,reg_time FROM "& DB_PRE &"member WHERE recommend_uid="& UID &" ORDER BY uid DESC"
				  OW.Pager.pageSize = 20
				  OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
				  OW.Pager.loopHtml = "<li><div class=""avatar""><img name=""avatar"" src=""{$avatar}"" /></div><div class=""info""><div class=""username"" username=""{$username}"" nickname=""{$nickname}"">{$nickname}</div><div class=""regtime"">"& UC.lang(1318) &"{$reg_time}</div></div></li>"
				  OW.Pager.run()
				  %>
                  <%=OW.Pager.loopHtmls%>
                  </ul>
              </div>
              <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
          </div>
      </div>
    </div>
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1314)%></h1>
          <form class="form-horizontal" name="reg-form">
              <div class="control-group">
                  <label class="control-label"><%=OS.lang(118)%></label>
                  <div class="controls"><input type="text" class="text" name="recommend_user" placeholder="<%=OS.lang(119)%>" /><span class="t-normal ml5"><%=OS.lang(120)%></span></div>
              </div>
              <div class="control-group">
                  <div class="controls controls-btn">
                      <button type="button" class="btn btn-primary" id="submit"><%=UC.lang(155)%></button>
                  </div>
              </div>
          </form>
      </div>
    </div>
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
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(10)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="ow-pagenav"><%=pageNavHtml()%></div>
                <div class="ow-count-header">
                    <span class="text-grid"><h4><%=UC.lang(1321)%></h4><p style="color:#333;"><%=OW.parsePrice(V("commission_count"))%><%=UC.lang(115)%></p></span>
                    <span class="text-grid text-grid-2"><h4><%=UC.lang(1322)%></h4><p><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></p></span>
                    <span class="text-do-grid">
                        <a class="btn btn-primary" href="javascript:;" id="drawcash"><%=UC.lang(1323)%></a>
                    </span>
                </div>
                <div class="section">
                    <%
                    OW.Pager.sql      = "SELECT logid,logtime,goods_name,goods_price,goods_amount,goods_sum,commission_money,commission_status,commission_charge_time FROM "& DB_PRE &"member_commission_log a WHERE commission_uid="& UID &" ORDER BY logid DESC"
                    OW.Pager.pageSize = 20
                    OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                    OW.Pager.loopHtml = "<tr><td field=""logtime"" value=""{$logtime}"">{$logtime}</td><td field=""goods_name"">{$goods_name}</td><td field=""goods_amount"">{$goods_amount}</td><td field=""commission_money"" value=""{$commission_money}"">{$commission_money}</td><td field=""commission_status"" value=""{$commission_status}"" commission_charge_time=""{$commission_charge_time}"">{$commission_status}</td></tr>"
                    OW.Pager.run()
                    %>
                    <table border="0" cellpadding="0" cellspacing="0" class="table table-striped table-bordered table-hover">
                    <thead><tr><th><%=UC.lang(1324)%></th><th><%=UC.lang(1325)%></th><th><%=UC.lang(1326)%></th><th><%=UC.lang(1327)%></th><th><%=UC.lang(1328)%></th></tr></thead>
                    <tbody><%=OW.Pager.loopHtmls%></tbody>
                    </table>
                </div>
                <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		$("#fenxiao td[field='commission_status']").each(function(){
			var status = parseInt($(this).attr("value")),
			chargeTime = $(this).attr("commission_charge_time"),
			text = "";
			if(status==0){
				text = '<font><%=UC.lang(1332)%></font><font class="subtext"><%=UC.lang(1333)%>'+OW.formatDateTime(chargeTime,0)+'</font>';
			}else if(status==1){
				text = '<font><%=UC.lang(1331)%><font>';
			};
			$(this).html(text);
		});
		$("#fenxiao td[field='logtime']").each(function(){
			$(this).html(OW.formatDateTime($(this).attr("value"),0));
		});
		$("#fenxiao td[field='commission_money']").each(function(){
			$(this).html(OW.parsePrice($(this).attr("value"))+'<%=UC.lang(115)%>');
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1336)%></h1>
          <% if SUBACT<>"view" then%>
          <div class="flow"><ul><li class="current"><%=UC.lang(1337)%></li><li class="last"><%=UC.lang(1338)%></li></ul></div>
          <% end if %>
		  <div class="section-refund-apply">
              <form name="save_form" id="save_form" action="javascript:;" method="post">
              <div class="tablegrid">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formtable">
                  <tr><td class="titletd"><%=UC.lang(1339)%></td>
                      <td class="infotd">
                      <b style="color:#c60000; font-size:20px; font-weight:normal;"><%=OW.parsePrice(V("commission_valid"))%><%=UC.lang(115)%></b>
                      <input type="hidden" class="text" name="drawcash_money" value="<%=V("commission_valid")%>" />
                      </td></tr>
                  <tr><td class="titletd top"><%=UC.lang(1340)%></td>
                      <td class="infotd"><select name="bank_type"><%=OS.createOptions(array("0:"& UC.lang("bank_type_0") &"","1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></td>
                  </tr>
                  <tr name="bank_name"><td class="titletd top"><%=UC.lang(1341)%></td>
                      <td class="infotd"><input type="text" class="text" name="bank_name" value="<%=V("bank_name")%>" /><span name="t_bank_name" class="t-normal ml5"></span></td>
                  </tr>
                  <tr name="bank_account_name"><td class="titletd top"><span name="bank_account_name_title"><%=UC.lang(1343)%></span></td>
                      <td class="infotd"><input type="text" class="text" name="bank_account_name" maxlength="100" value="<%=V("bank_account_name")%>" /><span name="t_bank_account_name" class="t-normal ml5"><%=UC.lang(1344)%></span></td>
                  </tr>
                  <tr name="bank_account"><td class="titletd top"><span name="bank_account_title"><%=UC.lang(1345)%></span></td>
                      <td class="infotd"><input type="text" class="text" name="bank_account" maxlength="100" value="<%=V("bank_account")%>" /><span name="t_bank_account" class="t-normal ml5"><%=UC.lang(1346)%></span></td>
                  </tr>
                  </table>
              </div>
              <div class="form-actions">
                  <button type="submit" class="btn btn-primary" name="submit"><%=UC.lang(160)%></button>
              </div>
              </form>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		$("select[name='bank_type']").change(function(){
			var bankType = $(this).val();
			if(bankType==0){
				bankAccountName    = "";
				bankAccountNameTip = '';
				bankAccount        = "";
				bankAccountTip     = '';
				$("tr[name='bank_name']").hide();
				$("tr[name='bank_account_name']").hide();
				$("tr[name='bank_account']").hide();
			}else if(bankType==1){
				bankAccountName    = "<%=UC.lang(1343)%>";
				bankAccountNameTip = '<%=UC.lang(1344)%>';
				bankAccount        = "<%=UC.lang(1345)%>";
				bankAccountTip     = '<%=UC.lang(1346)%>';
				$("tr[name='bank_name']").show();
				$("tr[name='bank_account_name']").show();
				$("tr[name='bank_account']").show();
			}else if(bankType==2){
				bankAccountName    = "<%=UC.lang(1347)%>";
				bankAccountNameTip = '<%=UC.lang(1348)%>';
				bankAccount        = "<%=UC.lang(1349)%>";
				bankAccountTip     = '<%=UC.lang(1350)%>';
				$("tr[name='bank_name']").hide();
				$("tr[name='bank_account_name']").show();
				$("tr[name='bank_account']").show();
			}else if(bankType==3){
				bankAccountName    = "<%=UC.lang(1351)%>";
				bankAccountNameTip = '<%=UC.lang(1352)%>';
				bankAccount        = "<%=UC.lang(1353)%>";
				bankAccountTip     = '<%=UC.lang(1354)%>';
				$("tr[name='bank_name']").hide();
				$("tr[name='bank_account_name']").show();
				$("tr[name='bank_account']").show();
			};
			$("input[name='bank_account_name']").attr("errmsg",bankAccountNameTip);
			$("input[name='bank_account']").attr("errmsg",bankAccountTip);
			$("span[name='bank_account_name_title']").html(bankAccountName);
			$("span[name='bank_account_title']").html(bankAccount);
			$("span[name='t_bank_account_name']").html(bankAccountNameTip);
			$("span[name='t_bank_account']").html(bankAccountTip);
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
				if(OW.isNull(bankName)){if(check){OWDialog().alert('<%=UC.lang(1355)%>').position().timeout(2); $("input[name='bank_name']").focus(); check=false;};};
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1356)%>').position().timeout(2); $("input[name='bank_account_name']").focus(); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1357)%>').position().timeout(2); $("input[name='bank_account']").focus(); check=false;};};
			}else if(bankType==2){
				if(OW.isNull(bankAccountName)){if(check){OWDialog().alert('<%=UC.lang(1358)%>').position().timeout(2); $("input[name='bank_account_name']").focus(); check=false;};};
				if(OW.isNull(bankAccount)){if(check){OWDialog().alert('<%=UC.lang(1359)%>').position().timeout(2); $("input[name='bank_account']").focus(); check=false;};};
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(10)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="ow-pagenav"><%=pageNavHtml()%></div>
                <div class="section">
                    <%
					 OW.Pager.sql      = "SELECT logid,date_apply,drawcash_money,bank_type,bank_name,bank_account,bank_account_name,approved,status FROM "& DB_PRE &"member_commission_drawcash a WHERE uid="& UID &" ORDER BY logid DESC"
                    OW.Pager.pageSize = 20
                    OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                    OW.Pager.loopHtml = "<tr approved=""{$approved}""><td field=""date_apply"" value=""{$date_apply}"">{$date_apply}</td><td field=""drawcash_money""><span name=""drawcash_money"" value=""{$drawcash_money}"">{$drawcash_money}</span>"& UC.lang(115) &"</td><td field=""bank""><span name=""bank_type"" value=""{$bank_type}"">{$bank_type}</span><span class=""ml5"" name=""bank_name"">{$bank_name}</span><span class=""ml5"" name=""bank_account_name"">{$bank_account_name}</span><span class=""ml5"" name=""bank_account"">{$bank_account}</span></td><td field=""status"" value=""{$status}"">{$status}</td></tr>"
                    OW.Pager.run()
                    %>
                    <table border="0" cellpadding="0" cellspacing="0" class="table table-striped table-bordered table-hover">
                    <thead><tr><th><%=UC.lang(1366)%></th><th><%=UC.lang(1367)%></th><th><%=UC.lang(1368)%></th><th><%=UC.lang(1369)%></th></tr></thead>
                    <tbody><%=OW.Pager.loopHtmls%></tbody>
                    </table>
                </div>
                <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		$("td[field='date_apply']").each(function(){
			$(this).html(OW.formatDateTime($(this).attr("value"),0));
		});
		$("span[name='drawcash_money']").each(function(){
			$(this).html(OW.parsePrice($(this).attr("value")));
		});
		$("td span[name='bank_type']").each(function(){
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
		$("td[field='status']").each(function(){
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <script type="text/javascript" src="js/qrcode.js"></script>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(10)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="ow-pagenav"><%=pageNavHtml()%></div>
                <div class="section-mytlink">
                    <dl class="ow-mytlink">
                        <dt><%=UC.lang(1320)%></dt>
                        <dd><input type="text" readonly="readonly" value="<%=myrlink%>" /></dd>
                    </dl>
                    <dl class="ow-mytlink-qrcode">
                        <dt><%=UC.lang(1319)%></dt>
                        <dd><div class="qrcode" id="qrcode"></div></dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		var $qrcode = new QRCode(document.getElementById("qrcode"),{width:200,height:200});
		$qrcode.makeCode("<%=myrlink%>");
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function goodsListHtml()
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(10)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="ow-pagenav"><%=pageNavHtml()%></div>
                <div class="section">
					<ul class="ow-goods-horizlist">
					<%
                    OW.Pager.sql      = "SELECT gid,rootpath,urlpath,title,subtitle,price,thumbnail,commission_rate,commission_type FROM "& DB_PRE &"goods a WHERE status=0 AND commission_rate>0 ORDER BY sales DESC,price DESC"
                    OW.Pager.pageSize = 10
                    OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                    OW.Pager.pageTpl  = ""
					OW.Pager.loopHtml = "<li><div class=""thumb""><a href="""& SITE_HURL &"{$rootpath}/{$urlpath}"& SITE_HTML_FILE_SUFFIX &"""><img src=""{$thumbnail}"" alt=""{$title}"" /></a></div><div class=""info""><h3 class=""title"">{$title}</h3><div class=""subtitle"">{$subtitle}</div><div class=""price""><span class=""money"" name=""price"" price=""{$price}"">{$price}</span><span class=""commission"" name=""commission"" commission_type=""{$commission_type}"" commission_rate=""{$commission_rate}"" price=""{$price}""></span></div></div></li>"
                    OW.Pager.run()
                    %>
                    <%=OW.Pager.loopHtmls%>
                    </ul>
                </div>
                <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
            </div>
        </div>
    </div>
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
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(10)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="ow-pagenav"><%=pageNavHtml()%></div>
                <div class="section">
                    <ul class="ow-userlist-horizlist">
					<%
                    OW.Pager.sql      = "SELECT top 20 username,nickname,avatar,commission_count FROM "& DB_PRE &"member a WHERE status=0 AND commission_count>0 ORDER BY commission_count DESC,commission_valid DESC"
					OW.Pager.pageSize = 20
                    OW.Pager.pageUrl  = "index.asp?ctl="& CTL &"&subctl="& SUBCTL &"&page={$page}"
                    OW.Pager.pageTpl  = ""
					OW.Pager.loopHtml = "<li><div class=""orderi""><i name=""i""></i></div><div class=""avatar""><img name=""avatar"" src=""{$avatar}"" /></div><div class=""info""><div class=""title""><span class=""username"" name=""username"" username=""{$username}"" nickname=""{$nickname}"">{$nickname}</span></div><div class=""subtitle""><span class=""commission"" name=""commission"" commission_count=""{$commission_count}""></span></div></div></li>"
                    OW.Pager.run()
                    %>
                    <%=OW.Pager.loopHtmls%>
                    </ul>
                </div>
                <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
            </div>
        </div>
    </div>
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

