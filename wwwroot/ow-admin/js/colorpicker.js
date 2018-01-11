﻿/*
* author: Lin Xiao Dong <1071322670@qq.com>
* update: 2018.01.01
* website: http://www.openwbs.com/
*/
var OWColor,OWColor_Class=function(a){var c=function(a){var d,b=c.defaults;a=a||{};for(d in b)void 0===a[d]&&(a[d]=b[d]);return new c.fn.constructor(a)};c.fn=c.prototype={constructor:function(a){var b;return this.config=a,this.color="#666666",this.dom=b=this.dom||this.init(a),this},init:function(a){var d,b=this,c=a.container;return c.html('<span class="colorpicker"></span><span class="colorpanel" style="position:absolute;z-index:9999;"></span>'),d={},d.colorpicker=c.find(".colorpicker"),d.colorpanel=c.find(".colorpanel"),d.colorpicker.click(function(){b.colorpicker()}),d},colorpicker:function(){var e,f,g,h,b=this,d=this.dom,i="",j=new Array("00","33","66","99","CC","FF"),k=new Array("FF0000","00FF00","0000FF","FFFF00","00FFFF","FF00FF"),l="";for(e=0;2>e;e++)for(f=0;6>f;f++){for(i+="<tr>",i+='<td name="color_cel" color="000" style="background-color:#000"></td>',0==e?(l=j[f]+j[f]+j[f],i=i+'<td name="color_cel" color="'+l+'" style="background-color:#'+l+'"></td>'):(l=k[f],i=i+'<td name="color_cel" color="'+l+'" style="background-color:#'+l+'"></td>'),i+='<td name="color_cel" color="000" style="background-color:#000"></td>',g=0;3>g;g++)for(h=0;6>h;h++)l=j[g+3*e]+j[h]+j[f],i=i+'<td name="color_cel" color="'+l+'" style="background-color:#'+l+'"></td>';i+="</tr>"}return d.colorpanel.html(c.tpl.replace("{tpl:colorTable}",i)),d.colorWin=d.colorpanel.find("div[name='color_win']"),d.colorpanel.find("a[name='close']").click(function(){b.close()}),d.colorpanel.find("a[name='color_clear']").html(b.config.clearValue).click(function(){b.config.clear.call(),b.close()}),d.colorpanel.find("input[name='color_display']").css("background-color",b.config.defaultColor),d.colorpanel.find("input[name='color_hex']").val(b.config.defaultColor),d.colorpanel.find("td[name='color_cel']").mouseover(function(){var b="#"+a(this).attr("color");d.colorpanel.find("input[name='color_display']").css("background-color",b),d.colorpanel.find("input[name='color_hex']").val(b)}).click(function(){var c="#"+a(this).attr("color");b.color=c,b.config.getColor.call(this),b.close()}),this},close:function(){this.dom.colorWin.remove()}},c.fn.constructor.prototype=c.fn,c.defaults={defaultColor:"#666666",clearValue:"clear"},c.tpl='<div name="color_win" style="position:relative; width:300px;"><a href="javascript:;" name="close" class="color-close">X</a><table border="0" cellspacing="0" cellpadding="0" style="border:1px solid #000;border-bottom:none;border-collapse:collapse;width:300px;" bordercolor="000000"><tr height=30><td colspan=21 bgcolor=#eeeeee><table cellpadding="0" cellspacing="1" border="0" style="border-collapse:collapse;"><tr><td style="padding-left:5px;"><input type="text" name="color_display" size="6" disabled style="border:solid 1px #000000; height:18px; line-height:18px;"></td><td style="padding-left:5px;"><input type="text" name="color_hex" size="7" style="border:solid 1px #000000; height:18px; line-height:18px; padding:0px 0px 0px 3px;"></td><td><div style="width:100px;"><a href="javascript:;" style="padding-left:8px;" name="color_clear">clear</a></div></td></tr></table></td></tr><tr><td><table border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="000000" style="cursor:hand;">{tpl:colorTable}</table></td></tr></table></div>',OWColor=c};OWColor_Class(this.jQuery,this);