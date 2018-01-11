<!--#include file="../ow.config.asp"-->
<!--#include file="ow.pinyin.lib.asp"-->
<%
dim PY_ARRAY,CN_STRING

function pinYin(byval s)
	dim i,ss
	PY_ARRAY = split(PY_DATA,"|")
	for i=1 to len(s)
		ss = ss & pinYinOne(mid(s,i,1))
	next
	ss = replace(ss,"    "," ")
	ss = replace(ss,"   "," ")
	ss = replace(ss,"  "," ")
	pinYin = ss
end function

function pinYinOne(ByVal s)
	dim i
	i = instr(PY_LIST,s)
	if i>0 then
		pinYinOne = PY_ARRAY(i)
	elseif instr(PY_LIST,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- ")>0 Then 
		pinYinOne = lcase(s)
	elseif instr(PY_LIST,"~!@#$%^&*()\-+;:'""<>,.\\，。；：“‘、　]+$")>0 then
		pinYinOne = " "
	else
		pinYinOne = s
	end if
end function

CN_STRING = request.QueryString("cn_string")
response.Write lcase(pinYin(CN_STRING))
%>