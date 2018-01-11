<%
dim UC_SETTING
class UC_SETTING_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "edit"
			if SAVE then
				call settingSave()
			else
				call setting()
			end if
		case "avatar"
			if SUBACT = "uploading" then
				call OW.include("ow-includes/ow.upload.lib.asp")
				call avatarUploading()
			elseif SUBACT = "cutting" then
				call avatarCutting()
			else
				call avatarSetting()
			end if
		case else
			call setting()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function avatarSetting()
	call UC.echoHeader()
	dim isCutAvatar
	isCutAvatar = OW.int(OW.getForm("get","cut"))
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
        <div class="avatar-set-body"> 
			<% if isCutAvatar=0 then %>
            <div class="avatar-upload">
                <div class="avatar-view-section">
                    <div class="header"><%=UC.lang(2012)%></div>
                  <div class="section"><img name="myavatar" src="<%=AVATAR%>"></div>
                </div>
                <div class="avatar-do-section">
                    <div class="header"><%=UC.lang(2013)%></div>
                    <div class="section">
                        <div class="upload-tip">
                        <%=UC.lang(2014)%><br />
                        </div>
                        <div class="upload-do">
                            <form action="index.asp?ctl=setting&act=avatar&subact=uploading" method="post" name="uploadform" enctype="multipart/form-data" target="uploadloader">
                            <input type="file" accept="image/gif,image/jpg,image/jpeg,image/png,image/bmp" name="file1" hidefocus="" class="file file-input">
                            <button type="button" class="btn btn-primary btn-large" name="btn-avatar-upload"><%=UC.lang(2015)%></button>
                            </form>
                        </div>
                      <iframe name="uploadloader" style="display:none; width:400px; margin:10px 0px;"></iframe>
                    </div>
                </div>
            </div>
            <script language="javascript" type="text/javascript">
			function uploadResult(msg){
                if(msg=="success"){
                    OW.openPage("index.asp?ctl=setting&act=avatar&cut=1");
                }else{
					alert("<%=UC.lang(2016)%>");
					OW.openPage("index.asp?ctl=setting&act=avatar");
                };
                OW.setDisabled($("button[name='btn-avatar-upload']"),false);
            };
			OW.setDisabled($("button[name='btn-avatar-upload']"),false);
            $(document).ready(function(){
                var avatar = "<%=AVATAR%>",
				$file1     = $("input[name='file1']");
                $("img[name='myavatar']").attr("src",avatar+"?r="+OW.random());
				$file1.change(function(){
					$("form[name='uploadform']").submit();
					var $dialog = OWDialog().posting("<%=UC.lang(2017)%>");
				});
                $("button[name='btn-avatar-upload']").click(function(){
                    OW.setDisabled($(this),true);
                    $("form[name='uploadform']").submit();
					var $dialog = OWDialog().posting("<%=UC.lang(2017)%>");
                });
            });
            </script>
            <% else %>
            <script type="text/javascript" src="js/jquery.imgareaselect.min.js"></script>
            <script type="text/javascript" src="js/jquery.lazyload.pack.js"></script>
            <div class="ow-avatar-cut">
                <table border="0" cellpadding="0" cellspacing="0"><tr>
                <td valign="top">
                <div class="my-avatar"><img id="myavatar" src="<%=AVATAR%>"></div>
                <div class="my-avatar-view">
                    <h3><%=UC.lang(2018)%></h3>
                    <div id="previewdiv" style="position:relative; overflow:hidden; width:150px; height:150px;">
                        <img id="avatarview" src="<%=AVATAR%>" style="position:relative; width:300px;" />
                    </div>
                </div>
                <div class="clear"></div>
                <form name="uploadform" action="index.asp?ctl=setting&act=avatar&subact=cutting" method="post" target="uploadloader">
                    <input type="hidden" id="originalvw" name="vw" value="0" />
                    <input type="hidden" id="sourcey" name="sx" value="0" />
                    <input type="hidden" id="sourcex" name="sy" value="0" />
                    <input type="hidden" id="width" name="wid" value="0" />
                    <input type="hidden" id="height" name="hei" value="0" />
                    <input type="hidden" name="imgsrc" value="" />
                    <input type="hidden" name="action_type" value="cut" />
                    <div class="submit"><input type="submit" class="btn btn-primary" name="btn-submit-photo" value="<%=UC.lang(155)%>" /></div>
                </form>
                <iframe name="uploadloader" style="display:none;"></iframe>
                </td>
                </tr></table>
            </div>
            <script language="javascript" type="text/javascript">
			$(document).ready(function(){
				$('#myavatar').lazyload({placeholder : "themes/default/images/grey.gif" });
				var hei,wid = 300;
				avatarCutInit("<%=AVATAR%>?r="+parseInt(Math.random()*1000));
				function imgPreview(img,selection){
					if(selection.width == 0) {selection.width  = 150;}
					if(selection.height == 0){selection.height = 150;}
					var scaleX = 150/selection.width; 
					var scaleY = 150/selection.height;
					$('#avatarview').attr('src',avatar).css({
						width:Math.round(scaleX*wid)+'px',
						height:Math.round(scaleX*hei)+'px',
						marginLeft:'-'+Math.round(scaleX*selection.x1)+'px',
						marginTop:'-'+Math.round(scaleY * selection.y1)+'px'
					}); 
					$('#sourcey').val(selection.x1);
					$('#sourcex').val(selection.y1);
					$('#width').val(selection.width);
					$('#height').val(selection.height);
				};
				function avatarCutInit(imgurl){
					avatar = imgurl;
					$("#myavatar").attr("src",avatar).attr("original",avatar);
					$("#avatarview").attr("src",avatar);
					$("input[name='imgsrc']").val(avatar);
					$(function(){
						$('#myavatar').imgAreaSelect({
							aspectRatio:'150:150',
							borderColor1:'#000',
							borderColor2:'#000',
							outerOpacity:0,
							selectionOpacity:0.4,
							selectionColor:'#fff',
							minWidth:60,
							minHeight:60,
							x1:0,
							y1:0,
							x2:150,
							y2:150,
							onSelectChange:imgPreview,
							onSelectStart:imgPreview,
							onSelectEnd:imgPreview
						});
					});
				};
			});
			function cutingFinish(){
				OW.openPage(OW.ucenterHurl+"ctl=setting&act=avatar");
			};
            </script>
            <% end if %>
        </div>
      </div>
    </div>
    <%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
	function uploadTip(byval msg)
		'echo msg
		call OW.echoJsCode("if(window.parent){window.parent.uploadResult("""& msg &""")};")
		die ""
	end function
	
	public function avatarUploading()
		dim dbResult
		dim Upload,file,savePath,uploadResult,uploadValue,allowMaxFileSize
		set Upload   = new MoLibUpload
		uploadResult = false
		savePath     = OS.defAvatarRoot
		'**
		allowMaxFileSize        = "2mb"
		Upload.AllowMaxSize     = allowMaxFileSize
		Upload.AllowMaxFileSize = allowMaxFileSize
		Upload.AllowFileTypes   = "*.jpg;*.jpeg;*.gif;*.png;*.bmp"
		Upload.Charset          = SYS_CHARSET
		Upload.SavePath         = SITE_PATH & savePath
		Upload.saveFilename     = UID
		'**
		if not Upload.GetData() then
			call uploadTip(replace(UC.lang(2019),"{$size}",allowMaxFileSize))
		else
			set file = Upload.Save("file1",0,true)
			if file.Succeed then
				uploadValue  = SITE_PATH & savePath & file.FileName
				call OW.FSO.imageCompress(uploadValue)
				dbResult = OW.DB.execute("UPDATE "& DB_PRE &"member SET avatar='"& uploadValue &"',avatar_big='"& uploadValue &"' WHERE uid="& UID &"")
				if dbResult then
					call uploadTip("success")
				else
					call uploadTip(UC.lang(2020))
				end if
			else
				uploadValue = file.Exception
				call uploadTip(UC.lang(2020))
			end if
			set file = nothing
		end if
		set Upload=nothing
	end function
	
	private function avatarCutting()
		on error resume next
		dim imgSX,imgSY,imgAreaW,imgAreaH,imgVW
		dim jpeg,avatarPath
		avatarPath = AVATAR
		if OW.isNul(avatarPath) then exit function
		imgSX    = OW.int(OW.getForm("post","sx"))
		imgSY    = OW.int(OW.getForm("post","sy"))
		imgAreaW = OW.int(OW.getForm("post","wid"))
		imgAreaW = OW.iif(imgAreaW>0,imgAreaW,150)
		imgAreaH = imgAreaW
		imgVW    = 300
		'**
		set jpeg = Server.CreateObject("Persits.Jpeg")
		jpeg.Open OW.FSO.ABSPath(avatarPath)
		imgWidth = jpeg.OriginalWidth
		imgX1    = (imgWidth/imgVW)*imgSX
		imgY1    = (imgWidth/imgVW)*imgSY
		imgX2    = imgX1+(imgAreaW/imgVW)*imgWidth
		imgY2    = imgY1+(imgWidth/imgVW)*imgAreaH
		'**
		if imgX2<=imgX1 then imgX1 = imgX1 + imgAreaW
		if imgY2<=imgY1 then imgY2 = imgY1 + imgAreaH
		'**
		jpeg.Crop imgX1,imgY1,imgX2,imgY2
		jpeg.Quality = 94
		jpeg.Width   = 200
		jpeg.Height  = 200
		jpeg.Save OW.FSO.ABSPath(avatarPath)
		set jpeg = nothing
		if err.number<>0 then
			err.clear()
			echo "<script type=""text/javascript"">if(window.parent){window.parent.cutingFinish()};</script>"
		else
			avatarCutting = true
			echo "<script type=""text/javascript"">if(window.parent){window.parent.cutingFinish()};</script>"
		end if
	end function
	
	private function setting()
		call UC.echoHeader()
%>
	<%=UC.htmlHeader()%>
    <%=UC.htmlSider()%>
    <div id="mbody">
      <div id="container">
          <h1 class="header"><%=UC.lang(2000)%></h1>
          <form class="form-horizontal" name="reg-form">
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(2001)%></label>
                  <div class="controls"><%=USERNAME%></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(2002)%></label>
                  <div class="controls"><%=EMAIL%></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(2003)%></label>
                  <div class="controls"><%=MOBILE%></div>
              </div>
              <div class="control-group">
                  <label class="control-label"><%=UC.lang(2004)%></label>
                  <div class="controls"><input type="text" class="text" name="nickname" placeholder="" value="<%=NICKNAME%>" ></div>
              </div>
              <div class="control-group">
                  <label for="username" class="control-label"><%=UC.lang(2005)%></label>
                  <div class="controls"><%=OS.getGroupName(GROUP_ID)%></div>
              </div>
              <% if SPECIAL_GROUP_ID>0 then %>
              <div class="control-group">
                  <label for="username" class="control-label"><%=UC.lang(2006)%></label>
                  <div class="controls"><%=OS.getGroupName(SPECIAL_GROUP_ID)%></div>
              </div>
              <% end if %>
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
			url       = "index.asp?ctl=setting&act=edit&save=true",
			valid     = true,
			$dialog   = OWDialog().posting(),
			$nickname = $("input[name='nickname']"),
			nickname  = $nickname.val();
			//**
			if(nickname=="" && valid){
				valid = false;
				$nickname.addClass("text-err").focus();
			}else{
				$nickname.removeClass("text-err");
			};
			//**
			if(valid){
				OW.ajax({
					me:"",url:url,data:"nickname="+escape(nickname),
					success:function(){
						$dialog.success("<%=UC.lang(2008)%>");
						OW.setDisabled($("button[name='btn_save']"),false);
						OW.refresh();
					},
					failed:function(msg){
						$dialog.error('<%=UC.lang(169)%>',msg).timeout(4);
						OW.setDisabled($("button[name='btn_save']"),false);
					}
				});
			}else{
				$dialog.close();
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
		V("nickname") = OW.validClientDBData(OW.getForm("post","nickname"),32)
		if V("nickname")="" then
			UC.errorSetting(UC.lang(2007))
			valid = false
		end if
		if valid then
			OW.DB.auxSQLValid = false
			result = OW.DB.updateRecord(DB_PRE &"member",array("nickname:"& V("nickname")),array("uid:"& UID))
			OW.DB.auxSQLValid = true
			if result then
				call OW.Cookie.setCookie("nickname",OW.escape(V("nickname")),OW.loginTimeout)
			end if
			UC.actionFinishSuccess     = result
			UC.actionFinishSuccessText = array(UC.lang(2009),"")
			UC.actionFinishFailText    = array(UC.lang(2010),"")
			UC.actionFinishRun()
		end if
	end function
	
end class
%>