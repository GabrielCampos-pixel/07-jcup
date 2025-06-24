import java_cup.runtime.*;

%%
%class QueryLexer
%cup
%unicode
%line
%column

%{
  private Symbol symbol(int type){
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value){
    return new Symbol(type, yyline, yycolumn, value);
  }

%}

letra = [a-zA-Z]
digito = [0-9]
id = {letra}({letra}|{digito})*
numero = {digito}+
espacobranco = [ \r\n\t]+ // Adicionado o '+' para consumir múltiplos espaços

%%
"FROM" {return symbol(sym.FROM);}
"SELECT" {return symbol(sym.SELECT);}
"WHERE" {return symbol(sym.WHERE);}
"AND" {return symbol(sym.AND);}
"," {return symbol(sym.VIRGULA);}
"=" {return symbol(sym.ATRIBUICAO);}
">" {return symbol(sym.MAIORQUE);}
"<" {return symbol(sym.MENORQUE);}
">=" {return symbol(sym.MAIORIGUAL);}
"<=" {return symbol(sym.MENORIGUAL);}
"!=" {return symbol(sym.NAOIGUAL);}
"*" {return symbol(sym.TODOS);} // Note: o CUP usa 'ALL' no não-terminal 'fields', mas o lexer produz 'TODOS'. É bom que sejam consistentes ou você trate isso na gramática.
{id} {return symbol(sym.ID, yytext());}
{numero} {return symbol(sym.NUMERO, Integer.valueOf(yytext()));}
\'([^\\']|\\.)*\' {return symbol(sym.STRING,
                            yytext().substring(1,
                                    yytext().length() - 1));}
{espacobranco} { /* IGNORE */ }

<<EOF>> { return symbol(sym.EOF);}

// Regra de erro para caracteres não reconhecidos
. { System.err.println("Erro léxico: Caractere inválido '" + yytext() + "' na linha " + (yyline+1) + ", coluna " + (yycolumn+1)); }