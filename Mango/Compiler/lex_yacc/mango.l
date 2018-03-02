%{
	#undef YY_INPUT
	#define YY_INPUT(buf, result, max_size) (result = string_input(buf, max_size))
	#include <Foundation/Foundation.h>
	#include "create.h"
	#include "y.tab.h"
	#import "MANExpression.h"
#define smaller(a, b) ((a) < (b) ? (a) : (b))
#define larger(a, b) ((a) > (b) ? (a) : (b))

	
	static char const *st_source_string;
	static unsigned long st_current_char_index;
	static unsigned long st_source_len;
	
	void
	nac_set_source_string(char const *source)
	{
		st_source_string = source;
		st_current_char_index = 0;
		st_source_len = strlen(source);
	}
	
	
	static int string_input(char *buf, int max_size)
	{
		unsigned long len = st_source_len - st_current_char_index;
		if(len <= 0){
			return 0;
		}
		len = smaller(len, max_size);
		strncpy(buf, &st_source_string[st_current_char_index], len);
		st_current_char_index += len;
		return (int)len;
	}
	

int yywrap(){
	return 1;
}

static void increment_line_number(){
	MANInterpreter *interpreter = man_get_current_compile_util();
	interpreter.currentLineNumber++;
}
%}
%start C_COMMENT CC_COMMENT STRING_LITERAL_STATE
%%
<INITIAL>":" {return COLON; }
<INITIAL>"^" {return POWER; }
<INITIAL>"," {return COMMA ;}
<INITIAL>";" {return SEMICOLON; }
<INITIAL>"(" {return LP; }
<INITIAL>")" {return RP; }
<INITIAL>"[" {return LB; }
<INITIAL>"]" {return RB; }
<INITIAL>"{" {return LC; }
<INITIAL>"}" {return RC; }
<INITIAL>"?" {return QUESTION; }
<INITIAL>"." { return DOT; }
<INITIAL>"@" { return AT; }


<INITIAL>"&&" {return AND; }
<INITIAL>"||" {return OR; }
<INITIAL>"!" {return NOT; }

<INITIAL>"==" {return EQ; }
<INITIAL>"!=" {return NE; }
<INITIAL>"<" {return LT; }
<INITIAL>"<=" {return LE; }
<INITIAL>">" {return GT; }
<INITIAL>">=" {return GE; }   


<INITIAL>"-" {return SUB; }
<INITIAL>"+" {return ADD; }
<INITIAL>"*" {return ASTERISK; }
<INITIAL>"/" {return DIV; }
<INITIAL>"%" {return MOD; }

<INITIAL>"-=" {return SUB_ASSIGN; }
<INITIAL>"+=" {return ADD_ASSIGN; }
<INITIAL>"*=" {return ASTERISK_ASSIGN; }
<INITIAL>"/=" {return DIV_ASSIGN; }
<INITIAL>"%=" {return MOD_ASSIGN; }

<INITIAL>"=" {return ASSIGN; }



<INITIAL>"++" { return INCREMENT; }
<INITIAL>"--" { return DECREMENT; }

      
<INITIAL>"declare"  {return DECLARE; }
<INITIAL>"struct"  {return STRUCT; }
<INITIAL>"class"  {return CLASS; }


<INITIAL>"if"  {return IF; }
<INITIAL>"else"  {return ELSE; }
<INITIAL>"for"  {return FOR; }
<INITIAL>"in" {return IN; }
<INITIAL>"while"  {return WHILE; }
<INITIAL>"do"  {return DO; }
<INITIAL>"switch"  {return SWITCH; }
<INITIAL>"case"  {return CASE; }
<INITIAL>"default"  {return DEFAULT; }
<INITIAL>"break"  {return BREAK; }
<INITIAL>"continue"  {return CONTINUE; }
<INITIAL>"return" {return RETURN; }




<INITIAL>"#If" {return ANNOTATION_IF; }




<INITIAL>"@property" {return PROPERTY; }
<INITIAL>"@selector" {return SELECTOR; }
<INITIAL>"weak" {return WEAK; }
<INITIAL>"strong" {return STRONG; }
<INITIAL>"copy" {return COPY; }
<INITIAL>"assign" {return ASSIGN_MEM; }
<INITIAL>"nonatomic" {return NONATOMIC; }
<INITIAL>"atomic" {return ATOMIC; }

<INITIAL>"void" {return VOID; }
<INITIAL>"BOOL" {return BOOL_; }
<INITIAL>"int" {return INT; }
<INITIAL>"uint" {return U_INT; }
<INITIAL>"double" {return DOUBLE; }
<INITIAL>"CString" {return C_STRING; }
<INITIAL>"id" {return ID; }
<INITIAL>"Class" {return CLASS_; }
<INITIAL>"SEL" {return SEL_; }
<INITIAL>"Block" {return BLOCK; }
<INITIAL>"Pointer" {return POINTER; }

<INITIAL>"self" {
	MANExpression *expression = man_create_expression(MAN_SELF_EXPRESSION);
	yylval.expression = (__bridge_retained void *)expression;
	return SELF;
}
<INITIAL>"super" {
	MANExpression *expression = man_create_expression(MAN_SUPER_EXPRESSION);
	yylval.expression = (__bridge_retained void *)expression;
	return SUPER;
	
}
<INITIAL>"nil" {
	MANExpression *expression = man_create_expression(MAN_NIL_EXPRESSION);
	yylval.expression = (__bridge_retained void *)expression;
	return NIL;
	
}
<INITIAL>"YES" {
	MANExpression *expression = man_create_expression(MAN_BOOLEAN_EXPRESSION);
	expression.boolValue = YES;
	yylval.expression = (__bridge_retained void *)expression;
	return YES_;
	
}
<INITIAL>"NO" {
	MANExpression *expression = man_create_expression(MAN_BOOLEAN_EXPRESSION);
	expression.boolValue = NO;
	yylval.expression = (__bridge_retained void *)expression;
	return NO_;
	
}



<INITIAL>[A-Za-z_$][A-Za-z_$0-9]* {
	NSString *identifier = man_create_identifier(yytext);
	yylval.identifier = (__bridge_retained void *)identifier;
	return IDENTIFIER;
}



<INITIAL>[1-9][0-9]* {
	MANExpression *expression = man_create_expression(MAN_INT_EXPRESSION);
	NSInteger val;
	sscanf(yytext,"%ld",&val);
	expression.integerValue = val;
	yylval.expression = (__bridge_retained void *)expression;
	return INTETER_LITERAL;
}



<INITIAL>"0"[xX][0-9a-fA-F]+ {
	MANExpression *expression = man_create_expression(MAN_INT_EXPRESSION);
	NSInteger val;
	sscanf(yytext,"%lx",&val);
	expression.integerValue = val;
	yylval.expression = (__bridge_retained void *)expression;
	return INTETER_LITERAL;
}


<INITIAL>"0" {
	MANExpression *expression = man_create_expression(MAN_INT_EXPRESSION);
	expression.integerValue = 0;
	yylval.expression = (__bridge_retained void *)expression;
	return INTETER_LITERAL;
}


<INITIAL>[0-9]+\.[0-9]+ {
	MANExpression *expression = man_create_expression(MAN_DOUBLE_EXPRESSION);
	double val;
	sscanf(yytext,"%lf",&val);
	expression.doubleValue = val;
	yylval.expression = (__bridge_retained void *)expression;
	return DOUBLE_LITERAL;
}

<INITIAL>\" {
	man_open_string_literal_buf();
	BEGIN STRING_LITERAL_STATE;
}

<INITIAL>[ \t] ;
<INITIAL>[\n] { increment_line_number(); }

<INITIAL>"/*" {	BEGIN C_COMMENT; }
<INITIAL>"//" { BEGIN CC_COMMENT; }
<INITIAL>.	{
	man_compile_err(0,MANCompileErrorParseErr);
}

<C_COMMENT>\n { increment_line_number();}
<C_COMMENT>. ;
<C_COMMENT>"*/"	{ BEGIN INITIAL; }
<C_COMMENT><<EOF>>	{
	man_compile_err(0,MANCompileErrorParseErr);
}

<CC_COMMENT>.	;
<CC_COMMENT>\n	{
	increment_line_number();
	BEGIN INITIAL;
}
<CC_COMMENT><<EOF>> { BEGIN INITIAL; }



<STRING_LITERAL_STATE>\" {
	MANExpression *expression = man_create_expression(MAN_STRING_EXPRESSION);
	expression.cstringValue = man_end_string_literal();
	yylval.expression = (__bridge_retained void *)expression;
	BEGIN  INITIAL;
	return STRING_LITERAL;
}

<STRING_LITERAL_STATE>. {
	man_append_string_literal(yytext[0]);
} 


<STRING_LITERAL_STATE>\\\"  { man_append_string_literal('\"'); }
<STRING_LITERAL_STATE>\\n	{ man_append_string_literal('\n'); }
<STRING_LITERAL_STATE>\\t	{ man_append_string_literal('\t'); }
<STRING_LITERAL_STATE>\\\\	{ man_append_string_literal('\\'); }
<STRING_LITERAL_STATE>[\x81-\x9f\xe0-\xef][\x40-\x7e\x80-\xfc] {
	man_append_string_literal(yytext[0]);
	man_append_string_literal(yytext[1]);
}


%%


