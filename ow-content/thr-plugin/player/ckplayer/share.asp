<!--#include file="../../../../ow-includes/ow.client.asp"-->
<%
function echoShare()
	dim s
	s = s &"<?xml version=""1.0"" encoding=""utf-8""?>"
	s = s &"<ckplayer>"
	s = s &"<share_html>{embed src="""& SITE_URL &"ow-content/thr-plugin/player/ckplayer/ckplayer.swf"" flashvars=""[$share]"" quality=""high"" width=""480"" height=""400"" align=""middle"" allowScriptAccess=""always"" allowFullscreen=""true"" type=""application/x-shockwave-flash""}{/embed}</share_html>"
	s = s &"<share_flash>"& SITE_URL &"ow-content/thr-plugin/player/ckplayer/ckplayer.swf?[$share]</share_flash>"
	s = s &"<share_flashvars>f,my_url,my_pic,a</share_flashvars>"
	s = s &"<share_path>"& SITE_URL &"ow-content/thr-plugin/player/ckplayer/share/</share_path>"
	s = s &"<share_replace></share_replace>"
	s = s &"<share_load>1</share_load>"
	s = s &"<share_charset>0</share_charset>"
	s = s &"<share_uuid>c25cf02c-1705-412d-bd4b-77a10b380f08</share_uuid>"
	s = s &"<share_button>"
	s = s &"<share><id>qqmb</id><img>qq.png</img><coordinate>13,30</coordinate></share>"
	s = s &"<share><id>sinaminiblog</id><img>sina.png</img><coordinate>101,30</coordinate></share>"
	s = s &"<share><id>qzone</id><img>qzone.png</img><coordinate>189,30</coordinate></share>"
	s = s &"<share><id>renren</id><img>rr.png</img><coordinate>277,30</coordinate></share>"
	s = s &"<share><id>kaixin001</id><img>kaixin001.png</img><coordinate>13,65</coordinate></share>"
	s = s &"<share><id>tianya</id><img>tianya.png</img><coordinate>101,65</coordinate></share>"
	s = s &"<share><id>feixin</id><img>feixin.png</img><coordinate>189,65</coordinate></share>"
	s = s &"<share><id>msn</id><img>msn.png</img><coordinate>277,65</coordinate></share>"
	s = s &"</share_button>"
	s = s &"</ckplayer>"
	echo s
end function
call echoShare()
set Client = nothing
%>