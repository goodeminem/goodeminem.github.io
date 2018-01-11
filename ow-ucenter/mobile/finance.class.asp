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
		dim arr,payId,payCode,payName,payLogo,payConfig,payDesc,payStatus
		dim rs,sql
		dim sb,sbtr : set sb = OW.stringBuilder()
		set rs = OW.DB.getRecordBySQL("SELECT pay_id,pay_code,pay_name,pay_logo,pay_config,pay_desc FROM "& DB_PRE &"payment WHERE status=0 AND is_mobile=1 AND is_charge=1 AND "& OW.DB.auxSQL &" ORDER BY sequence")
		do while not rs.eof
			payId     = OW.rs(rs("pay_id"))
			payCode   = OW.rs(rs("pay_code"))
			payName   = OW.rs(rs("pay_name"))
			payLogo   = OW.rs(rs("pay_logo"))
			payConfig = OW.rs(rs("pay_config"))
			payDesc   = OW.rs(rs("pay_desc"))
			'****
			sb.append "<label class=""owui-cell owui-check-label"" for=""pay_id_"& payId &""">"
            sb.append "<div class=""owui-cell-hd"">"
            sb.append "<input type=""radio"" class=""owui-check"" name=""payment"" id=""pay_id_"& payId &""" pay_code="""& payCode &""" value="""& payId &""" />"
            sb.append "<i class=""owui-icon-checked""></i>"
            sb.append "</div>"
            sb.append "<div class=""owui-cell-bd"">"
            sb.append "<h4 class=""owui-cell-title"">"& payName &"</h4>"
			sb.append "<div class=""owui-cell-title-text"">"& OW.editorContentClientDecode(payDesc) &"</div>"
            sb.append "</div>"
			sb.append "<div class=""owui-cell-ft"">"
            sb.append "<img class=""owui-bank-img"" src="""& payLogo &""">"
            sb.append "</div>"
            sb.append "</label>"
			'****
			rs.movenext
		loop
		OW.DB.closeRs rs
		sbtr = sb.toString() : set sb = nothing
		payment = sbtr
	end function
	
	private function charge()
	dim readonly,amount,inputAmount
	readonly = OW.int(OW.getForm("get","readonly"))
	amount   = OW.parseMoney(OW.getForm("get","amount"))
	amount   = OW.iif(amount>1,amount,1)
	inputAmount = OW.iif(amount>1,amount,"")
	call UC.echoHeader()
%>
    <%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1413))%>
    <section id="mbody">
        <div class="owui-form">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
            <div class="owui-cells">
                <div class="owui-cell">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1414)%>(<%=OW.config("money_sb")%>)</label></div>
                    <div class="owui-cell-bd">
                        <% if readonly=1 and amount>1 then%>
                        <input type="hidden" class="owui-input" name="amount" value="<%=amount%>" />
                        <div class="charge-money"><%=amount%></div>
                        <% else %>
                        <input type="number" class="owui-input" name="amount" placeholder="<%=UC.lang(1415)%>" value="<%=inputAmount%>" />
                        <% end if%>
                    </div>
                </div>
            </div>
            <div class="owui-cells owui-cells-checkbox">
                <%=payment%>
            </div>
            <div class="owui-btn-area">
                <a class="owui-btn owui-btn-primary" href="javascript:" id="submit"><%=UC.lang(1417)%></a>
            </div>
            </form>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		var $saveForm = $("#save_form"),
		$owPayment    = $("#ow_payment"),
		$btn          = $saveForm.find("#submit");
		OW.setDisabled($btn,false);
		$btn.click(function(){
			OW.setDisabled($btn,true);
			var amount,data,payId,payCode,bankCode='',
			$amount = $saveForm.find("input[name='amount']"),
			$input  = $saveForm.find("input[name='payment']:checked"),
			amount  = OW.parseMoney($amount.val()),
			payId   = OW.int($input.val()),
			payCode = OW.parseBankCode($input.attr("pay_code")),
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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1400))%>
    <section id="mbody">
        <div class="section-fiance-point" id="deposit_log">
            <div class="ow-count-header">
                <span class="text-grid"><h4><%=UC.lang(114)%></h4><p><%=OW.parsePrice(V("my_deposit_total"))%><%=UC.lang(115)%></p></span>
                <span class="text-grid text-grid-2"><h4><%=UC.lang(1401)%></h4><p><%=OW.parsePrice(V("my_deposit_available"))%><%=UC.lang(115)%></p></span>
                <span class="text-grid text-grid-3" style="display:none;"><h4><%=UC.lang(1402)%></h4><p><%=OW.parsePrice(V("my_deposit_freeze"))%><%=UC.lang(115)%></p></span>
                <span class="text-do-grid">
                    <a href="<%=UCENTER_HURL%>ctl=finance&act=charge" class="btn btn-primary btn-charge"><%=UC.lang(116)%></a>
                    <% if OS.isCanFinanceDrawcash then %>
                    <a href="javascript:;" class="btn btn-default" id="drawcash"><%=UC.lang(1323)%></a>
                    <% end if %>
                </span>
            </div>
            <div class="section" id="list_section">
                <div class="owui-panel">
                    <div class="owui-panel-hd"><%=UC.lang(1403)%></div>
                    <div class="owui-panel-bd">
                    <%
                    OW.Pager.sql      = "select logid,time,sn,trade_no,type,income,expend,deposit,remark from "& DB_PRE &"member_deposit_log where uid="& UID &" ORDER BY logid DESC"
                    OW.Pager.pageSize = 30
                    OW.Pager.pageUrl  = "index.asp?ctl=finance&page={$page}"
                    OW.Pager.pageTpl  = "{prev}{current}{next}"
                    OW.Pager.loopHtml = "<a href=""javascript:void(0);"" class=""owui-media-box owui-media-box-appmsg""><div class=""owui-media-box-hd""><div class=""owui-media-box-hd-datetime"" name=""datetime"" value=""{$time}"">{$time}</div></div><div class=""owui-media-box-bd""><h4 class=""owui-media-box-title"" name=""type"" value=""{$type}""><span class=""plusspan color-income"">+{$income}"& UC.lang(115) &"</span><span class=""minusspan color-expend"">-{$expend}"& UC.lang(115) &"</span><span class=""owui-media-box-subtitle"">"& UC.lang(114) &"：{$deposit}</span></h4><p class=""owui-media-box-desc"">{$remark}</p></div></a>"
                    OW.Pager.loopExecute= "if fieldName=""time"" then fieldValue = OW.formatDateTime(fieldValue,0)"
                    OW.Pager.run()
                    %>
                    <%=OW.Pager.loopHtmls%>
                    </div>
                </div>
            </div>
            <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		$("div[name='datetime']").each(function(){
			var time = $(this).attr("value");
			$(this).html('<span class="date">'+OW.formatDateTime(time,2)+'</span><span class="time">'+OW.formatDateTime(time,3)+'</span>');
		});
		//**交易类型
		$("#list_section h4[name='type']").each(function(){
			var type = parseInt($(this).attr("value"));
			if(type==1){
				$(this).find("span.minusspan").remove();
			}else if(type==2){
				$(this).find("span.plusspan").remove();
			};
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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1336))%>
    <section id="mbody">
        <div class="om-drawcash">
            <form name="save_form" id="save_form" action="javascript:;" method="post">
            <div class="owui-cells owui-cells-first">
                <div class="owui-cell">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1339)%></label></div>
                    <div class="owui-cell-bd"><b style="color:#c60000; font-size:18px; font-weight:normal;"><%=OW.parsePrice(V("my_deposit_available"))%><%=UC.lang(115)%></b><input type="hidden" class="owui-input owui-input-writeable" name="drawcash_money" placeholder="" value="<%=V("my_deposit_available")%>" /></div>
                </div>
                <div class="owui-cell owui-cell-select owui-cell-select-after">
                    <div class="owui-cell-hd"><label class="owui-label"><%=UC.lang(1340)%></label></div>
                    <div class="owui-cell-bd"><select class="owui-select" name="bank_type"><%=OS.createOptions(array("1:"& UC.lang("bank_type_1") &"","2:"& UC.lang("bank_type_2") &""),V("bank_type"))%></select></div>
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
			call UC.errorSetting(replace(UC.lang(1335),"{$money}",OW.parseMoney(OW.config("deposit_drawcash_limit"))))
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
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &"?ctl="& CTL &""" class=""goback""></a>",UC.lang(1330))%>
    <section id="mbody">
        <div class="ow-commission-list">
            <div class="owui-panel">
                <div class="owui-panel-bd">
                <%
                OW.Pager.sql      = "SELECT logid,date_apply,drawcash_money,bank_type,bank_name,bank_account,bank_account_name,approved,status FROM "& DB_PRE &"member_deposit_drawcash a WHERE uid="& UID &" ORDER BY logid DESC"
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
	
end class
%>

