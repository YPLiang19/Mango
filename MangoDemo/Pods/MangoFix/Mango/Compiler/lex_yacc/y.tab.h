/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     DOUBLE_LITERAL = 259,
     STRING_LITERAL = 260,
     INTETER_LITERAL = 261,
     SELF = 262,
     SUPER = 263,
     NIL = 264,
     NULL_ = 265,
     YES_ = 266,
     NO_ = 267,
     COLON = 268,
     SEMICOLON = 269,
     COMMA = 270,
     LP = 271,
     RP = 272,
     LB = 273,
     RB = 274,
     LC = 275,
     RC = 276,
     QUESTION = 277,
     DOT = 278,
     ASSIGN = 279,
     AT = 280,
     POWER = 281,
     AND = 282,
     OR = 283,
     NOT = 284,
     EQ = 285,
     NE = 286,
     LT = 287,
     LE = 288,
     GT = 289,
     GE = 290,
     SUB = 291,
     SUB_ASSIGN = 292,
     ADD = 293,
     ADD_ASSIGN = 294,
     ASTERISK_ASSIGN = 295,
     DIV = 296,
     DIV_ASSIGN = 297,
     MOD = 298,
     MOD_ASSIGN = 299,
     INCREMENT = 300,
     DECREMENT = 301,
     ANNOTATION_IF = 302,
     CLASS = 303,
     STRUCT = 304,
     DECLARE = 305,
     SELECTOR = 306,
     RETURN = 307,
     IF = 308,
     ELSE = 309,
     FOR = 310,
     IN = 311,
     WHILE = 312,
     DO = 313,
     SWITCH = 314,
     CASE = 315,
     DEFAULT = 316,
     BREAK = 317,
     CONTINUE = 318,
     PROPERTY = 319,
     WEAK = 320,
     STRONG = 321,
     COPY = 322,
     ASSIGN_MEM = 323,
     NONATOMIC = 324,
     ATOMIC = 325,
     ASTERISK = 326,
     VOID = 327,
     BOOL_ = 328,
     U_INT = 329,
     INT = 330,
     DOUBLE = 331,
     C_STRING = 332,
     CLASS_ = 333,
     SEL_ = 334,
     ID = 335,
     POINTER = 336,
     BLOCK = 337
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define DOUBLE_LITERAL 259
#define STRING_LITERAL 260
#define INTETER_LITERAL 261
#define SELF 262
#define SUPER 263
#define NIL 264
#define NULL_ 265
#define YES_ 266
#define NO_ 267
#define COLON 268
#define SEMICOLON 269
#define COMMA 270
#define LP 271
#define RP 272
#define LB 273
#define RB 274
#define LC 275
#define RC 276
#define QUESTION 277
#define DOT 278
#define ASSIGN 279
#define AT 280
#define POWER 281
#define AND 282
#define OR 283
#define NOT 284
#define EQ 285
#define NE 286
#define LT 287
#define LE 288
#define GT 289
#define GE 290
#define SUB 291
#define SUB_ASSIGN 292
#define ADD 293
#define ADD_ASSIGN 294
#define ASTERISK_ASSIGN 295
#define DIV 296
#define DIV_ASSIGN 297
#define MOD 298
#define MOD_ASSIGN 299
#define INCREMENT 300
#define DECREMENT 301
#define ANNOTATION_IF 302
#define CLASS 303
#define STRUCT 304
#define DECLARE 305
#define SELECTOR 306
#define RETURN 307
#define IF 308
#define ELSE 309
#define FOR 310
#define IN 311
#define WHILE 312
#define DO 313
#define SWITCH 314
#define CASE 315
#define DEFAULT 316
#define BREAK 317
#define CONTINUE 318
#define PROPERTY 319
#define WEAK 320
#define STRONG 321
#define COPY 322
#define ASSIGN_MEM 323
#define NONATOMIC 324
#define ATOMIC 325
#define ASTERISK 326
#define VOID 327
#define BOOL_ 328
#define U_INT 329
#define INT 330
#define DOUBLE 331
#define C_STRING 332
#define CLASS_ 333
#define SEL_ 334
#define ID 335
#define POINTER 336
#define BLOCK 337




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 14 "mango.y"
{
	void	*identifier;
	void	*expression;
	void	*statement;
	void    *struct_entry;
	void	*dic_entry;
	void	*type_specifier;
	void	*one_case;
	void	*else_if;
	void	*class_definition;
	void	*declare_struct;
	void	*member_definition;
	void	*block_statement;
	void	*list;
	void	*method_name_item;
	void	*function_param;
	void	*declaration;
	MANAssignKind assignment_operator;
	MANPropertyModifier property_modifier_list;



}
/* Line 1529 of yacc.c.  */
#line 237 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

