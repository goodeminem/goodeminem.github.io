<%
dim UC_FINANCE
class UC_FINANCE_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		if SUBCTL="drawcash" then
			if ACT="apply" then
				if SAVE then
					call drawcashApplySave()
				else
					call drawcashApply()
				end if
			else
				call drawcashListHtml()
			end if
		else
			select case ACT
			case "charge"
				call charge()
			case else
				call main()
			end select
		end if
	end sub
	
	private sub class_terminate()
	end sub
	
	private function getMyDeposit()
		dim arr
		arr = OS.getMemberDeposit(UID)
		V("my_deposit_total")     = OW.parseMoney(arr(0))
		V("my_deposit_available") = OW.parseMoney(arr(1))
		V("my_deposit_freeze")    = OW.parseMoney(arr(2))
	end function
	
	private function payment()
		dim i,arr,payId,payCode,payName,payLogo,payConfig,payDesc,payStatus
		dim rs,sql
		dim sb,sbtr : set sb = OW.stringBuilder()
		dim ss,sstr : set ss = OW.stringBuilder()
		if OW.isMobile then
			sql = "is_mobile=1"
		else
			sql = "is_mobile=0"
		end if
		sb.append "<ul class=""ow-payment-tab"" id=""ow_payment_tab"">"
		ss.append "<div class=""ow-payment-container"" id=""ow_payment_container"">"
		set rs = OW.DB.getRecordBySQL("SELECT pay_id,pay_code,pay_name,pay_logo,pay_config,pay_desc FROM "& DB_PRE &"payment WHERE status=0 AND "& sql &" AND is_charge=1 AND "& OW.DB.auxSQL &" ORDER BY sequence")
		do while not rs.eof
			i = i+1
			payId     = OW.rs(rs("pay_id"))
			payCode   = OW.rs(rs("pay_code"))
			payName   = OW.rs(rs("pay_name"))
			payLogo   = OW.rs(rs("pay_logo"))
			payConfig = OW.rs(rs("pay_config"))
			payDesc   = OW.rs(rs("pay_desc"))
			sb.append "<li name=""payment"" payment="""& i &""">"
			sb.append "<a href=""javascript:;""><label><input type=""radio"" name=""payment"" pay_code="""& payCode &""" value="""& payId &"""/>"& payName &"</label></a>"
			sb.append "</li>"
			'****
			ss.append "<div is_payment=""true"" payment="""& i &""" pay_id="""& payId &""">"
			if OW.isNotNul(payLogo) then
			ss.append "<div class=""logo""><img src="""& payLogo &"""></div>"
			end if
			if payCode="alipay" then
				if OS.SHOP.getAliInterfaceType(payConfig)="bankpay" then
					ss.append OS.SHOP.getAliBankPayList()
				end if
			end if
			ss.append "<div class=""text"">"& OW.editorContentClientDecode(payDesc) &"</div>"
			ss.append "</div>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "</ul>"
		ss.append "</div>"
		sbtr = sb.toString() : set sb = nothing
		sstr = ss.toString() : set ss = nothing
		payment = sbtr & sstr
	end function
	
	private function charge()
	dim readonly,amount,inputAmount
	readonly = OW.int(OW.getForm("get","readonly"))
	amount   = OW.parseMoney(OW.getForm("get","amount"))
	amount   = OW.iif(amount>1,amount,1)
	inputAmount = OW.iif(amount>1,amount,"")
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(1413)%></h1>
            <div class="ow-charge" id="charge">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
            <table class="formtable" width="100%" cellspacing="0" cellpadding="0" border="0">
            <tbody>
            <tr>
                <td class="titletd"><%=UC.lang(1414)%></td>
                <td class="infotd">
                    <% if readonly=1 and amount>1 then%>
                    <input type="hidden" class="text text-amount" name="amount" value="<%=amount%>" />
                    <div class="charge-money"><span class="money"><em><%=OW.config("money_sb")%></em><b><%=amount%></b></span><span></span></div>
                    <% else %>
                    <input type="text" class="text text-amount" maxlength="10" name="amount" value="<%=inputAmount%>" datatype="*" errmsg="<%=UC.lang(1415)%>" onblur="OW.onblur(this,{rep:'/[^0-9.]*/g',length:10})" />
                    <% end if%>
                </td>
            </tr>
            <tr>
                <td class="titletd top"><%=UC.lang(1416)%></td>
                <td class="infotd">
                    <div class="ow-payment" id="ow_payment"><%=payment%></div>
                </td>
            </tr>
            <tr>
                <td class="titletd"></td>
                <td class="infotd"><button type="button" class="btn btn-primary" name="submit"><%=UC.lang(1417)%></button></td>
            </tr>
            </tbody>
            </table>
            </form>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		var $saveForm = $("#save_form"),
		$owPayment    = $("#ow_payment"),
		$btn          = $saveForm.find("button[name='submit']");
		OW.tabSwitch({tab:"payment",tabbar:$("#ow_payment_tab"),container:$("#ow_payment_container"),current:1});
		$owPayment.find("dd[name='pay_bank_list'] li").hover(
			function(){$(this).find(".bank-name").show();},
			function(){$(this).find(".bank-name").hide();}
		);
		OW.setDisabled($btn,false);
		$btn.click(function(){
			OW.setDisabled($btn,true);
			var amount,data,payId,payCode,bankCode='',
			$amount = $saveForm.find("input[name='amount']"),
			$input  = $owPayment.find("li.current").find("input[name='payment']"),
			amount  = OW.parseMoney($amount.val()),
			payId   = OW.int($input.val()),
			payCode = OW.parseBankCode($input.attr("pay_code")),
			$payment= $owPayment.find("div[is_payment='true'][pay_id='"+payId+"']"),
			$dialog = OWDialog().posting();
			if(!OW.objExist($input)){
				$dialog.error("<%=UC.lang(1418)%>").position().timeout(2);
				OW.setDisabled($btn,false);
				return false;
			};
			if(amount<1){
				$dialog.error("<%=UC.lang(1419)%>").position().timeout(2);
				OW.setDisabled($btn,false);
				return false;
			};
			if(payCode=="alipay" && OW.objExist($payment.find("dd[name='pay_bank_list']"))){
				bankCode = OW.parseBankCode($payment.find("input[name='alipay_bank']:checked").val());
				if(OW.isNull(bankCode)){
					$dialog.error("<%=UC.lang(1420)%>").position().timeout(2);
					OW.setDisabled($btn,false);
					return false;
				};
			};
			data = "amount="+amount+"&pay_id="+payId+"&bank_code="+bankCode+"";
			OW.ajax({
				url:OW.siteUrl +"ow-includes/ow.ajax.member.asp?ctl=member&act=deposit_charge",
				data:data,
				success:function(){
					var pay = OW.ajaxData.is_pay_online,
					logid   = OW.int(OW.ajaxData.logid);
					if(pay && logid>0){
						OW.redirect(OW.siteUrl+"ow-includes/ow.charge.asp?id="+logid);
					}else{
						OW.redirect(OW.siteUrl+"?ctl=finance");
					};
					$dialog.close();
				},
				failed:function(msg){
					$dialog.error('<%=UC.lang(161)%>',msg).position().timeout(4);
					OW.setDisabled($btn,false);
				}
			});
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function main()
	call UC.echoHeader()
	call getMyDeposit()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody"> 
      <div id="container">
          <h1 class="header"><%=UC.lang(1400)%></h1>
          <div class="section-fiance-point" id="deposit_log">
              <div class="ow-count-header">
                  <span class="text-grid total"><h4><%=UC.lang(114)%></h4><p style="color:#333;"><%=OW.parsePrice(V("my_deposit_total"))%><%=UC.lang(115)%></p></span>
                  <span class="text-grid text-grid-2 available"><h4><%=UC.lang(1401)%></h4><p><%=OW.parsePrice(V("my_deposit_available"))%><%=UC.lang(115)%></p></span>
                  <span class="text-grid text-grid-2 freeze" style="display:none;"><h4><%=UC.lang(1402)%></h4><p><%=OW.parsePrice(V("my_deposit_freeze"))%><%=UC.lang(115)%></p></span>
                  <span class="text-do-grid">
                      <a class="btn btn-primary" href="<%=UCENTER_HURL%>ctl=finance&act=charge"><%=UC.lang(116)%></a>
                      <% if OS.isCanFinanceDrawcash then %>
                      <a class="btn btn-default" href="javascript:;" id="drawcash"><%=UC.lang(1323)%></a>
                      <% end if %>
                  </span>
              </div>
              <div class="section">
                  <%
				  OW.Pager.sql      = "select logid,sn,trade_no,type,income,expend,remark,deposit,time from "& DB_PRE &"member_deposit_log where uid="& UID &" ORDER BY logid DESC"
				  OW.Pager.pageSize = 20
				  OW.Pager.pageUrl  = "index.asp?ctl=finance&page={$page}"
				  OW.Pager.loopHtml = "<tr><td field=""logid"">{$logid}</td><td field=""sn"">{$sn}</td><td field=""trade_no"">{$trade_no}</td><td field=""type"" value=""{$type}"">{$type}</td><td field=""income"" value=""{$income}"">{$income}</td><td field=""expend"" value=""{$expend}"">{$expend}</td><td field=""remark"">{$remark}</td><td field=""deposit"" class=""deposit"" value=""{$deposit}"">{$deposit}</td><td field=""time"">{$time}</td></tr>"
				  OW.Pager.run()
				  %>
                  <table border="0" cellpadding="0" cellspacing="0" class="table table-striped table-bordered table-hover">
                  <thead><tr><th><%=UC.lang(1404)%></th><th><%=UC.lang(1405)%></th><th><%=UC.lang(1406)%></th><th><%=UC.lang(1407)%></th><th><%=UC.lang(1408)%></th><th><%=UC.lang(1409)%></th><th><%=UC.lang(1410)%></th><th><%=UC.lang(1411)%></th><th><%=UC.lang(1412)%></th></tr></thead>
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
		$("#deposit_log td[field='type']").each(function(){
			var type = parseInt($(this).attr("value"));
			var text = "";
			if(type==1){
				text = '<font class="color-income"><%=UC.lang(1408)%><font>';
			}else if(type==2){
				text = '<font class="color-expend"><%=UC.lang(1409)%><font>';
			};
			$(this).html(text);
		});
		//**收入
		$("#deposit_log td[field='income']").each(function(){
			var income = parseFloat($(this).attr("value"));
			var text   = "";
			if(income>0){text = '<font class="color-income">'+income+'<font>';};
			$(this).html(text);
		});
		//**支出
		$("#deposit_log td[field='expend']").each(function(){
			var expend = parseFloat($(this).attr("value"));
			var text   = "";
			if(expend>0){text = '<font class="color-expend">'+expend+'<font>';};
			$(this).html(text);
		});
		var $drawcash      = $("#drawcash"),
		myDepositAvailable = <%=OW.parseMoney(V("my_deposit_available"))%>;
		$drawcash.click(function(){
			if(myDepositAvailable>0){
				OW.openPage("?ctl=finance&subctl=drawcash&act=apply");
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
		call getMyDeposit()
		if OW.parseMoney(V("my_deposit_available"))>=OW.parseMoney(OW.config("deposit_drawcash_limit")) then
			call drawcashApplyHtml()
		else
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("deposit_drawcash_limit"))))
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
                        <b style="color:#c60000; font-size:20px; font-weight:normal;"><%=OW.parsePrice(V("my_deposit_available"))%><%=UC.lang(115)%></b>
                        <input type="hidden" class="text" name="drawcash_money" value="<%=V("my_deposit_available")%>" />
                        </td></tr>
                    <tr><td class="titletd top"><%=UC.lang(1340)%></td>
                        <td class="infotd"><select name="bank_type"><%=OS.createOptions(array("1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></td>
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
		call getMyDeposit()
		V("drawcash_money")    = OW.parseMoney(OW.getForm("post","drawcash_money"))
		V("bank_type")         = OW.int(OW.getForm("post","bank_type"))
		V("bank_name")         = OW.validClientDBData(OW.getForm("post","bank_name"),50)
		V("bank_account_name") = OW.validClientDBData(OW.getForm("post","bank_account_name"),100)
		V("bank_account")      = OW.validClientDBData(OW.getForm("post","bank_account"),32)
		V("ip")                = OW.getClientIP()
		'****
		if OW.parseMoney(V("my_deposit_available"))<OW.parseMoney(OW.config("deposit_drawcash_limit")) then
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("deposit_drawcash_limit"))))
			exit function
		end if
		if OW.parseMoney(V("drawcash_money"))>OW.parseMoney(V("my_deposit_available")) then
			call UC.errorSetting(UC.lang(1362))
			exit function
		end if
		if OW.parseMoney(V("drawcash_money"))<OW.parseMoney(OW.config("deposit_drawcash_limit")) then
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
		result = OW.DB.addRecord(DB_PRE &"member_deposit_drawcash",array("site_id:"& SITE_ID,"uid:"& UID,"status:0","approved:0","drawcash_money:"& V("drawcash_money"),"bank_type:"& V("bank_type"),"bank_name:"& V("bank_name"),"bank_account:"& V("bank_account"),"bank_account_name:"& V("bank_account_name"),"ip:"& V("ip"),"date_apply:"& SYS_TIME))
		if result then
			call OS.memberDepositExpend(UID,V("drawcash_money"),UC.lang(1421))
		end if
		'****
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(1364),"")
		UC.actionFinishFailText    = array(UC.lang(1365),"")
		UC.actionFinishRun()
	end function
	
	private function drawcashListHtml()
	call UC.echoHeader()
	call getMyDeposit()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
        <div id="container">
            <h1 class="header"><%=UC.lang(1400)%></h1>
            <div class="section-fenxiao" id="fenxiao">
                <div class="section">
                    <%
					 OW.Pager.sql      = "SELECT logid,date_apply,drawcash_money,bank_type,bank_name,bank_account,bank_account_name,approved,status FROM "& DB_PRE &"member_deposit_drawcash a WHERE uid="& UID &" ORDER BY logid DESC"
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
	
end class
%>

