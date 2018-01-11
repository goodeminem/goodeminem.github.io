var createShopCategory = function(opt){
	var isShop = OW.int(opt.is_shop),
	cateId     = OW.int(opt.cate_id);
	OW.ajax({
		url:OW.sitePath +"ow-includes/ow.cate.data.asp?is_shop="+isShop+"&cate_id="+cateId,data:"",
		success:function(){
			var jsonData = OW.ajaxData.category;
		},
		failed:function(msg){
			OWDialog().error('亲，很抱歉，分类数据获取失败，请刷新页面试试！<br>'+msg);
		}
	});
};