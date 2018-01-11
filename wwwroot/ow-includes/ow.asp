<%:dim console : set console = new console_Class:class console_Class:private consoleName,consoleCountName,consoleCount,consoleStr,limit:private sub class_initialize():on error resume next:limit= 1000:consoleName= lcase(CACHE_FLAG &"console"):consoleCountName = lcase(CACHE_FLAG &"console_count"):if DEBUG then:consoleCount = application(consoleCountName):if consoleCount>limit then:consoleCount = 0:application.lock:application(consoleName) = empty:application.unLock:end if:consoleStr = application(consoleName):consoleStr = consoleStr &"<div class='ow-console-start'><span class='text'>console:start</span><span class='runtime-all'>runTime<em>0"& formatNumber(Timer()-SYS_TIME_START) &"</em></span></div>":application.lock:application(consoleName)= consoleStr:application(consoleCountName) = consoleCount + 1:application.unLock:end if:if err.number<>0 then err.clear : end if:end sub:public function clear():on error resume next:application.lock:application(consoleName)= empty:application(consoleCountName) = empty:application.unLock:if err.number<>0 then err.clear : end if:end function:public function count():count = OW.int(application(consoleCountName)):end function:public function display():response.Write(application(consoleName)):end function:public function log(byval str):on error resume next:if DEBUG then:consoleCount = OW.int(application(consoleCountName)):if consoleCount>limit then:consoleCount = 0:application.lock:application(consoleName) = empty:application.unLock:end if:consoleStr = application(consoleName):consoleStr = consoleStr & "<div class='ow-console-item'>"& str &"<span class='runtime-all'>runTime<em>"& OW.runTime &"</em></span></div>":application.lock:application(consoleName)= consoleStr:application(consoleCountName) = consoleCount + 1:application.unLock:end if:if err.number<>0 then err.clear : end if:end function:end class:class VBS_Class:public function cbool_(byval s):cbool_ = cbool(s):end function:public function isArray_(byval arr):isArray_ = isArray(arr):end function:public function int_(byval s):int_ = int(s):end function:public function clng_(byval s):clng_ = clng(s):end function:public function dateDiff_(byval t, byval t1, byval t2):dateDiff_ = dateDiff(t,t1,t2):end function:public function dateAdd_(byval t, byval n, byval d):dateAdd_ = dateAdd(t,n,d):end function:public function formatCurrency_(byval s,byval decLen):formatCurrency_ = formatCurrency(s,decLen,-1):end function:public function instr_(byval ss,byval s):instr_ = instr(ss,s):end function:public function left_(byval s, byval l):left_ = left(s,l):end function:public function len_(byval s):len_ = len(s):end function:public function right_(byval s, byval l):right_ = right(s,l):end function:public function split_(byval s,byval st):split_ = split(s,st):end function:public function trim_(byval s):on error resume next:trim_ = trim(s):if err.number<>0 then err.clear : end if:end function:end class:%>
<%:class OW_Cache_Class:public cacheTime,htmlCacheTime,cacheFlag,htmlCachePath,tplCachePath,sysCachePath,createCacheByAdmin:public pcHtmlCachePath,pcTplCachePath,mobHtmlCachePath,mobTplCachePath:private sCacheName,sCacheData,iCacheNum,iCreateCacheNum:private sub class_initialize():cacheTime    = 24 * 60:htmlCacheTime= cacheTime * 10:cacheFlag    = "ow_":createCacheByAdmin = false:iCacheNum    = 200:iCreateCacheNum    = 0:end sub:private sub class_terminate():end sub:public function sysCacheValid(byval cacheName):sysCacheValid = cacheValid(0,cacheName):end function:public function tplCacheValid(byval cacheName):tplCacheValid = cacheValid(1,cacheName):end function:public function htmlCacheValid(byval cacheName):htmlCacheValid = cacheValid(2,cacheName):end function:public function cacheValid(byval cacheType,byval cacheName):dim cachePath,file,result,ctime:cacheName = lcase(cacheName):result    = false:if OW.isNul(cacheName) then cacheValid = result : exit function : end if:select case cacheType:case 0:cacheName = sysCachePath & cacheName:ctime     = cacheTime:case 1:cacheName = tplCachePath & cacheName:ctime     = cacheTime:case 2:cacheName = htmlCachePath & cacheName:ctime     = htmlCacheTime:end select:cachePath  = OW.FSO.ABSPath(cacheName):if OW.FSO.fileExists(cachePath) then:set file = OW.objectFSO.getFile(cachePath):if OW.dateDiff("s",cDate(file.dateLastModified),now()) < (ctime*60) then:result = true:end if:set file = nothing:end if:cacheValid = result:end function:    public function getTplCache(byval cacheName):dim s:cacheName = lcase(cacheName):if cacheName<>"" then:s = OW.read(tplCachePath & cacheName):end if:getTplCache = s:end function:    public function getHtmlCache(byval cacheName):dim s:cacheName = lcase(cacheName):if cacheName<>"" then:s = OW.read(htmlCachePath & cacheName):end if:getHtmlCache = s:end function:public function saveTplCache(byval cacheName,byval cacheValue):on error resume next:dim tmp:cacheName = lcase(cacheName):if cacheName<>"" then:cacheName = tplCachePath & cacheName:tmp = OW.FSO.overWrite:OW.FSO.overWrite = true:if OW.FSO.saveFile(cacheName,cacheValue) then:iCreateCacheNum = iCreateCacheNum + 1:else:OW.Error.msg = "OW.Cache.saveTplCache: "& cacheName:OW.Error.raise 27:err.clear:end if:OW.FSO.OverWrite = tmp:else:OW.Error.msg = "OW.Cache.saveTplCache: "& cacheName:OW.Error.raise 26:err.clear:end if:end function:public function saveHtmlCache(byval cacheName,byval cacheValue):on error resume next:dim tmp:cacheName = lcase(cacheName):if cacheName<>"" then:cacheName = htmlCachePath & cacheName:tmp = OW.FSO.overWrite:OW.FSO.overWrite = true:if OW.FSO.saveFile(cacheName,cacheValue) then:iCreateCacheNum = iCreateCacheNum + 1:else:OW.Error.msg = "OW.Cache.saveHtmlCache: "& cacheName:OW.Error.raise 27:err.clear:end if:OW.FSO.OverWrite = tmp:else:OW.Error.msg = "OW.Cache.saveHtmlCache: "& cacheName:OW.Error.raise 26:err.clear:end if:end function:public function clearFileCache(byval cachePath):on error resume next:dim file,fso,folder,mapPath,subFolder:mapPath    = OW.serverMapPath(SITE_PATH & cachePath):set fso    = OW.objectFSO:set folder = fso.getFolder(mapPath):for each subFolder in folder.subFolders:call OW.FSO.deleteFolder(OW.FSO.ABSPath(cachePath & subFolder.name)):next:for each file in folder.files:call OW.FSO.deleteFile(OW.FSO.ABSPath(cachePath & file.name)):next:if err then:clearFileCache = false:else:clearFileCache = true:end if:end function:public function clearTplCache():dim result : result = false:if clearFileCache(pcTplCachePath) then:result = clearFileCache(mobTplCachePath):end if:clearTplCache = result:end function:public function clearHtmlCache():dim result : result = false:if clearFileCache(pcHtmlCachePath) then:result = clearFileCache(mobHtmlCachePath):end if:clearHtmlCache = result:end function:public function clearSysCache():dim result : result = false:result = clearFileCache(sysCachePath):clearSysCache = result:end function:public function getRamCache(byval cacheName):dim cacheData:on error resume next:cacheName = lcase(cacheFlag & cacheName):cacheData = application(cacheName):if isArray(cacheData) then:if isObject(cacheData(0)) then:set getRamCache = cacheData(0):else:getRamCache = cacheData(0):end if:end If:if err.number<>0 then err.clear : end if:end function :public function saveRamCache(byval cacheName,byval cacheValue):on error resume next:dim cacheData:cacheName = lcase(cacheFlag & cacheName):cacheData = application(cacheName):if isArray(cacheData) then:if isObject(cacheValue) then set cacheData(0)=cacheValue else cacheData(0)=cacheValue : end if:cacheData(1) = SYS_TIME:else:redim cacheData(1):if isObject(cacheValue) then set cacheData(0)=cacheValue else cacheData(0)=cacheValue : end if:cacheData(1) = SYS_TIME:end if:application.lock:application(cacheName)= cacheData:application.unLock:if err.number<>0 then err.clear : end if:end function:public function ramCacheValid(byval cacheName):on error resume next:dim cacheData,result:result    = false:cacheName = lcase(cacheFlag & cacheName):cacheData = application(cacheName):if not isArray(cacheData) then ramCacheValid = false : exit function : end if:if OW.dateDiff("s",cDate(cacheData(1)),now()) < (cacheTime*60) then:result = true:end If:if err.number<>0 then err.clear : end if:ramCacheValid = result:End function:public sub clearRamCache(byval cacheName):cacheName = lcase(cacheFlag & cacheName):application.lock:application(cacheName) = empty:application.unLock:end sub:public function clearAllRamCache():on error resume next:application.lock():application.contents.removeAll():application.unLock():if err.number<>0 then:err.clear:clearAllRamCache = false:else:clearAllRamCache = true:end if:end function:public function showAllRamCache():dim app:for each app in application.Contents:echo app &"<br>":next:end function:public function getRamCacheNum():getRamCacheNum = application.contents.count:end function:public function createCacheNum():createCacheNum = iCreateCacheNum:end function:public function clearOtherCache():dim i,appl,num:num = getRamCacheNum - iCacheNum:i = 0:for each appl in application.Contents:application.Lock():application.contents.remove(appl):application.UnLock():i = i + 1:if i = num then exit for : end if:next:end function:end class:%>
<%:class OW_Cookie_Class:public cookiePre:public domain:public path:public isEncrypt:public isSecure:private sub class_initialize():end sub:private sub class_terminate():end sub:private function encrypt(byval s):encrypt = OW.Base64.Encode(s):end function:private function decrypt(byval s):decrypt = OW.Base64.Decode(s):end function:function attrTest(byval s, byval t):dim rule:select case lcase(t):case "int"rule = "^[-\+]?\d+$":case "domain"rule = "^(([\da-zA-Z][\da-zA-Z-]{0,61})?[\da-zA-Z]\.)+([a-zA-Z]{2,4}(?:\.[a-zA-Z]{2})?)$":case "ip"rule = "^((25[0-5]|2[0-4]\d|(1\d|[1-9])?\d)\.){3}(25[0-5]|2[0-4]\d|(1\d|[1-9])?\d)$":case else rule = t:end select:attrTest = OW.regTest(cstr(s),rule):end function:public function getCookie(byval key):on error resume next:if key="" then getCookie="" : exit function : end if:dim arr,subKey,c:if instr(key,":") > 0 then:arr = split(key,":"):key = arr(0):subKey = arr(1):end if:if key<>"" then:key = cookiePre & key:if OW.isNul(subKey) then:c = request.cookies(key):else:if request.cookies(key).HasKeys then c = request.cookies(key)(subKey) : end if:end if:if isEncrypt then c = decrypt(c) : end if:else:c = "":end if:if err.number <> 0 then err.Clear : end if:getCookie = c:end function:public function setCookie(byval key, byval v, byval opt):on error resume next:dim i,a,exps,arr,subKey,domain_,path_,secure_:if instr(key,":") > 0 then:arr  = split(key,":"):key = arr(0):subKey = arr(1):end if:if key<>"" then:if isArray(opt) then:for i = 0 to ubound(opt):a = opt(i):if isDate(a) then:exps = CDate(a):else:if attrTest(a,"int") then:if a<>0 then exps = now() + int(a)/60/24 : end if:else:if attrTest(a,"domain") or attrTest(a,"ip") then:domain_ = a:else:if instr(a,"/")>0 then:path_ = a:else:if lcase(a)="true" or lcase(a)="false" then:secure_ = a:end if:end if:end if:end if:end if:next:else:a = opt:if isDate(a) then:exps = CDate(a):else:if attrTest(a,"int") then:if a<>0 then exps = now() + int(a)/60/24 : end if:else:if attrTest(a,"domain") or attrTest(a,"ip") then:domain_ = a:else:if instr(a,"/")>0 then:path_ = a:else:if lcase(a)="true" or lcase(a)="false" then:secure_ = a:end if:end if:end if:end if:end if:end if:key = cookiePre & key:if isEncrypt and v<>"" then v = encrypt(v) : end if:if OW.isNul(subKey) then:response.cookies(key) = v:else:response.cookies(key)(subKey) = v:end if:if OW.isNul(domain_) then domain_ = domain : end if:if OW.isNul(path_)   then path_   = path : end if:if OW.isNul(secure_) then secure_ = isSecure : end if:if not(OW.isNul(exps))     then response.cookies(key).expires = exps : end if:if not(OW.isNul(domain_))  then response.cookies(key).domain  = domain_ : end if:if not(OW.isNul(path_))    then response.cookies(key).path    = path_ : end if:if not(OW.isNul(secure_))  then response.cookies(key).secure  = secure_ : end if:end if:if err.number <> 0 then err.clear : end if:end function:public sub removeCookie(byval key):dim arr,subKey:if instr(key,":") > 0 then:arr     = split(key,":"):key    = arr(0):subKey = arr(1):end if:if key<>"" then:key = cookiePre & key:if OW.isNul(subKey) then:response.cookies(key) = empty:else:if request.cookies(key).HasKeys then response.cookies(key)(subKey) = empty : end if:end if:end if:end sub:private sub clear():dim key:for each key in request.cookies:response.cookies(key) = empty:next:end sub:end class:%>
<%:class OW_DB_Table_Class:public category,content,contentData,contentModelPre,comment,formPre,orders,orderFormPre,goods,goodsData,goodsComment,goodsModelPre,goodsProduct,member,ucenterMember:private sub class_initialize():category  = DB_PRE &"category":content   = DB_PRE &"content"& SITE_ID &"":contentData     = DB_PRE &"content"& SITE_ID &"_data":contentModelPre = DB_PRE &"content"& SITE_ID &"_":comment   = DB_PRE &"comment":goods   = DB_PRE &"goods":goodsData     = DB_PRE &"goods_data":goodsComment  = DB_PRE &"goods_comment":goodsModelPre = DB_PRE &"goods"& SITE_ID &"_":goodsProduct  = DB_PRE &"goods_product":orders  = DB_PRE &"orders":formPre = DB_PRE &"form"& SITE_ID &"_":orderFormPre  = DB_PRE &"order_form"& SITE_ID &"_":member  = DB_PRE &"member":ucenterMember = DB_PRE &"ucenter_member":end sub:end class:class OW_DB_Class:public Table:public sitePath,fieldPre,showSQL,isSQLQueryNumCount,auxSQLValid:public dbType,dbServer,dbPort,dbName,dbUsername,dbPassword:private sAuxSQL,oConn,oRs,iI,iQueryType,iSqlQueryNum,bResult,sString:private sub class_initialize():iQueryType = 0:showSQL    = false:isSQLQueryNumCount = true:fieldPre   = "c_":sAuxSQL    = " 1=1 ":auxSQLValid= true:end sub:private sub class_terminate():on error resume next:err.clear:if lcase(typename(oConn)) = "connection" then:if oConn.State = 1 then oConn.close() : end if:set oConn = nothing:end if:set Table = nothing:err.clear:on error goto 0:end sub:public property Let SQLQueryNum(byval i):iSqlQueryNum = i:end property:public property Get SQLQueryNum():if iSqlQueryNum &""="" then iSqlQueryNum=0 : end if:SQLQueryNum = iSqlQueryNum:end property:public property Let QueryType(byval str):str = Lcase(str):if str = "1" or str = "command" then:iQueryType = 1:else:iQueryType = 0:end if:end property:public property get auxSQL:if auxSQLValid then:auxSQL = sAuxSQL:else:auxSQL = " 1=1 ":end if:end property:public property let auxSQL(byval str):sAuxSQL = str:end property:public sub close():  on error resume next:oConn.close:set oConn = nothing:err.clear:on error goto 0:end sub:public sub closeRs(ByRef rs):if isObject(rs) then:on error resume next:rs.close:set rs = nothing:err.clear:on error goto 0:end if:end sub:public function connectionDatabase():call createConn(dbType,dbServer &":"& dbPort,dbName,dbUsername,dbPassword):end function:public function createConn(byval dbType, byval dbServer, byval database, byval username, byval password):dim s,port:dbType = OW.int(dbType):dbServer = trim(cstr(dbServer)):if instr(dbServer,":") > 0 then:port     = trim(mid(dbServer,instr(dbServer,":")+1)):dbServer = left(dbServer,instr(dbServer,":")-1):end if:database = trim(cstr(database)):username = trim(cstr(username)):password = trim(cstr(password)):select case dbType:case 0:if OW.isNul(password) then:s = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& OW.serverMapPath(sitePath & dbServer):else:s = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& OW.serverMapPath(sitePath & dbServer) &";Jet OLEDB:Database Password="& password &";":end if:case 1:if port<>"" then dbServer = dbServer &","& port : end if:if username="" then:s = "provider=sqloledb;data source="& dbServer &";initial catalog="& database &";integrated security=SSPI;":else:s = "provider=sqloledb;data source="& dbServer &";initial catalog="& database &";user id="& username &";password="& password &";":end if:end select:openConn(s):end function:public function openConn(byval connStr):on error resume next : err.clear:dim timestart : timestart = timer():call console.log("<span class=""text"">OW.DB.openConn</span>"):if typename(oConn) = "Connection" then exit function : end if:dim i,accDBName : accDBName = OW.getFileName(DB_ACCESS_PATH,false):set oConn = server.createObject("ADODB.connection"):oConn.Open connStr:if err.number<>0 then:if dbType=0 then:call OW.FSO.deleteFile(OW.FSO.ABSPath("ow-content/data/"& accDBName &".ldb")):end if:oConn.close : set oConn = nothing:OW.Error.msg = "无法连接"& OW.iif(dbType=0,"ACCESS","MSSQL") &"数据库，请检查文件ow.config里的数据库配置信息是否正确!":OW.Error.raise 13:oConn.errors.clear:err.clear:else:if oConn.errors.count<>0 then:for i=0 to oConn.errors.count-1:call console.log("<span class=""text"">OW.DB.openConn.errors.item("& i &")</span><span class=""error"">"& oConn.errors.item(i) &"</span>"):next:end if:end if:call console.log("<span class=""text"">OW.DB.openConn:end</span><span class=""runtime-item"">耗时"& OW.parseRuntime(Timer()-timestart) &"</span>"):end function:public function execute(byval sql):dim timestart : timestart = timer():sql = trim(sql):if typename(oConn)<>"Connection" then connectionDatabase : end if:if ucase(left(sql,6))="SELECT" then:   dim i : i = iQueryType:iQueryType = 1:set execute = getRecordBySQL(sql):iQueryType = i:else:on error resume next:err.clear:dim cmd : set cmd = server.createObject("ADODB.Command"):with cmd: cmd.ActiveConnection = oConn: cmd.CommandText = sql: cmd.execute:end with:set cmd = nothing:if isSQLQueryNumCount then iSqlQueryNum = iSqlQueryNum + 1 : end if:call console.log("<span class=""db-sql"" name=""sql""><span class=""sql"">"& sql &"</span><span class=""runtime-item"">查询耗时"& OW.parseRuntime(Timer()-timestart) &"</span></span>"):if err.number<>0 then:execute = false:OW.Error.msg = "OW.DB.execute: "& sql:OW.Error.raise 15:err.clear:else:execute = true:end if:end if:end function:public function getRecord(byval table, byval condition, byval otherCondition):set getRecord = getRecordBySQL(wGetRecordSQL(table,condition,otherCondition)):end function:public function getRecordBySQL(byval sql):dim timestart : timestart = timer():on error resume next:err.clear:if typename(oConn) <> "Connection" then connectionDatabase : end if:if iQueryType = 1 then:dim cmd : set cmd = server.createObject("ADODB.Command"):with cmd:cmd.ActiveConnection = oConn:cmd.CommandText = sql:set getRecordBySQL = cmd.execute:end with:set cmd = nothing:else:set oRs = server.createObject("Adodb.Recordset"):with oRs:oRs.ActiveConnection = oConn:oRs.CursorType = 1:oRs.LockType = 1:oRs.Source = sql:oRs.Open:end with:set getRecordBySQL = oRs:set oRs = nothing:end if:if isSQLQueryNumCount then iSqlQueryNum = iSqlQueryNum + 1 : end if:call console.log("<span class=""db-sql"" name=""sql""><span class=""sql"">"& sql &"</span><span class=""runtime-item"">查询耗时"& OW.parseRuntime(Timer()-timestart) &"</span></span>"):if err.number<>0 then:OW.Error.msg = "OW.DB.getRecordBySQL: "& sql:OW.Error.raise 14:err.clear:end if:end function:public function addRecord(byval table, byval valueList):dim sql : sql = wAddRecordSQL(table,valueList):addRecord = OW.DB.execute(sql):end function:public function updateRecord(byval table, byval valueList, byval condition):dim sql : sql = wUpdateRecordSQL(table,valueList,condition):updateRecord = OW.DB.execute(sql):end function:public function deleteRecord(byval table, byval condition):dim sql : sql = wDeleteRecordSQL(table,condition):deleteRecord = OW.DB.execute(sql):end function:public function wGetRecordSQL(byval table, byval condition, byval otherCondition):if left(table,1)="[" then table = trim(mid(table,2,Len(table-2))) : end if:dim arr,fArr,fields,top,s,sql:    top = 0:arr = OW.param(table):    table = trim(arr(0)):if not(OW.isNul(arr(1))) then:fArr = OW.param(arr(1)):if OW.IsNum(fArr(0)) then:top = fArr(0):else:fields = trim(fArr(0)):end if:if not(OW.isNul(fArr(1))) then:fields = trim(fArr(1)):end if:end if:if IsArray(condition) then:s = valueToSQL(1,table,condition):else:s = condition:end if:sql="SELECT ":if top > 0 then sql = sql & "TOP "& top &" " : end if:sql = sql & OW.iif(fields <> "", fields, "*") & " FROM ["& table &"] ":if trim(s) <> "" then:sql = sql & "WHERE " & s &" ":if trim(otherCondition) <> "" then sql = sql & otherCondition : end if:if auxSQLValid then sql = sql &" AND "& auxSQL : end if:else:if trim(otherCondition) <> "" then:sql = sql &" WHERE "& otherCondition:if auxSQLValid then sql = sql &" AND "& auxSQL : end if:else:if auxSQLValid then sql = sql &" WHERE "& auxSQL : end if:end if:end if:wGetRecordSQL = sql:end function:public function wAddRecordSQL(byval table, byval valueList):dim sql:sql = "INSERT INTO ["& table &"] ("& valueToSQL(2,table,valueList) &") VALUES ("& valueToSQL(3,table,valueList) &")":wAddRecordSQL = sql:end function:public function wUpdateRecordSQL(byval table, byval valueList, byval condition):dim v,w,sql:v = OW.iif(IsArray(valueList),valueToSQL(4,table,valueList),valueList):if not(OW.isNul(condition)) then:w = " WHERE "& OW.iif(IsArray(condition),valueToSQL(1,table,condition),condition):if auxSQLValid then w = w &" AND "& auxSQL : end if:else:if auxSQLValid then w = " WHERE "& auxSQL : end if:end if:sql = "UPDATE ["& table &"] SET " & v & w:wUpdateRecordSQL = sql:end function:public function wDeleteRecordSQL(byval table, byval condition):dim s,sql:if IsArray(condition) then:s = valueToSQL(1,table,condition):else:s = condition:end if:sql = "DELETE FROM ["& table &"]":if trim(s) <> "" then:sql = sql &" WHERE "& s &"":if auxSQLValid then sql = " AND "& auxSQL : end if:else:if auxSQLValid then sql = " WHERE "& auxSQL : end if:end if:wDeleteRecordSQL = sql:end function:public function copyColumnData(byval table, byval a, byval b):copyColumnData = OW.DB.execute("UPDATE "& table &" SET "& b &" = "& a &""):end function:public function isTableExists(byval table):on error resume next:err.clear:if typename(oConn) <> "Connection" then connectionDatabase : end if:dim rs,result : result = true:set rs = server.createObject("Adodb.Recordset"):with rs:rs.ActiveConnection = oConn:rs.CursorType = 1:rs.LockType = 1:rs.Source = "SELECT * FROM ["& table &"]":rs.Open:end with:set rs = nothing:if err.number<>0 then:result = false:err.clear:end if:isTableExists = result:end function:public function isColumnExist(byval table, byval f):dim i,rs,result : result = false:set rs = OW.DB.getRecordBySQL("SELECT * FROM ["& table &"]"):for i=0 to rs.fields.count-1 :if lcase(rs.fields(i).name) = lcase(f) then:result = true:exit for:end if:next:OW.DB.closeRs rs:isColumnExist = result:end function:public function isRecordExists(byval table, byval condition, byval otherCondition):set oRs = getRecord(table,condition,otherCondition):if oRs.eof then:bResult = false:else:bResult = true:end if:OW.DB.closeRs oRs:isRecordExists = bResult:end function:public function isRecordExistsBySQL(byval sql):set oRs = getRecordBySQL(sql):if oRs.eof then:bResult = false:else:bResult = true:end if:OW.DB.closeRs oRs:isRecordExistsBySQL = bResult:end function:public function addColumn(byval table, byval column):select case dbType:case 0:addColumn = OW.DB.execute("ALTER TABLE ["& table &"] ADD COLUMN "& column &""):case 1:addColumn = OW.DB.execute("ALTER TABLE ["& table &"] ADD "& column &""):end select:end function:public function editColumn(byval table, byval oldColumn, byval newColumn):select case dbType:case "0","ACCESS":editColumn = false:case "1","MSSQL":editColumn = OW.DB.execute("exec sp_rename '"& table &"."& oldColumn &"','"& newColumn &"','column'"):end select:end function:public function deleteColumn(byval table, byval col):if left(col,1)<>"[" then col = "["& col &"]" : end if:deleteColumn = OW.DB.execute("ALTER TABLE ["& table &"] DROP COLUMN "& col &""):end function:public function deleteTable(byval table):dim sql:select case dbType:case 0:sql = "drop table "& table &"":case 1:sql = "if exists (select * from dbo.sysobjects where id = object_id(N'["& table &"]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table ["& table &"]":end select:if isTableExists(table) then:deleteTable = OW.DB.execute(Sql):else:deleteTable = false:end if:end function:public function getDiyField(byval table,byval tableAs):dim f,result:if tableAs <> "" then tableAs = trim(tableAs) &"." : end if:set oRs = OW.DB.getRecordBySQL("SELECT * FROM ["& table &"]"):For iI=0 To oRs.Fields.Count-1 :f = oRs.Fields(iI).Name:if lcase(left(f,Len(fieldPre))) = lcase(fieldPre) then:f  = tableAs & f:if result = "" then:result = f:else:result = result &","& f:end if:end if:Next:OW.DB.closeRs oRs:getDiyField = result:end function:public function getFieldValue(byval table, byval field, byval condition,byval otherCondition):set oRs = getRecord(table &":"& field,condition,otherCondition):if oRs.eof then:sString = "":else:sString = oRs(0):end if:OW.DB.closeRs oRs:getFieldValue = sString:end function:public function getFieldValueBySQL(sql):dim i,len,a,arr,hasData:set oRs = getRecordBySQL(sql):len = oRs.fields.count:if oRs.eof then:hasData = false:sString = "":else:hasData = true:arr = oRs.getRows():end if:OW.DB.closeRs oRs:if hasData then:if ubound(arr,2)=0 then:redim a(len-1):for i=0 to len-1:a(i) = arr(i,0):next:if len>1 then:getFieldValueBySQL = a:else:getFieldValueBySQL = a(0):end if:else:if len>1 then:getFieldValueBySQL = arr:else:redim a(ubound(arr,2)):for i=0 to ubound(arr,2):a(i) = arr(0,i):next:getFieldValueBySQL = a:end if:end if:else:if len>1 then:redim a(len-1):getFieldValueBySQL = a:else:getFieldValueBySQL = "":end if:end if:end function:public function getFieldValueByMaxID(byval table, byval fieldName, byval idField):set oRs = getRecordBySQL("SELECT TOP 1 ["& fieldName &"] FROM ["& table &"] WHERE "& auxSQL &" ORDER BY "& idField &" DESC"):if oRs.eof then:sString = "":else:sString = oRs(0):end if:OW.DB.closeRs oRs:getFieldValueByMaxID = sString:end function:public function fieldLoc(byval f,byval a):dim i : i = 0:f = lcase(trim(f)):for iI=0 To Ubound(a):if f = lcase(a(iI)) then:i = iI+1:end if:next:fieldLoc = i:end function:public function maxID(byval table,byval idField):set oRs = getRecordBySQL("SELECT MAX("& idField &") FROM ["& table &"] WHERE "& auxSQL &""):if not(oRs.eof) then:sString = oRs(0):else:sString = 0:end if:OW.DB.closeRs oRs:maxID = OW.int(sString):end function:public function maxCID():set oRs = getRecordBySQL("SELECT MAX(cid) FROM ["& OW.DB.Table.content &"]"):if not(oRs.eof) then:sString = oRs(0):else:sString = 0:end if:OW.DB.closeRs oRs:maxCID = OW.int(sString):end function:public function maxGID():maxGID = OW.DB.maxID(OW.DB.Table.goods,"gid"):end function:public function getColumnFieldType(byval dbTable,byval dbField):dim rs,fieldType:set rs = OW.DB.execute("SELECT "& dbField &" FROM ["& dbTable &"] WHERE 1=0"):fieldType = rs.fields(dbField).type:OW.DB.closeRs rs:getColumnFieldType = fieldType:end function:public function getFieldType(byval fieldName,byref fields):dim i:for i=0 to fields.count-1:if fields(i).name = fieldName then:getFieldType = fields(i).type : exit for:end if:next:end function:public function valueToSQL(byval t, byval table, byval valueList):on error resume next:t = int(t):dim arr,s : s = valueList:if isArray(valueList) then:s = "":dim i,f,v,rs,sql,tfv:sql = "SELECT * FROM ["& table &"] WHERE 1=0":set rs = OW.DB.execute(sql):for i=0 to Ubound(valueList):if i>0 then s = s & OW.iif(t=1," AND ",",") : end if:if instr(valueList(i),":")>0 then:arr = OW.param(valueList(i)):f = trim(arr(0)):    v = trim(arr(1)):if t = 2 then:s = trim(s):s = s &"["& f &"]":else:select case rs.fields(f).type:case 129,200,201,130,202,203,8,133,134:if t = 1 then:if OW.isNul(v) then:s = s & "(Len(["& f &"])=0 OR ["& f &"] IS NULL)":else:s = s & OW.iif(lcase(v)="null","["& f &"] IS NULL","["& f &"]='"& v &"'"):end if:end if:if t = 3 or t = 4 then:if t = 4 then s = s & "["& f &"]=" : end if:if OW.isNul(v) then:s = s & "''":else:s = s & OW.iif(lcase(v)="null","NULL","'"& v &"'"):end if:end if:case 135,7:if t = 1 then:if OW.isNul(v) then:s = s & "(Len(["& f &"])=0 OR ["& f &"] IS NULL)":else:s = s & OW.iif(lcase(v)="null","["& f &"] IS NULL","["& f &"]='"& v &"'"):end if:end if:if t = 3 or t = 4 then:if t = 4 then s = s & "["& f &"]=" : end if:if OW.isNul(v) then:s = s & OW.iif(dbType=0,"0","''"):else:s = s & OW.iif(lcase(v)="null","NULL","'"& v &"'"):end if:end if:case 11:tfv = lcase(cstr(v)):if t = 1 then:if OW.isNul(v) then:s = s & "( LEN(["& f &"])=0 OR ["& f &"] IS NULL )":else:s = s & OW.iif(lcase(v)="null","["& f &"] IS NULL","["& f &"]='"& v &"'"):end if:end if:if t = 3 or t = 4 then:if t = 4 then s = s & "["& f &"]=" : end if:if OW.isNul(v) then:s = s & "''":else:if tfv="true" or tfv = "1" then:s = s & OW.iif(dbType=0,"true","1"):else:if tfv="false" or tfv = "0" then:s = s & OW.iif(dbType=0,"false","0"):else:s = s & OW.iif(tfv="null","NULL", v ):end if:end if:end if:end if:case else:if t = 1 then:if OW.isNul(v) then:s = s & "(Len(["& f &"])=0 OR ["& f &"] IS NULL)":else:s = s & OW.iif(lcase(v)="null","["& f &"] IS NULL","["& f &"]="& v &""):end if:end if:if t = 3 or t = 4 then:if t = 4 then s = s & "["& f &"]=" : end if:if OW.isNul(v) then:s = s & "0":else:s = s & OW.iif(lcase(v)="null","NULL",v):end if:end if:end select:end if:else:s = s & valueList(i):end if:next:rs.close():set rs = nothing:if err.number<>0 then:OW.Error.msg = "OW.DB.valueToSQL: "& sql &"<br>"& s:OW.Error.raise 17:err.clear:end if:end if:valueToSQL = s:end function:public function createDBTable(byval table,byval tableType):dim sql,cresult:table = trim(table):if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if:if tableType="content" then:select case DB_TYPE:case 0:sql = "CREATE TABLE ["& table &"] (":sql = sql & "[cid] integer IDENTITY (1,1) PRIMARY KEY NOT NULL,":sql = sql & "[cate_id] integer NOT NULL,":sql = sql & "[ex1_cate_id] integer NULL,":sql = sql & "[ex2_cate_id] integer NULL,":sql = sql & "[type_id1] text (100) NULL,":sql = sql & "[type_id2] text (100) NULL,":sql = sql & "[type_id3] text (100) NULL,":sql = sql & "[type_id4] text (100) NULL,":sql = sql & "[type_id5] text (100) NULL,":sql = sql & "[type_id6] text (100) NULL,":sql = sql & "[type_id7] text (100) NULL,":sql = sql & "[type_id8] text (100) NULL,":sql = sql & "[sequence] integer NOT NULL,":sql = sql & "[status] integer NOT NULL,":sql = sql & "[title] text (100) NOT NULL,":sql = sql & "[font_color] text (7) NULL,":sql = sql & "[font_weight] integer NULL,":sql = sql & "[subtitle] text (100) NULL,":sql = sql & "[root_id] integer NULL,":sql = sql & "[rootpath] text (64) NULL,":sql = sql & "[urlpath] text (64) NULL,":sql = sql & "[url] text (255) NULL,":sql = sql & "[views] integer NOT NULL,":sql = sql & "[post_time] date NULL,":sql = sql & "[update_time] date NULL,":sql = sql & "[summary] text (250) NULL,":sql = sql & "[recommend] integer NOT NULL":sql = sql & ")":cresult = OW.DB.execute(sql):if cresult then:call OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])"):call OW.DB.execute("CREATE INDEX IDX_ex1_cate_id ON ["& table &"] ([ex1_cate_id])"):call OW.DB.execute("CREATE INDEX IDX_ex2_cate_id ON ["& table &"] ([ex2_cate_id])"):call OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])"):end if:case 1:sql = "CREATE TABLE ["& table &"] (":sql = sql & "[cid] [int] IDENTITY (1,1) NOT NULL,":sql = sql & "[cate_id] [int] NOT NULL,":sql = sql & "[ex1_cate_id] [int] NULL,":sql = sql & "[ex2_cate_id] [int] NULL,":sql = sql & "[type_id1] [nvarchar] (100) NULL,":sql = sql & "[type_id2] [nvarchar] (100) NULL,":sql = sql & "[type_id3] [nvarchar] (100) NULL,":sql = sql & "[type_id4] [nvarchar] (100) NULL,":sql = sql & "[type_id5] [nvarchar] (100) NULL,":sql = sql & "[type_id6] [nvarchar] (100) NULL,":sql = sql & "[type_id7] [nvarchar] (100) NULL,":sql = sql & "[type_id8] [nvarchar] (100) NULL,":sql = sql & "[sequence] [int] NOT NULL,":sql = sql & "[status] [tinyint] NOT NULL,":sql = sql & "[title] [nvarchar] (100) NOT NULL,":sql = sql & "[font_color] [nvarchar] (7) NULL,":sql = sql & "[font_weight] [int] NULL,":sql = sql & "[subtitle] [nvarchar] (100) NULL,":sql = sql & "[root_id] [int] NULL,":sql = sql & "[rootpath] [nvarchar] (64) NULL,":sql = sql & "[urlpath] [nvarchar] (64) NULL,":sql = sql & "[url] [nvarchar] (255) NULL,":sql = sql & "[views] [int] NOT NULL,":sql = sql & "[post_time] [datetime] NULL,":sql = sql & "[update_time] [datetime] NULL,":sql = sql & "[summary] [nvarchar] (250) NULL,":sql = sql & "[recommend] [tinyint] NOT NULL":sql = sql & ")":cresult = OW.DB.execute(sql):if cresult then:call OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cid]) ON [PRIMARY]"):call OW.DB.execute("CREATE INDEX IDX_cate_id ON ["& table &"] ([cate_id])"):call OW.DB.execute("CREATE INDEX IDX_ex1_cate_id ON ["& table &"] ([ex1_cate_id])"):call OW.DB.execute("CREATE INDEX IDX_ex2_cate_id ON ["& table &"] ([ex2_cate_id])"):call OW.DB.execute("CREATE INDEX IDX_sequence ON ["& table &"] ([sequence])"):end if:end select:end if:if tableType="content.data" then:select case DB_TYPE:case 0:sql = "CREATE TABLE ["& table &"] (":sql = sql & "[cid] integer PRIMARY KEY NOT NULL,":sql = sql & "[seo_title] text (250) NULL,":sql = sql & "[keywords] text (250) NULL,":sql = sql & "[description] text (250) NULL,":sql = sql & "[content] memo NULL,":sql = sql & "[mob_content] memo NULL":sql = sql & ")":cresult = OW.DB.execute(sql):case 1:sql = "CREATE TABLE ["& table &"] (":sql = sql & "[cid] [int] NOT NULL,":sql = sql & "[seo_title] [nvarchar] (250) NULL,":sql = sql & "[keywords] [nvarchar] (250) NULL,":sql = sql & "[description] [nvarchar] (250) NULL,":sql = sql & "[content] [ntext] NULL,":sql = sql & "[mob_content] [ntext] NULL":sql = sql & ")":cresult = OW.DB.execute(sql):if cresult then:call OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED ([cid]) ON [PRIMARY]"):end if:end select:end if:createDBTable = cresult:end function:public function createModelTable(byval table,byval primaryKey):dim sql,cresult:table = trim(table):if OW.DB.isTableExists(table) then OW.DB.deleteTable(table) : end if:select case DB_TYPE:case 0:sql = "CREATE TABLE ["& table &"] (":sql = sql & "["& primaryKey &"] integer PRIMARY KEY NOT NULL":sql = sql & ")":cresult = OW.DB.execute(sql):case 1:sql = "CREATE TABLE ["& table &"] (":sql = sql & "["& primaryKey &"] [int] NOT NULL":sql = sql & ")":cresult = OW.DB.execute(sql):if cresult then:call OW.DB.execute("ALTER TABLE ["& table &"] WITH NOCHECK ADD CONSTRAINT [PK_"& table &"] PRIMARY KEY CLUSTERED (["& primaryKey &"]) ON [PRIMARY]"):end if:end select:end function:end class:%>
<%
class OW_MD5_Class
	
	private BITS_TO_A_BYTE,BYTES_TO_A_WORD,BITS_TO_A_WORD
	
	private m_lOnBits(30)
	private m_l2Power(30)
	
	private sub class_initialize()
		BITS_TO_A_BYTE  = 8
		BYTES_TO_A_WORD = 4
		BITS_TO_A_WORD  = 32
		
	end sub
	
	public function encode(byval s)
		s = trim(s)
		if s = "" then encrypt = "" : exit function : end if
		encode = MD5(s,OW.charset)
	end function
	
	public function encrypt(byval s)
		s = trim(s)
		if s = "" then encrypt = "" : exit function : end if
		encrypt = MD5(s,lcase(OW.charset))
	end function
	
	private function LShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			LShift = lValue
			Exit function
		ElseIf iShiftBits = 31 then
			if lValue And 1 then
				LShift = &H80000000
			else
				LShift = 0
			end if
			Exit function
		ElseIf iShiftBits < 0 Or iShiftBits > 31 then
			Err.Raise 6
		end if
	
		if (lValue And m_l2Power(31 - iShiftBits)) then
			LShift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000
		else
			LShift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
		end if
	end function
	
	private function str2bin(varstr) 
		dim varasc
		dim i
		dim varchar
		dim varlow
		dim varhigh
		
		str2bin="" 
		for i=1 to Len(varstr) 
			varchar=mid(varstr,i,1) 
			varasc = Asc(varchar) 
			
			if varasc<0 then
			varasc = varasc + 65535 
			end if 
			
			if varasc>255 then
			varlow = Left(Hex(Asc(varchar)),2) 
			varhigh = right(Hex(Asc(varchar)),2) 
			str2bin = str2bin & chrB("&H" & varlow) & chrB("&H" & varhigh) 
			else 
			str2bin = str2bin & chrB(AscB(varchar)) 
			end if 
		next 
	end function 
	
	private function str2bin_utf(varstr)
		dim varchar, code, codearr, j, i
		str2bin_utf = ""
		for i=1 to Len(varstr)
			varchar = Mid(varstr,i,1)
			code = Server.UrlEncode(varchar)
			if(code="+") then code="%20" : end if
			if Len(code) = 1 then
			   str2bin_utf = str2bin_utf & chrB(AscB(code))
			else
			   codearr = Split(code,"%")
			   for j = 1 to UBound(codearr)
				  str2bin_utf = str2bin_utf & ChrB("&H" & codearr(j))
			   next
			 end if
		next
	end function
	
	private function RShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			RShift = lValue
			Exit function
		ElseIf iShiftBits = 31 then
			if lValue And &H80000000 then
				RShift = 1
			else
				RShift = 0
			end if
			Exit function
		ElseIf iShiftBits < 0 Or iShiftBits > 31 then
			Err.Raise 6
		end if
	
		RShift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)
	
		if (lValue And &H80000000) then
			RShift = (RShift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))
		end if
	end function
	
	private function RotateLeft(lValue, iShiftBits)
		RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))
	end function
	
	private function AddUnsigned(lX, lY)
		dim lX4
		dim lY4
		dim lX8
		dim lY8
		dim lResult
	
		lX8 = lX And &H80000000
		lY8 = lY And &H80000000
		lX4 = lX And &H40000000
		lY4 = lY And &H40000000
		
		lResult = (lX And &H3FFFFFFF) + (lY And &H3FFFFFFF)
	
		if lX4 And lY4 then
			lResult = lResult Xor &H80000000 Xor lX8 Xor lY8
		ElseIf lX4 Or lY4 then
			if lResult And &H40000000 then
				lResult = lResult Xor &HC0000000 Xor lX8 Xor lY8
			else
				lResult = lResult Xor &H40000000 Xor lX8 Xor lY8
			end if
		else
			lResult = lResult Xor lX8 Xor lY8
		end if
	
		AddUnsigned = lResult
	end function
	
	private function md5_F(x, y, z)
		md5_F = (x And y) Or ((Not x) And z)
	end function
	
	private function md5_G(x, y, z)
		md5_G = (x And z) Or (y And (Not z))
	end function
	
	private function md5_H(x, y, z)
		md5_H = (x Xor y Xor z)
	end function
	
	private function md5_I(x, y, z)
		md5_I = (y Xor (x Or (Not z)))
	end function
	
	private Sub md5_FF(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_F(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end Sub
	
	private Sub md5_GG(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_G(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end Sub
	
	private Sub md5_HH(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_H(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end Sub
	
	private Sub md5_II(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_I(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end Sub
	
	private function ConvertToWordArray(sMessage)
		dim lMessageLength
		dim lNumberOfWords
		dim lWordArray()
		dim lBytePosition
		dim lByteCount
		dim lWordCount
		
		Const MODULUS_BITS = 512
		Const CONGRUENT_BITS = 448
		
		lMessageLength = LenB(sMessage)
		
		lNumberOfWords = (((lMessageLength + ((MODULUS_BITS - CONGRUENT_BITS) \ BITS_TO_A_BYTE)) \ (MODULUS_BITS \ BITS_TO_A_BYTE)) + 1) * (MODULUS_BITS \ BITS_TO_A_WORD)
		ReDim lWordArray(lNumberOfWords - 1)
		
		lBytePosition = 0
		lByteCount = 0
		Do Until lByteCount >= lMessageLength
			lWordCount = lByteCount \ BYTES_TO_A_WORD
			lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE
			lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(AscB(MidB(sMessage, lByteCount + 1, 1)), lBytePosition)
			lByteCount = lByteCount + 1
		Loop
	
		lWordCount = lByteCount \ BYTES_TO_A_WORD
		lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE
		
		lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(&H80, lBytePosition)
		
		lWordArray(lNumberOfWords - 2) = LShift(lMessageLength, 3)
		lWordArray(lNumberOfWords - 1) = RShift(lMessageLength, 29)
	
		ConvertToWordArray = lWordArray
	end function
	
	private function WordToHex(lValue)
		dim lByte
		dim lCount
		
		for lCount = 0 to 3
			lByte = RShift(lValue, lCount * BITS_TO_A_BYTE) And m_lOnBits(BITS_TO_A_BYTE - 1)
			WordToHex = WordToHex & Right("0" & Hex(lByte), 2)
		next
	end function
	
	private function MD5(sMessage,input_charset)
		m_lOnBits(0) = CLng(1)
		m_lOnBits(1) = CLng(3)
		m_lOnBits(2) = CLng(7)
		m_lOnBits(3) = CLng(15)
		m_lOnBits(4) = CLng(31)
		m_lOnBits(5) = CLng(63)
		m_lOnBits(6) = CLng(127)
		m_lOnBits(7) = CLng(255)
		m_lOnBits(8) = CLng(511)
		m_lOnBits(9) = CLng(1023)
		m_lOnBits(10) = CLng(2047)
		m_lOnBits(11) = CLng(4095)
		m_lOnBits(12) = CLng(8191)
		m_lOnBits(13) = CLng(16383)
		m_lOnBits(14) = CLng(32767)
		m_lOnBits(15) = CLng(65535)
		m_lOnBits(16) = CLng(131071)
		m_lOnBits(17) = CLng(262143)
		m_lOnBits(18) = CLng(524287)
		m_lOnBits(19) = CLng(1048575)
		m_lOnBits(20) = CLng(2097151)
		m_lOnBits(21) = CLng(4194303)
		m_lOnBits(22) = CLng(8388607)
		m_lOnBits(23) = CLng(16777215)
		m_lOnBits(24) = CLng(33554431)
		m_lOnBits(25) = CLng(67108863)
		m_lOnBits(26) = CLng(134217727)
		m_lOnBits(27) = CLng(268435455)
		m_lOnBits(28) = CLng(536870911)
		m_lOnBits(29) = CLng(1073741823)
		m_lOnBits(30) = CLng(2147483647)
		
		m_l2Power(0) = CLng(1)
		m_l2Power(1) = CLng(2)
		m_l2Power(2) = CLng(4)
		m_l2Power(3) = CLng(8)
		m_l2Power(4) = CLng(16)
		m_l2Power(5) = CLng(32)
		m_l2Power(6) = CLng(64)
		m_l2Power(7) = CLng(128)
		m_l2Power(8) = CLng(256)
		m_l2Power(9) = CLng(512)
		m_l2Power(10) = CLng(1024)
		m_l2Power(11) = CLng(2048)
		m_l2Power(12) = CLng(4096)
		m_l2Power(13) = CLng(8192)
		m_l2Power(14) = CLng(16384)
		m_l2Power(15) = CLng(32768)
		m_l2Power(16) = CLng(65536)
		m_l2Power(17) = CLng(131072)
		m_l2Power(18) = CLng(262144)
		m_l2Power(19) = CLng(524288)
		m_l2Power(20) = CLng(1048576)
		m_l2Power(21) = CLng(2097152)
		m_l2Power(22) = CLng(4194304)
		m_l2Power(23) = CLng(8388608)
		m_l2Power(24) = CLng(16777216)
		m_l2Power(25) = CLng(33554432)
		m_l2Power(26) = CLng(67108864)
		m_l2Power(27) = CLng(134217728)
		m_l2Power(28) = CLng(268435456)
		m_l2Power(29) = CLng(536870912)
		m_l2Power(30) = CLng(1073741824)
		
		
		dim x
		dim k
		dim AA
		dim BB
		dim CC
		dim DD
		dim a
		dim b
		dim c
		dim d
		
		Const S11 = 7
		Const S12 = 12
		Const S13 = 17
		Const S14 = 22
		Const S21 = 5
		Const S22 = 9
		Const S23 = 14
		Const S24 = 20
		Const S31 = 4
		Const S32 = 11
		Const S33 = 16
		Const S34 = 23
		Const S41 = 6
		Const S42 = 10
		Const S43 = 15
		Const S44 = 21
		
		if LCase(input_charset) = "utf-8" then
			x = ConvertToWordArray(str2bin_utf(sMessage))
		else
			x = ConvertToWordArray(str2bin(sMessage))
		end if
		
		a = &H67452301
		b = &HEFCDAB89
		c = &H98BADCFE
		d = &H10325476
		
		for k = 0 to UBound(x) Step 16
			AA = a
			BB = b
			CC = c
			DD = d
			
			md5_FF a, b, c, d, x(k + 0), S11, &HD76AA478
			md5_FF d, a, b, c, x(k + 1), S12, &HE8C7B756
			md5_FF c, d, a, b, x(k + 2), S13, &H242070DB
			md5_FF b, c, d, a, x(k + 3), S14, &HC1BDCEEE
			md5_FF a, b, c, d, x(k + 4), S11, &HF57C0FAF
			md5_FF d, a, b, c, x(k + 5), S12, &H4787C62A
			md5_FF c, d, a, b, x(k + 6), S13, &HA8304613
			md5_FF b, c, d, a, x(k + 7), S14, &HFD469501
			md5_FF a, b, c, d, x(k + 8), S11, &H698098D8
			md5_FF d, a, b, c, x(k + 9), S12, &H8B44F7AF
			md5_FF c, d, a, b, x(k + 10), S13, &HFFFF5BB1
			md5_FF b, c, d, a, x(k + 11), S14, &H895CD7BE
			md5_FF a, b, c, d, x(k + 12), S11, &H6B901122
			md5_FF d, a, b, c, x(k + 13), S12, &HFD987193
			md5_FF c, d, a, b, x(k + 14), S13, &HA679438E
			md5_FF b, c, d, a, x(k + 15), S14, &H49B40821
			
			md5_GG a, b, c, d, x(k + 1), S21, &HF61E2562
			md5_GG d, a, b, c, x(k + 6), S22, &HC040B340
			md5_GG c, d, a, b, x(k + 11), S23, &H265E5A51
			md5_GG b, c, d, a, x(k + 0), S24, &HE9B6C7AA
			md5_GG a, b, c, d, x(k + 5), S21, &HD62F105D
			md5_GG d, a, b, c, x(k + 10), S22, &H2441453
			md5_GG c, d, a, b, x(k + 15), S23, &HD8A1E681
			md5_GG b, c, d, a, x(k + 4), S24, &HE7D3FBC8
			md5_GG a, b, c, d, x(k + 9), S21, &H21E1CDE6
			md5_GG d, a, b, c, x(k + 14), S22, &HC33707D6
			md5_GG c, d, a, b, x(k + 3), S23, &HF4D50D87
			md5_GG b, c, d, a, x(k + 8), S24, &H455A14ED
			md5_GG a, b, c, d, x(k + 13), S21, &HA9E3E905
			md5_GG d, a, b, c, x(k + 2), S22, &HFCEFA3F8
			md5_GG c, d, a, b, x(k + 7), S23, &H676F02D9
			md5_GG b, c, d, a, x(k + 12), S24, &H8D2A4C8A
			
			md5_HH a, b, c, d, x(k + 5), S31, &HFFFA3942
			md5_HH d, a, b, c, x(k + 8), S32, &H8771F681
			md5_HH c, d, a, b, x(k + 11), S33, &H6D9D6122
			md5_HH b, c, d, a, x(k + 14), S34, &HFDE5380C
			md5_HH a, b, c, d, x(k + 1), S31, &HA4BEEA44
			md5_HH d, a, b, c, x(k + 4), S32, &H4BDECFA9
			md5_HH c, d, a, b, x(k + 7), S33, &HF6BB4B60
			md5_HH b, c, d, a, x(k + 10), S34, &HBEBFBC70
			md5_HH a, b, c, d, x(k + 13), S31, &H289B7EC6
			md5_HH d, a, b, c, x(k + 0), S32, &HEAA127FA
			md5_HH c, d, a, b, x(k + 3), S33, &HD4EF3085
			md5_HH b, c, d, a, x(k + 6), S34, &H4881D05
			md5_HH a, b, c, d, x(k + 9), S31, &HD9D4D039
			md5_HH d, a, b, c, x(k + 12), S32, &HE6DB99E5
			md5_HH c, d, a, b, x(k + 15), S33, &H1FA27CF8
			md5_HH b, c, d, a, x(k + 2), S34, &HC4AC5665
			
			md5_II a, b, c, d, x(k + 0), S41, &HF4292244
			md5_II d, a, b, c, x(k + 7), S42, &H432AFF97
			md5_II c, d, a, b, x(k + 14), S43, &HAB9423A7
			md5_II b, c, d, a, x(k + 5), S44, &HFC93A039
			md5_II a, b, c, d, x(k + 12), S41, &H655B59C3
			md5_II d, a, b, c, x(k + 3), S42, &H8F0CCC92
			md5_II c, d, a, b, x(k + 10), S43, &HFFEFF47D
			md5_II b, c, d, a, x(k + 1), S44, &H85845DD1
			md5_II a, b, c, d, x(k + 8), S41, &H6FA87E4F
			md5_II d, a, b, c, x(k + 15), S42, &HFE2CE6E0
			md5_II c, d, a, b, x(k + 6), S43, &HA3014314
			md5_II b, c, d, a, x(k + 13), S44, &H4E0811A1
			md5_II a, b, c, d, x(k + 4), S41, &HF7537E82
			md5_II d, a, b, c, x(k + 11), S42, &HBD3AF235
			md5_II c, d, a, b, x(k + 2), S43, &H2AD7D2BB
			md5_II b, c, d, a, x(k + 9), S44, &HEB86D391
			
			a = AddUnsigned(a, AA)
			b = AddUnsigned(b, BB)
			c = AddUnsigned(c, CC)
			d = AddUnsigned(d, DD)
		next
		
		MD5 = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))
	end function
end class

class OW_MD6_Class
	private m_lOnBits(30)
	private m_l2Power(30)
	private BITS_TO_A_BYTE,BYTES_TO_A_WORD,BITS_TO_A_WORD
	private Pv_Md5Bits
	
	private sub class_initialize()
		BITS_TO_A_BYTE  = 8
		BYTES_TO_A_WORD = 4
		BITS_TO_A_WORD  = 32
		Pv_Md5Bits      = 32
	end sub
	
	'**设置生成的MD5的位数
	public Property Let MD5Bits(byval BV_Bits)
		Pv_Md5Bits = BV_Bits
	end property
	public property Get MD5Bits()
		MD5Bits = Pv_Md5Bits
	end property
	
	private function LShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			LShift = lValue
			exit function
		elseIf iShiftBits = 31 then
			if lValue and 1 then
				LShift = &H80000000
			else
				LShift = 0
			end if
			exit function
		elseIf iShiftBits < 0 or iShiftBits > 31 then
			Err.Raise 6
		end if
	
		if (lValue and m_l2Power(31 - iShiftBits)) then
			LShift = ((lValue and m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) or &H80000000
		else
			LShift = ((lValue and m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
		end if
	end function
	
	private function RShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			RShift = lValue
			exit function
		elseIf iShiftBits = 31 then
			if lValue and &H80000000 then
				RShift = 1
			else
				RShift = 0
			end if
			exit function
		elseIf iShiftBits < 0 or iShiftBits > 31 then
			Err.Raise 6
		end if
	
		RShift = (lValue and &H7FFFFFFE) \ m_l2Power(iShiftBits)
	
		if (lValue and &H80000000) then
			RShift = (RShift or (&H40000000 \ m_l2Power(iShiftBits - 1)))
		end if
	end function
	
	private function RotateLeft(lValue, iShiftBits)
		RotateLeft = LShift(lValue, iShiftBits) or RShift(lValue, (32 - iShiftBits))
	end function
	
	private function AddUnsigned(lX, lY)
		dim lX4
		dim lY4
		dim lX8
		dim lY8
		dim lResult
	
		lX8 = lX and &H80000000
		lY8 = lY and &H80000000
		lX4 = lX and &H40000000
		lY4 = lY and &H40000000
	
		lResult = (lX and &H3FFFFFFF) + (lY and &H3FFFFFFF)
	
		if lX4 and lY4 then
			lResult = lResult Xor &H80000000 Xor lX8 Xor lY8
		elseIf lX4 or lY4 then
			if lResult and &H40000000 then
				lResult = lResult Xor &HC0000000 Xor lX8 Xor lY8
			else
				lResult = lResult Xor &H40000000 Xor lX8 Xor lY8
			end if
		else
			lResult = lResult Xor lX8 Xor lY8
		end if
	
		AddUnsigned = lResult
	end function
	
	private function md5_F(x, y, z)
		md5_F = (x and y) or ((not x) and z)
	end function
	
	private function md5_G(x, y, z)
		md5_G = (x and z) or (y and (not z))
	end function
	
	private function md5_H(x, y, z)
		md5_H = (x Xor y Xor z)
	end function
	
	private function md5_I(x, y, z)
		md5_I = (y Xor (x or (not z)))
	end function
	
	private sub md5_FF(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_F(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end sub
	
	private sub md5_GG(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_G(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end sub
	
	private sub md5_HH(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_H(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end sub
	
	private sub md5_II(a, b, c, d, x, s, ac)
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(md5_I(b, c, d), x), ac))
		a = RotateLeft(a, s)
		a = AddUnsigned(a, b)
	end sub
	
	private function ConvertToWordArray(sMessage)
		dim lMessageLength
		dim lNumberOfWords
		dim lWordArray()
		dim lBytePosition
		dim lByteCount
		dim lWordCount
	
		Const MODULUS_BITS = 512
		Const CONGRUENT_BITS = 448
	
		lMessageLength = Len(sMessage)
	
		lNumberOfWords = (((lMessageLength + ((MODULUS_BITS - CONGRUENT_BITS) \ BITS_TO_A_BYTE)) \ (MODULUS_BITS \ BITS_TO_A_BYTE)) + 1) * (MODULUS_BITS \ BITS_TO_A_WORD)
		ReDim lWordArray(lNumberOfWords - 1)
	
		lBytePosition = 0
		lByteCount = 0
		Do Until lByteCount >= lMessageLength
			lWordCount = lByteCount \ BYTES_TO_A_WORD
			lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE
			lWordArray(lWordCount) = lWordArray(lWordCount) or LShift(Asc(Mid(sMessage, lByteCount + 1, 1)), lBytePosition)
			lByteCount = lByteCount + 1
		Loop
	
		lWordCount = lByteCount \ BYTES_TO_A_WORD
		lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE
	
		lWordArray(lWordCount) = lWordArray(lWordCount) or LShift(&H80, lBytePosition)
	
		lWordArray(lNumberOfWords - 2) = LShift(lMessageLength, 3)
		lWordArray(lNumberOfWords - 1) = RShift(lMessageLength, 29)
	
		ConvertToWordArray = lWordArray
	end function
	
	private function WordToHex(lValue)
		dim lByte
		dim lCount
	
		For lCount = 0 To 3
			lByte = RShift(lValue, lCount * BITS_TO_A_BYTE) and m_lOnBits(BITS_TO_A_BYTE - 1)
			WordToHex = WordToHex & right("0" & Hex(lByte), 2)
		Next
	end function
	
	public function MD5(sMessage)
		m_lOnBits(0) = CLng(1)
		m_lOnBits(1) = CLng(3)
		m_lOnBits(2) = CLng(7)
		m_lOnBits(3) = CLng(15)
		m_lOnBits(4) = CLng(31)
		m_lOnBits(5) = CLng(63)
		m_lOnBits(6) = CLng(127)
		m_lOnBits(7) = CLng(255)
		m_lOnBits(8) = CLng(511)
		m_lOnBits(9) = CLng(1023)
		m_lOnBits(10) = CLng(2047)
		m_lOnBits(11) = CLng(4095)
		m_lOnBits(12) = CLng(8191)
		m_lOnBits(13) = CLng(16383)
		m_lOnBits(14) = CLng(32767)
		m_lOnBits(15) = CLng(65535)
		m_lOnBits(16) = CLng(131071)
		m_lOnBits(17) = CLng(262143)
		m_lOnBits(18) = CLng(524287)
		m_lOnBits(19) = CLng(1048575)
		m_lOnBits(20) = CLng(2097151)
		m_lOnBits(21) = CLng(4194303)
		m_lOnBits(22) = CLng(8388607)
		m_lOnBits(23) = CLng(16777215)
		m_lOnBits(24) = CLng(33554431)
		m_lOnBits(25) = CLng(67108863)
		m_lOnBits(26) = CLng(134217727)
		m_lOnBits(27) = CLng(268435455)
		m_lOnBits(28) = CLng(536870911)
		m_lOnBits(29) = CLng(1073741823)
		m_lOnBits(30) = CLng(2147483647)
	
		m_l2Power(0) = CLng(1)
		m_l2Power(1) = CLng(2)
		m_l2Power(2) = CLng(4)
		m_l2Power(3) = CLng(8)
		m_l2Power(4) = CLng(16)
		m_l2Power(5) = CLng(32)
		m_l2Power(6) = CLng(64)
		m_l2Power(7) = CLng(128)
		m_l2Power(8) = CLng(256)
		m_l2Power(9) = CLng(512)
		m_l2Power(10) = CLng(1024)
		m_l2Power(11) = CLng(2048)
		m_l2Power(12) = CLng(4096)
		m_l2Power(13) = CLng(8192)
		m_l2Power(14) = CLng(16384)
		m_l2Power(15) = CLng(32768)
		m_l2Power(16) = CLng(65536)
		m_l2Power(17) = CLng(131072)
		m_l2Power(18) = CLng(262144)
		m_l2Power(19) = CLng(524288)
		m_l2Power(20) = CLng(1048576)
		m_l2Power(21) = CLng(2097152)
		m_l2Power(22) = CLng(4194304)
		m_l2Power(23) = CLng(8388608)
		m_l2Power(24) = CLng(16777216)
		m_l2Power(25) = CLng(33554432)
		m_l2Power(26) = CLng(67108864)
		m_l2Power(27) = CLng(134217728)
		m_l2Power(28) = CLng(268435456)
		m_l2Power(29) = CLng(536870912)
		m_l2Power(30) = CLng(1073741824)
	
	
		dim x
		dim k
		dim AA
		dim BB
		dim CC
		dim DD
		dim a
		dim b
		dim c
		dim d
	
		Const S11 = 7
		Const S12 = 12
		Const S13 = 17
		Const S14 = 22
		Const S21 = 5
		Const S22 = 9
		Const S23 = 14
		Const S24 = 20
		Const S31 = 4
		Const S32 = 11
		Const S33 = 16
		Const S34 = 23
		Const S41 = 6
		Const S42 = 10
		Const S43 = 15
		Const S44 = 21
	
		x = ConvertToWordArray(sMessage)
	
		a = &H67452301
		b = &HEFCDAB89
		c = &H98BADCFE
		d = &H10325476
	
		For k = 0 To UBound(x) Step 16
			AA = a
			BB = b
			CC = c
			DD = d
	
			md5_FF a, b, c, d, x(k + 0), S11, &HD76AA478
			md5_FF d, a, b, c, x(k + 1), S12, &HE8C7B756
			md5_FF c, d, a, b, x(k + 2), S13, &H242070DB
			md5_FF b, c, d, a, x(k + 3), S14, &HC1BDCEEE
			md5_FF a, b, c, d, x(k + 4), S11, &HF57C0FAF
			md5_FF d, a, b, c, x(k + 5), S12, &H4787C62A
			md5_FF c, d, a, b, x(k + 6), S13, &HA830461A
			md5_FF b, c, d, a, x(k + 7), S14, &HFD469501
			md5_FF a, b, c, d, x(k + 8), S11, &H698098DB
			md5_FF d, a, b, c, x(k + 9), S12, &H8B44F7AF
			md5_FF c, d, a, b, x(k + 10), S13, &HFFFF5BB1
			md5_FF b, c, d, a, x(k + 11), S14, &H895CD7BE
			md5_FF a, b, c, d, x(k + 12), S11, &H6B90112E
			md5_FF d, a, b, c, x(k + 13), S12, &HFD987193
			md5_FF c, d, a, b, x(k + 14), S13, &HA6794383
			md5_FF b, c, d, a, x(k + 15), S14, &H49B40821
	
			md5_GG a, b, c, d, x(k + 1), S21, &HF61E2562
			md5_GG d, a, b, c, x(k + 6), S22, &HC040B340
			md5_GG c, d, a, b, x(k + 11), S23, &H265E5A51
			md5_GG b, c, d, a, x(k + 0), S24, &HE9B6C7AA
			md5_GG a, b, c, d, x(k + 5), S21, &HD62F105D
			md5_GG d, a, b, c, x(k + 10), S22, &H2441453
			md5_GG c, d, a, b, x(k + 15), S23, &HD8A1E681
			md5_GG b, c, d, a, x(k + 4), S24, &HE7D3FBC8
			md5_GG a, b, c, d, x(k + 9), S21, &H21E1CDE6
			md5_GG d, a, b, c, x(k + 14), S22, &HC33707D6
			md5_GG c, d, a, b, x(k + 3), S23, &HF4D50D87
			md5_GG b, c, d, a, x(k + 8), S24, &H455A14ED
			md5_GG a, b, c, d, x(k + 13), S21, &HA9E3E905
			md5_GG d, a, b, c, x(k + 2), S22, &HFCEFA3F8
			md5_GG c, d, a, b, x(k + 7), S23, &H676F02D9
			md5_GG b, c, d, a, x(k + 12), S24, &H8D2A4C8A
	
			md5_HH a, b, c, d, x(k + 5), S31, &HFFFA3942
			md5_HH d, a, b, c, x(k + 8), S32, &H8771F681
			md5_HH c, d, a, b, x(k + 11), S33, &H6D9D6122
			md5_HH b, c, d, a, x(k + 14), S34, &HFDE5380C
			md5_HH a, b, c, d, x(k + 1), S31, &HA4BEEA44
			md5_HH d, a, b, c, x(k + 4), S32, &H4BDECFA9
			md5_HH c, d, a, b, x(k + 7), S33, &HF6BB4B60
			md5_HH b, c, d, a, x(k + 10), S34, &HBEBFBC70
			md5_HH a, b, c, d, x(k + 13), S31, &H289B7EC6
			md5_HH d, a, b, c, x(k + 0), S32, &HEAA127FA
			md5_HH c, d, a, b, x(k + 3), S33, &HD4EF3085
			md5_HH b, c, d, a, x(k + 6), S34, &H4881D05
			md5_HH a, b, c, d, x(k + 9), S31, &HD9D4D039
			md5_HH d, a, b, c, x(k + 12), S32, &HE6DB99E5
			md5_HH c, d, a, b, x(k + 15), S33, &H1FA27CF8
			md5_HH b, c, d, a, x(k + 2), S34, &HC4AC5665
	
			md5_II a, b, c, d, x(k + 0), S41, &HF4292244
			md5_II d, a, b, c, x(k + 7), S42, &H432AFF97
			md5_II c, d, a, b, x(k + 14), S43, &HAB9423A7
			md5_II b, c, d, a, x(k + 5), S44, &HFC93A039
			md5_II a, b, c, d, x(k + 12), S41, &H655B59C3
			md5_II d, a, b, c, x(k + 3), S42, &H8F0CCC92
			md5_II c, d, a, b, x(k + 10), S43, &HFFEFF47D
			md5_II b, c, d, a, x(k + 1), S44, &H85845DD1
			md5_II a, b, c, d, x(k + 8), S41, &H6FA87E4F
			md5_II d, a, b, c, x(k + 15), S42, &HFE2CE6E0
			md5_II c, d, a, b, x(k + 6), S43, &HA3014314
			md5_II b, c, d, a, x(k + 13), S44, &H4E0811A1
			md5_II a, b, c, d, x(k + 4), S41, &HF7537E82
			md5_II d, a, b, c, x(k + 11), S42, &HBD3AF235
			md5_II c, d, a, b, x(k + 2), S43, &H2AD7D2BB
			md5_II b, c, d, a, x(k + 9), S44, &HEB86D391
	
			a = AddUnsigned(a, AA)
			b = AddUnsigned(b, BB)
			c = AddUnsigned(c, CC)
			d = AddUnsigned(d, DD)
		Next
	
		if Pv_Md5Bits=32 then
			MD5 = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))
		else
		    MD5 = LCase(WordToHex(b) & WordToHex(c))
		end if
	end function
	
	public function encode(byval s)
		s = trim(s)
		if s = "" then encrypt = "" : exit function : end if
		encode = MD5(s)
	end function
	
	public function encrypt(byval s)
		s = Trim(s)
		if s = "" then Encrypt = "" : exit function : end if
		encrypt = MD5(s)
	end function
end class

'****
'**Feature     : AES Encryption
'**Author      : Roderick Divilbiss
'**Update      : linx(openwbs@qq.com)
'**Update Date : 2010-11-03 12:13:26
'**Description : Encrypt strings with AES in OpenWBS
'****
class OW_AES_Class
	private m_lOnBits(30)
	private m_l2Power(30)
	private m_bytOnBits(7)
	private m_byt2Power(7)

	private m_InCo(3)

	private m_fbsub(255)
	private m_rbsub(255)
	private m_ptab(255)
	private m_ltab(255)
	private m_ftable(255)
	private m_rtable(255)
	private m_rco(29)

	private m_Nk
	private m_Nb
	private m_Nr
	private m_fi(23)
	private m_ri(23)
	private m_fkey(119)
	private m_rkey(119)

	private sEncryptKey

	private sub class_initialize()
		m_InCo(0) = &HB
		m_InCo(1) = &HD
		m_InCo(2) = &H9
		m_InCo(3) = &HE
			
		m_bytOnBits(0) = 1
		m_bytOnBits(1) = 3
		m_bytOnBits(2) = 7
		m_bytOnBits(3) = 15
		m_bytOnBits(4) = 31
		m_bytOnBits(5) = 63
		m_bytOnBits(6) = 127
		m_bytOnBits(7) = 255
			
		m_byt2Power(0) = 1
		m_byt2Power(1) = 2
		m_byt2Power(2) = 4
		m_byt2Power(3) = 8
		m_byt2Power(4) = 16
		m_byt2Power(5) = 32
		m_byt2Power(6) = 64
		m_byt2Power(7) = 128
			
		m_lOnBits(0) = 1
		m_lOnBits(1) = 3
		m_lOnBits(2) = 7
		m_lOnBits(3) = 15
		m_lOnBits(4) = 31
		m_lOnBits(5) = 63
		m_lOnBits(6) = 127
		m_lOnBits(7) = 255
		m_lOnBits(8) = 511
		m_lOnBits(9) = 1023
		m_lOnBits(10) = 2047
		m_lOnBits(11) = 4095
		m_lOnBits(12) = 8191
		m_lOnBits(13) = 16383
		m_lOnBits(14) = 32767
		m_lOnBits(15) = 65535
		m_lOnBits(16) = 131071
		m_lOnBits(17) = 262143
		m_lOnBits(18) = 524287
		m_lOnBits(19) = 1048575
		m_lOnBits(20) = 2097151
		m_lOnBits(21) = 4194303
		m_lOnBits(22) = 8388607
		m_lOnBits(23) = 16777215
		m_lOnBits(24) = 33554431
		m_lOnBits(25) = 67108863
		m_lOnBits(26) = 134217727
		m_lOnBits(27) = 268435455
		m_lOnBits(28) = 536870911
		m_lOnBits(29) = 1073741823
		m_lOnBits(30) = 2147483647
			
		m_l2Power(0) = 1
		m_l2Power(1) = 2
		m_l2Power(2) = 4
		m_l2Power(3) = 8
		m_l2Power(4) = 16
		m_l2Power(5) = 32
		m_l2Power(6) = 64
		m_l2Power(7) = 128
		m_l2Power(8) = 256
		m_l2Power(9) = 512
		m_l2Power(10) = 1024
		m_l2Power(11) = 2048
		m_l2Power(12) = 4096
		m_l2Power(13) = 8192
		m_l2Power(14) = 16384
		m_l2Power(15) = 32768
		m_l2Power(16) = 65536
		m_l2Power(17) = 131072
		m_l2Power(18) = 262144
		m_l2Power(19) = 524288
		m_l2Power(20) = 1048576
		m_l2Power(21) = 2097152
		m_l2Power(22) = 4194304
		m_l2Power(23) = 8388608
		m_l2Power(24) = 16777216
		m_l2Power(25) = 33554432
		m_l2Power(26) = 67108864
		m_l2Power(27) = 134217728
		m_l2Power(28) = 268435456
		m_l2Power(29) = 536870912
		m_l2Power(30) = 1073741824

		sEncryptKey = "OW_AES"
	end sub
	private sub class_terminate()
	end sub

	public property Let EncryptKey(byval BV_EK)
		sEncryptKey = BV_EK
	end property
	public property Get EncryptKey()
		EncryptKey = sEncryptKey
	end property

	private function LShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			LShift = lValue
			exit function
		elseIf iShiftBits = 31 then
			if lValue and 1 then
				LShift = &H80000000
			else
				LShift = 0
			end if
			exit function
		elseIf iShiftBits < 0 or iShiftBits > 31 then
			Err.Raise 6
		end if
		
		if (lValue and m_l2Power(31 - iShiftBits)) then
			LShift = ((lValue and m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) or &H80000000
		else
			LShift = ((lValue and m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))
		end if
	end function

	private function RShift(lValue, iShiftBits)
		if iShiftBits = 0 then
			RShift = lValue
			exit function
		elseIf iShiftBits = 31 then
			if lValue and &H80000000 then
				RShift = 1
			else
				RShift = 0
			end if
			exit function
		elseIf iShiftBits < 0 or iShiftBits > 31 then
			Err.Raise 6
		end if
		
		RShift = (lValue and &H7FFFFFFE) \ m_l2Power(iShiftBits)
		
		if (lValue and &H80000000) then
			RShift = (RShift or (&H40000000 \ m_l2Power(iShiftBits - 1)))
		end if
	end function

	private function LShiftByte(bytValue, bytShiftBits)
		if bytShiftBits = 0 then
			LShiftByte = bytValue
			exit function
		elseIf bytShiftBits = 7 then
			if bytValue and 1 then
				LShiftByte = &H80
			else
				LShiftByte = 0
			end if
			exit function
		elseIf bytShiftBits < 0 or bytShiftBits > 7 then
			Err.Raise 6
		end if
		LShiftByte = ((bytValue and m_bytOnBits(7 - bytShiftBits)) * m_byt2Power(bytShiftBits))
		
	end function

	private function RShiftByte(bytValue, bytShiftBits)
		if bytShiftBits = 0 then
			RShiftByte = bytValue
			exit function
		elseIf bytShiftBits = 7 then
			if bytValue and &H80 then
				RShiftByte = 1
			else
				RShiftByte = 0
			end if
			exit function
		elseIf bytShiftBits < 0 or bytShiftBits > 7 then
			Err.Raise 6
		end if
		
		RShiftByte = bytValue \ m_byt2Power(bytShiftBits)
	end function

	private function RotateLeft(lValue, iShiftBits)
		RotateLeft = LShift(lValue, iShiftBits) or RShift(lValue, (32 - iShiftBits))
	end function

	private function RotateLeftByte(bytValue, bytShiftBits)
		RotateLeftByte = LShiftByte(bytValue, bytShiftBits) or RShiftByte(bytValue, (8 - bytShiftBits))
	end function

	private function Pack(b())
		dim lCount
		dim lTemp
		
		For lCount = 0 To 3
			lTemp = b(lCount)
			Pack = Pack or LShift(lTemp, (lCount * 8))
		Next
	end function

	private function PackFrom(b(), k)
		dim lCount
		dim lTemp
		
		For lCount = 0 To 3
			lTemp = b(lCount + k)
			PackFrom = PackFrom or LShift(lTemp, (lCount * 8))
		Next
	end function

	private sub Unpack(a, b())
		b(0) = a and m_lOnBits(7)
		b(1) = RShift(a, 8) and m_lOnBits(7)
		b(2) = RShift(a, 16) and m_lOnBits(7)
		b(3) = RShift(a, 24) and m_lOnBits(7)
	end sub

	private sub UnpackFrom(a, b(), k)
		b(0 + k) = a and m_lOnBits(7)
		b(1 + k) = RShift(a, 8) and m_lOnBits(7)
		b(2 + k) = RShift(a, 16) and m_lOnBits(7)
		b(3 + k) = RShift(a, 24) and m_lOnBits(7)
	end sub

	private function xtime(a)
		dim b
		
		if (a and &H80) then
			b = &H1B
		else
			b = 0
		end if
		
		xtime = LShiftByte(a, 1)
		xtime = xtime Xor b
	end function

	private function bmul(x, y)
		if x <> 0 and y <> 0 then
			bmul = m_ptab((CLng(m_ltab(x)) + CLng(m_ltab(y))) Mod 255)
		else
			bmul = 0
		end if
	end function

	private function SubByte(a)
		dim b(3)
		
		Unpack a, b
		b(0) = m_fbsub(b(0))
		b(1) = m_fbsub(b(1))
		b(2) = m_fbsub(b(2))
		b(3) = m_fbsub(b(3))
		
		SubByte = Pack(b)
	end function

	private function product(x, y)
		dim xb(3)
		dim yb(3)
		
		Unpack x, xb
		Unpack y, yb
		product = bmul(xb(0), yb(0)) Xor bmul(xb(1), yb(1)) Xor bmul(xb(2), yb(2)) Xor bmul(xb(3), yb(3))
	end function

	private function InvMixCol(x)
		dim y
		dim m
		dim b(3)
		
		m = Pack(m_InCo)
		b(3) = product(m, x)
		m = RotateLeft(m, 24)
		b(2) = product(m, x)
		m = RotateLeft(m, 24)
		b(1) = product(m, x)
		m = RotateLeft(m, 24)
		b(0) = product(m, x)
		y = Pack(b)
		
		InvMixCol = y
	end function

	private function ByteSub(x)
		dim y
		dim z
		
		z = x
		y = m_ptab(255 - m_ltab(z))
		z = y
		z = RotateLeftByte(z, 1)
		y = y Xor z
		z = RotateLeftByte(z, 1)
		y = y Xor z
		z = RotateLeftByte(z, 1)
		y = y Xor z
		z = RotateLeftByte(z, 1)
		y = y Xor z
		y = y Xor &H63
		
		ByteSub = y
	end function

	public sub gentables()
		dim i
		dim y
		dim b(3)
		dim ib
		
		m_ltab(0) = 0
		m_ptab(0) = 1
		m_ltab(1) = 0
		m_ptab(1) = 3
		m_ltab(3) = 1
		
		For i = 2 To 255
			m_ptab(i) = m_ptab(i - 1) Xor xtime(m_ptab(i - 1))
			m_ltab(m_ptab(i)) = i
		Next
		
		m_fbsub(0) = &H63
		m_rbsub(&H63) = 0
		
		For i = 1 To 255
			ib = i
			y = ByteSub(ib)
			m_fbsub(i) = y
			m_rbsub(y) = i
		Next
		
		y = 1
		For i = 0 To 29
			m_rco(i) = y
			y = xtime(y)
		Next
		
		For i = 0 To 255
			y = m_fbsub(i)
			b(3) = y Xor xtime(y)
			b(2) = y
			b(1) = y
			b(0) = xtime(y)
			m_ftable(i) = Pack(b)
			
			y = m_rbsub(i)
			b(3) = bmul(m_InCo(0), y)
			b(2) = bmul(m_InCo(1), y)
			b(1) = bmul(m_InCo(2), y)
			b(0) = bmul(m_InCo(3), y)
			m_rtable(i) = Pack(b)
		Next
	end sub

	public sub gkey(nb, nk, key())                
		dim i
		dim j
		dim k
		dim m
		dim N
		dim C1
		dim C2
		dim C3
		dim CipherKey(7)
		
		m_Nb = nb
		m_Nk = nk
		
		if m_Nb >= m_Nk then
			m_Nr = 6 + m_Nb
		else
			m_Nr = 6 + m_Nk
		end if
		
		C1 = 1
		if m_Nb < 8 then
			C2 = 2
			C3 = 3
		else
			C2 = 3
			C3 = 4
		end if
		
		For j = 0 To nb - 1
			m = j * 3
			
			m_fi(m) = (j + C1) Mod nb
			m_fi(m + 1) = (j + C2) Mod nb
			m_fi(m + 2) = (j + C3) Mod nb
			m_ri(m) = (nb + j - C1) Mod nb
			m_ri(m + 1) = (nb + j - C2) Mod nb
			m_ri(m + 2) = (nb + j - C3) Mod nb
		Next
		
		N = m_Nb * (m_Nr + 1)
		
		For i = 0 To m_Nk - 1
			j = i * 4
			CipherKey(i) = PackFrom(key, j)
		Next
		
		For i = 0 To m_Nk - 1
			m_fkey(i) = CipherKey(i)
		Next
		
		j = m_Nk
		k = 0
		Do While j < N
			m_fkey(j) = m_fkey(j - m_Nk) Xor _
				SubByte(RotateLeft(m_fkey(j - 1), 24)) Xor m_rco(k)
			if m_Nk <= 6 then
				i = 1
				Do While i < m_Nk and (i + j) < N
					m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
						m_fkey(i + j - 1)
					i = i + 1
				Loop
			else
				i = 1
				Do While i < 4 and (i + j) < N
					m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
						m_fkey(i + j - 1)
					i = i + 1
				Loop
				if j + 4 < N then
					m_fkey(j + 4) = m_fkey(j + 4 - m_Nk) Xor _
						SubByte(m_fkey(j + 3))
				end if
				i = 5
				Do While i < m_Nk and (i + j) < N
					m_fkey(i + j) = m_fkey(i + j - m_Nk) Xor _
						m_fkey(i + j - 1)
					i = i + 1
				Loop
			end if
			
			j = j + m_Nk
			k = k + 1
		Loop
		
		For j = 0 To m_Nb - 1
			m_rkey(j + N - nb) = m_fkey(j)
		Next
		
		i = m_Nb
		Do While i < N - m_Nb
			k = N - m_Nb - i
			For j = 0 To m_Nb - 1
				m_rkey(k + j) = InvMixCol(m_fkey(i + j))
			Next
			i = i + m_Nb
		Loop
		
		j = N - m_Nb
		Do While j < N
			m_rkey(j - N + m_Nb) = m_fkey(j)
			j = j + 1
		Loop
	end sub

	public sub Encrypting(buff())
		dim i
		dim j
		dim k
		dim m
		dim a(7)
		dim b(7)
		dim x
		dim y
		dim t
		
		For i = 0 To m_Nb - 1
			j = i * 4
			
			a(i) = PackFrom(buff, j)
			a(i) = a(i) Xor m_fkey(i)
		Next
		
		k = m_Nb
		x = a
		y = b
		
		For i = 1 To m_Nr - 1
			For j = 0 To m_Nb - 1
				m = j * 3
				y(j) = m_fkey(k) Xor m_ftable(x(j) and m_lOnBits(7)) Xor _
					RotateLeft(m_ftable(RShift(x(m_fi(m)), 8) and m_lOnBits(7)), 8) Xor _
					RotateLeft(m_ftable(RShift(x(m_fi(m + 1)), 16) and m_lOnBits(7)), 16) Xor _
					RotateLeft(m_ftable(RShift(x(m_fi(m + 2)), 24) and m_lOnBits(7)), 24)
				k = k + 1
			Next
			t = x
			x = y
			y = t
		Next
		
		For j = 0 To m_Nb - 1
			m = j * 3
			y(j) = m_fkey(k) Xor m_fbsub(x(j) and m_lOnBits(7)) Xor _
				RotateLeft(m_fbsub(RShift(x(m_fi(m)), 8) and m_lOnBits(7)), 8) Xor _
				RotateLeft(m_fbsub(RShift(x(m_fi(m + 1)), 16) and m_lOnBits(7)), 16) Xor _
				RotateLeft(m_fbsub(RShift(x(m_fi(m + 2)), 24) and m_lOnBits(7)), 24)
			k = k + 1
		Next
		
		For i = 0 To m_Nb - 1
			j = i * 4
			UnpackFrom y(i), buff, j
			x(i) = 0
			y(i) = 0
		Next
	end sub

	public sub Decrypting(buff())
		dim i
		dim j
		dim k
		dim m
		dim a(7)
		dim b(7)
		dim x
		dim y
		dim t
		
		For i = 0 To m_Nb - 1
			j = i * 4
			a(i) = PackFrom(buff, j)
			a(i) = a(i) Xor m_rkey(i)
		Next
		
		k = m_Nb
		x = a
		y = b
		
		For i = 1 To m_Nr - 1
			For j = 0 To m_Nb - 1
				m = j * 3
				y(j) = m_rkey(k) Xor m_rtable(x(j) and m_lOnBits(7)) Xor _
					RotateLeft(m_rtable(RShift(x(m_ri(m)), 8) and m_lOnBits(7)), 8) Xor _
					RotateLeft(m_rtable(RShift(x(m_ri(m + 1)), 16) and m_lOnBits(7)), 16) Xor _
					RotateLeft(m_rtable(RShift(x(m_ri(m + 2)), 24) and m_lOnBits(7)), 24)
				k = k + 1
			Next
			t = x
			x = y
			y = t
		Next
		
		For j = 0 To m_Nb - 1
			m = j * 3
			
			y(j) = m_rkey(k) Xor m_rbsub(x(j) and m_lOnBits(7)) Xor _
				RotateLeft(m_rbsub(RShift(x(m_ri(m)), 8) and m_lOnBits(7)), 8) Xor _
				RotateLeft(m_rbsub(RShift(x(m_ri(m + 1)), 16) and m_lOnBits(7)), 16) Xor _
				RotateLeft(m_rbsub(RShift(x(m_ri(m + 2)), 24) and m_lOnBits(7)), 24)
			k = k + 1
		Next
		
		For i = 0 To m_Nb - 1
			j = i * 4
			
			UnpackFrom y(i), buff, j
			x(i) = 0
			y(i) = 0
		Next
	end sub

	private function IsInitialized(vArray)
		on error resume next
		IsInitialized = IsNumeric(UBound(vArray))
	end function

	private sub CopyBytesASP(bytDest, lDestStart, bytSource(), lSourceStart, lLength)
		dim lCount
		lCount = 0
		Do
			bytDest(lDestStart + lCount) = bytSource(lSourceStart + lCount)
			lCount = lCount + 1
		Loop Until lCount = lLength
	end sub

	public function EncryptData(bytMessage, bytPassword)
		dim bytKey(31)
		dim bytIn()
		dim bytOut()
		dim bytTemp(31)
		dim lCount
		dim lLength
		dim lEncodedLength
		dim bytLen(3)
		dim lPosition
		
		if not IsInitialized(bytMessage) then
			exit function
		end if
		if not IsInitialized(bytPassword) then
			exit function
		end if
		
		For lCount = 0 To UBound(bytPassword)
			bytKey(lCount) = bytPassword(lCount)
			if lCount = 31 then
				exit For
			end if
		Next
		
		gentables
		gkey 8, 8, bytKey
		
		lLength = UBound(bytMessage) + 1
		lEncodedLength = lLength + 4
		
		if lEncodedLength Mod 32 <> 0 then
			lEncodedLength = lEncodedLength + 32 - (lEncodedLength Mod 32)
		end if
		ReDim bytIn(lEncodedLength - 1)
		ReDim bytOut(lEncodedLength - 1)
		
		Unpack lLength, bytIn
		CopyBytesASP bytIn, 4, bytMessage, 0, lLength

		For lCount = 0 To lEncodedLength - 1 Step 32
			CopyBytesASP bytTemp, 0, bytIn, lCount, 32
			Encrypting bytTemp
			CopyBytesASP bytOut, lCount, bytTemp, 0, 32
		Next
		
		EncryptData = bytOut
	end function

	public function DecryptData(bytIn, bytPassword)
		dim bytMessage()
		dim bytKey(31)
		dim bytOut()
		dim bytTemp(31)
		dim lCount
		dim lLength
		dim lEncodedLength
		dim bytLen(3)
		dim lPosition
		
		if not IsInitialized(bytIn) then
			exit function
		end if
		if not IsInitialized(bytPassword) then
			exit function
		end if
		
		lEncodedLength = UBound(bytIn) + 1
		
		if lEncodedLength Mod 32 <> 0 then
			exit function
		end if
		
		For lCount = 0 To UBound(bytPassword)
			bytKey(lCount) = bytPassword(lCount)
			if lCount = 31 then
				exit For
			end if
		Next
		
		gentables
		gkey 8, 8, bytKey

		ReDim bytOut(lEncodedLength - 1)
		
		For lCount = 0 To lEncodedLength - 1 Step 32
			CopyBytesASP bytTemp, 0, bytIn, lCount, 32
			Decrypting bytTemp
			CopyBytesASP bytOut, lCount, bytTemp, 0, 32
		Next

		lLength = Pack(bytOut)
		
		if lLength > lEncodedLength - 4 then
			exit function
		end if
		
		ReDim bytMessage(lLength - 1)
		CopyBytesASP bytMessage, 0, bytOut, 4, lLength
		
		DecryptData = bytMessage
	end function

	function AESEncrypt(sPlain,sPassword)
		dim bytIn()
		dim bytOut
		dim bytPassword()
		dim lCount
		dim lLength
		dim sTemp
		
		lLength = Len(sPlain)
		ReDim bytIn(lLength-1)
		For lCount = 1 To lLength
			bytIn(lCount-1) = CByte(AscB(Mid(sPlain,lCount,1)))
		Next
		lLength = Len(sPassword)
		ReDim bytPassword(lLength-1)
		For lCount = 1 To lLength
			bytPassword(lCount-1) = CByte(AscB(Mid(sPassword,lCount,1)))
		Next

		bytOut = EncryptData(bytIn, bytPassword)

		sTemp = ""
		For lCount = 0 To UBound(bytOut)
			sTemp = sTemp & right("0" & Hex(bytOut(lCount)), 2)
		Next

		AESEncrypt = sTemp
	end function

	function AESDecrypt(sCypher, sPassword)
		dim bytIn()
		dim bytOut
		dim bytPassword()
		dim lCount
		dim lLength
		dim sTemp
		on error resume next
		lLength = Len(sCypher)
		ReDim bytIn(lLength/2-1)
		For lCount = 0 To lLength/2-1
			bytIn(lCount) = CByte("&H" & Mid(sCypher,lCount*2+1,2))
		Next
		lLength = Len(sPassword)
		ReDim bytPassword(lLength-1)
		For lCount = 1 To lLength
			bytPassword(lCount-1) = CByte(AscB(Mid(sPassword,lCount,1)))
		Next
		bytOut = DecryptData(bytIn, bytPassword)
		if IsArray(bytOut) then
			lLength = UBound(bytOut) + 1
			sTemp = ""
			For lCount = 0 To lLength - 1
				sTemp = sTemp & Chr(bytOut(lCount))
			Next
		end if
		if Err.number <> 0 then Err.Clear : end if
		AESDecrypt = sTemp
	end function
	
	public function encrypt(byval s)
		s = Trim(s)
		if s = "" then Encrypt = "" : exit function : end if
		encrypt = AESEncrypt(OW.Escape(s),OW.Escape(sEncryptKey))
	end function
	
	public function decrypt(byval s)
		s = Trim(s)
		if s = "" then decrypt = "" : exit function : end if
		decrypt = OW.unEscape(AESDecrypt(s,OW.Escape(sEncryptKey)))
	end function
end class


'** Programmed by Markus Hartsmar for ShameDesigns in 2002. 
'** Email me at: mark@shamedesigns.com
'** Visit our website at: http://www.shamedesigns.com/
'****
'**Feature     : Encoding/Decoding of strings with Base64
'**Author      : Markus Hartsmar(mark@shamedesigns.com)
'**Update By   : linx(openwbs@qq.com)
'**Update Date : 2010-11-04 10:42:27
'**Description : Encoding strings with Base64 in OpenWBS
'****
class OW_Base64_Class

	private Base64Chars
	public sub class_initialize		
		Base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	end sub

	public function Encode( byVal strIn )
		dim c1, c2, c3, w1, w2, w3, w4, n, strOut
		For n = 1 To Len( strIn ) Step 3
			c1 = Asc( Mid( strIn, n, 1 ) )
			c2 = Asc( Mid( strIn, n + 1, 1 ) + Chr(0) )
			c3 = Asc( Mid( strIn, n + 2, 1 ) + Chr(0) )
			w1 = Int( c1 / 4 ) : w2 = ( c1 and 3 ) * 16 + Int( c2 / 16 )
			if Len( strIn ) >= n + 1 then
				w3 = ( c2 and 15 ) * 4 + Int( c3 / 64 ) 
			else 
				w3 = -1
			end if
			if Len( strIn ) >= n + 2 then
				w4 = c3 and 63 
			else 
				w4 = -1
			end if
			strOut = strOut + mimeEncode( w1 ) + mimeEncode( w2 ) + _
					  mimeEncode( w3 ) + mimeEncode( w4 )
		Next
		Encode = strOut
	end function

	public function Decode( byVal strIn )
		dim w1, w2, w3, w4, n, strOut
		For n = 1 To Len( strIn ) Step 4
			w1 = mimeDecode( Mid( strIn, n, 1 ) )
			w2 = mimeDecode( Mid( strIn, n + 1, 1 ) )
			w3 = mimeDecode( Mid( strIn, n + 2, 1 ) )
			w4 = mimeDecode( Mid( strIn, n + 3, 1 ) )
			if w2 >= 0 then _
				strOut = strOut + _
					Chr( ( ( w1 * 4 + Int( w2 / 16 ) ) and 255 ) )
			if w3 >= 0 then _
				strOut = strOut + _
					Chr( ( ( w2 * 16 + Int( w3 / 4 ) ) and 255 ) )
			if w4 >= 0 then _
				strOut = strOut + _
					Chr( ( ( w3 * 64 + w4 ) and 255 ) )
		Next
		Decode = strOut
	end function
	
	private function mimeEncode( byVal intIn )
		if intIn >= 0 then 
			mimeEncode = Mid( Base64Chars, intIn + 1, 1 ) 
		else 
			mimeEncode = ""
		end if
	end function

	private function mimeDecode( byVal strIn )
		if Len( strIn ) = 0 then
			mimeDecode = -1 : exit function
		else
			mimeDecode = InStr( Base64Chars, strIn ) - 1
		end if
	end function
end class
%>
<%:class OW_Error_Class:private oError,sMsg:private sub class_initialize:set oError = server.createObject(OW.dictName):oError(1)  = "此服务器系统不支持Scripting.FileSystemObject组件！":oError(2)  = "文件路径错误或者是文件不存在！":oError(3)  = "Included 文件内部运行错误，请检查被包含文件代码是否存在语法错误！":oError(4)  = "读取文件错误，请检查文件是否存在！":oError(5)  = "OpenWBS系统路径错误！":oError(6)  = "非法从系统外部提交数据！":oError(7)  = "保存日志失败！":oError(8)  = "模版文件不存在！":oError(9)  = "内容不存在！":oError(10) = "系统应用程序运行错误！":oError(11) = "函数参数错误！":oError(12) = "数据库对象为空,无法连接数据库服务器！":oError(13) = "无法连接数据库，请检查数据库配置信息是否正确！":oError(14) = "无效的查询条件，无法获取记录集！":oError(15) = "Execute SQL语句出错！":oError(16) = "向数据库插入新记录出错！":oError(17) = "生成SQL语句出错！":oError(18) = "更新数据库记录出错！":oError(19) = "从数据库删除记录出错！":oError(20) = "文件夹路径错误！":oError(21) = "文件路径错误！":oError(22) = "创建文件夹错误！":oError(23) = "创建文件错误！":oError(24) = "文件不存在！":oError(25) = "保存文件失败！":oError(26) = "文件缓存名称为空":oError(27) = "保存文件缓存失败":oError(28) = "保存缓存文件失败，请检查服务器网站目录下的缓存目录是否有写入和删除权限！":oError(29) = "网站模板解析执行出错！":oError(30) = "写入文件失败，请检查文件夹是否有写入权限！":oError(31) = "system config error":end sub:private sub class_terminate:set oError = nothing:end sub:public property Let msg(byval str):sMsg = str:end property:public sub raise(byval num):dim errMsg:num    = int(num):errMsg = oError(num):if num=0 then exit sub : end if:if num=2 then errMsg = errMsg &" "& sMsg &"" : end if:call showError(num,errMsg):sMsg = "":end sub:private function showError(byval num, byval msg):dim html:html = "<table cellpadding=""0"" cellspacing=""0"" class=""system-message"" identify=""system-message""><tbody><tr><td>":html = html & "<div style=""border:1px solid #eee; color:#333; font-size:14px; font-family:Arial,Helvetica,sans-serif; line-height:180%; padding:30px 40px;"">":html = html & "<div style=""font-size:24px;"">系统错误提示</div>":html = html & "<div style=""margin:0px 0px 5px 0px; padding:15px 0px 5px 0px;"">":html = html & "<div><b>Error.num:</b> "& num & "</div>":html = html & "<div><b>Error.msg:</b> "& msg &"</div>":if DEBUG then:html = html & "<div><b>Error.detail:</b> "& sMsg & "</div>":html = html & "<div><b>Error.page:</b> "& OW.urlDecode(OW.getUrl("")) & "</div>":if err.number<>0 then:html = html & "<div><b>Error.number:</b> "& err.number & "</div>":html = html & "<div><b>Error.description:</b> "& err.description & "</div>":html = html & "<div><b>Error.source:</b> "& err.source & "</div>":end if:end if:html = html & "</div>":html = html & "<div><b>寻找解决方案:</b> <a href=""http://www.openwbs.com/doc/"& num &".html"">http://www.openwbs.com/doc/"& num &".html</a></div>":html = html & "<div style=""border-top:1px solid #eee; font-size:11px; margin:8px 0px 0px 0px; padding:8px 0px 0px 0px;"">Version Information: "& OW_VERSION &" ("& OW_VERSION_SN &"); <span style=""float:right;"">Powered by <a href=""http://www.openwbs.com/"" target=""_blank"">OpenWBS</a></span></div>":html = html & "</div>":html = html & "</td></tr></tbody></table>":call console.log("<span class=""text"">OW.DB.error</span><span class=""error"">"& err.number & err.description & err.source &"</span>"):response.write html:call OpenWBSClose():end function:end class:%>
<%:class OW_FSO_Class:private sCharSet,sOverWrite:private iIsWatermarkPng:private sub class_initialize():sCharSet   = OW.CharSet:sOverWrite = true:iIsWatermarkPng = false:end sub:private sub class_terminate():end sub:public property let [CharSet](byval str):sCharSet = Ucase(str):end property:public property get [CharSet]():[CharSet] = sCharSet:end property:public property let OverWrite(byval bool):sOverWrite = bool:end property:public property get OverWrite():OverWrite = sOverWrite:end property:public function ABSPath(byval path):path = replace(path,"*",""):path = replace(path,"?",""):path = replace(path,"""",""):path = replace(path,"|",""):path = replace(path,"<",""):path = replace(path,">",""):path = replace(path,"../",""):path = replace(path,"\..",""):if OW.isNul(path) or OW.isNul(replace(path,"/","")) or OW.isNul(replace(path,"\","")) then:ABSPath = "":exit function:end if:if instr(path,":")>0 then:path = OW.regReplace(path,"[/]+","/"):else:path = replace(path,"\","/"):path = OW.regReplace(path,"[/]+","/"):if left(path,1)="/" then:path = OW.serverMapPath(path):else:path = OW.serverMapPath(SITE_PATH & path):end if:end if:if right(path,1)="\" then path=left(path,Len(path)-1) : end if:ABSPath = path:end function:public function wartermarkPosition(byval imgWidth,byval imgHeight,byval wmWidth,byval wmHeight):dim arr(1):select case OW.config("wartermark_position"):case 0:arr(0) = 10:arr(1) = 10:case 1:arr(0) = (imgWidth - wmWidth)/2:arr(1) = 10:case 2:arr(0) = imgWidth - wmWidth - 10:arr(1) = 10:case 3:arr(0) = 10:arr(1) = (imgHeight - wmHeight)/2:case 4:arr(0) = (imgWidth - wmWidth)/2:arr(1) = (imgHeight - wmHeight)/2:case 5:arr(0) = imgWidth - wmWidth - 10:arr(1) = (imgHeight - wmHeight)/2:case 6:arr(0) = 10:arr(1) = imgHeight - wmHeight - 10:case 7:arr(0) = (imgWidth - wmWidth)/2:arr(1) = imgHeight - wmHeight - 10:case 8:arr(0) = imgWidth - wmWidth - 10:arr(1) = imgHeight - wmHeight - 10:end select:wartermarkPosition = arr:end function:public function fontLength(byval fontText,byval fontSize):dim c,i,length,n:n = len(fontText):length = 0:for i=1 to n:c = abs(ascw(mid(fontText,i,1))):if c>255 then:length = length + fontSize:else:length = length + fontSize/2:end if:next:fontLength = length:end function:public function addWatermark(byval filepath):on error resume next:dim arr,isPNG,jpeg,wmLogo,wmX,wmY,wmImagePath:if not iIsWatermarkPng then:if OW.getFileExName(OW.config("wartermark_image"))="png" then:iIsWatermarkPng = true:end if:end if:set jpeg = server.createObject("Persits.Jpeg"):jpeg.Open OW.serverMapPath(filepath):if jpeg.OriginalWidth<OW.int(OW.config("wartermark_min_width")) or jpeg.OriginalHeight<OW.int(OW.config("wartermark_min_height")) then:addWatermark = false:else:OW.config("wartermark_transparency") = OW.parseFloat(OW.config("wartermark_transparency"),2):if OW.config("wartermark_transparency")>1 then OW.config("wartermark_transparency")=1 : end if:if OW.config("wartermark_transparency")<0 then OW.config("wartermark_transparency")=0 : end if:if OW.config("wartermark_type")=0 then:wmImagePath = OW.serverMapPath(OW.config("wartermark_image")):set wmLogo  = server.CreateObject("Persits.Jpeg"):wmLogo.open wmImagePath:arr = wartermarkPosition(jpeg.OriginalWidth,jpeg.OriginalHeight,wmLogo.OriginalWidth,wmLogo.OriginalHeight):wmX = arr(0):wmY = arr(1):if wmX < 0 then wmX=0 : end if:if wmY < 0 then wmY=0 : end if:if iIsWatermarkPng  then:jpeg.Canvas.DrawPNG wmX,wmY,wmImagePath:else:jpeg.Canvas.DrawImage wmX,wmY,wmLogo,OW.config("wartermark_transparency"):end if:jpeg.save OW.serverMapPath(filepath):set wmLogo = nothing:else:arr = wartermarkPosition(jpeg.OriginalWidth,jpeg.OriginalHeight,fontLength(OW.config("wartermark_font"),OW.config("wartermark_font_size")),OW.config("wartermark_font_size")):wmX = arr(0):wmY = arr(1):if wmX < 0 then wmX=0 : end if:if wmY < 0 then wmY=0 : end if:jpeg.Canvas.Font.Size    = OW.config("wartermark_font_size"):jpeg.Canvas.Font.Color   = OW.reps(OW.config("wartermark_font_color"),"#","&H"):jpeg.Canvas.Font.Bold    = false:jpeg.Canvas.Font.Family  = "宋体":jpeg.Canvas.Print wmX,wmY,OW.config("wartermark_font"):jpeg.Save server.MapPath(filepath):jpeg.Quality= 98:end if:addWatermark = true:end if:set jpeg = nothing:if err.number<>0 then:err.clear:addWatermark = false:end if:end function:public function imageCompress(byval imagePath):on error resume next:if not(OW.isObjInstalled("Persits.Jpeg")) then imageCompress = false : exit function : end if:dim jpegObj,filePath,fileName,oHeight,oWidth:filePath = OW.getFolderPath(imagePath):fileName = OW.getFileName(imagePath,false):set jpegObj = server.createObject("Persits.Jpeg"):jpegObj.Open OW.FSO.ABSPath(imagePath):oHeight = jpegObj.OriginalHeight:oWidth  = jpegObj.OriginalWidth:jpegObj.Quality = 94:if oWidth>2000 then:jpegObj.Width  = 2000:jpegObj.Height = 2000/oWidth * oHeight:end if:jpegObj.Save server.MapPath(imagePath):set jpegObj = nothing:if err.number<>0 then:err.clear():OW.FSO.deleteFile(OW.FSO.ABSPath(imagePath)):imageCompress = false:else:imageCompress = true:end if:end function:public function checkFSOInstalled():if OW.isFSOInstalled = false then:OW.Error.Msg = "OW.FSO.checkFSOInstalled()":OW.Error.raise 1:err.clear():end if:end function:public function createFolder(byval folderPath):call checkFSOInstalled():dim okPath,i:dim pFolderExists : pFolderExists = false:createFolder  = false:folderPath = ABSPath(folderPath):if not(OW.isNul(folderPath)) then:folderPath=split(folderPath,"\"):for i=0 to ubound(folderPath):if i=0 then:okPath = trim(folderPath(i)):else:if trim(folderPath(i))<>"" then:okPath = okPath &"\"& trim(folderPath(i)):    end if:end if:if i>0 then:if pFolderExists=false then:if not OW.ObjectFSO.folderExists(okPath)=false then:pFolderExists = true:end if:end if:if pFolderExists=true then:on error resume next:if OW.ObjectFSO.folderExists(okPath)=false then:call createFolderByFSO(okPath):end if:if err.number<>0 then:OW.Error.Msg = okPath:OW.Error.raise 20:err.clear():end if:end if:end if:next:createFolder = okPath:end if:end function:public function createFolderByFSO(byval folderPath):err.clear():on error resume next:dim result : result = true:OW.ObjectFSO.createFolder(folderPath):if err.number<>0 then:result = false:end if:err.clear():createFolderByFSO = result:end function:public function deleteFile(byval fileABSPath):dim result : result = true:on error resume next:OW.ObjectFSO.deleteFile(fileABSPath):if err.number<>0 then:result = false:else:result = true:end if:err.clear():deleteFile = result:end function:public function deleteFolder(byval folderABSPath):dim result : result = true:on error resume next:OW.ObjectFSO.deleteFolder(folderABSPath):if err.number<>0 then:err.clear():if OW.right(folderABSPath,1)="/" then:OW.ObjectFSO.deleteFolder(OW.left(folderABSPath,len(folderABSPath)-1)):if err.number<>0 then:result = false:end if:end if:else:result = true:end if:deleteFolder = result:end function:public function fileCopy(byval fromFilePath,byval toFilePath):on error resume next:dim filepath,result : result = true:if fromFilePath="" or toFilePath="" then fileCopy = false : exit function : end if:filepath = OW.getFolderPath(toFilePath):if not folderExists(filepath) then:call OW.FSO.createFolder(filepath):end if:OW.ObjectFSO.copyFile ABSPath(fromFilePath),ABSPath(toFilePath):if err.number<>0 then:result = false:err.clear():end if:fileCopy = result:end function:public function folderCopy(byval fromPath,byval toPath):on error resume next:dim folderPath,result : result = true:if fromPath="" or toPath="" then folderCopy = false : exit function : end if:if not folderExists(toPath) then:call OW.FSO.createFolder(toPath):end if:OW.ObjectFSO.copyfolder ABSPath(fromPath),ABSPath(toPath):if err.number<>0 then:result = false:err.clear():end if:folderCopy = result:end function:public function fileExists(byval filepath):on error resume next:dim restult:filepath = ABSPath(filepath):restult = OW.ObjectFSO.FileExists(filepath):if err.number<>0 then:restult = false:err.clear():end if:fileExists = restult:end function:public function fileList(byval folderPath,byval returnType):on error resume next:dim i,f,fi,folder,arr,json,html,mapPath,tmp,return:folderPath = OW.parseFolderPath(folderPath):returnType = lcase(returnType):if folderPath = "/" then folderPath = "" : end if:mapPath = OW.serverMapPath(SITE_PATH & folderPath):set f = OW.objectFSO:if f.folderExists(mapPath)=false then:fileList = "{""foldername"":"""& OW.getFolderName(folderPath) &""",""size"":""0"",""datetime"":"""",""folderpath"":"""& folderPath &""",""filecount"":""0"",""files"":[],""folderexists"":""false""}":exit function:end if:set folder = f.getFolder(mapPath):i = 0:redim arr(folder.Files.count):for each fi in folder.Files:arr(i) = fi.name:i= i + 1:tmp    = "{""filename"":"""& fi.name &""",""size"":"""& OW.FormatSize(fi.size) &""",""datetime"":"""& fi.datelastmodified &""",""filepath"":"""& folderPath & fi.name &"""}":if OW.isNul(json) then:json = tmp:else:json = json &","& tmp:end if:next:json = "{""foldername"":"""& OW.getFolderName(folderPath) &""",""size"":"""& OW.FormatSize(folder.size) &""",""datetime"":"""& folder.datelastmodified &""",""folderpath"":"""& folderPath &""",""filecount"":"""& folder.Files.count &""",""files"":["& json &"]}":set folder = nothing:set f    = nothing:select case returnType:case "array" : return = arr:case "html"  : return = html:case "json"  : return = json:end select:if err.number<>0 then:err.clear():end if:fileList = return:end function:public function fileRename(byval filepath, byval filename):if fileExists(filepath) then:on error resume next:dim fso,f:filepath = ABSPath(filepath):set fso = OW.objectFSO:set f = fso.getFile(filepath):f.name = filename:set fso = nothing:set f = nothing:if err.number<>0 then:err.clear():fileRename = false:else:fileRename = true:end if:else:fileRename = false:end if:end function:public function getFilesize(byval filepath):if fileExists(filepath) then:filepath = ABSPath(filepath):dim f,fso,fsize:set fso = OW.objectFSO:set f   = fso.getFile(filepath):    fsize   = f.size:set fso = nothing:set f   = nothing:getFilesize = fsize:else:getFilesize = 0:end if:end function:public function fileWriteable(byval filepath):on error resume next:dim fileABSPath : fileABSPath = filepath:dim ado:set ado = server.createObject("ADODB.Stream"):With ado:.Mode = 3:.Type = 2:.Open:.CharSet   = sCharSet:.LoadFromFile fileABSPath:.SaveToFile fileABSPath,2:.Close:end With:set ado = nothing:fileWriteable = true:if err.number<>0 then fileWriteable = false : end if:err.clear():end function:public function folderExists(byval folderPath):folderPath = ABSPath(folderPath):if OW.IsFSOInstalled then:if OW.ObjectFSO.folderExists(folderPath) then folderExists = true : end if:else:folderExists = false:OW.Error.Msg = "OW.FSO.folderExists("""& folderPath &""")":OW.Error.raise 1:err.clear():end if:end function:public function folderList(byval folderPath,byval returnType):dim i,f,folder,subFolder,json,html,mapPath,tmp:folderPath = OW.parseFolderPath(folderPath):if folderPath = "/" then folderPath = "" : end if:mapPath = OW.serverMapPath(SITE_PATH & folderPath):set f = OW.objectFSO:if f.folderExists(mapPath)=false then:folderList = "{""foldername"":"""& OW.getFolderName(folderPath) &""",""size"":""0"",""datetime"":"""",""folderpath"":"""& folderPath &""",""subfolderscount"":""0"",""subfolders"":[],""folderexists"":""false""}":exit function:end if:i = 0:set folder=f.getFolder(mapPath):for each subFolder in folder.subFolders:i   = i + 1:tmp = "{""foldername"":"""& subFolder.name &""",""size"":"""& OW.FormatSize(subFolder.size) &""",""datetime"":"""& subFolder.datelastmodified &""",""folderpath"":"""& folderPath & subFolder.name &"/"",""subfolderscount"":"""& subFolder.SubFolders.count &""",""subfolders"":[],""folderexists"":""true""}":if json = "" then:json = tmp:else:json = json &","& tmp:end if:next:json = "{""foldername"":"""& OW.getFolderName(folderPath) &""",""size"":"""& OW.FormatSize(folder.size) &""",""datetime"":"""& folder.datelastmodified &""",""folderpath"":"""& folderPath &""",""subfolderscount"":"""& folder.SubFolders.count &""",""subfolders"":["& json &"],""folderexists"":""true""}":set folder = nothing:set f    = nothing:select case lcase(returnType):case "json" : folderList = json:case "html" : folderList = html:end select:end function:public function folderWriteable(byval folderPath):on error resume next:dim filepath,text : text = "writeable "& SYS_TIME:if right(folderPath,1)="\" then:filepath = folderPath & "testwriteable.txt":else:filepath = folderPath &"\"& "testwriteable.txt":end if:dim ado:set ado = server.createObject("ADODB.Stream"):With ado:.Mode = 3:.Type = 2:.Open:.CharSet   = sCharSet:.Position  = 0:.WriteText = text:.SaveToFile filepath,2:.Close:end With:set ado = nothing:if err.number<>0 then:folderWriteable = false:else:if fileExists(filepath) then:folderWriteable = true:call deleteFile(filepath):else:folderWriteable = false:end if:end if:err.clear():end function:public function saveFile(byval filepath, byval text):saveFile = saveTextFileByADO(filepath,text):end function:public function saveTextFile(byval filepath, byval text):saveTextFile = saveTextFileByADO(filepath,text):end function:public function saveTextFileByADO(byval filepath, byval fileContent):on error resume next:if OW.isNul(filepath) then saveTextFileByADO=false : exit function : end if:dim ado,folderPath,result:filepath = ABSPath(filepath):folderPath = left(filepath,InstrRev(filepath,"\")-1):if folderExists(folderPath) = false then:folderPath = createFolder(folderPath):end if:if folderPath = false then saveTextFileByADO = false : exit function : end if:set ado = server.createObject("ADODB.Stream"):With ado:.Mode = 3:.Type = 2:.Open:.CharSet   = sCharSet:.Position  = 0:.WriteText = fileContent:.SaveToFile filepath,2:.Flush:.Close:end With:set ado = nothing:result = true:if err.number<>0 then:result = false:OW.Error.Msg = filepath:OW.Error.raise 30:end if:err.clear():saveTextFileByADO = result:end function:public function saveTextFileByFSO(byval fileABSPath,byval text):on error resume next:dim f,fi:set f  = server.createObject("Scripting.FileSystemObject")   :set fi = f.OpenTextFile(fileABSPath,2,true):fi.Write text:set fi = nothing:set f  = nothing:if err.number<>0 then:saveTextFileByFSO = false:else:saveTextFileByFSO = true:end if:err.clear():end function:end class:%>
<%:class OW_HTTP_Class:private sTempString,sRelFilePath,sAbsFilePath:public function bytesToBstr(byval body,byval coding):on error resume next:dim stream:set stream = server.createObject("adodb.stream"):stream.type = 1:stream.mode = 3:stream.open:stream.write body:stream.position = 0:stream.type = 2:stream.charset = coding:bytesToBstr = stream.ReadText:stream.close:set stream = nothing:if err.number<>0 then:err.clear:end if:end function:function getBody(conStr,startStr,overStr,incluL,incluR):if conStr="$false$" or conStr="" or isNull(conStr)=true or startStr="" or isNull(startStr)=true or overStr="" or isNull(overStr)=true then:getBody = "$false$":exit function:end if:dim start,over:start = InStrB(1,conStr,startStr,vbBinaryCompare):if start <= 0 then:start = InStrB(1,conStr,replace(startStr,vbCrLf,chr(10)),vbBinaryCompare):if start <= 0 then:start = InStrB(1,conStr,replace(startStr,vbCrLf,chr(13)),vbBinaryCompare):if start <= 0 then:getBody = "$false$":exit function:else:if incluL = false then:start = start + LenB(startStr):end if:end if:else:if incluL = false then:start = start + LenB(startStr):end if:end if:else:if incluL = false then:start = start + LenB(startStr):end if:end if:over = InStrB(start,conStr,overStr,vbBinaryCompare):if over <= 0 or over <= start then:over = InStrB(start,conStr,replace(overStr,vbCrLf,chr(10)),vbBinaryCompare):if over <= 0 or over <= start then:over = InStrB(start,conStr,replace(overStr,vbCrLf,chr(13)),vbBinaryCompare):if over <= 0 or over <= start then:getBody = "$false$":exit function:else:if incluR = true then:over = over + LenB(overStr):end if:end if:else:if incluR = true then:over = over + LenB(overStr):end if:end if:else:if incluR = true then:over = over + LenB(overStr):end if:end if:getBody = MidB(conStr,start,over - start):end function:public function getData(byval url,byval coding):getData = httpRequest("GET",url,"",coding):end function:public function postData(byval url,byval data,byval coding):postData = httpRequest("POST",url,data,coding):end function:public function httpRequest(byval method,byval url,byval data,byval coding):dim i,http,xmlHttp,return:on error resume next:if OW.isNul(url) or len(url)<8 then:httpRequest = "":exit function:end if:method  = OW.iif(ucase(method)="GET","GET","POST"):xmlHttp = array("MSXML2.serverXMLHTTP","MSXML2.XMLHTTP","Microsoft.XMLHTTP","MSXML2.ServerXMLHTTP.3.0","MSXML2.ServerXMLHTTP.6.0","WinHttp.WinHttpRequest.5.1"):coding  = OW.trim(coding):coding  = OW.iif(OW.isNul(coding),OW.charset,coding):do while true:if OW.isObjInstalled(xmlHttp(i)) then:set http = server.createObject(xmlHttp(i)):http.open method,url,false:if method="GET" then:http.send:if http.readystate<>4 then:return = "":else:return = bytesToBstr(http.ResponseBody,coding):end if:else:http.setRequestHeader "Content-Type","application/x-www-form-urlencoded":http.send data:return = bytesToBstr(http.ResponseBody,coding):end if:if err.number<>0 then:err.clear:if DEBUG then : call OS.addSystemErrorRecord("OW.HTTP.httpRequest("""& method &""","""& url &""","""& data &""","""& coding &""")出现错误！","server.createObject("& xmlHttp(i) &")") : end if:end if:exit do:else:if i<ubound(xmlHttp) then:i = i+1:else:exit do:end if:end if:loop:set http = nothing:httpRequest = return:end function:public function saveRemoteFile(byval remoteUrl,byval locPath):if OW.isNul(locPath) then:saveRemoteFile = false:exit function:end if:on error resume next:dim folderPath,ado,xHttp,remoteData:folderPath = OW.getFolderPath(locPath):if not(OW.FSO.folderExists(folderPath)) then:call OW.FSO.createFolder(folderPath):end if:set xHttp = server.createObject("Microsoft.XMLHTTP"):with xHttp:.open "get",remoteUrl,false,"","":.send:remoteData = .responseBody:end with:if err.number<>0 then:err.clear:saveRemoteFile = false:exit function:end if:set xHttp = Nothing:set ado = server.createObject("Adodb.Stream"):with ado:.type = 1:.open:.write remoteData:.saveToFile OW.serverMapPath(SITE_PATH & locPath),2:.cancel:.close:end with:set ado = Nothing:if err.number<>0 then:err.clear:saveRemoteFile = false:else:saveRemoteFile = true:end if:end function:end class:%>
<%:class OW_JSON_Class:private sub class_initialize():end sub:private sub class_terminate():end sub:public function parse(byval str):set parse = JSON.parse(str):end function:public function stringify(byval obj):stringify = JSON.stringify(obj):end function:end class:%>
<script language="javascript" runat="server">
if(!Array.prototype.get){Array.prototype.get=function(prop){return this[prop];}}"use strict";if(!this.JSON){JSON={};}
(function(){function f(n){return n<10?'0'+n:n;}
if(typeof Date.prototype.toJSON!=='function'){Date.prototype.toJSON=function(key){return isFinite(this.valueOf())?this.getUTCFullYear()+'-'+
f(this.getUTCMonth()+1)+'-'+
f(this.getUTCDate())+'T'+
f(this.getUTCHours())+':'+
f(this.getUTCMinutes())+':'+
f(this.getUTCSeconds())+'Z':null;};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key){return this.valueOf();};}
var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a){var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}
function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}
if(typeof rep==='function'){value=rep.call(holder,key,value);}
switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]'){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}
v=partial.length===0?'[]':gap?'[\n'+gap+
partial.join(',\n'+gap)+'\n'+
mind+']':'['+partial.join(',')+']';gap=mind;return v;}
if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}
v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
if(typeof JSON.stringify!=='function'){JSON.stringify=function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}
rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}
return str('',{'':value});};}
if(typeof JSON.parse!=='function'){JSON.parse=function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}
return reviver.call(holder,key,value);}
cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+
('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}
if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
throw new SyntaxError('JSON.parse');};}}());
</script>
<%:class OW_Session_Class:public isEncrypt,sessionPre,[timeout],appSessionNumLimit:private sub class_initialize():appSessionNumLimit = 5000:end sub:private sub class_terminate():end sub:private function encrypt(byval s):encrypt = OW.Base64.Encode(s):end function:private function decrypt(byval s):decrypt = OW.Base64.Decode(s):end function:public function getAppSession(byval key,byval expiresTime):dim arr,t:expiresTime = OW.int(expiresTime):arr   = application(sessionPre & key):if isArray(arr) then:if OW.dateDiff("s",cdate(arr(1)),SYS_TIME) < expiresTime then:getAppSession = arr(0):else:getAppSession = "":call removeAppSession(sessionPre & key):end if:else:getAppSession = "":call removeAppSession(sessionPre & key):end if:end function:public sub setAppSession(byval key ,byval v):key = sessionPre & key:application(key) = array(v,SYS_TIME):if application.contents.count > appSessionNumLimit then:call clearTimeoutAppSession():end if:end sub:public sub updateAppSession(byval key):dim arr:arr = application(sessionPre & key):if isArray(arr) then:application(sessionPre & key) = array(arr(0),SYS_TIME):end if:end sub:public sub clearTimeoutAppSession():dim key,val:for each key in application.contents:val = application.Contents(key):if isArray(val) then:if dateDiff("n",cdate(val(1)),SYS_TIME) > OW.loginTimeout then:call removeAppSession(key):end if:end if:next:end sub:public sub removeAppSession(byval key):if left(key,len(sessionPre))<>sessionPre then:key = sessionPre & key:end if:application.lock:application.contents.remove(key):application.unLock:end sub:public sub removeAllAppSession():dim key:for each key in application.contents:application.lock:application.contents.remove(key):application.unLock:next:end sub:public function getSession(byval key):dim v:if key<>"" then:key = sessionPre & key:if isObject(session(key)) then:set getSession = session(key):else:v = session(key):if isEncrypt then v = decrypt(v) : end if:getSession = v:end if:else:getSession = "":end if:end function:public sub setSession(byval key, byval v):key = sessionPre & key:if isObject(v) then:set session(key) = v:else:if isEncrypt then v = encrypt(v) : end if:session(key) = v:end if:session.Timeout = timeout:end sub:public sub removeSession(byval key):key = sessionPre & key:if isObject(session(key)) then:set session(key) = nothing:end if:  session.Contents.remove(key):end sub:public sub removeAll():  session.Contents.removeAll():end sub:private sub clear():session.Abandon():end sub:end class:%>
<%
class OW_SHA1_Class
	'**OW.SHA1.encode(str)
	public function encode(byval str)
		encode = SHA1Class.encode(str)
	end function
end class
%>
<script language="javascript" type="text/javascript" runat="server">
var SHA1Class = new SHA1_Class();
function SHA1_Class(){
	var hexcase = 0;
	var b64pad  = "=";
	var chrsz   = 8;
	function hex_sha1(s){return binb2hex(core_sha1(str2binb(s),s.length * chrsz));};
	function b64_sha1(s){return binb2b64(core_sha1(str2binb(s),s.length * chrsz));};
	function str_sha1(s){return binb2str(core_sha1(str2binb(s),s.length * chrsz));};
	function hex_hmac_sha1(key, data){ return binb2hex(core_hmac_sha1(key, data));};
	function b64_hmac_sha1(key, data){ return binb2b64(core_hmac_sha1(key, data));};
	function str_hmac_sha1(key, data){ return binb2str(core_hmac_sha1(key, data));};
	function sha1_vm_test(){
		return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
	};
	function core_sha1(x,len){
		x[len >> 5] |= 0x80 << (24 - len % 32);
		x[((len + 64 >> 9) << 4) + 15] = len;
		var w = Array(80);
		var a =  1732584193;
		var b = -271733879;
		var c = -1732584194;
		var d =  271733878;
		var e = -1009589776;
		for(var i = 0; i < x.length; i += 16){
			var olda = a;
			var oldb = b;
			var oldc = c;
			var oldd = d;
			var olde = e;
			for(var j = 0; j < 80; j++){
				if(j < 16) w[j] = x[i + j];
				else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
				var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
								 safe_add(safe_add(e, w[j]), sha1_kt(j)));
				e = d;
				d = c;
				c = rol(b, 30);
				b = a;
				a = t;
			};
			a = safe_add(a, olda);
			b = safe_add(b, oldb);
			c = safe_add(c, oldc);
			d = safe_add(d, oldd);
			e = safe_add(e, olde);
		};
		return Array(a, b, c, d, e);
	};
	function sha1_ft(t, b, c, d){
		if(t < 20) return (b & c) | ((~b) & d);
		if(t < 40) return b ^ c ^ d;
		if(t < 60) return (b & c) | (b & d) | (c & d);
		return b ^ c ^ d;
	};
	function sha1_kt(t){
		return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
			 (t < 60) ? -1894007588 : -899497514;
	};
	function core_hmac_sha1(key, data){
		var bkey = str2binb(key);
		if(bkey.length > 16) bkey = core_sha1(bkey, key.length * chrsz);
		var ipad = Array(16), opad = Array(16);
		for(var i = 0; i < 16; i++){
			ipad[i] = bkey[i] ^ 0x36363636;
			opad[i] = bkey[i] ^ 0x5C5C5C5C;
		};
		var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
		return core_sha1(opad.concat(hash), 512 + 160);
	};
	function safe_add(x, y){
		var lsw = (x & 0xFFFF) + (y & 0xFFFF);
		var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
		return (msw << 16) | (lsw & 0xFFFF);
	};
	function rol(num, cnt){
		return (num << cnt) | (num >>> (32 - cnt));
	};
	function str2binb(str){
		var bin = Array();
		var mask = (1 << chrsz) - 1;
		for(var i = 0; i < str.length * chrsz; i += chrsz){
			bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (32 - chrsz - i%32);
		};
		return bin;
	};
	function binb2str(bin){
		var str = "";
		var mask = (1 << chrsz) - 1;
		for(var i = 0; i < bin.length * 32; i += chrsz){
			str += String.fromCharCode((bin[i>>5] >>> (32 - chrsz - i%32)) & mask);
		};
		return str;
	};
	function binb2hex(binarray){
		var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
		var str = "";
		for(var i = 0; i < binarray.length * 4; i++){
			str += hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF) +
			   hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8  )) & 0xF);
		};
		return str;
	};
	function binb2b64(binarray){
		var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		var str = "";
		for(var i = 0; i < binarray.length * 4; i += 3){
			var triplet = (((binarray[i   >> 2] >> 8 * (3 -  i   %4)) & 0xFF) << 16)
					| (((binarray[i+1 >> 2] >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 )
					|  ((binarray[i+2 >> 2] >> 8 * (3 - (i+2)%4)) & 0xFF);
			for(var j = 0; j < 4; j++){
				if(i * 8 + j * 6 > binarray.length * 32){
					str += b64pad;
				}else{
					str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
				};
			};
		};
		return str;
	};
	this.encode = function(str){
		return hex_sha1(str);
	};
};
</script>
<%#@~^UwkAAA==nX+^!Y`V8!8TFZFTFZFTqZF!8TFZF!8Tq!vm4Dc*XbLm4DvX**[^4M`Fq{*[^tMcWGbLm4D`F,*'m4DcFZ,b'1tDv1!*[m4.ccO#Lm4Dc1R#'m4.`8!1bLmt.cF%b[14M`*R#LmtM`O{#Lm4Dv%{bLmtMc*F#[14.`8FF#'m4.vGf#L^tM`{q*[m4.v%#L^4Dc8!+#[1tMc,F#'m4Dc{8#[14Dv*v*'^tM`8Fq#'^4Dc%Ob[1t.c8F!b'1t.`8TR#'1tM`*Z#L^tM`0,*[^4M`%Fb[1tDvqq,*[1t.`qT2#'m4.`O,b'1tDcX8#'m4.v%+*[1tDvFyq#Lm4DvGXbLmtMc%W#[14.`8Fy#'m4.vF+F*'m4Dc1Z#[^4M`0%*'1t.vGR#[1tMcF8,b[1t.cO%#L^tM`*Zb'm4Dv*f#'^4DcFy+#Lm4.v,!b'1t.`Rf*[^4Dv*&*[14Dv*q#Lm4.v,,*'m4D`8T1#Lm4DcFT0*[^tMccR#'^4D`1T*[^tMcR&bLm4D`8!Wb[1t.`8 +bLmtMcFZ!#L^4DvGy#'m4.vGf#L^tM`qqy#[^4M`{,*'1t.vFZ,#Lm4.`Rvb[1t.c8FG*'m4D`OTb[1tM`Gb'1t.`+#Lm4.vF!1bLm4DvqZ!bLm4D`RG*'m4Dc*2#'^4D`8Tv*[m4.cFZ!*[^t.cFFb[14DvFT0*[m4.vFq%*'1t.v,R#[1tMcFZvb[1t.c8F *'m4D`8T1#Lm4DcFTT*[^tMc%F#'^4D`Xf*[^tMc8!*[1tDvFZT#Lm4DvGqbLmtMcFZ%#L^4DvF8%b[^4M`1%*'m4DcqZ*#'^4Dcv+bLm4M`8F,*[14Dv,1#Lm4.vF!Ob[1tDvqT%*[1t.`qqF#'m4.`8!TbLmt.c+Gb[14M`qZc*[m4Dvq!l#'m4DcqZF#L^tM`%Rb'm4Dv,T#'^4DcFZ*#Lm4.v,%b'1t.`+{*[^4Dvvv*[14DvF+ *[^4M`FZT#LmtMc{ *[1t.`{f*[^tMcF8 b'1tDc{O#'m4.vFqZ#LmtM`F*#Lm4DvFT0*[m4.`O,#L^4Dv*8#'m4.vv#L^tM`qqR#[^4M`1%*'1t.vF8!#Lm4.`F%b[1t.c8!%*'m4D`Fb[1tM`qFTbLm4Dvq!Z#'^4D`q+8#'m4.v,{*[1tDv%Rb[1t.`R b'1tDvq!R#[14.`F**[^t.cF b[14DvG0bLmt.cW%b[14M`1O#LmtM`8T**[^tM`qTF#[14Dv*c*'^tM`O,b[^4M`q!Ob[1t.cRv#'^4DcFy+*[^4Dv,,*[14DvGq#Lm4.v*G*'m4D`8q{#Lm4Dc,1bLm4DvX!*[^4M`%XbLm4Dvq8GbLm4D`O!*'m4DcFZ,b'1tDvq Z#[14.`W,*[^t.cO,b[14Dv*TbLmt.c8!f#L^4Dc8F8#[1tMcGl#'m4Dc0W#[14DvFFyb'm4DvFT%b'1t.`O0#Lm4.vF!1bLm4Dv08#'1tM`FZ&*'m4Dc,Z#'^4D`8q!*[m4.c%+#Lm4Dcq8Gb[14Dv%1bLmt.clFb[14M`0y#LmtM`8q *[^tM`10*[m4.`l!#L^4Dv*y#'m4.v**#L^tM`1T*[m4.vFq!*'1t.v%+#[1tMcF8Gb[1t.cR,#L^tM`*8b'm4Dv%+#'^4DcF8+#Lm4.v,%b'1t.`lT*[^4Dv* *[14DvFT&*[^4M`,Zb[1tDv{q#Lm4DcFT0*[^tMcFZ%b'1tDc{l#'m4.vGq*[1tDvGWb[1t.`l&b'1tDvq!Z#[14.`8!O#'m4.vGT#L^tM`qql#[^4M`{&*'1t.vGy#[1tMcGR#'m4Dc*R#[14Dv,,*'^tM`8!X#'^4DcFZ{#Lm4.v*cb'1t.`O1*[^4DvF!O#L^tM`0v*[^4M`Fy+#LmtMc1,*[1t.`{q*[^tMc*F#'^4D`qqF#'m4.v,1*[1tDv*Zb[1t.`R*b'1tDvqFF#[14.`8!Z#'m4.v*q#L^tM`{**[m4.vFq *'1t.vFZ!#Lm4.`FFb[1t.cR*#L^tM`F8qb[1tM`1,b'1t.`lq#Lm4.v% b'1t.`8+8#'1tM`Gl#L^tM`0c*[^4M`F8+#LmtMcq 8#Lm4Dc1Z#'m4.`R%b'1tDc{R#'m4.vFqO#LmtM`O0#Lm4Dv*TbLmtMc*2#[14.`8 y#'m4.v,T#L^tM`0f*[m4.v*f#L^4Dc8!R#[1tMc,R#'m4DcqZ,#L^tM`%8b'm4DvFqFb'1t.`FX#Lm4.v%cb'1t.`8qy#'1tM`FZ%*'m4Dc,R#'^4D`8T,*[m4.c%8#Lm4DcqZ&b[14Dv,TbLmt.c8FT#L^4DcRv*[m4DvqFF#'m4Dc0O#[14Dv*F*'^tM`R b[^4M`qFyb[1t.cO%#'^4Dc*ZbLm4M`l #Lm4.`lcb#*xG0CAA==^#~@%>
<%#@~^Qw8AAA==nX+^!Y`V8!8TFZFTFZFTqZF!8TFZF!8Tq!vm4Dc*XbLm4DvX**[^4M`Fq{*[^tMcWGbLm4D`O!*'m4Dc%R#'^4D`8Tc*[m4.cFZ%*[^t.cR,b[14Dv*qbLmt.cRvb[14M`*R#LmtM`OT#Lm4Dv%fbLmtMcFZc#L^4DvF8*b[^4M`{G*'m4Dc0W#[^4M`**'1t.vFy!#Lm4.`FGb[1t.c+%#L^tM`vOb'm4DvFq,b'1t.`F{#Lm4.v%cb'1t.`+X*[^4DvF Z#L^tM`{G*[^4M`vRb[1tDv1#Lm4DcFq1*[^tMcGF#'^4D`0**[^tMc+*bLm4D`8 Zb[1t.`FGb'1tDv%*[m4.cvO#Lm4Dcq8,b[14DvG{bLmt.cRcb[14M`l#LmtM`8+!*[^tM`{{*[m4.`+%#L^4DvvO#'m4.vFq,*'m4Dc{F#[^4M`0c*'1t.vvl#[1tMcF8Fb[1t.cO%#L^tM`vRb'm4Dvv1#'^4DcF81#Lm4.vGGb'1t.`R**[^4Dvv**[14DvF+!*[^4M`GFb[1tDv0#Lm4Dcv1bLm4DvqFO#'^4D`{{*[^tMcRcbLm4D`+**'m4DcFy!b'1tDv{G*[m4.cvR#Lm4DcO#'m4.`8F1bLmt.cFGb[14M`0W#LmtM`+X#Lm4DvF+T*[m4.`FG#L^4DvvR#'m4.vv1#L^tM`qqO#[^4M`{G*'1t.v%W#[1tMcvl#'m4Dcqy!#L^tM`GFb'm4Dvv0#'^4DcvOb[1t.c8F,b'1t.`F{*[^4Dv%c*[14DvvX#Lm4.vF Zb[1tDv{{#Lm4Dcv{bLm4Dvq!W#'^4D`qql#'m4.vG{*[1tDv%Wb[1t.`+*b'1tDvq Z#[14.`FG*[^t.c+%b[14Dvv1bLmt.c8F1#L^4DcFG*[m4Dv0c*[^tM`X*[m4.`8 !*'^tM`FGb[^4M`%*'m4DcO#[^4M`qFObLm4M`FG#Lm4.`Rcb[1t.c+*#L^tM`FyTb[1tM`{Gb'1t.`+0#Lm4.vv,b'1t.`8qO#'1tM`GF#L^tM`0c*[^4M`vlb[1tDvq+!*[1t.`{{*[^tMcvR#'^4D`1*[^tMc8F1*[1tDvGFb[1t.`Rcb'1tDv**[m4.cFy!*[^t.cFGb[14Dvv{bLmt.c8!*#L^4Dc8!+#[1tMc,F#'m4Dc{y#[14DvG&*'^tM`8Fq#'^4DcGFb[1t.cRc#'^4DcvObLm4M`8 !*[14DvGX#Lm4.v%&*'m4D`OTb[1tM`q!bLm4Dv1G*[^4M`G+bLm4Dv{2#'1tM`F8F*'m4DcGF#'^4D`R*#LmtMc,*[1t.`Xf*[^tMcGl#'^4D`0f*[^tMcO!bLm4D`8!+b[1t.`OGb'1tDv{ *[m4.cG2#Lm4Dcq8Fb[14DvG0bLmt.c+%b[14M`0l#LmtM`8q *[^tM`{**[m4.`8!,*'^tM`F%b[^4M`qF8b[1t.cO,#'^4DcFZX*[^4DvF!2#L^tM`q Z#'^4D`F{#LmtMc%*[1t.`0X*[^tMcF8 b'1tDc{W#'m4.vFTO#LmtM`F0#Lm4DvFqq*[m4.`O,#L^4DvFZ*b[^4M`q!2b[1t.c8 !b'1t.`F{*[^4Dv%c*[14DvvX#Lm4.vFFyb[1tDv{*#Lm4DcFT1*[^tMcGR#'^4D`qq8#'m4.v,1*[1tDvFZX#Lm4DvFTf*[m4.`l&#L^4DvGO#'m4.v%f#L^tM`qTF#[^4M`q!ObLm4M`R,#Lm4.`l!b[1t.c8!c*'m4D`8+q#Lm4DcGXbLm4Dv%*[^4M`v1bLm4Dvq8,bLm4D`F,*'m4DcvF#'^4D`8TG*[m4.cFZ,*[^t.cR,b[14Dv*TbLmt.c8!*#L^4Dc8 8#[1tMcGl#'m4DcR#[14Dvv,*'^tM`8 T#'^4DcGRb[1t.c8 Fb'1t.`8TF#'1tM`FZ,*'m4Dc%O#'^4D`lT#LmtMcq!W#Lm4DcqyFb[14DvGXbLmt.c+%b[14M`O#LmtM`8q,*[^tM`{{*[m4.`+G#L^4DvFZGb[^4M`q!Ob[1t.cR,#'^4Dc*ZbLm4M`8!c*[14DvF+F*[^4M`Glb[1tDv0#Lm4Dcv1bLm4DvqFO#'^4D`{{*[^tMcR&bLm4D`8!Fb[1t.`8!1bLmtMc%O#[14.`l!*[^t.c8!*#L^tM`q+8#[^4M`{**'1t.vvR#[1tMcvO#'m4Dcqy!#L^tM`GRb'm4Dv%f#'^4DcFZ{#Lm4.vF!1bLm4Dv0O#'1tM`*Z#L^tM`q!W#'^4D`8+F*[m4.cGl#Lm4DcR#'m4.`RFb'1tDcX8#'m4.vGX*[1tDv%2b[1t.`O!b'1tDvq!+#[14.`OG*[^t.cF b[14DvGfbLmt.c8Fq#L^4DcFG*[m4Dv0c*[^tM`X*[m4.`8F,*'^tM`F*b[^4M`0&*'m4Dc1Z#[^4M`q!+bLm4M`OG#Lm4.`F b[1t.cF&#L^tM`F8qb[1tM`{Gb'1t.`R*#Lm4.vv*b'1t.`l+*[^4DvG**[14Dv%f#Lm4.v,!*'m4D`8T#Lm4Dc,{bLm4Dv{ *[^4M`GfbLm4Dvq8FbLm4D`FG*'m4Dc%W#'^4D`+X#LmtMcX *[1t.`{X*[^tMc%2#'^4D`1T*[^tMc8!*[1tDv,Fb[1t.`F b'1tDv{&*[m4.cF8F*[^t.cF%b[14Dvv0bLmt.cO,b[14M`q8 *[m4Dv{c*[^tM`qTO#[14DvG%*'^tM`8Fq#'^4Dc,Ob[1t.c8!*b'1t.`8T2#'1tM`Fy!*'m4DcGF#'^4D`R*#LmtMc,*[1t.`qqy#'m4.`Fcb'1tDcqZ,b[14M`{R#LmtM`8qF*[^tM`11*[m4.`8!**'^tM`8!f#'^4DcFyT#Lm4.vGGb'1t.`R**[^4DvF!F#L^tM`qFy#'^4D`F*#LmtMcq!O#Lm4Dc{R#'m4.`8FqbLmt.cO,b[14M`qZ**[m4Dvq!2#'m4Dc*R#[14DvG%*'^tM`8!X#'^4DcFZ{#Lm4.vF!1bLm4Dv0O#'1tM`*Z#L^tM`q!W#'^4D`8+F*[m4.cGl#Lm4DcR#'m4.`8!{bLmt.cl&b[14M`{l#LmtM`Rf#Lm4Dv,TbLmtMcFZv#L^4Dv,F#'m4.vG+#L^tM`{f*[m4.vFqF*'1t.vGF#[1tMc%W#'m4Dcl#[14Dv* *'^tM`F*b[^4M`0&*'m4Dc1Z#[^4M`q!+bLm4M`OG#Lm4.`F b[1t.cF&#L^tM`F8qb[1tM`{,b'1t.`R*#Lm4.v,,b'1t.`8qy#'1tM`GW#L^tM`q!O#'^4D`F0#LmtMcqF8#Lm4Dc1O#'m4.`8!XbLmt.c8!f#L^4Dc8 Z#[1tMcGF#'m4Dc0W#[14Dv%**'^tM`8F+#'^4DcGWb[1t.c8!,b'1t.`F0*[^4DvFF8#L^tM`1,*[^4M`FZX#LmtMcq!2#Lm4Dcqy!b[14DvG{bLmt.cRcb[14M`0l#LmtM`8q *[^tM`{**[m4.`8!,*'^tM`F%b[^4M`qF8b[1t.cO,#'^4DcFZX*[^4DvF!2#L^tM`*%*[^4M`GRb[1tDvqT**[1t.`qTF#'m4.`8!1bLmt.cR,b[14M`XZ#LmtM`8Tc*[^tM`q+8#[14DvG**'^tM`+%b[^4M`q!Fb[1t.clF#'^4DcGlbLm4M`R&#Lm4.`O!b[1t.c8!v*'m4D`O{b[1tM`{ b'1t.`Ff#Lm4.vFFqbLm4Dv{F#'1tM`%W#L^tM`,*[^4M`cOb[1tDv{X#Lm4Dc%fbLm4Dv1!*[^4M`FT*[^tMcOGbLm4D`F *'m4DcG2#'^4D`8qF*[m4.cGF#Lm4Dc0W#'m4.`+,b'1tDcqyFb[14M`{l#LmtM`Rf#Lm4DvFT{*[m4.`8F *'^tM`F*b[^4M`0&*'m4DcqZG#'^4Dcv8b*#bf0DAA==^#~@%>
<%#@~^dAQAAA==nX+^!Y`V8!8TFZFTFZFTqZF!8TFZF!8Tq!vm4Dc*XbLm4DvX**[^4M`Fq{*[^tMcWGbLm4D`F,*'m4DcFZ,b'1tDv1!*[m4.ccO#Lm4Dc1R#'m4.`8!1bLmt.cF%b[14M`*R#LmtM`O{#Lm4Dv%{bLmtMc*F#[14.`8FF#'m4.vGf#L^tM`{+*[m4.vG*#L^4Dc8!R#[1tMc,Z#'m4Dc{8#[14DvF!Rb'm4DvF+Fb'1t.`OT#Lm4.v%Gb'1t.`F0*[^4Dvc%*[14DvGX#Lm4.vGF*'m4D`F*b[1tM`X&b'1t.`8T!*[^4M`FT1*[^tMcF!bLm4D`8Flb[1t.`F&b'1tDv{ *[m4.c%+#Lm4DcqyFb[14Dv,0bLmt.c+Gb[14M`qZG*[m4DvXc*[^tM`11*[m4.`l!#L^4Dv%+#'m4.vc0#L^tM`{f*[m4.vv1#L^4DclG*[m4Dv0c*[^tM`{f*[m4.`+%#L^4DvcR#'m4.vFT&*'m4Dc1R#[^4M`q!ObLm4M`lG#Lm4.`W%b[1t.cOG#L^tM`G8b'm4DvFT%b'1t.`8qG*[^4M`,TbLm4Dvqy bLm4D`8Fyb[1t.`8!0bLmtMc,O#[14.`8FZ#'m4.vGf#L^tM`qqF#[^4M`0,*'1t.v*Z#[1tMcFy!b[1t.c8!%*'m4D`R1b[1tM`0%b'1t.`Ff#Lm4.vFFqbLm4Dv{l#'1tM`%W#L^tM`qFy#'^4D`8+F*[m4.c,Z#Lm4Dc0R#'m4.`F%b'1tDcq8,b[14M`1R#LmtM`lT#Lm4Dv*fbLmtMcFy #L^4Dv,Z#'m4.v%f#L^tM`Xf*[m4.vF+F*'1t.v,Z#[1tMc%F#'m4Dc0y#[14DvFFyb'm4Dv,1#'^4DcFZ1#Lm4.v%vb'1t.`8T+#'1tM`FZ!*'m4DcvF#'^4D`8Tc*[m4.ccO#Lm4Dc1O#'m4.`8!1bLmt.c8F1#L^4Dc8Fy#[1tMcGO#'m4DcqZ,#L^tM`%+b'm4DvFqGb'1t.`OT#Lm4.vvGb'1t.`+*[^4DvF!O#L^tM`q!Z#'^4D`R{#LmtMcX&*[1t.`qT+#'m4.`8!TbLmt.cFFb[14M`qZ%*[m4DvqFR#'m4Dc1R#[14DvF!+b'm4DvFqFb'1t.`+q#*#ISkBAA==^#~@%>
<%:class OW_Pager_Class:public currentPage,count,fields,page,pageSize,pageUrl,sql,loopExecute,loopHtml,loopHtmls,pageHtmls,isRsEscape,pageTpl:private sub class_initialize():currentPage = -1:count = 0:fields= "":pageSize    = 20:pageUrl     = "":sql   = "":loopExecute = "":loopHtml    = "":loopHtmls   = "":pageHtmls   = "":isRsEscape  = false:pageTpl     = "":end sub:private sub class_terminate():end sub:public function demo():OW.Pager.isRsEscape = true:OW.Pager.sql  = "select title,rootpath,urlpath,url,post_time,update_time from "& OW.DB.Table.content &" where status=0 AND cate_id IN(2,16)":OW.Pager.pageSize   = 20:OW.Pager.pageUrl    = OW.urlRewrite("c4"):OW.Pager.pageUrl    = "javascript:OW.shop.getConsultation({$page});":OW.Pager.pageTpl    = "{prev}{current}{next}":OW.Pager.loopHtml   = "<li><span class=""datetime"">{$post_time}</span><a href=""{$url}"" target=""_blank"">{$title}</a></li>":OW.Pager.loopExecute= "if fieldName=""buyer"" then fieldValue = OW.anonymousName(fieldValue) else if fieldName=""goods_price"" then fieldValue = OW.parsePrice(fieldValue) end if":OW.Pager.run():echo "OW.Page.count: "& OW.Pager.count &"<br><br>":echo "OW.Page.loopHtmls: "& OW.Pager.loopHtmls &"<br><br>":echo "OW.Page.pageHtmls: "& OW.Pager.pageHtmls &"<br>":echo "OW.runTime: "& OW.runTime &"<br>":end function:public function run():dim a,i,j,k,fieldsCount,url,p,pages,rs,loopStr,s:dim fieldName,fieldValue,match,matches:dim prevStr,firstStr,prevpagesStr,currentStr,nextpagesStr,nextStr,lastStr,allpagesStr,recordsStr,perpageStr:dim curPage,rsCount,pCount,pSize:pageHtmls = "":if currentPage = -1 then:currentPage = OW.int(OW.getForm("get","page")):end if:if currentPage=0 then currentPage = 1 : end if:loopHtmls   = "":set rs= OW.DB.getRecordBySQL(sql):fieldsCount = rs.fields.count-1:if not rs.eof then:if rs.recordCount>=1 then rsCount = rs.recordCount else rsCount = 0 : end if:rs.pageSize = pageSize : curPage = currentPage:if curPage>0 then:if curPage > rs.pageCount then rs.absolutePage = rs.pageCount else rs.absolutePage = curPage : end if:end if:curPage = rs.absolutePage:pCount  = rs.pageCount:pSize   = pageSize:for i=1 to pageSize:if rs.eof then exit for : end if:loopStr = loopHtml:for k=0 to fieldsCount:fieldName = rs.fields(k).name:fieldValue= OW.rs(rs(fieldName)):if isRsEscape then fieldValue = OW.escape(fieldValue) : end if:if loopExecute<>"" then execute(loopExecute) : end if:loopStr   = OW.rep(loopStr,"{\$"& fieldName &"}",fieldValue):next:loopHtmls = loopHtmls & loopStr:rs.movenext:next:count = rsCount:end if:OW.DB.closeRs rs:pageHtmls = createPages(pageUrl,curPage,rsCount,pCount,pSize,pageTpl):end function:public function createPages(byval url,byval curPage,byval rsCount,byval pCount,byval pSize,byval pageTpls):dim a,p,s:dim prevStr,firstStr,prevpagesStr,currentStr,nextpagesStr,nextStr,lastStr,allpagesStr,recordsStr,perpageStr:curPage = OW.int(curPage):rsCount = OW.int(rsCount):pCount  = OW.int(pCount):pSize   = OW.int(pSize):pageTpls= replace(pageTpls,"[","{"):pageTpls= replace(pageTpls,"]","}"):if curPage>4 then firstStr = "<a class=""first"" href="""& replace(url,"{$page}",1) &""">"& lang_page(5) &"</a>" : end if:if curPage>1 then prevStr = "<a class=""prev"" href="""& replace(url,"{$page}",curPage-1) &""">"& lang_page(1) &"</a>" : end if:if curPage>1 then a=1 : end if:if curPage>2 then a=2 : end if:for p=curPage-a to curPage-1:prevpagesStr = prevpagesStr &"<a class=""prev-pages"" href="""& replace(url,"{$page}",p) &""">"& p &"</a>":next:if curPage>0 then:currentStr = "<span class=""current"">"& curPage &"</span>":end if:for p=curPage+1 to curPage+3:if p>pCount then exit for : end if:nextpagesStr = nextpagesStr &"<a class=""next-pages"" href="""& replace(url,"{$page}",p) &""">"&p&"</a>":next:if not(curPage=pCount or curPage>pCount) then nextStr = "<a class=""next"" href="""& replace(url,"{$page}",curPage+1) &""">"& lang_page(2) &"</a>" : end if:if (pCount - curPage) > 3 then lastStr = "<a class=""last"" href="""& replace(url,"{$page}",pCount) &""">"& lang_page(6) &"</a>" : end if:allpagesStr = "<span class=""unlink allpages"">"& replace(lang_page(3),"{$n}",pCount) &"</span>":recordsStr  = "<span class=""unlink records"">"& replace(lang_page(0),"{$n}",rsCount) &"</span>":perpageStr  = "<span class=""unlink perpage"">"& replace(lang_page(4),"{$n}",pSize) &"</span>":if OW.isNul(pageTpls) then:s = prevStr & firstStr & prevpagesStr & currentStr & nextpagesStr & nextStr & lastStr & allpagesStr & recordsStr & perpageStr:else:s = pageTpls:s = replace(s,"{first}",firstStr):s = replace(s,"{prev}",prevStr):s = replace(s,"{prevpages}",prevpagesStr):s = replace(s,"{current}",currentStr):s = replace(s,"{nextpages}",nextpagesStr):s = replace(s,"{next}",nextStr):s = replace(s,"{last}",lastStr):s = replace(s,"{allpages}",allpagesStr):s = replace(s,"{records}",recordsStr):s = replace(s,"{perpage}",perpageStr):end if:createPages = s:end function:end class:%>
<script language="javascript" type="text/javascript" runat="server">function jsEncodeURIComponent(uriComponent){return encodeURIComponent(uriComponent)};function jsDecodeURIComponent(encodedURI){try{return decodeURIComponent(encodedURI)}catch(err){return ""}};</script>