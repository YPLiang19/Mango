/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



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




/* Copy the first part of user declarations.  */
#line 1 "mango.y"

	#define YYDEBUG 1
	#define YYERROR_VERBOSE
	#import <Foundation/Foundation.h>
	#import "create.h"
	#import "man_ast.h"
	

int yyerror(char const *str);
int yylex(void);



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

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
/* Line 193 of yacc.c.  */
#line 297 "y.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 310 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  99
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   947

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  83
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  78
/* YYNRULES -- Number of rules.  */
#define YYNRULES  208
/* YYNRULES -- Number of states.  */
#define YYNSTATES  395

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   337

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    11,    13,    15,    17,
      18,    23,    37,    51,    53,    57,    58,    67,    68,    78,
      79,    91,    92,   105,   107,   111,   120,   128,   130,   134,
     136,   138,   140,   142,   144,   146,   148,   150,   152,   154,
     156,   158,   160,   162,   164,   166,   168,   170,   172,   175,
     178,   180,   182,   184,   192,   200,   202,   204,   206,   208,
     211,   218,   220,   222,   224,   227,   229,   231,   233,   236,
     240,   242,   244,   248,   250,   252,   254,   256,   258,   260,
     262,   268,   273,   275,   279,   281,   285,   287,   291,   295,
     297,   301,   305,   309,   313,   315,   319,   323,   325,   329,
     333,   337,   339,   342,   345,   347,   350,   353,   355,   359,
     363,   365,   369,   374,   378,   382,   384,   388,   392,   394,
     398,   404,   411,   415,   420,   424,   429,   431,   433,   435,
     437,   439,   441,   443,   448,   451,   454,   457,   460,   463,
     465,   467,   472,   477,   481,   483,   485,   487,   493,   497,
     504,   509,   512,   518,   520,   524,   527,   530,   533,   538,
     544,   552,   559,   568,   570,   573,   580,   589,   591,   594,
     599,   600,   604,   605,   607,   617,   627,   633,   641,   650,
     658,   661,   664,   668,   671,   672,   676,   677,   682,   684,
     687,   689,   691,   693,   695,   697,   699,   701,   703,   705,
     707,   709,   711,   713,   715,   717,   719,   721,   723
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
      84,     0,    -1,    -1,    85,    -1,    86,    -1,    85,    86,
      -1,    90,    -1,    88,    -1,   160,    -1,    -1,    47,    16,
     114,    17,    -1,    87,    50,    49,     3,    20,     3,    13,
       5,    15,     3,    13,    89,    21,    -1,    87,    50,    49,
       3,    20,     3,    13,    89,    15,     3,    13,     5,    21,
      -1,     3,    -1,    89,    15,     3,    -1,    -1,    87,    48,
       3,    13,     3,    20,    91,    21,    -1,    -1,    87,    48,
       3,    13,     3,    20,    92,   110,    21,    -1,    -1,    87,
      48,     3,    13,     3,    32,    95,    34,    20,    93,    21,
      -1,    -1,    87,    48,     3,    13,     3,    32,    95,    34,
      20,    94,   110,    21,    -1,     3,    -1,    95,    15,     3,
      -1,    87,    64,    16,    97,    17,   101,     3,    14,    -1,
      87,    64,    16,    17,   101,     3,    14,    -1,    98,    -1,
      97,    15,    98,    -1,    99,    -1,   100,    -1,    65,    -1,
      66,    -1,    67,    -1,    68,    -1,    69,    -1,    70,    -1,
      72,    -1,    73,    -1,    75,    -1,    74,    -1,    76,    -1,
      77,    -1,    80,    -1,    78,    -1,    79,    -1,    82,    -1,
      81,    -1,     3,    71,    -1,    49,     3,    -1,     3,    -1,
     103,    -1,   104,    -1,    87,    36,    16,   101,    17,   105,
     155,    -1,    87,    38,    16,   101,    17,   105,   155,    -1,
     106,    -1,   107,    -1,     3,    -1,   108,    -1,   107,   108,
      -1,     3,    13,    16,   101,    17,     3,    -1,    96,    -1,
     102,    -1,   109,    -1,   110,   109,    -1,   112,    -1,   113,
      -1,     3,    -1,     3,    13,    -1,   113,     3,    13,    -1,
     115,    -1,   117,    -1,   133,   116,   117,    -1,    24,    -1,
      37,    -1,    39,    -1,    40,    -1,    42,    -1,    44,    -1,
     118,    -1,   118,    22,   117,    13,   117,    -1,   118,    22,
      13,   117,    -1,   119,    -1,   118,    28,   119,    -1,   120,
      -1,   119,    27,   120,    -1,   121,    -1,   120,    30,   121,
      -1,   120,    31,   121,    -1,   122,    -1,   121,    32,   122,
      -1,   121,    33,   122,    -1,   121,    34,   122,    -1,   121,
      35,   122,    -1,   123,    -1,   122,    38,   123,    -1,   122,
      36,   123,    -1,   124,    -1,   123,    71,   124,    -1,   123,
      41,   124,    -1,   123,    43,   124,    -1,   125,    -1,    29,
     124,    -1,    36,   124,    -1,   133,    -1,   133,    45,    -1,
     133,    46,    -1,   115,    -1,   126,    15,   115,    -1,   133,
      13,   133,    -1,   127,    -1,   128,    15,   127,    -1,    25,
      20,   128,    21,    -1,    25,    20,    21,    -1,     3,    13,
     133,    -1,   130,    -1,   131,    15,   130,    -1,    20,   131,
      21,    -1,     3,    -1,   133,    23,     3,    -1,   133,    23,
     111,    16,    17,    -1,   133,    23,   111,    16,   126,    17,
      -1,     3,    16,    17,    -1,     3,    16,   126,    17,    -1,
      16,   114,    17,    -1,   133,    18,   114,    19,    -1,    11,
      -1,    12,    -1,     6,    -1,     4,    -1,     5,    -1,     9,
      -1,    10,    -1,    51,    16,   111,    17,    -1,    25,     6,
      -1,    25,     4,    -1,    25,     5,    -1,    25,    11,    -1,
      25,    12,    -1,     7,    -1,     8,    -1,    25,    16,   114,
      17,    -1,    25,    18,   126,    19,    -1,    25,    18,    19,
      -1,   129,    -1,   132,    -1,   134,    -1,    26,   101,    16,
      17,   155,    -1,    26,   101,   155,    -1,    26,   101,    16,
     135,    17,   155,    -1,    26,    16,    17,   155,    -1,    26,
     155,    -1,    26,    16,   135,    17,   155,    -1,   136,    -1,
     135,    15,   136,    -1,   101,     3,    -1,   138,    14,    -1,
     101,     3,    -1,   101,     3,    24,   114,    -1,    53,    16,
     114,    17,   155,    -1,    53,    16,   114,    17,   155,    54,
     155,    -1,    53,    16,   114,    17,   155,   140,    -1,    53,
      16,   114,    17,   155,   140,    54,   155,    -1,   141,    -1,
     140,   141,    -1,    54,    53,    16,   114,    17,   155,    -1,
      59,    16,   114,    17,    20,   143,   145,    21,    -1,   144,
      -1,   143,   144,    -1,    60,   114,    13,   155,    -1,    -1,
      61,    13,   155,    -1,    -1,   114,    -1,    55,    16,   146,
      14,   146,    14,   146,    17,   155,    -1,    55,    16,   138,
      14,   146,    14,   146,    17,   155,    -1,    57,    16,   114,
      17,   155,    -1,    58,   155,    57,    16,   114,    17,    14,
      -1,    55,    16,   101,     3,    56,   114,    17,   155,    -1,
      55,    16,     3,    56,   114,    17,   155,    -1,    63,    14,
      -1,    62,    14,    -1,    52,   146,    14,    -1,   114,    14,
      -1,    -1,    20,   156,    21,    -1,    -1,    20,   157,   158,
      21,    -1,   159,    -1,   158,   159,    -1,   137,    -1,   139,
      -1,   142,    -1,   147,    -1,   150,    -1,   148,    -1,   149,
      -1,   152,    -1,   151,    -1,   153,    -1,   154,    -1,   137,
      -1,   139,    -1,   142,    -1,   147,    -1,   150,    -1,   148,
      -1,   149,    -1,   154,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    84,    84,    85,    89,    90,    93,    98,   103,   112,
     115,   122,   137,   154,   162,   175,   174,   187,   186,   200,
     199,   213,   212,   228,   235,   245,   254,   266,   267,   274,
     275,   278,   282,   286,   290,   296,   300,   306,   310,   314,
     318,   322,   326,   330,   334,   338,   342,   346,   350,   354,
     358,   365,   366,   369,   380,   391,   392,   395,   405,   412,
     421,   432,   433,   436,   443,   452,   453,   456,   459,   465,
     474,   477,   478,   488,   493,   497,   501,   505,   509,   515,
     516,   524,   533,   534,   543,   544,   553,   554,   561,   570,
     571,   578,   585,   592,   601,   602,   609,   618,   619,   626,
     633,   642,   643,   650,   659,   660,   667,   676,   683,   692,
     701,   708,   717,   724,   732,   741,   748,   757,   766,   773,
     780,   793,   807,   816,   826,   830,   841,   842,   843,   844,
     845,   846,   847,   848,   854,   861,   869,   876,   883,   890,
     895,   900,   907,   914,   919,   920,   921,   927,   936,   945,
     955,   962,   969,   980,   987,   996,  1005,  1013,  1020,  1032,
    1039,  1047,  1055,  1066,  1073,  1082,  1091,  1101,  1108,  1117,
    1127,  1130,  1137,  1140,  1145,  1156,  1168,  1177,  1186,  1195,
    1206,  1214,  1222,  1230,  1240,  1239,  1251,  1250,  1265,  1272,
    1282,  1283,  1284,  1285,  1286,  1287,  1288,  1289,  1290,  1291,
    1292,  1295,  1296,  1297,  1298,  1299,  1300,  1301,  1302
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IDENTIFIER", "DOUBLE_LITERAL",
  "STRING_LITERAL", "INTETER_LITERAL", "SELF", "SUPER", "NIL", "NULL_",
  "YES_", "NO_", "COLON", "SEMICOLON", "COMMA", "LP", "RP", "LB", "RB",
  "LC", "RC", "QUESTION", "DOT", "ASSIGN", "AT", "POWER", "AND", "OR",
  "NOT", "EQ", "NE", "LT", "LE", "GT", "GE", "SUB", "SUB_ASSIGN", "ADD",
  "ADD_ASSIGN", "ASTERISK_ASSIGN", "DIV", "DIV_ASSIGN", "MOD",
  "MOD_ASSIGN", "INCREMENT", "DECREMENT", "ANNOTATION_IF", "CLASS",
  "STRUCT", "DECLARE", "SELECTOR", "RETURN", "IF", "ELSE", "FOR", "IN",
  "WHILE", "DO", "SWITCH", "CASE", "DEFAULT", "BREAK", "CONTINUE",
  "PROPERTY", "WEAK", "STRONG", "COPY", "ASSIGN_MEM", "NONATOMIC",
  "ATOMIC", "ASTERISK", "VOID", "BOOL_", "U_INT", "INT", "DOUBLE",
  "C_STRING", "CLASS_", "SEL_", "ID", "POINTER", "BLOCK", "$accept",
  "compile_util", "definition_list", "definition", "annotation_if",
  "declare_struct", "identifier_list", "class_definition", "@1", "@2",
  "@3", "@4", "protocol_list", "property_definition",
  "property_modifier_list", "property_modifier", "property_rc_modifier",
  "property_atomic_modifier", "type_specifier", "method_definition",
  "instance_method_definition", "class_method_definition", "method_name",
  "method_name_1", "method_name_2", "method_name_item",
  "member_definition", "member_definition_list", "selector", "selector_1",
  "selector_2", "expression", "assign_expression", "assignment_operator",
  "ternary_operator_expression", "logic_or_expression",
  "logic_and_expression", "equality_expression", "relational_expression",
  "additive_expression", "multiplication_expression", "unary_expression",
  "postfix_expression", "expression_list", "dic_entry", "dic_entry_list",
  "dic", "struct_entry", "struct_entry_list", "struct_literal",
  "primary_expression", "block_body", "function_param_list",
  "function_param", "declaration_statement", "declaration", "if_statement",
  "else_if_list", "else_if", "switch_statement", "case_list", "one_case",
  "default_opt", "expression_opt", "for_statement", "while_statement",
  "do_while_statement", "foreach_statement", "continue_statement",
  "break_statement", "return_statement", "expression_statement",
  "block_statement", "@5", "@6", "statement_list", "statement",
  "top_statement", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    83,    84,    84,    85,    85,    86,    86,    86,    87,
      87,    88,    88,    89,    89,    91,    90,    92,    90,    93,
      90,    94,    90,    95,    95,    96,    96,    97,    97,    98,
      98,    99,    99,    99,    99,   100,   100,   101,   101,   101,
     101,   101,   101,   101,   101,   101,   101,   101,   101,   101,
     101,   102,   102,   103,   104,   105,   105,   106,   107,   107,
     108,   109,   109,   110,   110,   111,   111,   112,   113,   113,
     114,   115,   115,   116,   116,   116,   116,   116,   116,   117,
     117,   117,   118,   118,   119,   119,   120,   120,   120,   121,
     121,   121,   121,   121,   122,   122,   122,   123,   123,   123,
     123,   124,   124,   124,   125,   125,   125,   126,   126,   127,
     128,   128,   129,   129,   130,   131,   131,   132,   133,   133,
     133,   133,   133,   133,   133,   133,   133,   133,   133,   133,
     133,   133,   133,   133,   133,   133,   133,   133,   133,   133,
     133,   133,   133,   133,   133,   133,   133,   134,   134,   134,
     134,   134,   134,   135,   135,   136,   137,   138,   138,   139,
     139,   139,   139,   140,   140,   141,   142,   143,   143,   144,
     145,   145,   146,   146,   147,   147,   148,   149,   150,   150,
     151,   152,   153,   154,   156,   155,   157,   155,   158,   158,
     159,   159,   159,   159,   159,   159,   159,   159,   159,   159,
     159,   160,   160,   160,   160,   160,   160,   160,   160
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     0,
       4,    13,    13,     1,     3,     0,     8,     0,     9,     0,
      11,     0,    12,     1,     3,     8,     7,     1,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       1,     1,     1,     7,     7,     1,     1,     1,     1,     2,
       6,     1,     1,     1,     2,     1,     1,     1,     2,     3,
       1,     1,     3,     1,     1,     1,     1,     1,     1,     1,
       5,     4,     1,     3,     1,     3,     1,     3,     3,     1,
       3,     3,     3,     3,     1,     3,     3,     1,     3,     3,
       3,     1,     2,     2,     1,     2,     2,     1,     3,     3,
       1,     3,     4,     3,     3,     1,     3,     3,     1,     3,
       5,     6,     3,     4,     3,     4,     1,     1,     1,     1,
       1,     1,     1,     4,     2,     2,     2,     2,     2,     1,
       1,     4,     4,     3,     1,     1,     1,     5,     3,     6,
       4,     2,     5,     1,     3,     2,     2,     2,     4,     5,
       7,     6,     8,     1,     2,     6,     8,     1,     2,     4,
       0,     3,     0,     1,     9,     9,     5,     7,     8,     7,
       2,     2,     3,     2,     0,     3,     0,     4,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       9,   118,   129,   130,   128,   139,   140,   131,   132,   126,
     127,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    37,    38,    40,    39,    41,
      42,    44,    45,    43,    47,    46,     0,     9,     4,     0,
       7,     6,     0,     0,    70,    71,    79,    82,    84,    86,
      89,    94,    97,   101,   144,   145,   104,   146,   201,     0,
     202,   203,   204,   206,   207,   205,   208,     8,     0,    48,
     118,     0,     0,   115,     0,   135,   136,   134,   137,   138,
       0,     0,     0,    50,     0,   186,     0,   151,   102,   104,
     103,     0,    49,     0,     0,   172,     0,     0,     0,     1,
       5,     0,     0,   157,   183,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    73,    74,    75,    76,    77,    78,   105,   106,     0,
     156,   122,   107,     0,   124,     0,     0,   117,     0,   143,
       0,   113,   110,     0,     0,     0,     0,     0,   153,     0,
       0,     0,   148,     0,    67,     0,    65,    66,     0,   118,
       0,   173,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    83,    85,    87,    88,    90,    91,    92,    93,
      96,    95,    99,   100,    98,     0,   119,     0,    72,     0,
     123,   114,   116,   141,   142,     0,   112,     0,   150,   155,
       0,     0,   185,   172,     0,     0,   190,   191,   192,   193,
     195,   196,   194,   198,   197,   199,   200,     0,   188,     0,
       0,    10,    68,   133,     0,     0,     0,   157,   172,   172,
       0,     0,     0,     0,     0,   158,    81,     0,   125,     0,
     108,   111,   109,   154,   152,     0,   181,   180,   187,   189,
     147,     0,    69,   159,     0,     0,     0,     0,   176,     0,
       0,     0,     0,    80,   120,     0,   182,   149,     0,   161,
     163,     0,     0,   172,   172,     0,     0,   170,   167,    17,
       0,     0,   121,     0,   160,     0,   164,   179,     0,     0,
       0,   177,     0,     0,   168,     0,     0,     9,    23,     0,
       0,     0,   162,   178,     0,     0,     0,     0,   166,    16,
       0,    61,    62,    51,    52,    63,     9,     0,     0,    13,
       0,     0,     0,   175,   174,   169,   171,     0,     0,     0,
      18,    64,    24,    21,     0,     0,     0,     0,     0,     0,
       0,     9,     0,    14,   165,     0,     0,     0,    31,    32,
      33,    34,    35,    36,     0,    27,    29,    30,    20,     9,
       0,     0,     0,     0,     0,     0,     0,    22,     0,     0,
      57,     0,    55,    56,    58,     0,     0,    28,     0,     0,
      11,    12,     0,    53,     0,    59,    54,    26,     0,    14,
       0,    25,     0,     0,    60
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    36,    37,    38,   310,    40,   321,    41,   296,   297,
     340,   341,   299,   311,   354,   355,   356,   357,    42,   312,
     313,   314,   371,   372,   373,   374,   315,   316,   155,   156,
     157,   161,    44,   129,    45,    46,    47,    48,    49,    50,
      51,    52,    53,   133,   142,   143,    54,    73,    74,    55,
      56,    57,   147,   148,    58,    59,    60,   269,   270,    61,
     277,   278,   295,   163,    62,    63,    64,    65,   213,   214,
     215,    66,    87,   149,   150,   217,   218,    67
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -312
static const yytype_int16 yypact[] =
{
     362,    12,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,
    -312,   838,     9,   164,    53,   838,   838,    51,    87,    83,
      91,   123,   169,   182,   195,  -312,  -312,  -312,  -312,  -312,
    -312,  -312,  -312,  -312,  -312,  -312,   222,   445,  -312,    56,
    -312,  -312,   203,   202,  -312,  -312,    19,   198,   130,    42,
      81,    -5,  -312,  -312,  -312,  -312,   216,  -312,  -312,   210,
    -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,   184,  -312,
     211,   209,   217,  -312,    44,  -312,  -312,  -312,  -312,  -312,
     838,   719,   872,   160,    69,   220,   120,  -312,  -312,     8,
    -312,   838,  -312,   233,   838,   685,   838,   180,   838,  -312,
    -312,   235,   193,   219,  -312,   768,   838,   838,   838,   838,
     838,   838,   838,   838,   838,   838,   838,   838,   838,   838,
     244,  -312,  -312,  -312,  -312,  -312,  -312,  -312,  -312,   838,
    -312,  -312,  -312,   105,  -312,   896,     9,  -312,   231,  -312,
     144,  -312,  -312,    80,    37,   182,   247,   166,  -312,   230,
     605,   215,  -312,   237,   239,   242,  -312,   262,   250,     7,
     265,  -312,   255,   256,   254,   257,   258,   259,   271,   838,
     838,   263,   198,   130,    42,    42,    81,    81,    81,    81,
      -5,    -5,  -312,  -312,  -312,   260,    30,   261,  -312,   838,
    -312,    39,  -312,  -312,  -312,   896,  -312,   896,  -312,  -312,
     490,   182,  -312,   838,   266,   267,  -312,  -312,  -312,  -312,
    -312,  -312,  -312,  -312,  -312,  -312,  -312,   525,  -312,   182,
     190,  -312,  -312,  -312,   273,   182,   838,     5,   838,   838,
     182,   838,   278,   296,   280,  -312,  -312,   838,  -312,   804,
    -312,  -312,    39,  -312,  -312,   287,  -312,  -312,  -312,  -312,
    -312,   182,  -312,   248,   288,   838,   290,   292,  -312,   291,
     249,    17,   304,  -312,  -312,   197,  -312,  -312,    -9,   264,
    -312,   182,   293,   838,   838,   298,   838,   112,  -312,   294,
     310,   303,  -312,   301,  -312,    -9,  -312,  -312,   182,   302,
     305,  -312,   307,   308,  -312,   306,   309,   279,  -312,    18,
     212,   838,  -312,  -312,   182,   182,   182,   182,  -312,  -312,
       4,  -312,  -312,  -312,  -312,  -312,    -2,   322,   311,  -312,
     313,   314,   315,  -312,  -312,  -312,  -312,   332,   334,   335,
    -312,  -312,  -312,   333,   352,   353,   182,   490,   490,    88,
     336,   279,   346,   347,  -312,   344,   358,   490,  -312,  -312,
    -312,  -312,  -312,  -312,   206,  -312,  -312,  -312,  -312,    11,
     360,   372,   376,   376,   377,    46,   490,  -312,    82,   363,
     368,   182,  -312,   380,  -312,   182,   371,  -312,   383,   386,
    -312,  -312,   374,  -312,   368,  -312,  -312,  -312,   378,  -312,
     490,  -312,   379,   390,  -312
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -312,  -312,  -312,   357,    14,  -312,    35,  -312,  -312,  -312,
    -312,  -312,  -312,  -312,  -312,    32,  -312,  -312,   -14,  -312,
    -312,  -312,    38,  -312,  -312,    27,  -311,    61,   283,  -312,
    -312,     2,   -65,  -312,   -99,  -312,   299,   297,    90,    54,
      63,    -8,  -312,   -77,   213,  -312,  -312,   270,  -312,  -312,
     229,  -312,   272,   207,  -133,   317,  -132,  -312,   141,  -130,
    -312,   137,  -312,  -194,  -129,  -128,  -126,  -125,  -312,  -312,
    -312,  -123,   -22,  -312,  -312,  -312,   199,  -312
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -185
static const yytype_int16 yytable[] =
{
      86,    97,    43,   132,   140,   331,   171,    88,    90,   245,
     -50,    85,    72,    71,    39,   -50,   132,   206,   207,   330,
     208,   209,   210,    68,   211,   212,   119,   216,    68,   169,
     188,   120,   367,   317,   256,   257,   116,   279,   117,    43,
     327,   105,   328,   222,   283,    17,   -67,   106,   331,   280,
     197,    39,   318,   127,   128,   119,    83,   119,    17,   136,
     120,   255,   120,   226,   152,   137,   118,    91,   329,    84,
     146,   236,    83,    85,   110,   111,   112,   113,    69,   289,
     290,   160,   138,    69,   206,   207,   145,   208,   209,   210,
      92,   211,   212,   153,   216,   195,   158,   379,   164,    93,
     166,   196,    18,   380,   101,   347,   102,    94,   182,   183,
     184,   348,   349,   350,   351,   352,   353,   114,    18,   115,
     189,   185,   190,   198,   240,    25,    26,    27,    28,    29,
      30,    31,    32,    33,    34,    35,   151,   146,   263,    95,
      85,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    43,   348,   349,   350,   351,   352,   353,   189,
     108,   109,   265,   194,   176,   177,   178,   179,    75,    76,
      77,   235,   276,   293,   132,    78,    79,   180,   181,   244,
      80,   200,    81,   201,    82,    96,   146,    70,     2,     3,
       4,     5,     6,     7,     8,     9,    10,   250,   174,   175,
      11,   131,    85,   253,    12,   200,   103,   251,   258,    13,
      14,    98,   189,    15,   282,   319,   104,   320,    83,    43,
      16,   365,    99,   366,   130,   107,   134,    68,   254,   267,
     135,    69,   219,   259,   119,    19,   154,   165,   167,   120,
     121,  -184,   168,   169,    89,    89,   284,   186,   193,   287,
     199,   202,   222,   122,   221,   123,   124,   272,   125,   223,
     126,   127,   128,   302,    18,   224,   303,   225,   227,   228,
     229,   230,   233,   231,   234,   232,   237,   239,   292,   238,
     246,   247,   323,   324,   325,   326,   252,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,   260,   261,
     262,   266,   268,   322,   273,   271,   274,   281,   275,   276,
     288,   144,   291,   298,   344,   -15,   300,   301,   285,   304,
     306,   307,   305,   345,   346,   332,    17,   308,   334,   335,
     309,   333,   336,   364,    89,    89,    89,    89,    89,    89,
      89,    89,    89,    89,    89,    89,    89,    89,   337,   383,
     338,   339,   378,   386,   -19,   342,   343,   358,    89,   360,
     361,   362,    -2,   319,   191,     1,     2,     3,     4,     5,
       6,     7,     8,     9,    10,   363,   392,   369,    11,   370,
     376,   382,    12,   384,   381,   387,   388,    13,    14,   389,
     390,    15,   391,   394,   100,   368,   393,   377,    16,    89,
     385,   375,   359,   187,   173,   172,   192,   243,   241,    17,
     286,    18,   162,    19,   294,    20,   249,    21,     0,    22,
      23,    24,     0,   220,   144,     0,   242,     0,     0,     0,
       0,     0,     0,     0,    25,    26,    27,    28,    29,    30,
      31,    32,    33,    34,    35,    -3,     0,     0,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,     0,     0,
       0,    11,     0,     0,     0,    12,    89,     0,     0,     0,
      13,    14,     0,     0,    15,     0,     0,     0,     0,     0,
       0,    16,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    17,    83,    18,     0,    19,     0,    20,     0,
      21,     0,    22,    23,    24,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,     0,    18,
       0,    11,     0,     0,     0,    12,   248,     0,     0,     0,
      13,    14,     0,     0,    15,     0,     0,     0,     0,     0,
       0,    16,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,     0,    18,     0,    19,   203,    20,     0,
      21,     0,    22,    23,    24,     0,     0,   204,   205,     0,
       0,     0,     0,     0,     0,     0,     0,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,     1,     2,
       3,     4,     5,     6,     7,     8,     9,    10,     0,     0,
       0,    11,     0,     0,     0,    12,     0,     0,     0,     0,
      13,    14,     0,     0,    15,     0,     0,     0,     0,     0,
       0,    16,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    18,     0,    19,   203,    20,     0,
      21,     0,    22,    23,    24,     0,     0,   204,   205,     0,
       0,     0,     0,     0,     0,     0,     0,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,   159,     2,
       3,     4,     5,     6,     7,     8,     9,    10,     0,     0,
       0,    11,     0,     0,     0,    12,     0,     0,     0,     0,
      13,    14,     0,     0,    15,     0,     0,     0,     0,     0,
       0,    16,    70,     2,     3,     4,     5,     6,     7,     8,
       9,    10,     0,     0,    18,    11,    19,     0,   139,    12,
       0,     0,     0,     0,    13,    14,     0,     0,    15,     0,
       0,     0,     0,     0,     0,    16,     0,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,     0,     0,
      19,    70,     2,     3,     4,     5,     6,     7,     8,     9,
      10,   170,     0,     0,    11,     0,     0,     0,    12,     0,
       0,     0,     0,    13,    14,     0,     0,    15,     0,     0,
       0,     0,     0,     0,    16,     0,     0,    70,     2,     3,
       4,     5,     6,     7,     8,     9,    10,     0,     0,    19,
      11,   264,     0,     0,    12,     0,     0,     0,     0,    13,
      14,     0,     0,    15,     0,     0,     0,     0,     0,     0,
      16,    70,     2,     3,     4,     5,     6,     7,     8,     9,
      10,     0,     0,     0,    11,    19,     0,     0,    12,     0,
       0,     0,     0,    13,    14,     0,     0,    15,     0,     0,
       0,     0,     0,     0,    16,    70,     2,     3,     4,     5,
       6,     7,     8,     9,    10,     0,     0,     0,    11,    19,
       0,     0,    12,   141,     0,     0,     0,    13,    14,    70,
       2,     3,     4,     5,     6,     7,     8,     9,    10,     0,
       0,     0,    11,     0,     0,     0,    12,     0,     0,     0,
       0,    13,    14,    19,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    19
};

static const yytype_int16 yycheck[] =
{
      14,    23,     0,    68,    81,   316,   105,    15,    16,   203,
       3,    20,     3,    11,     0,     3,    81,   150,   150,    21,
     150,   150,   150,    16,   150,   150,    18,   150,    16,    24,
     129,    23,    21,    15,   228,   229,    41,    20,    43,    37,
      36,    22,    38,    13,    53,    47,    16,    28,   359,    32,
      13,    37,    34,    45,    46,    18,     3,    18,    47,    15,
      23,    56,    23,    56,    86,    21,    71,    16,    64,    16,
      84,   170,     3,    20,    32,    33,    34,    35,    71,   273,
     274,    95,    80,    71,   217,   217,    17,   217,   217,   217,
       3,   217,   217,    91,   217,    15,    94,    15,    96,    16,
      98,    21,    49,    21,    48,    17,    50,    16,   116,   117,
     118,    65,    66,    67,    68,    69,    70,    36,    49,    38,
      15,   119,    17,   145,   189,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    16,   151,   237,    16,
      20,    72,    73,    74,    75,    76,    77,    78,    79,    80,
      81,    82,   150,    65,    66,    67,    68,    69,    70,    15,
      30,    31,   239,    19,   110,   111,   112,   113,     4,     5,
       6,   169,    60,    61,   239,    11,    12,   114,   115,   201,
      16,    15,    18,    17,    20,    16,   200,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,   219,   108,   109,
      16,    17,    20,   225,    20,    15,     3,    17,   230,    25,
      26,    16,    15,    29,    17,     3,    14,     5,     3,   217,
      36,    15,     0,    17,    14,    27,    17,    16,   226,   251,
      13,    71,    17,   231,    18,    51,     3,    57,     3,    23,
      24,    21,    49,    24,    15,    16,   268,     3,    17,   271,
       3,    21,    13,    37,    17,    39,    40,   255,    42,    17,
      44,    45,    46,   285,    49,     3,   288,    17,     3,    14,
      14,    17,    13,    16,     3,    17,    13,    16,   276,    19,
      14,    14,   304,   305,   306,   307,    13,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    20,     3,
      20,    14,    54,   301,    14,    17,    14,     3,    17,    60,
      17,    82,    14,     3,   336,    21,    13,    16,    54,    17,
      13,    13,    17,   337,   338,     3,    47,    21,    15,    15,
      21,    20,    17,   347,   105,   106,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,    16,   371,
      16,    16,   366,   375,    21,     3,     3,    21,   129,    13,
      13,    17,     0,     3,   135,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    17,   390,     5,    16,     3,
       3,    13,    20,     3,    21,    14,     3,    25,    26,     3,
      16,    29,    14,     3,    37,   360,    17,   365,    36,   170,
     373,   363,   341,   120,   107,   106,   136,   200,   195,    47,
     269,    49,    95,    51,   277,    53,   217,    55,    -1,    57,
      58,    59,    -1,   151,   195,    -1,   197,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    72,    73,    74,    75,    76,    77,
      78,    79,    80,    81,    82,     0,    -1,    -1,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    -1,    -1,
      -1,    16,    -1,    -1,    -1,    20,   237,    -1,    -1,    -1,
      25,    26,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    47,     3,    49,    -1,    51,    -1,    53,    -1,
      55,    -1,    57,    58,    59,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    -1,    49,
      -1,    16,    -1,    -1,    -1,    20,    21,    -1,    -1,    -1,
      25,    26,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    81,    82,    -1,    49,    -1,    51,    52,    53,    -1,
      55,    -1,    57,    58,    59,    -1,    -1,    62,    63,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    -1,    -1,
      -1,    16,    -1,    -1,    -1,    20,    -1,    -1,    -1,    -1,
      25,    26,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    49,    -1,    51,    52,    53,    -1,
      55,    -1,    57,    58,    59,    -1,    -1,    62,    63,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    -1,    -1,
      -1,    16,    -1,    -1,    -1,    20,    -1,    -1,    -1,    -1,
      25,    26,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      -1,    36,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    -1,    -1,    49,    16,    51,    -1,    19,    20,
      -1,    -1,    -1,    -1,    25,    26,    -1,    -1,    29,    -1,
      -1,    -1,    -1,    -1,    -1,    36,    -1,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    -1,    -1,
      51,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    13,    -1,    -1,    16,    -1,    -1,    -1,    20,    -1,
      -1,    -1,    -1,    25,    26,    -1,    -1,    29,    -1,    -1,
      -1,    -1,    -1,    -1,    36,    -1,    -1,     3,     4,     5,
       6,     7,     8,     9,    10,    11,    12,    -1,    -1,    51,
      16,    17,    -1,    -1,    20,    -1,    -1,    -1,    -1,    25,
      26,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,    -1,
      36,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    -1,    -1,    -1,    16,    51,    -1,    -1,    20,    -1,
      -1,    -1,    -1,    25,    26,    -1,    -1,    29,    -1,    -1,
      -1,    -1,    -1,    -1,    36,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    12,    -1,    -1,    -1,    16,    51,
      -1,    -1,    20,    21,    -1,    -1,    -1,    25,    26,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    12,    -1,
      -1,    -1,    16,    -1,    -1,    -1,    20,    -1,    -1,    -1,
      -1,    25,    26,    51,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    51
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,     6,     7,     8,     9,    10,    11,
      12,    16,    20,    25,    26,    29,    36,    47,    49,    51,
      53,    55,    57,    58,    59,    72,    73,    74,    75,    76,
      77,    78,    79,    80,    81,    82,    84,    85,    86,    87,
      88,    90,   101,   114,   115,   117,   118,   119,   120,   121,
     122,   123,   124,   125,   129,   132,   133,   134,   137,   138,
     139,   142,   147,   148,   149,   150,   154,   160,    16,    71,
       3,   114,     3,   130,   131,     4,     5,     6,    11,    12,
      16,    18,    20,     3,    16,    20,   101,   155,   124,   133,
     124,    16,     3,    16,    16,    16,    16,   155,    16,     0,
      86,    48,    50,     3,    14,    22,    28,    27,    30,    31,
      32,    33,    34,    35,    36,    38,    41,    43,    71,    18,
      23,    24,    37,    39,    40,    42,    44,    45,    46,   116,
      14,    17,   115,   126,    17,    13,    15,    21,   114,    19,
     126,    21,   127,   128,   133,    17,   101,   135,   136,   156,
     157,    16,   155,   114,     3,   111,   112,   113,   114,     3,
     101,   114,   138,   146,   114,    57,   114,     3,    49,    24,
      13,   117,   119,   120,   121,   121,   122,   122,   122,   122,
     123,   123,   124,   124,   124,   114,     3,   111,   117,    15,
      17,   133,   130,    17,    19,    15,    21,    13,   155,     3,
      15,    17,    21,    52,    62,    63,   137,   139,   142,   147,
     148,   149,   150,   151,   152,   153,   154,   158,   159,    17,
     135,    17,    13,    17,     3,    17,    56,     3,    14,    14,
      17,    16,    17,    13,     3,   114,   117,    13,    19,    16,
     115,   127,   133,   136,   155,   146,    14,    14,    21,   159,
     155,    17,    13,   155,   114,    56,   146,   146,   155,   114,
      20,     3,    20,   117,    17,   126,    14,   155,    54,   140,
     141,    17,   114,    14,    14,    17,    60,   143,   144,    20,
      32,     3,    17,    53,   155,    54,   141,   155,    17,   146,
     146,    14,   114,    61,   144,   145,    91,    92,     3,    95,
      13,    16,   155,   155,    17,    17,    13,    13,    21,    21,
      87,    96,   102,   103,   104,   109,   110,    15,    34,     3,
       5,    89,   114,   155,   155,   155,   155,    36,    38,    64,
      21,   109,     3,    20,    15,    15,    17,    16,    16,    16,
      93,    94,     3,     3,   155,   101,   101,    17,    65,    66,
      67,    68,    69,    70,    97,    98,    99,   100,    21,   110,
      13,    13,    17,    17,   101,    15,    17,    21,    89,     5,
       3,   105,   106,   107,   108,   105,     3,    98,   101,    15,
      21,    21,    13,   155,     3,   108,   155,    14,     3,     3,
      16,    14,   101,    17,     3
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 6:
#line 94 "mango.y"
    {
				MANClassDefinition *classDefinition = (__bridge_transfer MANClassDefinition *)(yyvsp[(1) - (1)].class_definition);
				man_add_class_definition(classDefinition);
			}
    break;

  case 7:
#line 99 "mango.y"
    {
				MANStructDeclare *structDeclare = (__bridge_transfer MANStructDeclare *)(yyvsp[(1) - (1)].declare_struct);
				man_add_struct_declare(structDeclare);
			}
    break;

  case 8:
#line 104 "mango.y"
    {
				MANStatement *statement = (__bridge_transfer MANStatement *)(yyvsp[(1) - (1)].statement);
				man_add_statement(statement);
			}
    break;

  case 9:
#line 112 "mango.y"
    {
				(yyval.expression) = nil;
			}
    break;

  case 10:
#line 116 "mango.y"
    {
				(yyval.expression) = (yyvsp[(3) - (4)].expression);
			}
    break;

  case 11:
#line 126 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (13)].expression);
				NSString *structName = (__bridge_transfer NSString *)(yyvsp[(4) - (13)].identifier);
				NSString *typeEncodingKey = (__bridge_transfer NSString *)(yyvsp[(6) - (13)].identifier);
				NSString *typeEncodingValue = (__bridge_transfer NSString *)(yyvsp[(8) - (13)].expression);
				NSString *keysKey = (__bridge_transfer NSString *)(yyvsp[(10) - (13)].identifier);
				NSArray *keysValue = (__bridge_transfer NSArray *)(yyvsp[(12) - (13)].list);
				MANStructDeclare *structDeclare = man_create_struct_declare(annotaionIfConditionExpr, structName, typeEncodingKey, typeEncodingValue.UTF8String, keysKey, keysValue);
				(yyval.declare_struct) = (__bridge_retained void *)structDeclare;
				
			}
    break;

  case 12:
#line 141 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (13)].expression);
				NSString *structName = (__bridge_transfer NSString *)(yyvsp[(4) - (13)].identifier);
				NSString *keysKey = (__bridge_transfer NSString *)(yyvsp[(6) - (13)].identifier);
				NSArray *keysValue = (__bridge_transfer NSArray *)(yyvsp[(8) - (13)].list);
				NSString *typeEncodingKey = (__bridge_transfer NSString *)(yyvsp[(10) - (13)].identifier);
				NSString *typeEncodingValue = (__bridge_transfer NSString *)(yyvsp[(12) - (13)].expression);
				MANStructDeclare *structDeclare = man_create_struct_declare(annotaionIfConditionExpr, structName, typeEncodingKey, typeEncodingValue.UTF8String, keysKey, keysValue);
				(yyval.declare_struct) = (__bridge_retained void *)structDeclare;
				
			}
    break;

  case 13:
#line 155 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);
				[list addObject:identifier];
				(yyval.list) = (__bridge_retained void *)list;
				
			}
    break;

  case 14:
#line 163 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(3) - (3)].identifier);
				[list addObject:identifier];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 15:
#line 175 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (6)].expression);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(3) - (6)].identifier);
				NSString *superNmae = (__bridge_transfer NSString *)(yyvsp[(5) - (6)].identifier);
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,nil);
			}
    break;

  case 16:
#line 182 "mango.y"
    {
				MANClassDefinition *classDefinition = man_end_class_definition(nil);
				(yyval.class_definition) = (__bridge_retained void *)classDefinition;
			}
    break;

  case 17:
#line 187 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (6)].expression);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(3) - (6)].identifier);
				NSString *superNmae = (__bridge_transfer NSString *)(yyvsp[(5) - (6)].identifier);
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,nil);
			}
    break;

  case 18:
#line 194 "mango.y"
    {
				NSArray *members = (__bridge_transfer NSArray *)(yyvsp[(8) - (9)].list);
				MANClassDefinition *classDefinition = man_end_class_definition(members);
				(yyval.class_definition) = (__bridge_retained void *)classDefinition;
			}
    break;

  case 19:
#line 200 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (9)].expression);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(3) - (9)].identifier);
				NSString *superNmae = (__bridge_transfer NSString *)(yyvsp[(5) - (9)].identifier);
				NSArray *protocolNames = (__bridge_transfer NSArray *)(yyvsp[(7) - (9)].list);
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,protocolNames);
			}
    break;

  case 20:
#line 208 "mango.y"
    {
				MANClassDefinition *classDefinition = man_end_class_definition(nil);
				(yyval.class_definition) = (__bridge_retained void *)classDefinition;
			}
    break;

  case 21:
#line 213 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (9)].expression);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(3) - (9)].identifier);
				NSString *superNmae = (__bridge_transfer NSString *)(yyvsp[(5) - (9)].identifier);
				NSArray *protocolNames = (__bridge_transfer NSArray *)(yyvsp[(7) - (9)].list);
				man_start_class_definition(annotaionIfConditionExpr, name, superNmae,protocolNames);
			}
    break;

  case 22:
#line 221 "mango.y"
    {
				NSArray *members = (__bridge_transfer NSArray *)(yyvsp[(11) - (12)].list);
				MANClassDefinition *classDefinition = man_end_class_definition(members);
				(yyval.class_definition) = (__bridge_retained void *)classDefinition;
			}
    break;

  case 23:
#line 229 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);
				[list addObject:identifier];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 24:
#line 236 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(3) - (3)].identifier);
				[list addObject:identifier];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 25:
#line 246 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (8)].expression);
				MANPropertyModifier modifier = (yyvsp[(4) - (8)].property_modifier_list);
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(6) - (8)].type_specifier);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(7) - (8)].identifier);
				MANPropertyDefinition *propertyDefinition = man_create_property_definition(annotaionIfConditionExpr, modifier, typeSpecifier, name);
				(yyval.member_definition) = (__bridge_retained void *)propertyDefinition;
			}
    break;

  case 26:
#line 255 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (7)].expression);
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(5) - (7)].type_specifier);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(6) - (7)].identifier);
				MANPropertyDefinition *propertyDefinition = man_create_property_definition(annotaionIfConditionExpr, 0x00, typeSpecifier, name);
				(yyval.member_definition) = (__bridge_retained void *)propertyDefinition;
			}
    break;

  case 28:
#line 268 "mango.y"
    {
				(yyval.property_modifier_list) = (yyvsp[(1) - (3)].property_modifier_list) | (yyvsp[(3) - (3)].property_modifier_list);
			}
    break;

  case 31:
#line 279 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierMemWeak;
			}
    break;

  case 32:
#line 283 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierMemStrong;
			}
    break;

  case 33:
#line 287 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierMemCopy;
			}
    break;

  case 34:
#line 291 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierMemAssign;
			}
    break;

  case 35:
#line 297 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierNonatomic;
			}
    break;

  case 36:
#line 301 "mango.y"
    {
				(yyval.property_modifier_list) = MANPropertyModifierAtomic;
			}
    break;

  case 37:
#line 307 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_VOID);
			}
    break;

  case 38:
#line 311 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_BOOL);
			}
    break;

  case 39:
#line 315 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_INT);
			}
    break;

  case 40:
#line 319 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_U_INT);
			}
    break;

  case 41:
#line 323 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_DOUBLE);
			}
    break;

  case 42:
#line 327 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_C_STRING);
			}
    break;

  case 43:
#line 331 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_OBJECT);
			}
    break;

  case 44:
#line 335 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_CLASS);
			}
    break;

  case 45:
#line 339 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_SEL);
			}
    break;

  case 46:
#line 343 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_BLOCK);
			}
    break;

  case 47:
#line 347 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_POINTER);
			}
    break;

  case 48:
#line 351 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_OBJECT);
			}
    break;

  case 49:
#line 355 "mango.y"
    {
				(yyval.type_specifier) =  (__bridge_retained void *)man_create_struct_type_specifier((__bridge_transfer NSString *)(yyvsp[(2) - (2)].identifier));
			}
    break;

  case 50:
#line 359 "mango.y"
    {
				(yyval.type_specifier) = (__bridge_retained void *)man_create_type_specifier(MAN_TYPE_UNKNOWN);
			}
    break;

  case 53:
#line 370 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (7)].expression);
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(4) - (7)].type_specifier);
				NSArray *items = (__bridge_transfer NSArray *)(yyvsp[(6) - (7)].list);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(7) - (7)].block_statement);
				MANMethodDefinition *methodDefinition = man_create_method_definition(annotaionIfConditionExpr, NO, returnTypeSpecifier, items, block);
				(yyval.member_definition) = (__bridge_retained void *)methodDefinition;
			}
    break;

  case 54:
#line 381 "mango.y"
    {
				MANExpression *annotaionIfConditionExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (7)].expression);
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(4) - (7)].type_specifier);
				NSArray *items = (__bridge_transfer NSArray *)(yyvsp[(6) - (7)].list);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(7) - (7)].block_statement);
				MANMethodDefinition *methodDefinition = man_create_method_definition(annotaionIfConditionExpr, YES, returnTypeSpecifier, items, block);
				(yyval.member_definition) = (__bridge_retained void *)methodDefinition;
			}
    break;

  case 57:
#line 396 "mango.y"
    {
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);
				MANMethodNameItem *item = man_create_method_name_item(name, nil, nil);
				NSMutableArray *list = [NSMutableArray array];
				[list addObject:item];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 58:
#line 406 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANMethodNameItem *item = (__bridge_transfer MANMethodNameItem *)(yyvsp[(1) - (1)].method_name_item);
				[list addObject:item];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 59:
#line 413 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (2)].list);
				MANMethodNameItem *item = (__bridge_transfer MANMethodNameItem *)(yyvsp[(2) - (2)].method_name_item);
				[list addObject:item];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 60:
#line 422 "mango.y"
    {
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(1) - (6)].identifier);
				name = [NSString stringWithFormat:@"%@:",name];
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(4) - (6)].type_specifier);
				NSString *paramName = (__bridge_transfer NSString *)(yyvsp[(6) - (6)].identifier);
				MANMethodNameItem *item = man_create_method_name_item(name, typeSpecifier, paramName);
				(yyval.method_name_item) = (__bridge_retained void *)item;
			}
    break;

  case 63:
#line 437 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANMemberDefinition *memberDefinition = (__bridge_transfer MANMemberDefinition *)(yyvsp[(1) - (1)].member_definition);
				[list addObject:memberDefinition];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 64:
#line 444 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (2)].list);
				MANMemberDefinition *memberDefinition = (__bridge_transfer MANMemberDefinition *)(yyvsp[(2) - (2)].member_definition);
				[list addObject:memberDefinition];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 68:
#line 460 "mango.y"
    {
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(1) - (2)].identifier);
				NSString *selector = [NSString stringWithFormat:@"%@:",name];
				(yyval.identifier) = (__bridge_retained void *)selector;
			}
    break;

  case 69:
#line 466 "mango.y"
    {
				NSString *name1 = (__bridge_transfer NSString *)(yyvsp[(1) - (3)].identifier);
				NSString *name2 = (__bridge_transfer NSString *)(yyvsp[(2) - (3)].identifier);
				NSString *selector = [NSString stringWithFormat:@"%@%@:", name1, name2];
				(yyval.identifier) = (__bridge_retained void *)selector;
			}
    break;

  case 72:
#line 479 "mango.y"
    {
				MANAssignExpression *expr = (MANAssignExpression *)man_create_expression(MAN_ASSIGN_EXPRESSION);
				expr.assignKind = (yyvsp[(2) - (3)].assignment_operator);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 73:
#line 489 "mango.y"
    {
					(yyval.assignment_operator) = MAN_NORMAL_ASSIGN;
					
				}
    break;

  case 74:
#line 494 "mango.y"
    {
					(yyval.assignment_operator) = MAN_SUB_ASSIGN;
				}
    break;

  case 75:
#line 498 "mango.y"
    {
					(yyval.assignment_operator) = MAN_ADD_ASSIGN;
				}
    break;

  case 76:
#line 502 "mango.y"
    {
					(yyval.assignment_operator) = MAN_MUL_ASSIGN;
				}
    break;

  case 77:
#line 506 "mango.y"
    {
					(yyval.assignment_operator) = MAN_DIV_ASSIGN;
				}
    break;

  case 78:
#line 510 "mango.y"
    {
					(yyval.assignment_operator) = MAN_MOD_ASSIGN;
				}
    break;

  case 80:
#line 517 "mango.y"
    {
				MANTernaryExpression *expr = (MANTernaryExpression *)man_create_expression(MAN_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MANExpression *)(yyvsp[(1) - (5)].expression);
				expr.trueExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (5)].expression);
				expr.falseExpr = (__bridge_transfer MANExpression *)(yyvsp[(5) - (5)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 81:
#line 525 "mango.y"
    {
				MANTernaryExpression *expr = (MANTernaryExpression *)man_create_expression(MAN_TERNARY_EXPRESSION);
				expr.condition = (__bridge_transfer MANExpression *)(yyvsp[(1) - (4)].expression);
				expr.falseExpr = (__bridge_transfer MANExpression *)(yyvsp[(4) - (4)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 83:
#line 535 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LOGICAL_OR_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 85:
#line 545 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LOGICAL_AND_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 87:
#line 555 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_EQ_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 88:
#line 562 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_NE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 90:
#line 572 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LT_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 91:
#line 579 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_LE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 92:
#line 586 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_GT_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 93:
#line 593 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_GE_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 95:
#line 603 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_ADD_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 96:
#line 610 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_SUB_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 98:
#line 620 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_MUL_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 99:
#line 627 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_DIV_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 100:
#line 634 "mango.y"
    {
				MANBinaryExpression *expr = (MANBinaryExpression *)man_create_expression(MAN_MOD_EXPRESSION);
				expr.left = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.right = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 102:
#line 644 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_LOGICAL_NOT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 103:
#line 651 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(NSC_NEGATIVE_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 105:
#line 661 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_INCREMENT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 106:
#line 668 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_DECREMENT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 107:
#line 677 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (1)].expression);
				[list addObject:expr];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 108:
#line 684 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				[list addObject:expr];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 109:
#line 693 "mango.y"
    {
				MANExpression *keyExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				MANExpression *valueExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				MANDicEntry *dicEntry = man_create_dic_entry(keyExpr, valueExpr);
				(yyval.dic_entry) = (__bridge_retained void *)dicEntry;
			}
    break;

  case 110:
#line 702 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANDicEntry *dicEntry = (__bridge_transfer MANDicEntry *)(yyvsp[(1) - (1)].dic_entry);
				[list addObject:dicEntry];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 111:
#line 709 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				MANDicEntry *dicEntry = (__bridge_transfer MANDicEntry *)(yyvsp[(3) - (3)].dic_entry);
				[list addObject:dicEntry];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 112:
#line 718 "mango.y"
    {
				MANDictionaryExpression *expr = (MANDictionaryExpression *)man_create_expression(MAN_DIC_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)(yyvsp[(3) - (4)].list);
				expr.entriesExpr = entriesExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 113:
#line 725 "mango.y"
    {
				MANDictionaryExpression *expr = (MANDictionaryExpression *)man_create_expression(MAN_DIC_LITERAL_EXPRESSION);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 114:
#line 733 "mango.y"
    {
				NSString *key = (__bridge_transfer NSString *)(yyvsp[(1) - (3)].identifier);
				MANExpression *valueExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (3)].expression);
				MANStructEntry *structEntry = man_create_struct_entry(key, valueExpr);
				(yyval.struct_entry) = (__bridge_retained void *)structEntry;
			}
    break;

  case 115:
#line 742 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANStructEntry *structEntry = (__bridge_transfer MANStructEntry *)(yyvsp[(1) - (1)].struct_entry);
				[list addObject:structEntry];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 116:
#line 749 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				MANStructEntry *structEntry = (__bridge_transfer MANStructEntry *)(yyvsp[(3) - (3)].struct_entry);
				[list addObject:structEntry];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 117:
#line 758 "mango.y"
    {
				MANStructpression *expr = (MANStructpression *)man_create_expression(MAN_STRUCT_LITERAL_EXPRESSION);
				NSArray *entriesExpr = (__bridge_transfer NSArray *)(yyvsp[(2) - (3)].list);
				expr.entriesExpr = entriesExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 118:
#line 767 "mango.y"
    {
				MANIdentifierExpression *expr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (1)].identifier);;
				expr.identifier = identifier;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 119:
#line 774 "mango.y"
    {
				MANMemberExpression *expr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				expr.expr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (3)].expression);
				expr.memberName = (__bridge_transfer NSString *)(yyvsp[(3) - (3)].identifier);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 120:
#line 781 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (5)].expression);
				NSString *selector = (__bridge_transfer NSString *)(yyvsp[(3) - (5)].identifier);
				MANMemberExpression *memberExpr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				
				(yyval.expression) = (__bridge_retained void *)funcCallExpr;
			}
    break;

  case 121:
#line 794 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (6)].expression);
				NSString *selector = (__bridge_transfer NSString *)(yyvsp[(3) - (6)].identifier);
				MANMemberExpression *memberExpr = (MANMemberExpression *)man_create_expression(MAN_MEMBER_EXPRESSION);
				memberExpr.expr = expr;
				memberExpr.memberName = selector;
				
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = memberExpr;
				funcCallExpr.args = (__bridge_transfer NSArray<MANExpression *> *)(yyvsp[(5) - (6)].list);
				
				(yyval.expression) = (__bridge_retained void *)funcCallExpr;
			}
    break;

  case 122:
#line 808 "mango.y"
    {
				MANIdentifierExpression *identifierExpr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (3)].identifier);
				identifierExpr.identifier = identifier;
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = identifierExpr;
				(yyval.expression) = (__bridge_retained void *)funcCallExpr;
			}
    break;

  case 123:
#line 817 "mango.y"
    {
				MANIdentifierExpression *identifierExpr = (MANIdentifierExpression *)man_create_expression(MAN_IDENTIFIER_EXPRESSION);
				NSString *identifier = (__bridge_transfer NSString *)(yyvsp[(1) - (4)].identifier);
				identifierExpr.identifier = identifier;
				MANFunctonCallExpression *funcCallExpr = (MANFunctonCallExpression *)man_create_expression(MAN_FUNCTION_CALL_EXPRESSION);
				funcCallExpr.expr = identifierExpr;
				funcCallExpr.args = (__bridge_transfer NSArray<MANExpression *> *)(yyvsp[(3) - (4)].list);
				(yyval.expression) = (__bridge_retained void *)funcCallExpr;
			}
    break;

  case 124:
#line 827 "mango.y"
    {
				(yyval.expression) = (yyvsp[(2) - (3)].expression);
			}
    break;

  case 125:
#line 831 "mango.y"
    {
				MANExpression *arrExpr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (4)].expression);
				MANExpression *indexExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (4)].expression);
				
				MANSubScriptExpression *expr = (MANSubScriptExpression *)man_create_expression(MAN_SUB_SCRIPT_EXPRESSION);
				expr.aboveExpr = arrExpr;
				expr.bottomExpr = indexExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
				
			}
    break;

  case 133:
#line 849 "mango.y"
    {
				MANExpression *expr = man_create_expression(MAN_SELECTOR_EXPRESSION);
				expr.selectorName = (__bridge_transfer NSString *)(yyvsp[(3) - (4)].identifier);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 134:
#line 855 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 135:
#line 862 "mango.y"
    {
				
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 136:
#line 870 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 137:
#line 877 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 138:
#line 884 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (2)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 139:
#line 891 "mango.y"
    {
				MANExpression *expr = man_create_expression(MAN_SELF_EXPRESSION);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 140:
#line 896 "mango.y"
    {
				MANExpression *expr = man_create_expression(MAN_SUPER_EXPRESSION);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 141:
#line 901 "mango.y"
    {
				MANUnaryExpression *expr = (MANUnaryExpression *)man_create_expression(MAN_AT_EXPRESSION);
				MANExpression *subExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (4)].expression);
				expr.expr = subExpr;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 142:
#line 908 "mango.y"
    {
				MANArrayExpression *expr = (MANArrayExpression *)man_create_expression(MAN_ARRAY_LITERAL_EXPRESSION);
				NSArray *itemExpressions = (__bridge_transfer NSArray *)(yyvsp[(3) - (4)].list);
				expr.itemExpressions = itemExpressions;
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 143:
#line 915 "mango.y"
    {
				MANArrayExpression *expr = (MANArrayExpression *)man_create_expression(MAN_ARRAY_LITERAL_EXPRESSION);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 147:
#line 928 "mango.y"
    {
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(2) - (5)].type_specifier);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (5)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,nil,block);
				(yyval.expression) = (__bridge_retained void *)expr;
				
			}
    break;

  case 148:
#line 937 "mango.y"
    {
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(2) - (3)].type_specifier);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(3) - (3)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,nil,block);
				(yyval.expression) = (__bridge_retained void *)expr;
				
			}
    break;

  case 149:
#line 946 "mango.y"
    {
				MANTypeSpecifier *returnTypeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(2) - (6)].type_specifier);
				NSArray<MANParameter *> *parameter = (__bridge_transfer NSArray<MANParameter *> *)(yyvsp[(4) - (6)].list);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(6) - (6)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,returnTypeSpecifier,parameter,block);
				(yyval.expression) = (__bridge_retained void *)expr;
				
			}
    break;

  case 150:
#line 956 "mango.y"
    {
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(4) - (4)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,nil,block);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 151:
#line 963 "mango.y"
    {
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(2) - (2)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,nil,block);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 152:
#line 970 "mango.y"
    {
				NSArray<MANParameter *> *parameter = (__bridge_transfer NSArray<MANParameter *> *)(yyvsp[(3) - (5)].list);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (5)].block_statement);
				MANBlockExpression *expr = (MANBlockExpression *)man_create_expression(MAN_BLOCK_EXPRESSION);
				man_build_block_expr(expr,nil,parameter,block);
				(yyval.expression) = (__bridge_retained void *)expr;
			}
    break;

  case 153:
#line 981 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANParameter *parameter = (__bridge_transfer MANParameter *)(yyvsp[(1) - (1)].function_param);
				[list addObject:parameter];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 154:
#line 988 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (3)].list);
				MANParameter *parameter = (__bridge_transfer MANParameter *)(yyvsp[(3) - (3)].function_param);
				[list addObject:parameter];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 155:
#line 997 "mango.y"
    {
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(1) - (2)].type_specifier);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(2) - (2)].identifier);
				MANParameter *parameter = man_create_parameter(type, name);
				(yyval.function_param) = (__bridge_retained void *)parameter;
			}
    break;

  case 156:
#line 1006 "mango.y"
    {
				MANDeclaration *declaration = (__bridge_transfer MANDeclaration *)(yyvsp[(1) - (2)].declaration);
				MANDeclarationStatement *statement = man_create_declaration_statement(declaration);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 157:
#line 1014 "mango.y"
    {
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(1) - (2)].type_specifier);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(2) - (2)].identifier);
				MANDeclaration *declaration = man_create_declaration(type, name, nil);
				(yyval.declaration) = (__bridge_retained void *)declaration;
			}
    break;

  case 158:
#line 1021 "mango.y"
    {
				MANTypeSpecifier *type = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(1) - (4)].type_specifier);
				NSString *name = (__bridge_transfer NSString *)(yyvsp[(2) - (4)].identifier);
				MANExpression *initializer = (__bridge_transfer MANExpression *)(yyvsp[(4) - (4)].expression);
				MANDeclaration *declaration = man_create_declaration(type, name, initializer);
				(yyval.declaration) = (__bridge_retained void *)declaration;
			}
    break;

  case 159:
#line 1033 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(3) - (5)].expression);
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (5)].block_statement);
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, nil, nil);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 160:
#line 1040 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(3) - (7)].expression);
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (7)].block_statement);
				MANBlockBody  *elseBlocl = (__bridge_transfer MANBlockBody  *)(yyvsp[(7) - (7)].block_statement);
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, nil, elseBlocl);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 161:
#line 1048 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(3) - (6)].expression);
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (6)].block_statement);
				NSArray<MANElseIf *> *elseIfList = (__bridge_transfer NSArray<MANElseIf *> *)(yyvsp[(6) - (6)].list);
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, elseIfList, nil);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 162:
#line 1056 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(3) - (8)].expression);
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (8)].block_statement);
				NSArray<MANElseIf *> *elseIfList = (__bridge_transfer NSArray<MANElseIf *> *)(yyvsp[(6) - (8)].list);
				MANBlockBody  *elseBlocl = (__bridge_transfer MANBlockBody  *)(yyvsp[(8) - (8)].block_statement);
				MANIfStatement *statement = man_create_if_statement(condition, thenBlock, elseIfList, elseBlocl);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 163:
#line 1067 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANElseIf *elseIf = (__bridge_transfer MANElseIf *)(yyvsp[(1) - (1)].else_if);
				[list addObject:elseIf];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 164:
#line 1074 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (2)].list);
				MANElseIf *elseIf = (__bridge_transfer MANElseIf *)(yyvsp[(2) - (2)].else_if);
				[list addObject:elseIf];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 165:
#line 1083 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(4) - (6)].expression);
				MANBlockBody  *thenBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(6) - (6)].block_statement);
				MANElseIf *elseIf = man_create_else_if(condition, thenBlock);
				(yyval.else_if) = (__bridge_retained void *)elseIf;
			}
    break;

  case 166:
#line 1092 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (8)].expression);
				NSArray<MANCase *> *caseList = (__bridge_transfer NSArray *)(yyvsp[(6) - (8)].list);
				MANBlockBody  *defaultBlock = (__bridge_transfer MANBlockBody  *)(yyvsp[(7) - (8)].block_statement);
				MANSwitchStatement *statement = man_create_switch_statement(expr,caseList, defaultBlock);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 167:
#line 1102 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANCase *case_ = (__bridge_transfer MANCase *)(yyvsp[(1) - (1)].one_case);
				[list addObject:case_];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 168:
#line 1109 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (2)].list);
				MANCase *case_ = (__bridge_transfer MANCase *)(yyvsp[(2) - (2)].one_case);
				[list addObject:case_];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 169:
#line 1118 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (4)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(4) - (4)].block_statement);
				MANCase *case_ = man_create_case(expr, block);
				(yyval.one_case) = (__bridge_retained void *)case_;
			}
    break;

  case 170:
#line 1127 "mango.y"
    {
				(yyval.block_statement) = nil;
			}
    break;

  case 171:
#line 1131 "mango.y"
    {
				(yyval.block_statement) = (yyvsp[(3) - (3)].block_statement);
			}
    break;

  case 172:
#line 1137 "mango.y"
    {
				(yyval.expression) = nil;
			}
    break;

  case 174:
#line 1146 "mango.y"
    {
				MANExpression *initializerExpr = (__bridge_transfer MANExpression *)(yyvsp[(3) - (9)].expression);
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(5) - (9)].expression);
				MANExpression *post = (__bridge_transfer MANExpression *)(yyvsp[(7) - (9)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(9) - (9)].block_statement);
				MANForStatement *statement = man_create_for_statement(initializerExpr, nil,
				condition, post, block);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 175:
#line 1157 "mango.y"
    {
				MANDeclaration *declaration = (__bridge_transfer MANDeclaration *)(yyvsp[(3) - (9)].declaration);
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(5) - (9)].expression);
				MANExpression *post = (__bridge_transfer MANExpression *)(yyvsp[(7) - (9)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(9) - (9)].block_statement);
				MANForStatement *statement = man_create_for_statement(nil, declaration,
				condition, post, block);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 176:
#line 1169 "mango.y"
    {
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(3) - (5)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(5) - (5)].block_statement);
				MANWhileStatement *statement = man_create_while_statement( condition, block);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 177:
#line 1178 "mango.y"
    {
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(2) - (7)].block_statement);
				MANExpression *condition = (__bridge_transfer MANExpression *)(yyvsp[(5) - (7)].expression);
				MANDoWhileStatement *statement = man_create_do_while_statement(block, condition);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 178:
#line 1187 "mango.y"
    {
				MANTypeSpecifier *typeSpecifier = (__bridge_transfer MANTypeSpecifier *)(yyvsp[(3) - (8)].type_specifier);
				NSString *varName = (__bridge_transfer NSString *)(yyvsp[(4) - (8)].identifier);
				MANExpression *arrayExpr = (__bridge_transfer MANExpression *)(yyvsp[(6) - (8)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(8) - (8)].block_statement);
				MANForEachStatement *statement = man_create_for_each_statement(typeSpecifier, varName, arrayExpr, block);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 179:
#line 1196 "mango.y"
    {
				NSString *varName = (__bridge_transfer NSString *)(yyvsp[(3) - (7)].identifier);
				MANExpression *arrayExpr = (__bridge_transfer MANExpression *)(yyvsp[(5) - (7)].expression);
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(7) - (7)].block_statement);
				MANForEachStatement *statement = man_create_for_each_statement(nil, varName, arrayExpr, block);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 180:
#line 1207 "mango.y"
    {
				MANContinueStatement *statement = man_create_continue_statement();
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 181:
#line 1215 "mango.y"
    {
				MANBreakStatement *statement = man_create_break_statement();
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 182:
#line 1223 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(2) - (3)].expression);
				MANReturnStatement *statement = man_create_return_statement(expr);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 183:
#line 1231 "mango.y"
    {
				MANExpression *expr = (__bridge_transfer MANExpression *)(yyvsp[(1) - (2)].expression);
				MANExpressionStatement *statement  = man_create_expression_statement(expr);
				(yyval.statement) = (__bridge_retained void *)statement;
			}
    break;

  case 184:
#line 1240 "mango.y"
    {
				MANBlockBody  *block = man_open_block_statement();
				(yyval.block_statement) = (__bridge_retained void *)block;
			}
    break;

  case 185:
#line 1245 "mango.y"
    {
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(2) - (3)].block_statement);
				block = man_close_block_statement(block,nil);
				(yyval.block_statement) = (__bridge_retained void *)block;
			}
    break;

  case 186:
#line 1251 "mango.y"
    {
				MANBlockBody  *block = man_open_block_statement();
				(yyval.block_statement) = (__bridge_retained void *)block;
			}
    break;

  case 187:
#line 1256 "mango.y"
    {
				MANBlockBody  *block = (__bridge_transfer MANBlockBody  *)(yyvsp[(2) - (4)].block_statement);
				NSArray *list = (__bridge_transfer NSArray *)(yyvsp[(3) - (4)].list);
				block = man_close_block_statement(block,list);
				(yyval.block_statement) = (__bridge_retained void *)block;
			}
    break;

  case 188:
#line 1266 "mango.y"
    {
				NSMutableArray *list = [NSMutableArray array];
				MANStatement *statement = (__bridge_transfer MANStatement *)(yyvsp[(1) - (1)].statement);
				[list addObject:statement];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;

  case 189:
#line 1273 "mango.y"
    {
				NSMutableArray *list = (__bridge_transfer NSMutableArray *)(yyvsp[(1) - (2)].list);
				MANStatement *statement = (__bridge_transfer MANStatement *)(yyvsp[(2) - (2)].statement);
				[list addObject:statement];
				(yyval.list) = (__bridge_retained void *)list;
			}
    break;


/* Line 1267 of yacc.c.  */
#line 3447 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 1305 "mango.y"


