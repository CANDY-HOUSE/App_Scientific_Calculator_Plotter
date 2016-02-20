/*
 對物件偵錯時,請愛用alert(OBJECT.toSource());
 
 */
//--------------多國語系-----------------------------------------
var stralert1,stralert2,stralert9s1,stralert9s2,stralert9s3,stralert9s4,stralert10s1,stralert10s2,stralert11,stralert12,stralert13,stralert14;
function internatioanlVersion(caseN){switch(caseN){
    case 1:
        stralert1s1='Do NOT write like  ';
        stralert1s2='\nWrite like  ';
        stralert1s3='  or  ';
        stralert2=' can only be applied to a Real Number.';
        stralert9s1='")" is ';
        stralert9s2=' less than "("\nPlease check again!';
        stralert9s3='")" is ';
        stralert9s4=' more than "("\nPlease check again!';
        stralert10s1=' right "|" missing!\nPlease check again!';
        stralert10s2=' left "|" missing!\nPlease check again!';
        stralert11=' cannot be put here';
        stralert12=' is undefined';
        stralert13='When defining a function, do NOT include operators or numbers into the function name.';
        stralert14=' cannot be re-defined';
        break;
    case 2:
        stralert1s1='不要寫成  ';
        stralert1s2='\n請改寫成  ';
        stralert1s3='  或  ';
        stralert2=' 只能用在 實數';
        stralert9s1='")" 比 "(" 少';
        stralert9s2=' 個\n請再檢查一次!';
        stralert9s3='")" 比 "(" 多';
        stralert9s4=' 個\n請再檢查一次!';
        stralert10s1=' 個 右絕對值 不足\n請再檢查一次!';
        stralert10s2=' 個 左絕對值 不足\n請再檢查一次!';
        stralert11=' 不能放在這裡';
        stralert12=' 沒有被定義';
        stralert13='定義函數時,函數名字內不要含有數字或運算符號';
        stralert14=' 不能被重新定義';
        break;
    case 3:
        stralert1s1='';
        stralert1s2='  の形を右の形のように書いてください：  ';
        stralert1s3='  または  ';
        stralert2=' は実数にしか適用できない';
        stralert9s1='")" は "(" より';
        stralert9s2=' 個少ないです\nもう一度チェックしてください!';
        stralert9s3='")" は "(" より';
        stralert9s4=' 個多いです\nもう一度チェックしてください!';
        stralert10s1=' 個 右絶対値 が足りません\nもう一度チェックしてください!';
        stralert10s2=' 個 左絶対値 が足りません\nもう一度チェックしてください!';
        stralert11=' はここに置けません';
        stralert12=' はまだ定義されていない';
        stralert13='関数を定義する時、関数の名前には演算子と数字を使わないでください';
        stralert14=' は再定義できない';
        break;
    
}}
internatioanlVersion(1);



//---------------myEval=translate+lex+parse+evaluate------------
function myEval(input,workingMode){
	return evaluate(parse(lex(translate(input))),workingMode);
}

function MathMLthis(input,workingMode){/*因為myEval內部也使用restitute,所以在此mode判斷獨立寫出來,而且我還沒決定restitute到底要不要all模式*/
	var obj = parse(lex(translate(input)));

	if(workingMode=='all'){
		var output = "";
		for (var i = 0; i < obj.length; i++) {
			var value0= restitute(obj[i]);
			output +=value0;
		}
		return output;		
	}else{return restitute(obj[0])}
}

function makeComputerUnderstandThisMath(input,workingMode){/*給繪圖用的*/
    return restituteForComputer(parse(lex(translate(input))),workingMode);
}

//------------------------------------------translator Start--------------------------------------------------
function translate(str){
//-------------括號偵錯程式
	var nId = 0;
	for(var i= 0; i < str.length; i++){
		if(str.charAt(i) == '('){nId++;}
		else if(str.charAt(i) == ')'){nId--;}
	}
	if(nId > 0){alert(stralert9s1+nId+stralert9s2);str=打漢字讓function故障;}
	if(nId < 0){alert(stralert9s3+(-nId)+stralert9s4);str=打漢字讓function故障;}
    
//---------------斷行與空格處理程式
	for(var i= 0; i < str.length; i++){
		if(/\s/.test(str.charAt(i))&&!/[\r\n]/.test(str.charAt(i)) ){str=str.substring(0,i)+str.substring(i+1);}
	}//刪除所有空白字元,不然絕對值可能判斷錯誤,但保留換行字元增加擴充性
    
	var ms=0;
	for(var i= 0; i < str.length; i++){
		if(/[\r\n]/.test(str.charAt(i-1))){
			if(str.charAt(i) == '|'){ms++;str=str.substring(0,i)+'abs('+str.substring(i+1);}
			else if(str.charAt(i) == '-'){str=str.substring(0,i)+'(-1)·'+str.substring(i+1);}//請自行決定要不要這個功能
			else if(str.charAt(i) == '+'){str=str.substring(0,i)+str.substring(i+1);}//請自行決定要不要這個功能
		}
	}
//-------------	一般處理程式
    var isCharacterOrString=function(C){
        if( C!==""&&!/\s/.test(C))//前者是給i=-1;後者是給i=length
            return !/[CP\+\-\×\·\/\*\^\_\%\=\(\)\,\!\°\|0-9\.]/.test(C);
        else return false;
    }
	str = str.replace(/pi/gi,'π');
	str = str.replace(/\•/gi,'·');
	str = str.replace(/\÷/g,'/');
	str = str.replace(/sqrt/g,'√');
	str = str.replace(/cbrt/g,'∛');

    for(var i= 0; i < str.length; i++){
        if(str.charAt(i-1)==')'&&str.charAt(i) == '('){str=str.substring(0,i)+'·'+str.substring(i);}
        if(str.charAt(i)=='i'){
            if(/[0-9√∛]/.test(str.charAt(i+1))){alert(stralert1s1+"i"+str.charAt(i+1)+stralert1s2+"i×"+str.charAt(i+1)+stralert1s3+"i·"+str.charAt(i+1));str=打漢字讓function故障;}
            if(str.charAt(i-1)==')'){alert(stralert1s1+str.charAt(i-1)+"i"+stralert1s2+str.charAt(i-1)+"×i"+stralert1s3+str.charAt(i-1)+"·i");str=打漢字讓function故障;}
            if(!isCharacterOrString(str.charAt(i-1))&&!isCharacterOrString(str.charAt(i+1)))str=str.substring(0,i)+'¡'+str.substring(i+1);//倒“驚嘆號¡”偽裝虛數i
        }
    }
    for(var i= 0; i < str.length; i++){
        if(str.charAt(i) == '¡'){
            if(/[0-9]/.test(str.charAt(i-1))){str=str.substring(0,i)+'·'+str.substring(i);}
            if(str.charAt(i+1)=='('){alert(stralert1s1+"i"+str.charAt(i+1)+stralert1s2+"i×"+str.charAt(i+1)+stralert1s3+"i·"+str.charAt(i+1));str=打漢字讓function故障;}
        }
    }
    for(var i= 0; i < str.length; i++){
       if(/[0-9\)]/.test(str.charAt(i))){
            if(/[(]/.test(str.charAt(i+1))||isCharacterOrString(str.charAt(i+1))){alert(stralert1s1+str.charAt(i)+str.charAt(i+1)+stralert1s2+str.charAt(i)+"×"+str.charAt(i+1)+stralert1s3+str.charAt(i)+"·"+str.charAt(i+1));str=打漢字讓function故障;}
       }
    }

//------------絕對值處理程式
	var ml = ms;
	for(var i= 0; i < str.length; i++){
		if(str.charAt(i) == '|'){
			if(		i==0||
					/[Δ\+\-\×\·\/\^\(]/.test(str.charAt(i-1))||
                    /[0-9\(]/.test(str.charAt(i+1))||
                    isCharacterOrString(str.charAt(i+1))
			){ml++;str=str.substring(0,i)+'abs('+str.substring(i+1);/*alert(str+i+'上');*/}
			else if(i==str.length-1||
					/[\×\·\/\)\^\!\°\%]/.test(str.charAt(i+1))||
					/[0-9\)\!\°\%]/.test(str.charAt(i-1))||
                    isCharacterOrString(str.charAt(i-1))
			){ml--;str=str.substring(0,i)+')'+str.substring(i+1);/*alert(str+i+'下');*/}
		}
	}
	if(ml>0){alert(+ml+stralert10s1);str=打漢字讓function故障;}
	if(ml<0){alert(-ml+stralert10s2);str=打漢字讓function故障;}
//-------------括號升級處理程式,不這麼做計算完全沒有問題,但是還原後括號會被省略
	for(var i= 0; i < str.length; i++){
		if(!isCharacterOrString(str.charAt(i-1))&&str.charAt(i) == '('){
            str=str.substring(0,i)+'doFirst('+str.substring(i+1);
		}
	}
//--------------
	return str;
}
//-----------------------------translator End-----------------------------------------------------------------------------------------
//-----------------------------lexer Start--------------------------------------------------------------------------------------------

//註:字串[i],矩陣[i],物件[id]
var lex=function(input) {
	var isOperator = function (C) { return /[CP\+\-\×\·\/\*\^\_\%\=\(\)\,\!\°]/.test(C); },
		isDigit = function (C) { return /[0-9]/.test(C); },
        isComplexUnit = function (C){return /\¡/.test(C);},
		isWhiteSpace = function (C) { return /\s/.test(C); },//遇到空白字元,會忽略,因此也導致parser把斷行判斷成新的任務
		isIdentifier = function (C) { return typeof C === "string" && !isOperator(C) && !isDigit(C) && !isWhiteSpace(C) && !isComplexUnit(C); };

	var tokens = [], c, i = 0;
	var advance = function () { return c = input[++i]; };
	var addToken = function (type, value, iValue) {
		tokens.push({//push物件{}
			type: type,
			value: value,
            iValue: iValue
		});
	};
	while (i < input.length) {
		c = input[i];
		if (isWhiteSpace(c)){ advance();}
		else if (isOperator(c)) {
			addToken(c);
			advance();
		}
		else if (isDigit(c)) {
			var num = c;
			while (isDigit(advance())){ num += c;}
			if (c === ".") {
				do{ num += c; }while (isDigit(advance()));
			}
			num = parseFloat(num);
			if (!isFinite(num)){ alert(num +"is too large or too small for a 64-bit double.");}
			addToken("number", num, 0);
		}
        else if(isComplexUnit(c)){
            addToken("number", 0, 1);
            advance();
        }
		else if (isIdentifier(c)) {
			var idn = c;
			while (isIdentifier(advance())){ idn += c;}
			addToken("identifier", idn);
		}
		else{ alert("出現無法辨識的符號: "+c);}
	}
	addToken("(end)");
	return tokens;
};
//--------------------------------lexer End------------------------------------------------------------------------------------------
//--------------------------------parser Start---------------------------------------------------------------------------------------
var parse=function(tokens) {
	var i = 0;
	var symbols = {};
	var token = function () {
		var iTOKEN = Object.create(symbols[tokens[i].type]);
		iTOKEN.type = tokens[i].type;
		iTOKEN.value = tokens[i].value;
        iTOKEN.iValue = tokens[i].iValue;
        return iTOKEN;
	};

	var advance = function () { i++; return token(); };


	var symbol = function (id, nud, lbp, led) {//null denotation(nud); left binding power(lbp); left denotation(led)
		var sym = symbols[id] || {};
		//|| {}預防下面預處理的id在input裡沒有。可以把沒有也可馬上建立的東西assign給沒有也不能馬上建立的variable,但是不可以把沒有也不能馬上建立的東西assign給variable
		symbols[id] = {//把物件symbols[id]加入以下三個特徵
			nud: sym.nud || nud,
			lbp: sym.lbp || lbp,
			led: sym.lef || led
		};
	};
	//infix()跟prefix()跟suffix()都是在調用symbol()
	var infix = function (id, lbp, rbp, led) {//right binding power(rbp)
		rbp = rbp || lbp;
		symbol(id, null, lbp, led || function (left) {//||led是給infix"="用的
			return {//不是加入特徵,而是return一個新物件
					type: id,
					left: left,
					right: expression(rbp)
					}
			;}
		);
	};
	var prefix = function (id, rbp) {
		symbol(id, function () {
			return {
				type: id,
				right: expression(rbp)
			};}
		);
	};
	var suffix = function (id, lbp) {
		symbol(id, null, lbp, function (left) {
			return {
					type: id,
					left: left,
					}
			;}
		);
	};


	//expression是兩個很像的process組成的!
	//nud的process只給number,(,prefix,identifier運作
	//led循環process只給infix運作
	var expression = function (rbp) {
		var t = token();
        advance();
		if (!t.nud){ alert(t.type+stralert11);}//不存在,null,undefined都會叫
		var left = t.nud(t);
		while (rbp < token().lbp) {
			t = token();
            advance();
			if (!t.led) {alert(t.type+stralert11)};
			left = t.led(left);//括號裡left是用t.rbp運算,不是外部rbp。而且advance會影響括號裡的token。但外部rbp不受影響。
		}
		return left;
	};


	//symbol預處理,讓token().lbp從沒有變成undefined,否則expression的while (rbp < token().lbp)無法判斷這些符號
	symbol(",");
	symbol(")");
	symbol("(end)");

	symbol("number", function (number) {
		return number;
	});
	
	symbol("(", function () {
		value = expression(2);
		if (token().type !== ")"){ alert("少了')'");}
		advance();
		return value;
	});

    
    suffix("*", 8);
    suffix("!", 8);
	suffix("%", 8);
	suffix("°", 8);
	prefix("+", 3);//原版是7
	prefix("-", 3);//原版是7
	infix("P", 8);
	infix("C", 8);
	infix("^", 6, 5);
	infix("_", 6, 5);
	infix("×", 4);
    infix("·",4);
	infix("/", 4);
	infix("+", 3);
	infix("-", 3);


	symbol("identifier", function (name) {
		if (token().type === "(") {
			var args = [];
			if (tokens[i + 1].type === ")"){ advance();}//看似無用指令,保留執行無變數函數abc()的功能
			else{
				do {//do-while的語法無論是否符合條件都會先執行一次,這就是與while的差別
                    advance();
					args.push(expression(2));
				}while(token().type === ",");
			}
            advance();
			return {
				type: "call",
				args: args,
				name: name.value
			};
		}
		return name;
	});

	infix("=", 1, 2, function (left) {
		if (left.type === "call") {
			for (var i = 0; i < left.args.length; i++) {
				if (left.args[i].type !== "identifier") {alert(stralert13)};
			}
			return {
				type: "define_a_Function",
				name: left.name,
				args: left.args,
				value: expression(2)
			};
		} else if (left.type === "identifier") {
			return {
				type: "assign_a_value",
				name: left.value,
				value: expression(2)
			};
		}
		else {alert(left.value+stralert14)};
	});

	var parseTree = [];
	while (token().type !== "(end)") {
		parseTree.push(expression(0));
	}
	return parseTree;
};
//----------------------------------------parser End--------------------------------------------------------------------
//----------------------------------------evaluator Start---------------------------------------------------------------
var evaluate=function(parseTree,workingMode) {
                      
    var operators = {
		"+": function (a, b) {
            return(typeof b === "undefined")?a:{
                value:a.value+b.value,
                iValue:a.iValue+b.iValue
            }
		},
		"-": function (a, b) {
            return(typeof b === "undefined")?{
                value:-a.value,
                iValue:-a.iValue
            }:{
                value:a.value-b.value,
                iValue:a.iValue-b.iValue
            }
		},
        "×": function (a, b) {
            return(a.iValue===0&&b.iValue===0)?{
                value:a.value*b.value,
                iValue:0
            }:{
                value:a.value*b.value-a.iValue*b.iValue,
                iValue:a.value*b.iValue+a.iValue*b.value
            }
        },
        "·": function (a, b) {
            return operators["×"](a,b);
        },
		"/": function (a, b) {
            if(a.iValue===0&&b.iValue===0){
                return{
                      value:a.value/b.value,
                      iValue:0
                }
            }else{
                var mother=b.value*b.value+b.iValue*b.iValue;
                return{
                      value:(a.value*b.value+a.iValue*b.iValue)/mother,
                      iValue:(-a.value*b.iValue+a.iValue*b.value)/mother
                }
            }
        },
        "*": function (a) {
            return{
                value:a.value,
                iValue:-a.iValue
            }
        },
		"^": function (a, b) {
            if(a.iValue===0&&b.iValue===0&&a.value>=0)
                return{
                      value:Math.pow(a.value,b.value),
                      iValue:0
                }
            else{
                var A0=Math.sqrt(a.value*a.value+a.iValue*a.iValue);
                var theta=myMath.atanRevised(nround(a.value),nround(a.iValue));//不用nround,當值極小會造成角度誤判180°
                var A=Math.pow(A0,b.value)*Math.pow(Math.E,-b.iValue*theta);
                var theta2=b.value*theta+b.iValue*Math.log(A0);
                var R=Math.cos(theta2);
                var I=Math.sin(theta2);
                return{
                    value:A*R,
                    iValue:A*I
                }
            }
        },
		"P": function (a, b) {
                if(a.iValue===0&&b.iValue===0)return {value:myMath.permutation(a.value, b.value),iValue:0}
                else alert("nPx"+stralert2);
        },
		"C": function (a, b) {
                if(a.iValue===0&&b.iValue===0)return {value:myMath.combination(a.value, b.value),iValue:0}
                else alert("nCx"+stralert2);
        },
		"!": function (a) {
                if(a.iValue===0)return{value: myMath.factorial(a.value),iValue:0}
                else alert("x!"+stralert2);
        },
		"%": function (a) {
            return {
                value:a.value/100,
                iValue:(a.iValue===0)?0:a.iValue/100
            }
        },
		"°": function (a) {//matlab does this way
            return {
                value : a.value/180*Math.PI,
                iValue :(a.iValue===0)?0:a.iValue/180*Math.PI
            }
        },
	};

	var variables = {
        π: {
            value:Math.PI,
            iValue:0
        },
        e: {
            value:Math.E,
            iValue:0
        },
        Infinity:{
            value:Infinity,
            iValue:0
        },
        '∞':{
            value:Infinity,
            iValue:0
        },
	};

	var functions = {
		doFirst: function (a) { return a; },
        abs: function (a){
            return{
                value:Math.sqrt(a.value*a.value+a.iValue*a.iValue),
                iValue:0
            }
        },
        ln: function(a){//wiki
            return(a.iValue===0&&a.value>=0)?{
                value:Math.log(a.value),
                iValue:0
            }:{
                value:Math.log(Math.sqrt(a.value*a.value+a.iValue*a.iValue)),
                iValue:myMath.atanRevised(nround(a.value),nround(a.iValue))//不用nround,當值極小會造成角度誤判180°
            }
        },
        log: function(a){
            return(a.iValue===0&&a.value>=0)?{
                value:Math.log(a.value)/Math.log(10),
                iValue:0
            }:{
                value:Math.log(Math.sqrt(a.value*a.value+a.iValue*a.iValue))/Math.log(10),
                iValue:myMath.atanRevised(nround(a.value),nround(a.iValue))/Math.log(10)//不用nround,當值極小會造成角度誤判180°
            }
        },
        "√": function (a){
            if(a.value>=0&&a.iValue===0)return{
                value:Math.sqrt(a.value),
                iValue:0
            }
            else{
                var A=Math.sqrt(Math.sqrt(a.value*a.value+a.iValue*a.iValue));
                var theta=myMath.atanRevised(nround(a.value),nround(a.iValue))//不用nround,當值極小會造成角度誤判180°
                return{
                    value:A*Math.cos(theta/2),
                    iValue:A*Math.sin(theta/2)
                }
            }
        },
        "∛": function (a){
            if(a.iValue===0)return{/*MatlabR2013a的判斷式是a.value>=0&&a.iValue===0,這會造成∛(-1)變虛數,也是可以啦！因為這是另外一種數學定義:(-1)^(1/3)*/
                value:myMath.cbrt(a.value),
                iValue:0
            }
            else{
                var A=Math.pow(Math.sqrt(a.value*a.value+a.iValue*a.iValue),1/3);
                var theta=myMath.atanRevised(nround(a.value),nround(a.iValue))//不用nround,當值極小會造成角度誤判180°
                return{
                    value:A*Math.cos(theta/3),
                    iValue:A*Math.sin(theta/3)
                }
            }
        },
        sin: function(a){
            return(a.iValue===0)?{
                value:Math.sin(a.value),
                iValue:0
            }:{
                value:Math.sin(a.value)*myMath.cosh(a.iValue),
                iValue:Math.cos(a.value)*myMath.sinh(a.iValue)
            };
        },
        cos: function(a){
            return(a.iValue===0)?{
                value:Math.cos(a.value),
                iValue:0
            }:{
                value:Math.cos(a.value)*myMath.cosh(a.iValue),
                iValue:-Math.sin(a.value)*myMath.sinh(a.iValue)
            };
        },
        tan: function(a){
            if(a.iValue===0){
                return {
                    value:Math.tan(a.value),
                    iValue:0
                }
            }
            else{
                var I={
                      value:0,
                      iValue:1
                    };
                var II={
                      value:0,
                      iValue:2
                    };
                var realUnit={
                      value:1,
                      iValue:0
                    };
                return operators["/"](operators["-"]( operators["^"]( variables["e"],operators["×"](II,a) ),realUnit ),operators["×"](I,operators["+"]( operators["^"]( variables["e"],operators["×"](II,a) ),realUnit )));
            }
        },
        sinh: function(a){
            if(a.iValue===0){
                return{
                    value:myMath.sinh(a.value),
                    iValue:0
                }
            }
            else{
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return operators["/"](operators["-"](operators["^"]( variables["e"],a ), operators["^"]( variables["e"],operators["-"](a) )  ),real2Unit)
            }
        },
        cosh: function(a){
            if(a.iValue===0){
                return{
                    value:myMath.cosh(a.value),
                    iValue:0
                }
            }
            else{
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return operators["/"](operators["+"](operators["^"]( variables["e"],a ), operators["^"]( variables["e"],operators["-"](a) )  ),real2Unit)
            }
        },
        tanh: function(a){
            if(a.iValue===0){
                return{
                    value:myMath.tanh(a.value),
                    iValue:0
                }
            }
            else{
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return operators["/"](operators["-"](realUnit, operators["^"]( variables["e"],operators["×"](operators["-"](real2Unit),a) )  ),operators["+"](realUnit, operators["^"]( variables["e"],operators["×"](operators["-"](real2Unit),a) )  ))
      
            }
        },
        asin: function(a){
            if(a.iValue===0&& a.value>=-1 && a.value<=1){
                return{
                    value:Math.asin(a.value),
                    iValue:0
                }
            }else{
                var I={
                      value:0,
                      iValue:1
                    };
                var minusI={
                      value:0,
                      iValue:-1
                    };
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return operators["×"](minusI,functions["ln"](operators["+"](operators["×"](I,a),functions["√"](operators["-"](realUnit,operators["^"](a,real2Unit))))))
            }
        },
        acos: function(a){
            if(a.iValue===0&& a.value>=-1 && a.value<=1){
                return{
                    value:Math.acos(a.value),
                    iValue:0
                }
            }else{
                var halfPI={
                      value:Math.PI/2,
                      iValue:0
                    };
                var I={
                      value:0,
                      iValue:1
                    };
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return operators["+"](halfPI,operators["×"](I,functions["ln"](operators["+"](operators["×"](I,a),functions["√"](operators["-"](realUnit,operators["^"](a,real2Unit)))))))
            }
        },
        atan: function(a){
            if(a.iValue===0){
                return{
                    value:Math.atan(a.value),
                    iValue:0
                }
            }else{
                var I={
                      value:0,
                      iValue:1
                    };
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var HalfI={
                      value:0,
                      iValue:0.5
                };
                return operators["×"](HalfI,operators["-"](functions["ln"](operators["-"](realUnit,operators["×"](I,a))),functions["ln"](operators["+"](realUnit,operators["×"](I,a)))))
            }
        },
        asinh: function(a){
            if(a.iValue===0){
                return{
                    value:myMath.asinh(a.value),
                    iValue:0
                }
            }else{
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var real2Unit={
                      value:2,
                      iValue:0
                    };
                return functions["ln"](operators["+"](a,functions["√"](operators["+"](operators["^"](a,real2Unit),realUnit))))
            }
        },
        acosh: function(a){
            if(a.iValue===0 && a.value>=1){
                return{
                    value:myMath.acosh(a.value),
                    iValue:0
                }
            }else{
                var realUnit={
                      value:1,
                      iValue:0
                    };
                return functions["ln"](operators["+"](a,operators["×"](functions["√"](operators["+"](a,realUnit)), functions["√"](operators["-"](a,realUnit)))))
            }
        },
        atanh: function(a){
            if(a.iValue===0 && a.value>=-1 && a.value<=1){
                return{
                    value:myMath.atanh(a.value),
                    iValue:0
                }
            }else{
                var realUnit={
                      value:1,
                      iValue:0
                    };
                var realHalfUnit={
                      value:0.5,
                      iValue:0
                    };
                return operators["×"](realHalfUnit,operators["-"](functions["ln"](operators["+"](realUnit,a)),functions["ln"](operators["-"](realUnit,a))))
            }
        },

//		round: Math.round,
//		ceil: Math.ceil,
//		floor: Math.floor,
//		max: Math.max,
//		min: Math.min,
//		random: Math.random,
	};
	var args = {};
    function cloneObjectInJS(obj) {
        if (null == obj || "object" != typeof obj) return obj;
        if (obj instanceof Date) {
            var copy = new Date();
            copy.setTime(obj.getTime());
            return copy;
        }
        if (obj instanceof Array) {
            var copy = [];
            for (var i = 0, len = obj.length; i < len; ++i) {
                copy[i] = cloneObjectInJS(obj[i]);
            }
            return copy;
        }
        if (obj instanceof Object) {
            var copy = {};
            for (var attr in obj) {
                if (obj.hasOwnProperty(attr)) copy[attr] = cloneObjectInJS(obj[attr]);
            }
            return copy;
        }
        alert("Unable to copy obj! Its type isn't supported.");
    }

	var parseNode = function (node) {
		if (node.type === "number"){return node;}
		else if (operators[node.type]) {
            if ( node.left && node.right){ return operators[node.type](parseNode(node.left), parseNode(node.right));}
			else if (!node.left && node.right){ return operators[node.type](parseNode(node.right));}//for+-
			else if ( node.left &&!node.right){ return operators[node.type](parseNode(node.left));};//for!%°
		}
		else if (node.type === "identifier") {
            var value = args.hasOwnProperty(node.value) ? args[node.value] : variables[node.value];//(id)[id][id]
			if (typeof value === "undefined"){ alert(node.value + stralert12);};
            return value;
		}
		else if (node.type === "call") {
            var tempArgs=[];
			for (var i = 0; i < node.args.length; i++) {tempArgs[i] = parseNode(node.args[i]);};
            return functions[node.name].apply(null, tempArgs);
		}
		else if (node.type === "assign_a_value") {                      
			variables[node.name] = parseNode(node.value);
		}
		else if (node.type === "define_a_Function") {
			functions[node.name] = function () {/*"define_a_Function"時只會把這個function寫入資料庫,但要等到"call"才會compile*/
                var argsRecovery=cloneObjectInJS(args);//Javascript物件複製不能直接用等號,等號只是傳址
				for (var i = 0; i < node.args.length; i++) {
					args[node.args[i].value] = arguments[i];/*arguments物件對應apply函數*/
				}
				var ret = parseNode(node.value);
                args=cloneObjectInJS(argsRecovery);
				return ret;
			};
		}
	};
    
                      
    function nround(v){//数値vを指定の小数点以下桁数n(n>=1)で四捨五入する関数nround;javascript會有算不準的問題
        var n=9;
        var tmp = 1;
        for(var i= 0; i < n; i++)tmp = tmp * 10;
        var v = Math.round(v * tmp);
        v = v / tmp;
        return v;
    }
    function showButHideNone(A,B){
        var a=nround(A);
        var b=nround(B);
        var ansTemp="???";//=a +" + ("+b+")·i";
        if(a===0&&b===0)ansTemp = 0;
        else if(a!==0&&b===0)ansTemp = myScientificNotation(a);
        else if(a===0&&b===1)ansTemp = "i";
        else if(a===0&&b===-1)ansTemp = " -i";
        else if(a===0&&b!==0&&b!==1&&b!==-1)ansTemp = myScientificNotation(b)+"·i";
        else if(a!==0&&b===1)ansTemp = myScientificNotation(a) +" + "+"i";
        else if(a!==0&&b!==1&&b>0)ansTemp = myScientificNotation(a) +" + "+ myScientificNotation(b)+"·i";
        else if(a!==0&&b===-1)ansTemp = myScientificNotation(a) +" - "+"i";
        else if(a!==0&&b!==-1&&b<0)ansTemp = myScientificNotation(a) +" - "+ myScientificNotation(-b)+"·i";
        return ansTemp;
    }
    
    if(workingMode=='all'){
		var output = "";
		for (var i = 0; i < parseTree.length; i++) {
			var value0= restitute(parseTree[i]);//舊版會互相干擾
            var ansObject=parseNode(parseTree[i]);
            if (parseTree[i].type==="assign_a_value"||parseTree[i].type === "define_a_Function") {output +=value0+'<br>';}
            else{
                var value=showButHideNone(ansObject.value,ansObject.iValue);
                output +=value0+' = '+value+'<br>';
            }
		}
		return output;		
    }else if(!workingMode){
        var ansObject=parseNode(parseTree[0]);
        return showButHideNone(ansObject.value,ansObject.iValue);
    }else if(workingMode=='ReturnFinalReal'){
        var ansObject;
        for(var i = 0; i < parseTree.length; i++){
            ansObject=parseNode(parseTree[i]);
        }
        if(nround(ansObject.iValue)===0)return nround(ansObject.value);
    }

};
//----------------------------------------evaluator End------------------------------------------------------------------
//----------------------------------------restituter(plugIn of evaluator) Start----------------
var restitute=function(parseTree) {//plugIn of evaluator

	var operators = {
        "+": function (a, b) {
            if (typeof b === "undefined") {return ' + '+a;}
            return a+' + '+ b;
        },
        "-": function (a, b) {
            if (typeof b === "undefined") {return ' - '+a;}
            return a +' - '+ b;
        },
        "·": function (a, b) { return a +' · '+ b; },
        "×": function (a, b) { return a +'×'+ b; },
		"/": function (a, b) { return '<math><mfrac><mn>'+a +'</mn><mn>'+ b+'</mn></mfrac></math>'; },
        "*": function (a) { return a+'*'; },
        "^": function (a, b) { return a+'<sup>'+b+'</sup>'; },
		"_": function (a, b) { return a+'<sub>'+b+'</sub>'; },
		"P": function (a, b) { return '<math><msubsup><mo>P</mo><mn>'+ b +'</mn><mn>'+ a +'</mn></msubsup></math>'; },
		"C": function (a, b) { return '<math><msubsup><mo>C</mo><mn>'+ b +'</mn><mn>'+ a +'</mn></msubsup></math>'; },
		"!": function (a) { return a+'!'; },
        "%": function (a) { return a+'%'; },
		"°": function (a) { return a+'°'; },
	};
/*
	var variables = {
		π: 'π',
		e: 'e',
	};
*/
	var parseNode = function (node) {
		if (node.type === "number"){return showButHideNone(node.value,node.iValue);}
		else if (operators[node.type]) {
			if ( node.left && node.right){ return operators[node.type](parseNode(node.left), parseNode(node.right));}
			else if (!node.left && node.right){ return operators[node.type](parseNode(node.right));}//for+-
			else if ( node.left &&!node.right){ return operators[node.type](parseNode(node.left));};//for!%°
		}
		else if (node.type === "identifier") {
/*			if(variables[node.value]){return variables[node.value];}
			else { return node.value;}
*/          return node.value;
		}
		else if (node.type === "call") {
            var tempArray2=[];
			for (var i = 0; i < node.args.length; i++) { tempArray2[i]= parseNode(node.args[i]);};
			if(node.name=='√'){
				return '<math><msqrt><mn>'+ tempArray2.toString()+'</mn></msqrt></math>';
			}else if(node.name=='∛'){
				return '<math><mroot><mn>'+ tempArray2.toString()+'</mn><mn>3</mn></mroot></math>';
			}else if(node.name=='abs'){
				return '|'+ tempArray2.toString()+'|';
			}else if(node.name=='doFirst'){
				return '('+ tempArray2.toString()+')';
			}else{return node.name+'('+ tempArray2.toString()+')';}
		}
        else if (node.type === "assign_a_value") {
            return node.name+' ≡ '+parseNode(node.value);
        }
        else if (node.type === "define_a_Function") {
            var tempArray=[];
            for(var i=0;i<node.args.length;i++){tempArray[i]=parseNode(node.args[i]);};
            return node.name+'('+tempArray.toString()+')'+' ≡ '+parseNode(node.value);
        }

	};
                      
    function showButHideNone(a,b){
        var ansTemp=0;
        if(a!==0&&b===0)ansTemp = myScientificNotation(a);
        else if(a===0&&b===1)ansTemp = "i";
/*      else if(a===0&&b!==0&&b!==1)ansTemp = b+"·i";
        else if(a!==0&&b===1)ansTemp = a +" + "+"i";
        else if(a!==0&&b!==0&&b!==1)ansTemp = a +" + "+ b+"·i";
*/
        return ansTemp;
    }

	return parseNode(parseTree);
};
//---------------------------------------restituter(plugIn of evaluator) End------------------
                      
var restituteForComputer=function(parseTree,workingMode){/*給繪圖用的*/
    var operators = {
        "+": function (a, b) {
            if (typeof b === "undefined") {return a;}/*eval竟然不吃++*/
            return a+'+'+ b;
        },
        "-": function (a, b) {
            if (typeof b === "undefined") {return '(-1)*'+a;}/*eval竟然不吃--*/
            return a +'-'+ b;
        },
        "·": function (a, b) { return a +'*'+ b; },
        "×": function (a, b) { return a +'*'+ b; },
        "/": function (a, b) { return a +'/'+ b; },
        "^": function (a, b) { return 'Math.pow('+a+','+b+')'; },
        "P": function (a, b) { return 'myMath.permutation('+ a +','+ b +')'; },
        "C": function (a, b) { return 'myMath.combination('+ a +','+ b +')'; },
        "!": function (a) { return 'myMath.factorial('+a+')'; },
        "%": function (a) { return a+'/100'; },
        "°": function (a) { return a+'/180*Math.PI'; },
    };
    var variables = {
        π:'Math.PI',
        e:'Math.E',
        x:'(x)',/*不然log(x)-x在x<0竟然畫不出來*/
        y:'(y)',
        θ:'(θ)'
    };
    var args = {};
    var parseNode = function (node) {
        if (node.type === "number"){return showButHideNone(node.value,node.iValue);}
        else if (operators[node.type]) {
            if ( node.left && node.right){ return operators[node.type](parseNode(node.left), parseNode(node.right));}
            else if (!node.left && node.right){ return operators[node.type](parseNode(node.right));}//for+-
            else if ( node.left &&!node.right){ return operators[node.type](parseNode(node.left));};//for!%°
        }
        else if (node.type === "identifier") {
            var value = args.hasOwnProperty(node.value) ? args[node.value] : variables[node.value];//(id)[id][id]
            if (typeof value === "undefined"){ alert(node.value + stralert12);};
            return value;
        }
        else if (node.type === "call") {
            var tempArray2=[];
            for (var i = 0; i < node.args.length; i++) { tempArray2[i]= parseNode(node.args[i]);};
            if(node.name=='√'){
                return 'Math.sqrt('+ tempArray2.toString()+')';
            }else if(node.name=='∛'){
                return 'myMath.cbrt('+ tempArray2.toString()+')';
            }else if(node.name=='doFirst'){
                return '('+ tempArray2.toString()+')';
            }else if(node.name=='ln'){
                return 'Math.log('+ tempArray2.toString()+')';
            }else if(node.name=='log'){
                return 'Math.log('+ tempArray2.toString()+')/Math.log(10)';
            }else if(node.name=='sin' || node.name=='cos' || node.name=='tan' || node.name=='asin' || node.name=='acos' || node.name=='atan' || node.name=='abs'){
                return 'Math.'+node.name+'('+ tempArray2.toString()+')';
            }else{return 'myMath.'+node.name+'('+ tempArray2.toString()+')';}
        }
        else if (node.type === "assign_a_value") {
            variables[node.name] = parseNode(node.value);
        }
    };
    function showButHideNone(a,b){
        var ansTemp=0;
        if(a!==0&&b===0)ansTemp = a;
        else if(a===0&&b===1)ansTemp = "i";
        return ansTemp;
    }
                      
                      
    if(workingMode="ReturnFinalFormula"){
        var ansObject;
        for(var i = 0; i < parseTree.length; i++){
            ansObject=parseNode(parseTree[i]);
        }
        return ansObject;
    }
    else {return parseNode(parseTree[0]);}

}
                      
///////////////////////////////////////科學記號處理功能Start///////////////////////////////

function myScientificNotation(x){
    if(typeof x==="string"){x=Number(x);}
                      
    var data= String(x).split(/[eE]/);
    if(data.length== 1) return data[0];
                      
    return data[0]+"×10<sup>"+data[1].replace(/^\+/,'')+"</sup>";
}
///////////////////////////////////////科學記號處理功能End///////////////////////////////



var myMath={
                     
        atanRevised:function (x,y){
            if(x<0&&y===0)return Math.PI;//atan2(,) bug make it -pi
            else return Math.atan2(y,x);//DONOT USE atan()
        },
        sinh :function(x){return (Math.exp(x) - Math.exp(-x)) / 2;},
        cosh :function(x){return (Math.exp(x) + Math.exp(-x)) / 2;},
        tanh :function(x){return (Math.exp(x) - Math.exp(-x)) / (Math.exp(x) + Math.exp(-x));},
        asinh :function(x){return Math.log(x + Math.sqrt(x * x + 1));},
        acosh :function(x){return Math.log(x + Math.sqrt(x * x - 1));},
        atanh :function(x){return Math.log((1 + x) / (1 - x)) / 2;},
                      
        sec: function(x){return 1 / Math.cos(x);},
        csc :function(x){return 1 / Math.sin(x);},
        cot :function(x){return 1 / Math.tan(x);},
        asec :function(x){return Math.atan(x / Math.sqrt(x * x - 1)) + myMath.sgn(x - 1) * (2 * Math.atan(1));},
        acsc :function(x){return Math.atan(x / Math.sqrt(x * x - 1)) + (myMath.sgn(x) - 1) * (2 * Math.atan(1));},
        acot :function(x){return Math.atan(x) + (2 * Math.atan(1));},

        cbrt: function(x){
            if(x>=0){return Math.pow(x, 1/3);}
            else{return -Math.pow(-x, 1/3);}
        },
        factorial: function(x){
            if(x == Math.floor(x) && x >= 0){
                if(x == 0){return 1;}
                else{return x * myMath.factorial(x - 1);}
            }
            else{return myMath.gamma(x+1);}
        },
                      //function permutation(x, y){   return factorial(x) / factorial(x - y);}//這是超笨方法,因為800P3=800*799*798竟然算不出來
        permutation: function(x, y){
            if(x == Math.floor(x) && x > 0 && y == Math.floor(y) && y > 0 && x >= y){
                for(var a=i=x, b=x-y; i>b+1; a*=--i);
                return a;
            }
            else if(x>=0&&y==0){return 1;}
            else{return 0;}
        },
        combination: function(x, y){
            return myMath.permutation(x, y) / myMath.factorial(y);
        },
        sgn: function(x){
            var s;
            if(x == 0){s = 0;}
            else if(x > 0){s = 1;}
            else if(x < 0){s = -1;}
            return s;
        },
                      
                      
        loggamma: function(x){
            var log2pi = Math.log(2 * Math.PI);
            var N = 8;
            var B0 = 1.0;
            var B1 = (-1.0 / 2.0);
            var B2 = ( 1.0 / 6.0);
            var B4 = (-1.0 / 30.0);
            var B6 = ( 1.0 / 42.0);
            var B8 = (-1.0 / 30.0);
            var B10 = ( 5.0 / 66.0);
            var B12 = (-691.0 / 2730.0);
            var B14 = ( 7.0 / 6.0);
            var B16 = (-3617.0 / 510.0);
            var v = 1.0;
            while(x < N){
                v *= x;
                x++;
            }
            var w = 1 / (x * x);
            var tmp = B16 / (16 * 15);
            tmp = tmp * w + B14 / (14 * 13);
            tmp = tmp * w + B12 / (12 * 11);
            tmp = tmp * w + B10 / (10 * 9);
            tmp = tmp * w + B8 / (8 * 7);
            tmp = tmp * w + B6 / (6 * 5);
            tmp = tmp * w + B4 / (4 * 3);
            tmp = tmp * w + B2 / (2 * 1);
            tmp = tmp / x + 0.5 * log2pi - Math.log(v) - x + (x - 0.5) * Math.log(x);
            return tmp;
        },
                      
        gamma: function(x){
            if(x < 0.0){
                return Math.PI / (Math.sin(Math.PI * x) * Math.exp(myMath.loggamma(1 - x)));
            }
            return Math.exp(myMath.loggamma(x));
        },
                      
    /*
     function euler(){
     return 0.57721566490153286060651209;
     }
     function goldenratio(){
     return 1.61803398874989484820;
     }
     function maximum() {
     var res, arg, elements, i, j;
     res = null;
     arg = maximum.arguments;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(res == null){
     res = elements[j];
     }else{
     res = Math.max(res, elements[j]);
     }
     }
     }else{
     if(res == null){
     res = arg[i];
     }else{
     res = Math.max(res, arg[i]);
     }
     }
     }
     return res;
     }
     function minimum() {
     var res, arg, elements, i, j;
     res = null;
     arg = minimum.arguments;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(res == null){
     res = elements[j];
     }else{
     res = Math.min(res, elements[j]);
     }
     }
     }else{
     if(res == null){
     res = arg[i];
     }else{
     res = Math.min(res, arg[i]);
     }
     }
     }
     return res;
     }
     function sum(){
     var arg = sum.arguments;
     var res = 0;
     var elements, i, j;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     res += elements[j];
     }
     }else{
     res += arg[i];
     }
     }
     return res;
     }
     function mean(){
     var arg = mean.arguments;
     var res = 0;
     var n = 0;
     var elements, i, j;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     res += elements[j];
     n++;
     }
     }else{
     res += arg[i];
     n++;
     }
     }
     return res / n;
     }
     function gmean(){
     var arg = gmean.arguments;
     var res = 0;
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(elements[j] <= 0){
     return null;
     }else{
     res += Math.log(elements[j]);
     n++;
     }
     }
     }else{
     if(arg[i] <= 0){
     return null;
     }else{
     res += Math.log(arg[i]);
     n++;
     }
     }
     }
     return Math.exp(res / n);
     }
     function hmean(){
     var arg = hmean.arguments;
     var res = 0;
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(elements[j] <= 0){
     return null;
     }else{
     res += (1 / elements[j]);
     n++;
     }
     }
     }else{
     if(arg[i] <= 0){
     return null;
     }else{
     res += (1 / arg[i]);
     n++;
     }
     }
     }
     return (n / res);
     }
     function mode(){
     var arg = mode.arguments;
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     n++;
     }
     }else{
     n++;
     }
     }
     var ary = new Array(n);
     n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = eval(elements[j]);
     n++;
     }
     }else{
     ary[n] = eval(arg[i]);
     n++;
     }
     }
     
     ary.sort(sorting);
     var tmp = 1;
     var mode_n = 0;
     var mode_v = null;
     for(var i= 0; i < ary.length - 1; i++){
     if(ary[i] == ary[i + 1]){
     tmp++;
     }else{
     tmp = 1;
     }
     if(mode_n < tmp){
     mode_n = tmp;
     mode_v = ary[i];
     }
     }
     tmp = 1;
     var mode_len = 0;
     for(var i= 0; i < ary.length - 1; i++){
     if(ary[i] == ary[i + 1]){
     tmp++;
     }else{
     tmp = 1;
     }
     if(mode_n == tmp){
     mode_len++;
     }
     }
     if(mode_len == 1){
     return mode_v;
     }else{
     mode_ary = new Array(mode_len);
     tmp = 1;
     j = 0;
     for(var i= 0; i < ary.length - 1; i++){
     if(ary[i] == ary[i + 1]){
     tmp++;
     }else{
     tmp = 1;
     }
     if(mode_n == tmp){
     mode_ary[j] = ary[i];
     j++;
     }
     }
     var str = "";
     for(var i= 0; i < mode_ary.length; i++){
     if(i > 0) str += ", ";
     str += mode_ary[i];
     }
     return str;
     //return str.split(/[ ,]/);
     }
     }
     function median(){
     var arg = median.arguments;
     var ary = new Array(256);
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = eval(elements[j]);
     n++;
     }
     }else{
     ary[n] = eval(arg[i]);
     n++;
     }
     }
     ary.sort(sorting);
     if(n % 2 == 0){
     return (ary[Math.floor(n / 2) - 1] + ary[Math.floor(n / 2)]) / 2;
     }else{
     return ary[Math.floor(n / 2)];
     }
     }
     function quart1(){
     var arg = quart1.arguments;
     var ary = new Array(256);
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = elements[j];
     n++;
     }
     }else{
     ary[n] = arg[i];
     n++;
     }
     }
     ary.sort(sorting);
     return ary[Math.floor(n / 4)];
     }
     function quart3(){
     var arg = quart3.arguments;
     var ary = new Array(256);
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = elements[j];
     n++;
     }
     }else{
     ary[n] = arg[i];
     n++;
     }
     }
     ary.sort(reverse);
     return ary[Math.floor(n / 4)];
     }
     function rss(){
     var arg = rss.arguments;
     var ave = 0, sum = 0, elements, i, j, n = 0;
     if(arg.length > 0){
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sum += eval(elements[j]);
     n++;
     }
     }else{
     sum += eval(arg[i]);
     n++;
     }
     }
     ave = sum / n;
     sum = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sum += (elements[j] - ave) * (elements[j] - ave);
     }
     }else{
     sum += (arg[i] - ave) * (arg[i] - ave);
     }
     }
     return sum;
     }else{
     return null;
     }
     }
     function uvar(){
     var arg = uvar.arguments;
     var ave = 0, sum = 0, elements, i, j, n = 0;
     if(arg.length > 0){
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sum += elements[j];
     n++;
     }
     }else{
     sum += arg[i];
     n++;
     }
     }
     ave = sum / n;
     sum = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sum += (elements[j] - ave) * (elements[j] - ave);
     }
     }else{
     sum += (arg[i] - ave) * (arg[i] - ave);
     }
     }
     return (sum / (n - 1));
     }else{
     return null;
     }
     }
     function variance(){
     var arg = variance.arguments;
     var sqsum, sum, elements, i, j;
     sqsum = 0;
     sum = 0;
     if(arg.length > 0){
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sqsum += (elements[j] * elements[j]);
     sum += elements[j];
     }
     }else{
     sqsum += (arg[i] * arg[i]);
     sum += arg[i];
     }
     }
     return ((sqsum / arg.length) - ((sum / arg.length) * (sum / arg.length)));
     }else{
     return null;
     }
     }
     function skew(){
     //skewness 歪度
     var arg = skew.arguments;
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     n++;
     }
     }else{
     n++;
     }
     }
     var ary = new Array(n);
     n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = eval(elements[j]);
     n++;
     }
     }else{
     ary[n] = eval(arg[i]);
     n++;
     }
     }
     var m1 = mean(ary);
     var m2 = 0;
     var m3 = 0;
     var m4 = 0;
     var x;
     for(var i= 0; i < ary.length; i++){
     x = ary[i];
     m2 += (x - m1) * (x - m1);
     m3 += (x - m1) * (x - m1) * (x - m1);
     m4 += (x - m1) * (x - m1) * (x - m1) * (x - m1);
     }
     m2 = m2 / n;
     m3 = m3 / n;
     m4 = m4 / n;
     return m3 / (m2 * Math.sqrt(m2));
     }
     function kurt(){
     //kurtosis 尖度
     var arg = kurt.arguments;
     var elements, i, j, n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     n++;
     }
     }else{
     n++;
     }
     }
     var ary = new Array(n);
     n = 0;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     ary[n] = eval(elements[j]);
     n++;
     }
     }else{
     ary[n] = eval(arg[i]);
     n++;
     }
     }
     var m1 = mean(ary);
     var m2 = 0;
     var m3 = 0;
     var m4 = 0;
     var x;
     for(var i= 0; i < ary.length; i++){
     x = ary[i];
     m2 += (x - m1) * (x - m1);
     m3 += (x - m1) * (x - m1) * (x - m1);
     m4 += (x - m1) * (x - m1) * (x - m1) * (x - m1);
     }
     m2 = m2 / n;
     m3 = m3 / n;
     m4 = m4 / n;
     return m4 / (m2 * m2);
     }
     function cv(){
     var arg = cv.arguments;
     return (variance(arg) / mean(arg));
     }
     function stdev(){
     var arg = stdev.arguments;
     var elements, i, j;
     var n = 0;
     var sqsum = 0;
     var sum = 0;
     if(arg.length > 0){
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length > 1){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     sqsum += (elements[j] * elements[j]);
     sum += elements[j];
     n++;
     }
     }else{
     sqsum += (arg[i] * arg[i]);
     sum += arg[i];
     n++;
     }
     }
     return Math.sqrt((sqsum / n) - ((sum / n) * (sum / n)));
     }else{
     return null;
     }
     }
     function stirling1(n, x){
     n = Math.abs(Math.floor(n));
     x = Math.abs(Math.floor(x));
     if(x < 1 || x > n){
     return 0;
     }
     if(x == n){
     return 1;
     }
     return (n - 1) * stirling1(n - 1, x) + stirling1(n - 1, x - 1);
     }
     function stirling2(n, x){
     n = Math.abs(Math.floor(n));
     x = Math.abs(Math.floor(x));
     if(x < 1 || x > n){
     return 0;
     }
     if(x == 1 || x == n){
     return 1;
     }
     return x * stirling2(n - 1, x) + stirling2(n - 1, x - 1);
     }
     function mod(x, y){
     return x % y;
     }
     function gcd() {
     var res, arg, elements, i, j;
     res = null;
     arg = gcd.arguments;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(res == null){
     res = elements[j];
     }else{
     res = gcd2(res, elements[j]);
     }
     }
     }else{
     if(res == null){
     res = arg[i];
     }else{
     res = gcd2(res, arg[i]);
     }
     }
     }
     return res;
     }
     function lcm(elements){
     var res, arg, elements, i, j;
     res = null;
     arg = lcm.arguments;
     for(var i= 0; i < arg.length; i++){
     if(arg[i].length){
     elements = arg[i];
     for(var j= 0; j < elements.length; j++){
     if(res == null){
     res = elements[j];
     }else{
     res = lcm2(res, elements[j]);
     }
     }
     }else{
     if(res == null){
     res = arg[i];
     }else{
     res = lcm2(res, arg[i]);
     }
     }
     }
     return res;
     }
     function gcd2(x, y){
     x = Math.abs(Math.floor(x));
     y = Math.abs(Math.floor(y));
     if(y == 0){
     return x;
     }else{
     return gcd(y, x % y);
     }
     }
     function lcm2(x, y){
     x = Math.abs(parseInt(x));
     y = Math.abs(parseInt(y));
     return (x / gcd(x, y)) * y;
     }
     function inv(x){
     return 1 / x;
     }
     function sorting(a,b){
     return a - b;
     }
     function reverse(a,b){
     return b - a;
     }
     
     function erf(x){
     if(x == 0){
     return 0;
     }else{
     var sgn = 1;
     if(x < 0){
     sgn = -1;
     x = Math.abs(x);
     }else{
     sgn = 1;
     }
     }
     return sgn * (0.000748371 + (1.10247861 * x) + (0.16200162 * x * x) - (0.7677032 * x * x * x) + (0.44091761 * x * x * x * x) - (0.1055138 * x * x * x * x * x) + (0.00944751 * x * x * x * x * x * x));
     }
     function erfc(x){
     if(x == 0){
     return 1;
     }else{
     var sgn = 1;
     if(x < 0){
     sgn = -1;
     x = Math.abs(x);
     }else{
     sgn = 1;
     }
     }
     return sgn * (0.99925163 - (1.1024786 * x) - (0.1620016 * x * x) + (0.76770323 * x * x * x) - (0.4409176 * x * x * x * x) + (0.10551382 * x * x * x * x * x) - (0.0094475 * x * x * x * x * x * x));
     }
     function beta(p, q){
     return (gamma(p) * gamma(q)) / gamma(p + q);
     }
     */
}