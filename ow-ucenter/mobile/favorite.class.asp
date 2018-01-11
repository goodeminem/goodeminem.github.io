<%
dim UC_FAVORITE
class UC_FAVORITE_CLASS
	
	private oRs,sSQL,sString
	
	private sub class_initialize()
	end sub
	
	public sub init()
		select case ACT
		case "delete"
			call delete()
		case else
			call main()
		end select
	end sub
	
	private sub class_terminate()
	end sub
	
	private function delete()
		dim arr,gid
		gid = OW.int(OW.getForm("post","gid"))
		if not(gid>0) then UC.errorSetting(UC.lang(1201)) : exit function
		result = OW.DB.execute("DELETE FROM ["& DB_PRE &"goods_favorite] WHERE uid="& UID &" AND gid="& gid &" AND "& OW.DB.auxSQL &"")
		UC.actionFinishSuccess     = result
		UC.actionFinishSuccessText = array(UC.lang(1202),"")
		UC.actionFinishFailText    = array(UC.lang(1203),"")
		UC.actionFinishRun()
	end function
	
	private function main()
	dim arr,myDeposit,myDepositAvailable,myDepositFreeze
	arr = OS.getMemberDeposit(UID)
	myDepositTotal     = arr(0)
	myDepositAvailable = arr(1)
	myDepositFreeze    = arr(2)
	
	call UC.echoHeader()
%>
	<%=UC.htmlHeaderMobile("<a href="""& UCENTER_URL &""" class=""ucenter""></a>",UC.lang(1200))%>
    <section id="mbody">
        <div class="section-favorite" id="favorite_goods">
            <div class="section">
                <%
                 OW.Pager.sql      = "select gid,market_price,price,thumbnail,title,subtitle,rootpath,urlpath,font_color,font_weight,point_set,point_pay_amount from "& OW.DB.Table.goods &" WHERE gid IN (select gid from "& DB_PRE &"goods_favorite where uid="& UID &" AND "& OW.DB.auxSQL &") AND "& OW.DB.auxSQL &""
                OW.Pager.pageSize = 30
                OW.Pager.pageUrl  = "index.asp?ctl=favorite&page={$page}"
                OW.Pager.pageTpl  = "{prev}{current}{next}"
				OW.Pager.loopHtml = "<li><div class=""thumb""><a href="""& OW.urlRewrite("c7") &""" title=""{$title}"" target=""_blank""><img src=""{$thumbnail}"" alt=""{$title}"" title=""{$title}""></a></div><div class=""info""><h3 class=""title""><a href="""& OW.urlRewrite("c7") &""" title=""{$title}"" target=""_blank"">{$title}</a></h3><p class=""subtitle"">{$subtitle}</p><p class=""price"" point_set=""{$point_set}""><span class=""point""><b>{$point_pay_amount}</b><em>"& OS.lang(200) &"</em><i>+</i></span><span class=""money""><em>"& OW.config("money_sb") &"</em><b>{$price}</b></span></p></div><a href=""javascript:;"" class=""delete"" gid=""{$gid}"" name=""delete"">"& UC.lang(150) &"</a></li>"
                OW.Pager.run()
                %>
                <ul class="ow-goods-horizlist" name="goods">
                <%=OW.Pager.loopHtmls%>
                </ul>
            </div>
            <div class="footer"><div class="pager"><%=OW.Pager.pageHtmls%></div></div>
        </div>
    </section>
    <script type="text/javascript">
    $(window).ready(function(){
		var $favorites = $("#favorite_goods");
		//积分价格
		$(".price").each(function(){
			var pointSet = $(this).attr("point_set"),
			price = OW.parseMoney($(this).find(".money > b").html());
			if(pointSet==0){
				$(this).find(".point").remove();
			};
			if(!price>0){
				$(this).find(".money").hide();
				$(this).find(".point > i").hide();
			};
		});
		//删除
		$favorites.find("a[name='delete']").click(function(){
			var $li = $(this).parent(),
			gid = $(this).attr("gid"),
			$dialog = new OWDialog({
				id:OW.createDialogID(),
				content:"<%=UC.lang(151)%>",
				ok:function(){
					var url = OW.ucenterHurl +"ctl=favorite&act=delete",
					data    = "gid="+gid;
					$dialog.button({id:"ok",remove:true},{id:"cancel",remove:true}).posting().position();
					OW.ajax({
						url:url,data:data,
						success:function(){
							$dialog.success("<%=UC.lang(152)%>").timeout(2);
							$li.remove();
						},
						failed:function(msg){
							$dialog.error('<%=UC.lang(153)%>',msg).timeout(3);
						}
					});
					return false;
				},
				cancel:true,
				close:false
			}).position();
		});
	});
    </script>
	<%=UC.htmlFooter()%>
<%
	call UC.echoFooter()
	end function
	
end class
%>

