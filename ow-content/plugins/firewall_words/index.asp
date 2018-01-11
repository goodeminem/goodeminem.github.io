<%
'**
'站点管理
'**
dim PLUGIN_FIREWALL_WORDS
class PLUGIN_FIREWALL_WORDS_CLASS
	
	private aArr,oRs,iI,bResult
	private bAuxSQLValid
	
	private sub class_initialize()
	end sub
	
	public sub init()
		if CTL="firewall_words" then
			select case ACT
			case "add"
				call add()
			case "edit"
				if SUBACT="firewall" then
					call statusEdit()
				elseif SUBACT = "status_edit" then
					if SAVE then
						bAuxSQLValid = true
						call Admin.statusEdit(DB_PRE &"firewall_words","id",bAuxSQLValid,array("成功更改词语状态","无法更新数据库，词语状态更改失败！"))
					end if
				else
					call edit()
				end if
			case "delete"
				call delete()
			case "manage"
				call manage()
			end select
		end if
	end sub
	
	private sub class_terminate()
	end sub
	
	private function add()
		dim check : check = true
		dim word,replaceWord,result
		word        = OW.validDBData(OW.getForm("post","word"),64)
		replaceWord = OW.validDBData(OW.getForm("post","replace_word"),64)
		if word="" then : Admin.errorSetting("词语不能为空！") : check = false
		if check and Admin.errMsgCount=0 then
			if OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_words WHERE word='"& word &"' AND "& OW.DB.auxSQL &"") then
				result = true
			else
				result = OW.DB.addRecord(DB_PRE &"firewall_words",array("site_id:"& SITE_ID,"status:0","word:"& word,"replace_word:"& replaceWord))
			end if
			Admin.actionFinishSuccess     = result
			Admin.actionFinishSuccessText = array("成功添加词语("& word &")","")
			Admin.actionFinishFailText    = array("添加词语("& word &")失败","")
			Admin.actionFinishRun()
		end if
	end function
	
	private function delete()
		dim arr,i,check : check = true
		'**接收数据
		V("ids") = OW.regReplace(OW.getForm("post","ids"),"[^0-9,]","")
		arr      = split(V("ids"),",")
		'**
		if V("ids")="" then check = false : Admin.errorSetting("id传递不正确")
		'**从数据库删除记录
		if check then
			for i=0 to ubound(arr)
				call deleting(arr(i))
			next
			'**输出操作结果信息
			Admin.actionFinishSuccess     = true
			Admin.actionFinishSuccessText = array(V("delete_action_text"),"")
			Admin.actionFinishFailText    = array(V("delete_action_text"),"")
			Admin.actionFinishRun()
		end if
	end function
	
	private function deleting(byval id)
		dim result : result = true
		if id<=0 then
			deleting = false
			exit function
		end if
		'**
		if not(OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_words WHERE id="& id &" AND "& OW.DB.auxSQL &"")) then
			V("delete_action_text") = V("delete_action_text") &"词语不存在或已被删除"&"(id: "& id &")"&"<br>"
			deleting = false
			exit function
		end if
		'**
		V("word") = OW.DB.getFieldValueBySQL("SELECT [word] FROM "& DB_PRE &"firewall_words WHERE id="& id &"")
		result  = OW.DB.execute("DELETE FROM "& DB_PRE &"firewall_words WHERE id="& id &"")
		if result then
			V("delete_action_text") = V("delete_action_text") &"删除成功词语("& id &")"&"<br>"
		else
			V("delete_action_text") = V("delete_action_text") &"词语("& id &")删除失败"&"<br>"
		end if
		deleting = result
	end function
	
	private function edit()
		dim check : check = true
		dim id,word,replaceWord,result
		id          = OW.int(OW.getForm("post","id"))
		word        = OW.validDBData(OW.getForm("post","word"),64)
		replaceWord = OW.validDBData(OW.getForm("post","replace_word"),64)
		if not OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_words WHERE id="& id &" AND "& OW.DB.auxSQL &"") then Admin.errorSetting("id不能传递错误！") : check = false
		if word="" then Admin.errorSetting("词语不能为空！") : check = false
		if check and Admin.errMsgCount=0 then
			if OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_words WHERE id<>"& id &" AND word='"& word &"' AND "& OW.DB.auxSQL &"") then
				result = OW.DB.updateRecord(DB_PRE &"firewall_words",array("replace_word:"& replaceWord),array("id:"& id))
			else
				result = OW.DB.updateRecord(DB_PRE &"firewall_words",array("word:"& word,"replace_word:"& replaceWord),array("id:"& id))
			end if
			Admin.actionFinishSuccess     = result
			Admin.actionFinishSuccessText = array("成功添加词语("& word &")","")
			Admin.actionFinishFailText    = array("添加词语("& word &")失败","")
			Admin.actionFinishRun()
		end if
	end function
	
	private function statusEdit()
		dim status,result : result = false
		dim succText,failText
		status = OW.int(OW.getForm("post","status"))
		if status = 1 then
			succText = "成功开启词语防火墙"
			failText = "词语防火墙开启失败"
		else
			succText = "成功关闭词语防火墙"
			failText = "词语防火墙关闭失败"
		end if
		result = OW.DB.execute("UPDATE "& DB_PRE &"site_config SET config_value='"& status &"' WHERE config_name='firewall_words_open' AND "& OW.DB.auxSQL &"")
		call OW.Cache.clearRamCache(OW.configCacheName)
		Admin.actionFinishSuccess     = result
		Admin.actionFinishSuccessText = array(succText,"")
		Admin.actionFinishFailText    = array(failText,"")
		Admin.actionFinishRun()
	end function
	
	private function manage()
		call Admin.echoHeader()
		call Admin.echoBreadcrumb()
	%>
    <div class="mbody">
        <div class="wbox">
            <div class="inbox">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" class="infoTable">
                <tr><td class="titletd top">词语防火墙</td>
                    <td class="infotd">
                    <div style="padding-top:2px;">
                    <% if OW.config("firewall_words_open") then %>
                    <a class="switch switch-on" href="javascript:;" name="firewall_switch" value="1"><span>已开启</span></a>
                    <% else %>
                    <a class="switch switch-off" href="javascript:;" name="firewall_switch" value="0"><span>已关闭</span></a>
                    <% end if %>
                    </div>
                    </td>
                </tr>
                <tr><td class="titletd top">词语列表</td>
                    <td class="infotd">
                    <div style="margin:3px 0px 0px 0px;">
                    <button type="button" class="btn btn-primary mr5" name="add_word">添加词语</button><button class="btn" id="delete_selected">批量删除</button>
                    <span class="t-normal ml5"></span>
                    </div>
                    <div class="list-area" id="data_list_area" style="margin:8px 0px 0px 0px;">
                    <table border="0" cellpadding="0" cellspacing="0" class="listTable" style="width:auto;">
                      <thead>
                          <tr class="thead">
                              <th><input type="checkbox" name="select_all" id="select_all"></th>
                              <th>id</th>
                              <th>词语</th>
                              <th>替换词</th>
                              <th>状态</th>
                              <th>操作</th>
                          </tr>
                      </thead>
                      <tbody>
                      <%=ipListing()%>
                      </tbody>
                    </table>
                    </div>
                    </td>
                </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		Admin.dataListTableInit({
			ctl:"<%=CTL%>",
			act_edit:"edit",
			auxData:"is_plugin=true",
			field_name:"word",
			status_validValue:"正常",
			status_validTitle:"点击可设置为无效状态",
			status_invalidValue:'无效',
			status_invalidTitle:'点击可设置为正常状态',
			delete_confirm:"您确定要删除吗？",
			delete_confirm2:"您确定要删除 {tpl:name} 吗？",
			delete_doing:"正在删除词语...",
			delete_success:"删除成功",
			delete_failed:"删除操作失败",
			delete_tip:"请先选择您要删除的词语"
		});
		$("a[name='firewall_switch']").click(function(){
			var value = parseInt($(this).attr("value"));
			var $span = $(this).find("span");
			if(value==1){
				if(firewallIpSetting(0)){
					$(this).removeClass("switch-on").addClass("switch-off");
					$(this).attr("value",0);
					$span.html("已关闭");
				};
			}else{
				if(firewallIpSetting(1)){
					$(this).removeClass("switch-off").addClass("switch-on");
					$(this).attr("value",1);
					$span.html("已开启");
				};
			};
		});
		function firewallIpSetting(status){
			var result = false,text;
			if(status==1){
				text = "开启词语防火墙";
			}else{
				text = "关闭词语防火墙";
			};
			var $dialog = OWDialog({content:'<div class="posting">正在'+ text +'，请稍候...</div>',follow:$("a[name='firewall_switch']"),shadow:false});
			Admin.ajax({
				async:false,me:"",data:"status="+status+"",url:"index.asp?ctl=<%=CTL%>&act=edit&subact=firewall&is_plugin=true&save=true",
				success:function(){
					result = true;
					$dialog.close();
				},
				failed:function(msg){
					result = false;
					$dialog.error(text+"失败",msg).timeout(2);
				}
			});
			return result;
		};
		//**添加词语
		var addIpTpl = '<div class="inbox" style="width:480px;">'+
							'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="infoTable">'+
							  '<tbody>'+
								'<tr><td class="titletd">词语</td>'+
									'<td class="infotd">'+
									'<input type="hidden" class="text" name="id" value=""/>'+
									'<input type="text" class="text" name="word" maxlength="64" value=""/>'+
									'<div><span class="t-normal" name="t_word"></span><div>'+
									'</td>'+
								'</tr>'+
								'<tr><td class="titletd">替换词语</td>'+
									'<td class="infotd">'+
									'<input type="text" class="text" name="repalce_word" maxlength="64" value=""/>'+
									'<div><span class="t-normal" name="t_repalce_word"></span><div>'+
									'</td>'+
								'</tr>'+
							  '</tbody>'+
							'</table>'+
						'</div>';
		$("button[name='add_word']").click(function(){
			var $dialog = new OWDialog({
				id:'d_add_word',title:'添加词语',content:addIpTpl,padding:"10px 10px 5px 10px",follow:$(this),cancel:true,
				ok:function(){
					var check    = true,
					$word        = $("#d_add_word").find("input[name='word']"),
					$replaceWord = $("#d_add_word").find("input[name='repalce_word']"),
					$tip         = $("#d_add_word").find("span[name='t_word']"),
					word         = $.trim($word.val()),
					replaceWord  = $.trim($replaceWord.val());
					$word.val(word);
					if(word==""){
						$tip.addClass("t-err").html("请先填写词语！").show();
						check = false;
						$word.focus();
					};
					if(check){
						$dialog.content('<div class="loading">正在向服务器提交数据...</div>').button({id:'ok',remove:true},{id:'cancel',disabled:true}).padding("20px 40px");
						Admin.ajax({
							url:"index.asp?ctl=<%=CTL%>&act=add&is_plugin=true&save=true",data:"word="+escape(word)+"&replace_word="+escape(replaceWord)+"",
							success:function(){
								$dialog.title(false).success('成功添加 <b>'+ word +'</b>').button({id:'cancel',remove:true}).timeout(2);
								OW.refresh();
							},
							failed:function(msg){
								$dialog.title(false).error('添加 <b>'+ word +'</b>失败！',msg).button({id:'cancel',remove:true}).timeout(2);
							}
						});
					};
					return false;
				},
				initialize:function(){
					$(this).find("input[name='word']").focus();
				}
			});
		});
		//**
		$("a[name='word_edit']").click(function(){
			var $this   = $(this);
			var $dialog = new OWDialog({
				id:'d_edit_word',title:'词语编辑',content:addIpTpl,padding:"10px 10px 5px 10px",follow:$(this),cancel:true,
				ok:function(){
					var check    = true,
					$id          = $("#d_edit_word").find("input[name='id']"),
					$word        = $("#d_edit_word").find("input[name='word']"),
					$replaceWord = $("#d_edit_word").find("input[name='repalce_word']"),
					$tip         = $("#d_edit_word").find("span[name='t_word']"),
					id           = $.trim($id.val()),
					word         = $.trim($word.val()),
					replaceWord  = $.trim($replaceWord.val());
					$word.val(word);
					if(word==""){
						$tip.addClass("t-err").html("请先填写词语！").show();
						check = false;
						$word.focus();
					};
					if(check){
						$dialog.content('<div class="loading">正在向服务器提交数据...</div>').button({id:'ok',remove:true},{id:'cancel',disabled:true}).padding("20px 40px");
						Admin.ajax({
							url:"index.asp?ctl=<%=CTL%>&act=edit&is_plugin=true&save=true",data:"id="+id+"&word="+escape(word)+"&replace_word="+escape(replaceWord),
							success:function(){
								$dialog.title(false).success('成功修改 <b>'+ word +'</b>').button({id:'cancel',remove:true}).timeout(2);
								OW.refresh();
							},
							failed:function(msg){
								$dialog.title(false).error('修改 <b>'+ word +'</b>失败！',msg).button({id:'cancel',remove:true}).timeout(2);
							}
						});
					};
					return false;
				},
				initialize:function(){
					var $id      = $("#d_edit_word").find("input[name='id']"),
					$word        = $("#d_edit_word").find("input[name='word']"),
					$replaceWord = $("#d_edit_word").find("input[name='repalce_word']");
					$id.val($this.parent().parent().find("td[field='id']").attr("value"));
					$word.val($this.parent().parent().find("td[field='word']").attr("value"));
					$replaceWord.val($this.parent().parent().find("td[field='replace_word']").attr("value"));
					$replaceWord.focus();
				}
			});
		});
		
	});
	</script>
    <%
		call Admin.echoFooter()
	end function
	
	private function ipListing()
		Admin.list("fields")         = "id,word,replace_word,status"
		Admin.list("sql")            = "SELECT "& Admin.list("fields") &" FROM ["& DB_PRE &"firewall_words] WHERE "& OW.DB.auxSQL &""
		Admin.list("pagesize")       = Admin.getPageSise(ACTION_ID)
		Admin.list("checkboxExists") = true
		Admin.list("opeations")      = "<a class=""btn btn-small mr5"" name=""word_edit"" href=""javascript:;"">编辑</a><a class=""btn btn-small"" name=""delete"" href=""javascript:;"">删除</a>"
		Admin.list("auxURLPara")     = "is_plugin=true"
		Admin.list("returnType")     = "html"
		ipListing = Admin.getDataList()
	end function

end class
%>