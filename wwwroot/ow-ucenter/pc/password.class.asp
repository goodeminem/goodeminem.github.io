<%
dim UC_PASSWORD
class UC_PASSWORD_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "edit"
			if SAVE then
				call settingSave()
			end if
		case else
			call setting()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function setting()
	call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(1800)%></h1>
          <form class="form-horizontal" name="form_setting">
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(1801)%></label>
                  <div class="controls"><%=USERNAME%></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(1802)%></label>
                  <div class="controls"><%=EMAIL%></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(1803)%></label>
                  <div class="controls"><input type="password" class="text" name="password" placeholder="<%=UC.lang(1806)%>" value="" ></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(1804)%></label>
                  <div class="controls"><input type="password" class="text" name="new_password" placeholder="<%=UC.lang(1807)%>" value="" ></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(1805)%></label>
                  <div class="controls"><input type="password" class="text" name="renew_password" placeholder="<%=UC.lang(1808)%>" value="" ></div>
              </div>
              <div class="control-group">
                  <div class="controls controls-btn">
                      <button type="button" class="btn btn-primary" name="btn_save"><%=UC.lang(155)%></button>
                  </div>
              </div>
          </form>
      </div>
    </div>
    <script type="text/javascript">
    $(document).ready(function(){
		$("button[name='btn_save']").click(function(){settingSave();});
		function settingSave(){
			OW.setDisabled($("button[name='btn_save']"),true);
			//**
			var errMsg,
			url         = "index.asp?ctl=password&act=edit&save=true",
			valid       = true,
			closeDialog = true,
			$dialog     = OWDialog().posting(),
			$password      = $("input[name='password']"),
			$newPassword   = $("input[name='new_password']"),
			$reNewPassword = $("input[name='renew_password']"),
			pw   = OW.trim($password.val()),
			npw  = OW.trim($newPassword.val()),
			rnpw = OW.trim($reNewPassword.val());
			//**
			if(OW.isNull(pw) && valid){
				valid = false;
				$password.addClass("text-err").focus();
			}else{
				$password.removeClass("text-err");
			};
			//**
			if(OW.isNull(npw) && valid){
				valid = false;
				$newPassword.addClass("text-err").focus();
			}else{
				$newPassword.removeClass("text-err");
			};
			//**
			if(OW.isNull(rnpw) && valid){
				valid = false;
				$reNewPassword.addClass("text-err").focus();
			}else{
				$reNewPassword.removeClass("text-err");
			};
			if((npw != rnpw) && valid){
				valid = false;
				closeDialog = false;
				$dialog.error("<%=UC.lang(1809)%>").position().timeout(2);
				$reNewPassword.addClass("text-err").val("").focus();
				$reNewPassword.addClass("text-err").val("");
			};
			//**
			if(valid){
				OW.ajax({
					me:"",url:url,data:"password="+OW.encrypt.encode(pw)+"&new_password="+OW.encrypt.encode(npw),
					success:function(){
						$dialog.success("<%=UC.lang(1812)%>").position();
						OW.setDisabled($("button[name='btn_save']"),false);
						OW.delay(2000,function(){OW.refresh();});
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(169)%>',msg).position().timeout(4);
						OW.setDisabled($("button[name='btn_save']"),false);
					}
				});
			}else{
				if(closeDialog){$dialog.close();};
				OW.setDisabled($("button[name='btn_save']"),false);
			};
		};
	});
    </script>
    <%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	private function settingSave()
		dim result,valid
		result = true
		valid  = true
		V("password")     = OW.clientUserDataDecode(OW.getForm("post","password"))
		V("new_password") = OW.clientUserDataDecode(OW.getForm("post","new_password"))
		if V("password")="" then
			UC.errorSetting(UC.lang(1810))
			valid = false
		end if
		'**
		V("password")     = OW.parsePassword(V("password"))
		V("new_password") = OW.parsePassword(V("new_password"))
		'**
		V("user_password") = OW.DB.getFieldValueBySQL("SELECT password FROM "& DB_PRE &"member WHERE uid="& UID &"")
		if OW.isNul(V("user_password")) or V("user_password")<>V("password") then
			UC.errorSetting(UC.lang(1811))
			valid = false
		end if
		if valid then
			OW.DB.auxSQLValid = false
			result = OW.DB.updateRecord(DB_PRE &"member",array("password:"& V("new_password")),array("uid:"& UID))
			if result then
				call OW.DB.updateRecord(DB_PRE &"ucenter_member",array("password:"& V("new_password")),array("uid:"& UID))
			end if
			OW.DB.auxSQLValid = true
			UC.actionFinishSuccess     = result
			UC.actionFinishSuccessText = array(UC.lang(1813),"")
			UC.actionFinishFailText    = array(UC.lang(1814),"")
			UC.actionFinishRun()
		end if
	end function
	
end class

%>