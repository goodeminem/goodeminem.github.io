var weixinPay = function(tradeType,isDebug,siteURL,orderId,isChooseWXPay,prepayId,jsAPIParameters){
	var WeixinJSBridgePayInit = function(){
		if(typeof(WeixinJSBridge) == "undefined"){
			if(document.addEventListener){
				document.addEventListener('WeixinJSBridgeReady',onBridgeReady,false);
			}else if(document.attachEvent){
				document.attachEvent('WeixinJSBridgeReady',onBridgeReady);
				document.attachEvent('onWeixinJSBridgeReady',onBridgeReady);
			};
		}else{
			onBridgeReady();
		};
	},
	onBridgeReady = function(){
		WeixinJSBridge.invoke(
			'getBrandWCPayRequest',
			jsAPIParameters,
			function(res){
				if(res.err_msg=="get_brand_wcpay_request:ok"){
					if(tradeType==1){
						OW.openPage(siteURL+"ow-ucenter/?ctl=orders&act=detail&order_id="+orderId+"");
					}else{
						OW.openPage(siteURL+"ow-ucenter/?ctl=finance");
					};
				}else{
					if(tradeType==1){
						OW.openPage(siteURL+"?ctl=order&act=payment&order_id="+orderId+"");
					}else{
						OW.goBack();
					};
				};
			}
		);
	};
	var chooseWXPayInit = function(){
		var appId = $('#appId').val(),
		timeStamp = $('#timeStamp').val(),
		nonceStr  = $('#nonceStr').val(),
		package   = $('#package').val(),
		signType  = $('#signType').val(),
		paySign   = $('#paySign').val(),
		timeStamp2= $('#timeStamp2').val(),
		nonceStr2 = $('#nonceStr2').val(),
		signature = $('#signature').val();
		wx.config({
			debug:isDebug,
			appId:appId,
			timestamp:timeStamp2,
			nonceStr:nonceStr2,
			signature:signature,
			jsApiList:['chooseWXPay']
		});
		wx.ready(function(){
			wx.chooseWXPay({
				appId:appId,
				timestamp:timeStamp,
				nonceStr:nonceStr,
				package:package,
				signType:signType,
				paySign:paySign,
				success:function(res){
					if(tradeType==1){
						OW.openPage(siteURL+"ow-ucenter/?ctl=orders&act=detail&order_id="+orderId+"");
					}else{
						OW.openPage(siteURL+"ow-ucenter/?ctl=finance");
					};
				},
				cancel:function(res){
					if(tradeType==1){
						OW.openPage(siteURL+"?ctl=order&act=payment&order_id="+orderId+"");
					}else{
						OW.goBack();
					};
				}
			});
		});
	};
	if(OW.isNotNull(prepayId)){
		if(isChooseWXPay){
			chooseWXPayInit();
		}else{
			WeixinJSBridgePayInit();
		};
	}else{
		alert("微信支付开小差了，请稍后再试试。");
		if(tradeType==1){
			OW.openPage(siteURL+"?ctl=order&act=payment&order_id="+orderId+"");
		}else{
			OW.goBack();
		};
	};
};