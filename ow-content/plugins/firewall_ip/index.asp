<%
'**
'IP防火墙
'**
dim PLUGIN_FIREWALL_IP
class PLUGIN_FIREWALL_IP_CLASS
	
	private aArr,oRs,iI,bResult
	
	private sub class_initialize()
	end sub
	
	public sub init()
		if CTL="firewall_ip" then
			select case ACT
			case "add"
				call add()
			case "edit"
				call edit()
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
		dim ip,result
		ip = OW.left(OW.regReplace(OW.getForm("post","ip"),"[^0-9.]",""),15)
		if ip="" then : Admin.errorSetting("ip不能为空！") : check = false
		if check and Admin.errMsgCount=0 then
			if OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_ip WHERE ip='"& ip &"' AND "& OW.DB.auxSQL &"") then
				result = true
			else
				result = OW.DB.addRecord(DB_PRE &"firewall_ip",array("site_id:"& SITE_ID,"ip:"& ip))
			end if
			Admin.actionFinishSuccess     = result
			Admin.actionFinishSuccessText = array("成功添加ip("& ip &")","")
			Admin.actionFinishFailText    = array("添加ip("& ip &")失败","")
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
		if not(OW.DB.isRecordExistsBySQL("SELECT * FROM "& DB_PRE &"firewall_ip WHERE id="& id &" AND "& OW.DB.auxSQL &"")) then
			V("delete_action_text") = V("delete_action_text") &"ip不存在或已被删除"&"(id: "& id &")"&"<br>"
			deleting = false
			exit function
		end if
		'**
		V("ip") = OW.DB.getFieldValueBySQL("SELECT [ip] FROM "& DB_PRE &"firewall_ip WHERE id="& id &"")
		result  = OW.DB.execute("DELETE FROM "& DB_PRE &"firewall_ip WHERE id="& id &"")
		if result then
			V("delete_action_text") = V("delete_action_text") &"删除成功ip("& id &")"&"<br>"
		else
			V("delete_action_text") = V("delete_action_text") &"ip("& id &")删除失败"&"<br>"
		end if
		deleting = result
	end function
	
	private function edit()
		dim status,result : result = false
		dim succText,failText
		status = OW.int(OW.getForm("post","status"))
		if status = 1 then
			succText = "成功开启ip防火墙"
			failText = "ip防火墙开启失败"
		else
			succText = "成功关闭ip防火墙"
			failText = "ip防火墙关闭失败"
		end if
		result = OW.DB.execute("UPDATE "& DB_PRE &"site_config SET config_value='"& status &"' WHERE config_name='firewall_ip_open' AND "& OW.DB.auxSQL &"")
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
                <tr><td class="titletd top">IP防火墙</td>
                    <td class="infotd">
                    <div style="padding-top:2px;">
                    <% if OW.config("firewall_ip_open") then %>
                    <a class="switch switch-on" href="javascript:;" name="firewall_switch" value="1"><span>已开启</span></a>
                    <% else %>
                    <a class="switch switch-off" href="javascript:;" name="firewall_switch" value="0"><span>已关闭</span></a>
                    <% end if %>
                    </div>
                    </td>
                </tr>
                <tr><td class="titletd top">IP黑名单列表</td>
                    <td class="infotd">
                    <div style="margin:3px 0px 0px 0px;">
                    <button type="button" class="btn btn-primary mr5" name="add_ip">添加IP</button><button class="btn" id="delete_selected">批量删除</button>
                    <span class="t-normal ml5">技巧提示：添加 "192.168."(不含引号) 可匹配 192.168.0.0～192.168.255.255 范围内的所有地址</span>
                    </div>
                    <div class="list-area" id="data_list_area" style="margin:8px 0px 0px 0px;">
                    <table border="0" cellpadding="0" cellspacing="0" class="listTable" style="width:auto;">
                      <thead>
                          <tr class="thead">
                              <th><input type="checkbox" name="select_all" id="select_all"></th>
                              <th>id</th>
                              <th>ip</th>
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
			field_name:"ip",
			status_validValue:"正常",
			status_validTitle:"点击可设置为无效状态",
			status_invalidValue:'无效',
			status_invalidTitle:'点击可设置为正常状态',
			delete_confirm:"您确定要删除吗？",
			delete_confirm2:"您确定要删除ip {tpl:name} 吗？",
			delete_doing:"正在删除ip...",
			delete_success:"删除成功",
			delete_failed:"删除操作失败",
			delete_tip:"请先选择您要删除的ip"
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
				text = "开启ip防火墙";
			}else{
				text = "关闭ip防火墙";
			};
			var $dialog = OWDialog({content:'<div class="posting">正在'+ text +'，请稍候...</div>',follow:$("a[name='firewall_switch']"),shadow:false});
			Admin.ajax({
				async:false,me:"",data:"status="+status+"",url:"index.asp?ctl=<%=CTL%>&act=edit&is_plugin=true&save=true",
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
		//**添加ip
		var addIpTpl = '<div class="inbox" style="width:480px;">'+
							'<table border="0" cellpadding="0" cellspacing="0" width="100%" class="infoTable">'+
							  '<tbody>'+
								'<tr><td class="titletd">填写ip</td>'+
									'<td class="infotd">'+
									'<input type="text" class="text" name="ip" maxlength="50" value=""/>'+
									'<div><span class="t-normal" name="t_ip"></span><div>'+
									'</td>'+
								'</tr>'+
							  '</tbody>'+
							'</table>'+
						'</div>';
		$("button[name='add_ip']").click(function(){
			var $dialog = new OWDialog({
				id:'d_add_ip',
				title:'添加ip',
				content:addIpTpl,
				padding:"10px 10px 5px 10px",
				ok:function(){
					var check = true,
					$input    = $("#d_add_ip").find("input[name='ip']"),
					$tip      = $("#d_add_ip").find("span[name='t_ip']"),
					data      = $.trim($input.val());
					$input.val(data);
					if(data==""){
						$tip.addClass("t-err").html("请先填写ip！").show();
						check = false;
						$input.focus();
					};
					if(check){
						$dialog.content('<div class="loading">正在向服务器提交数据...</div>').button({id:'ok',remove:true},{id:'cancel',disabled:true}).padding("20px 40px");
						Admin.ajax({
							url:"index.asp?ctl=<%=CTL%>&act=add&is_plugin=true&save=true",data:"ip="+escape(data),
							success:function(){
								$dialog.title(false).success('成功添加 <b>'+ data +'</b>').button({id:'cancel',remove:true}).timeout(2);
								OW.refresh();
							},
							failed:function(msg){
								$dialog.title(false).error('添加 <b>'+ data +'</b>失败！',msg).button({id:'cancel',remove:true}).timeout(2);
							}
						});
					};
					return false;
				},
				cancel:true,
				close:false,
				follow:$(this),
				initialize:function(){
					$(this).find("input[name='ip']").focus();
				}
			});
		});
		//**
	});
	</script>
    <%
		call Admin.echoFooter()
	end function
	
	private function ipListing()
		Admin.list("fields")         = "id,ip"
		Admin.list("sql")            = "SELECT "& Admin.list("fields") &" FROM ["& DB_PRE &"firewall_ip] WHERE "& OW.DB.auxSQL &""
		Admin.list("pagesize")       = Admin.getPageSise(ACTION_ID)
		Admin.list("checkboxExists") = true
		Admin.list("opeations")      = "<a class=""btn btn-small"" name=""delete"" href=""javascript:;"">删除</a>"
		Admin.list("auxURLPara")     = "is_plugin=true"
		Admin.list("returnType")     = "html"
		ipListing = Admin.getDataList()
	end function

end class
%>