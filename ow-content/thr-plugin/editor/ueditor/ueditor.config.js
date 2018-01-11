(function () {
    var URL = SITE_PATH +"ow-content/thr-plugin/editor/ueditor/";
    window.UEDITOR_CONFIG = {
        UEDITOR_HOME_URL: URL
        , serverUrl: URL + ""
        , toolbars: [[
            'fullscreen', 'source', '|', 'paragraph', 'fontfamily', 'fontsize', 'insertorderedlist', 'insertunorderedlist', 'indent', 'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'rowspacingtop', 'rowspacingbottom', 'lineheight', '|', 'removeformat', 'pasteplain' ],[
            
            'forecolor', 'backcolor', 'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'blockquote', 'superscript', 'subscript', 'directionalityltr', 'directionalityrtl', '|', 'link', 'unlink', 'anchor', 'spechars', '|', 'insertcode', 'map', 'gmap', 'template', '|', 'searchreplace' ],[
            
            'imagenone', 'imageleft', 'imageright', 'imagecenter', '|', 'insert_image', 'insert_attachment', 'insertvideo', 'music', '|', 'inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol', 'mergecells', 'mergeright', 'mergedown', 'splittocells', 'splittorows', 'splittocols', '|', 'undo', 'redo' 
        ]]
        ,zIndex:10
        ,autoHeightEnabled:false
        ,autoFloatEnabled:false
        ,allowDivTransToP:true
        ,enableAutoSave:false
        ,retainOnlyLabelPasted:false
        ,labelMap:{'insert_image':'图片','insert_attachment':'附件'}
        ,initialContent:''
        ,initialFrameHeight:512
        ,maximumWords:20000
        ,wordOverFlowMsg:'<span style="color:red;">你输入的字符个数已经超出最大允许值，可能会无法保存！</span>'
		,xssFilterRules: true
		,inputXssFilter: true
		,outputXssFilter: true
        ,pageBreakTag:'_openwbs_page_break_tag_'
        ,sourceEditor:"codemirror"
        ,codeMirrorJsUrl:URL + "third-party/codemirror/codemirror.js"
        ,codeMirrorCssUrl:URL + "third-party/codemirror/codemirror.css"
		,whitList: {
			a:      ['target', 'href', 'title', 'class', 'style'],
			abbr:   ['title', 'class', 'style'],
			address: ['class', 'style'],
			area:   ['shape', 'coords', 'href', 'alt'],
			article: [],
			aside:  [],
			audio:  ['autoplay', 'controls', 'loop', 'preload', 'src', 'class', 'style'],
			b:      ['class', 'style'],
			bdi:    ['dir'],
			bdo:    ['dir'],
			big:    [],
			blockquote: ['cite', 'class', 'style'],
			br:     [],
			caption: ['class', 'style'],
			center: [],
			cite:   [],
			code:   ['class', 'style'],
			col:    ['align', 'valign', 'span', 'width', 'class', 'style'],
			colgroup: ['align', 'valign', 'span', 'width', 'class', 'style'],
			dd:     ['class', 'style'],
			del:    ['datetime'],
			details: ['open'],
			div:    ['class', 'style'],
			dl:     ['class', 'style'],
			dt:     ['class', 'style'],
			em:     ['class', 'style'],
			embed:  ['src', 'align', 'allowScriptAccess', 'allowFullScreen', 'alt', 'class', 'height', 'id', 'mode', 'quality', 'style', 'width', 'title', 'type'],
			font:   ['color', 'size', 'face'],
			footer: [],
			h1:     ['class', 'style'],
			h2:     ['class', 'style'],
			h3:     ['class', 'style'],
			h4:     ['class', 'style'],
			h5:     ['class', 'style'],
			h6:     ['class', 'style'],
			header: [],
			hr:     [],
			i:      ['class', 'style'],
			iframe: ['src', 'alt', 'allowfullscreen', 'class', 'frameborder', 'height', 'id', 'style', 'width', 'title'],
			img:    ['src', 'alt', 'title', 'width', 'height', 'id', '_src', 'loadingclass', 'class', 'data-latex'],
			ins:    ['datetime'],
			li:     ['class', 'style'],
			mark:   [],
			nav:    [],
			ol:     ['class', 'style'],
			p:      ['class', 'style'],
			pre:    ['class', 'style'],
			s:      [],
			section:[],
			small:  [],
			span:   ['class', 'style'],
			sub:    ['class', 'style'],
			sup:    ['class', 'style'],
			strong: ['class', 'style'],
			table:  ['width', 'border', 'align', 'valign', 'class', 'style'],
			tbody:  ['align', 'valign', 'class', 'style'],
			td:     ['width', 'rowspan', 'colspan', 'align', 'valign', 'class', 'style'],
			tfoot:  ['align', 'valign', 'class', 'style'],
			th:     ['width', 'rowspan', 'colspan', 'align', 'valign', 'class', 'style'],
			thead:  ['align', 'valign', 'class', 'style'],
			tr:     ['rowspan', 'align', 'valign', 'class', 'style'],
			tt:     [],
			u:      [],
			ul:     ['class', 'style'],
			video:  ['src', 'autoplay', 'controls', 'loop', 'preload', 'height', 'width', 'class', 'style']
		}
    };
})();