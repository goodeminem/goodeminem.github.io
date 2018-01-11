<%
dim UC_ORDER_FORM_DATA
class UC_ORDER_FORM_DATA_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "add"
			if SAVE then
				call addSave()
			else
				call add()
			end if
		case "set_default"
			if SAVE then
				call setDefault()
			end if
		case "edit"
			if SAVE then
				call editSave()
			else
				call edit()
			end if
		case "delete"
			call delete()
		case else
			call main()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function delete()
		dim arr
		V("id")         = OW.int(OW.getForm("post","id"))
		V("data_exist") = true
		if not(V("id")>0) then UC.errorSetting(UC.lang(165)) : exit function
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_form_data WHERE id="& V("id") &" AND uid="& UID &" AND "& OW.DB.auxSQL &"")
		if not(rs.eof) then
			V("data_exist") = true
		end if
		OW.DB.closeRs rs
		if not(V("data_exist")) then UC.errorSetting(UC.lang(165)) : exit function
		'**
		result = OW.DB.execute("DELETE FROM ["& DB_PRE &"order_form_data] WHERE id="& V("id") &" AND "& OW.DB.auxSQL &"")
		'**
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(152),"")
		UC.actionFinishFailText    = array(UC.lang(153),"")
		UC.actionFinishRun()
	end function
	
	private function setDefault()
		dim arr
		V("id")         = OW.int(OW.getForm("post","id"))
		V("data_exist") = true
		if not(V("id")>0) then UC.errorSetting(UC.lang(165)) : exit function
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_form_data WHERE id="& V("id") &" AND uid="& UID &" AND "& OW.DB.auxSQL &"")
		if not(rs.eof) then
			V("data_exist") = true
			V("form_id")    = OW.int(rs("form_id"))
		else
			V("form_id")    = 0
		end if
		OW.DB.closeRs rs
		if not(V("data_exist")) then UC.errorSetting(UC.lang(165)) : exit function
		'**
		result = OW.DB.execute("UPDATE ["& DB_PRE &"order_form_data] SET is_default=1 WHERE uid="& UID &" AND id="& V("id") &" AND form_id="& V("form_id") &" AND "& OW.DB.auxSQL &"")
		if result then
			call OW.DB.execute("UPDATE ["& DB_PRE &"order_form_data] SET is_default=0 WHERE uid="& UID &" AND id<>"& V("id") &" AND form_id="& V("form_id") &" AND "& OW.DB.auxSQL &"")
		end if
		'**
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(167),"")
		UC.actionFinishFailText    = array(UC.lang(168),"")
		UC.actionFinishRun()
	end function
	
	private function main()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody"> 
      <div id="container">
          <h1 class="header"><%=UC.lang(1500)%></h1>
          <div class="ow-formdata" id="formdata">
              <div class="top-area">
                  <a class="btn btn-primary" href="javascript:;" url="<%=UCENTER_HURL%>ctl=order_form_data&act=add&form_id={$form_id}" id="add_new"><i class="glyphicon glyphicon-plus"></i><%=UC.lang(1501)%></a>
              </div>
              <div class="section-list" id="list">
                  <%=formDataList%>
              </div>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		//**
		var addTpl = '<div id="add_window"><div class="dialog-post-form"><dl><dt class="label"><%=UC.lang(1502)%></dt><dd><div name="category_section"><%=goodsOrderFormSelect()%></div></dd></dl></div></div>';
		$("#add_new").click(function(){
			var url = $(this).attr("url"),
			$dialog = OWDialog({
				id:'d_add_new',
				title:'<%=UC.lang(1501)%>',
				content:addTpl,
				padding:'0px 0px 0px 0px',
				cancel:true,
				follow:$(this),
				initialize:function(){
					var $select = $("select[name='form_id']");
					if($select.find("option").length==1){
						var formId = $select.find("option:selected").val();
						OW.openPage(url.replace("{$form_id}",formId));
					};
				},
				ok:function(){
					var $select = $("select[name='form_id']"),
					$postDialog = OWDialog().posting().position({top:"50px"}),
					formId      = $select.find("option:selected").val();
					OW.openPage(url.replace("{$form_id}",formId));
				}
			});
		});
		//**默认
		$("a[name='set_default']").click(function(){
			var id  = $(this).attr("value"),
			url     = "<%=UCENTER_HURL%>ctl=<%=CTL%>&act=set_default&save=true",
			$dialog = UC.dialogPosting();
			OW.ajax({
				me:"",url:url,data:"id="+id,
				success:function(){
					$dialog.success("<%=UC.lang(162)%>").position();
					OW.delay(2000,function(){
						OW.refresh();
					});
				},
				failed:function(msg){
					$dialog.error('<%=UC.lang(163)%>',msg).position().timeout(4);
					OW.setDisabled($("button[name='submit']"),false);
				}
			});
		});
		//**删除
		$("a[name='delete']").click(function(){
			if(confirm("<%=UC.lang(151)%>")){
				var id  = $(this).attr("value"),
				url     = "<%=UCENTER_HURL%>ctl=<%=CTL%>&act=delete",
				$dialog = UC.dialogPosting();
				OW.ajax({
					me:"",url:url,data:"id="+id,
					success:function(){
						$dialog.success("<%=UC.lang(152)%>").position();
						OW.delay(2000,function(){
							OW.refresh();
						});
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(153)%>',msg).position().timeout(4);
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
	
	private function goodsOrderFormSelect()
		dim rs
		dim sb,str : set sb = OW.stringBuilder()
		sb.append "<select name=""form_id"">"
		set rs = OW.DB.getRecordBySQL("SELECT form_id,name FROM ["& DB_PRE &"form] WHERE is_shop=1 AND status=0 AND "& OW.DB.auxSQL &" ORDER BY sequence")
		do while not rs.eof
			sb.append "<option form_id="""& rs("form_id") &""" value="""& rs("form_id") &""">"& rs("name") &"</option>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		sb.append "</select>"
		str = sb.toString() : set sb = nothing
		goodsOrderFormSelect = str
	end function
	
	public function formDataList()
		dim arr,i,rs,rs2
		dim formId,formData,name,value,regionData,regionName
		dim sb,str : set sb = OW.stringBuilder()
		set rs = OW.DB.getRecordBySQL( "SELECT * FROM "& DB_PRE &"order_form_data WHERE uid="& UID &" AND "& OW.DB.auxSQL &" ORDER BY id ASC")
		do while not(rs.eof)
			formId     = OW.int(rs("form_id"))
			formData   = OW.rs(rs("data"))
			regionData = OW.rs(rs("region_data"))
			'**
			sb.append "<div class=""ow-formdata-list"">"
			sb.append "<div class=""header"">"
			sb.append OW.DB.getFieldValueBySQL("SELECT name FROM "& DB_PRE &"form WHERE form_id="& formId &" AND "& OW.DB.auxSQL &"")
			if OW.int(rs("is_default"))=1 then
			sb.append "<span class=""default"">"& UC.lang(1503) &"</span>"
			end if
			sb.append "</div>"
			'**
			if OW.int(OW.config("is_region_open"))=1 then
				regionName = OS.getRegionName(regionData)
				sb.append "<div class=""item""><div class=""colname"">"& OS.lang(37) &"：</div><div class=""colvalue"">"& regionName &"</div></div>"
			end if
			'**
			set rs2 = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& formId &" AND "& OW.DB.auxSQL &" AND status=0 AND display_in_admin=0 ORDER BY sequence ASC")
			do while not rs2.eof
				name  = OW.rs(rs2("field_name"))
				value = OW.unEscape(OW.getODataKeyValue(formData,OW.rs(rs2("field"))))
				sb.append "<div class=""item""><div class=""colname"">"& name &"：</div><div class=""colvalue"">"& value &"</div></div>"
			rs2.movenext
			loop
			OW.DB.closeRs rs2
			'**
			sb.append "<div class=""footer"">"
			if OW.int(rs("is_default"))<>1 then
			sb.append "<a href=""javascript:;"" name=""set_default"" value="""& rs("id") &""">"& UC.lang(1504) &"</a>"
			end if
			sb.append "<a href="""& UCENTER_HURL &"ctl=order_form_data&act=edit&id="& rs("id") &""">"& UC.lang(164) &"</a><a href=""javascript:;"" name=""delete"" value="""& rs("id") &""">"& UC.lang(150) &"</a>"
			sb.append "</div>"
			sb.append "</div>"
			rs.movenext
		loop
		OW.DB.closeRs rs
		'**
		str = sb.toString() : set sb = nothing
		formDataList = str
	end function
	
	private function add()
		dim rs
		dim regionData,name,input,tips,js
		dim sb,str : set sb = OW.stringBuilder()
		'**
		V("form_id") = OW.int(OW.getForm("get","form_id"))
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form WHERE status=0 AND form_id="& V("form_id") &" AND "& OW.DB.auxSQL &"")
		if rs.eof then
			V("form_exist") = false
		else
			V("form_exist") = true
		end if
		OW.DB.closeRs rs
		if not(V("form_exist")) then
			call UC.errorSetting(UC.lang(1505))
			exit function
		end if
		'**
		V("is_region_exist") = false
		if OW.int(OW.config("is_region_open"))=1 then
			V("is_region_exist") = true
			set sb = OW.stringBuilder()
			sb.append "<tr>"
			sb.append "<td class=""titletd""><i class=""important"">*</i>"& OS.lang(37) &"</td>"
			sb.append "<td class=""infotd""><span id=""order_region_select_grid""></span><span name=""t_order_region"" class=""t-normal ml5""></span><script type=""text/javascript"" src="""& SITE_URL &"ow-content/data/ow.region.js""></script><script type=""text/javascript"">$(document).ready(function(){OW.createRegionSelect($(""#order_region_select_grid""),""order_region"","""& regionData &""");});</script></td>"
			sb.append "</tr>"
		end if
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& V("form_id") &" AND "& OW.DB.auxSQL &" AND status=0 AND display_in_admin=0 ORDER BY sequence ASC")
		do while not rs.eof
			
			arrayData = OS.createFormFieldHtml(true,OW.rs(rs("field")),OW.rs(rs("field_name")),OW.rs(rs("field_type")),OW.int(rs("field_datasize")),fieldvalue,OW.rs(rs("field_options")),OW.int(rs("not_null")),OW.rs(rs("tips")))
			name  = arrayData(0)
			input = arrayData(1)
			tips  = arrayData(2) 
			js    = arrayData(3)
			sb.append "<tr><td class=""titletd"">"& name &"</td><td class=""infotd"">"& input & tips & js &"</td></tr>"
		rs.movenext
		loop
		OW.DB.closeRs rs
		str = sb.toString() : set sb = nothing
		V("form_html") = "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"" class=""formtable"">"& str &"</table>"
		'**
		call doingHtml()
	end function
	
	private function edit()
		dim rs
		dim formData,regionData,name,input,tips,js
		dim sb,str : set sb = OW.stringBuilder()
		'**
		V("id") = OW.int(OW.getForm("get","id"))
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_form_data WHERE id="& V("id") &" AND uid="& UID &" AND "& OW.DB.auxSQL &"")
		if rs.eof then
			V("data_exist") = false
		else
			V("data_exist") = true
			V("form_id")    = OW.int(rs("form_id"))
			V("form_data")  = OW.rs(rs("data"))
			V("region_data")= OW.rs(rs("region_data"))
			formData   = V("form_data")
			regionData = V("region_data")
		end if
		OW.DB.closeRs rs
		'**
		if not(V("data_exist")) then call UC.errorSetting(UC.lang(165)) : exit function
		'**
		V("is_region_exist") = false
		if OW.int(OW.config("is_region_open"))=1 then
			V("is_region_exist") = true
			set sb = OW.stringBuilder()
			sb.append "<tr>"
			sb.append "<td class=""titletd""><i class=""important"">*</i>"& OS.lang(37) &"</td>"
			sb.append "<td class=""infotd""><span id=""order_region_select_grid""></span><span name=""t_order_region"" class=""t-normal ml5""></span><script type=""text/javascript"" src="""& SITE_URL &"ow-content/data/ow.region.js""></script><script type=""text/javascript"">$(document).ready(function(){OW.createRegionSelect($(""#order_region_select_grid""),""order_region"","""& regionData &""");});</script></td>"
			sb.append "</tr>"
		end if
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& V("form_id") &" AND "& OW.DB.auxSQL &" AND status=0 AND display_in_admin=0 ORDER BY sequence ASC")
		do while not rs.eof
			fieldValue = OW.dbDataDecodeToInput(OW.unEscape(OW.getODataKeyValue(formData,OW.rs(rs("field")))))
			arrayData  = OS.createFormFieldHtml(true,OW.rs(rs("field")),OW.rs(rs("field_name")),OW.rs(rs("field_type")),OW.int(rs("field_datasize")),fieldvalue,OW.rs(rs("field_options")),OW.int(rs("not_null")),OW.rs(rs("tips")))
			name  = arrayData(0)
			input = arrayData(1)
			tips  = arrayData(2) 
			js    = arrayData(3)
			sb.append "<tr><td class=""titletd"">"& name &"</td><td class=""infotd"">"& input & tips & js &"</td></tr>"
		rs.movenext
		loop
		OW.DB.closeRs rs
		str = sb.toString() : set sb = nothing
		V("form_html") = "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"" class=""formtable"">"& str &"</table>"
		'**
		call doingHtml()
	end function
	
	private function doingHtml()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container" class="om-website">
          <h1 class="header"><%=OW.iif(ACT="add",UC.lang(166),UC.lang(164))%></h1>
          <div class="section-form">
          <form name="save_form" id="save_form" action="javascript:;" method="post">
              <div class="tablegrid">
                  <%=V("form_html")%>
              </div>
              <div class="form-actions">
                  <button type="submit" class="btn btn-primary" name="submit"><%=UC.lang(155)%></button>
              </div>
          </form>
          </div>
      </div>
    </div>
    <script type="text/javascript">
    $(window).ready(function(){
		var id    = "<%=V("id")%>",
		formId    = "<%=V("form_id")%>",
		$saveForm = $("#save_form");
		$saveForm.submit(function(){
			OW.parseFormInputValue({form:$saveForm});
			var isRegioned,$validForm,
			isRegionExist  = <%=lcase(V("is_region_exist"))%>,
			valid          = true,
			regionData     = "region_data=",
			$regionSelect  = $("select[is_region='1']"),
			$regionTipSpan = $("span[name='t_order_region']");
			if(isRegionExist){
				if($regionSelect.length>0){
					$regionTipSpan.removeClass("t-err").html("");
					$regionSelect.each(function(){
						if(!OW.int($(this).val())>0){
							valid = false;
							$(this).focus();
							$regionTipSpan.addClass("t-err").html("<%=UC.lang(1506)%>");
						};
						regionData = "region_data="+$(this).find("option:selected").attr("path");
					});
				};
			};
			$validForm = OWValidForm({form:$(this)});
			$validForm.verify();
			if($validForm.result && valid){
				var $dialog = UC.dialogPosting();
				var url = "?ctl=<%=CTL%>&act=<%=ACT%>&form_id="+formId+"&id="+id+"&save=true";
				$validForm.getFormData();
				OW.ajax({
					me:"",url:url,data:regionData+"&"+$validForm.formData,
					success:function(){
						var id = OW.ajaxData.id;
						$dialog.success("<%=UC.lang(158)%>").position();
						OW.delay(2000,function(){
							OW.redirect("?ctl=<%=CTL%>");
						});
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(157)%>',msg).position().timeout(4);
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
	
	private function addSave()
		dim rs,result,valid,formTable,field,value
		dim odata,str : set odata = OW.ODataBuilder()
		valid  = true
		V("form_id") = OW.int(OW.getForm("get","form_id"))
		if OW.int(OW.config("is_region_open"))=1 then
			V("region_data") = OW.left(OW.regReplace(OW.getForm("post","region_data"),"[^0-9,]",""),250)
			odata.add "region_data",V("region_data")
		end if
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form WHERE status=0 AND form_id="& V("form_id") &" AND "& OW.DB.auxSQL &"")
		if rs.eof then
			V("form_exist") = false
		else
			V("form_exist") = true
		end if
		OW.DB.closeRs rs
		'**
		if not(V("form_exist")) then
			UC.errorSetting(UC.lang(1507))
			valid = false
		end if
		'**
		if valid then
			set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& V("form_id") &" AND display_in_admin=0 AND "& OW.DB.auxSQL &" AND status=0 ORDER BY sequence ASC")
			do while not rs.eof
				field  = rs("field")
				value  = OW.getForm("post",field)
				value  = OS.SHOP.getOrderFormFieldValue(value,field,rs("field_type"),rs("field_datasize"))
				odata.add field,value
				rs.movenext
			loop
			OW.DB.closeRs rs
			V("form_data") = odata.toString() : set odata = nothing
			result = OW.DB.addRecord(DB_PRE &"order_form_data",array("site_id:"& SITE_ID,"uid:"& UID,"form_id:"& V("form_id"),"data:"& V("form_data"),"is_default:0","sequence:1","region_data:"& V("region_data")))
			'**
			UC.actionFinishSuccess     = result
			UC.actionFinishSuccessText = array(UC.lang(1508),"")
			UC.actionFinishFailText    = array(UC.lang(1509),"")
			UC.actionFinishRun()
		end if
	end function
	
	private function editSave()
		dim rs,result,formTable,field,value
		dim odata,str : set odata = OW.ODataBuilder()
		V("id")         = OW.int(OW.getForm("get","id"))
		V("data_exist") = false
		V("form_exist") = false
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"order_form_data WHERE id="& V("id") &" AND uid="& UID &" AND "& OW.DB.auxSQL &"")
		if not(rs.eof) then
			V("data_exist") = true
			V("form_id")    = OW.int(rs("form_id"))
		end if
		OW.DB.closeRs rs
		if not(V("data_exist")) then UC.errorSetting(UC.lang(165)) : exit function
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form WHERE status=0 AND form_id="& V("form_id") &" AND "& OW.DB.auxSQL &"")
		if not(rs.eof) then
			V("form_exist") = true
		end if
		OW.DB.closeRs rs
		if not(V("form_exist")) then UC.errorSetting(UC.lang(1510) &"(form_id:"& V("form_id") &")！")  : exit function
		'**
		if OW.int(OW.config("is_region_open"))=1 then
			V("region_data") = OW.left(OW.regReplace(OW.getForm("post","region_data"),"[^0-9,]",""),250)
			odata.add "region_data",V("region_data")
		end if
		'**
		set rs = OW.DB.getRecordBySQL("SELECT * FROM "& DB_PRE &"form_field WHERE form_id="& V("form_id") &" AND display_in_admin=0 AND "& OW.DB.auxSQL &" AND status=0 ORDER BY sequence ASC")
		do while not rs.eof
			field  = rs("field")
			value  = OW.getForm("post",field)
			value  = OS.SHOP.getOrderFormFieldValue(value,field,rs("field_type"),rs("field_datasize"))
			odata.add field,value
			rs.movenext
		loop
		OW.DB.closeRs rs
		V("form_data") = odata.toString() : set odata = nothing
		result = OW.DB.updateRecord(DB_PRE &"order_form_data",array("data:"& V("form_data"),"region_data:"& V("region_data")),array("id:"& V("id")))
		'**
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(1511),"")
		UC.actionFinishFailText    = array(UC.lang(1512),"")
		UC.actionFinishRun()
	end function

end class
%>

