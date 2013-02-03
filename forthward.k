// kompile forthward.k && krun test.forthward

module FORTHWARD-SYNTAX
  syntax Exp ::= Fn
               | Val
               | Id
               | Exp Exp [seqstrict,left]
  syntax Val ::= Atom | Quote
  syntax Atom ::= #Int
  syntax Fn ::= "*" | "+" | "-" | "/" | "random" | "bind" | "apply"
  syntax Quote ::= "(" Exp ")" [onlyLabel, klabel(quote)]
endmodule

module FORTHWARD
  imports FORTHWARD-SYNTAX
  syntax KResult ::= Val
  syntax Quote ::= "quote" "(" Exp ")" [klabel(quote)]

  configuration <T>
    <k> $PGM:Exp </k>
    <stack> .List </stack>
    <state> .Map </state>
  </T>

  rule <k> (E1 E2) => E1 ~> E2 ... </k> [structural]
  rule <k> V:Val => . ... </k>
       <stack> (.List => ListItem(V)) ... </stack>
  rule <k> random => 0 ... </k> [transition]
  rule <k> random => 1 ... </k> [transition]
  rule <k> / => V1 /Int V2 ... </k>
       <stack> (ListItem(V1) ListItem(V2)) => . ... </stack> [transition]
  rule <k> * => V1 *Int V2 ... </k>
       <stack> (ListItem(V1) ListItem(V2)) => . ... </stack> [transition]
  rule <k> + => V1 +Int V2 ... </k>
       <stack> (ListItem(V1) ListItem(V2)) => . ... </stack> [transition]
  rule <k> - => V1 -Int V2 ... </k>
       <stack> (ListItem(V1) ListItem(V2)) => . ... </stack> [transition]
  rule <k> apply => E ... </k>
       <stack> ListItem(quote(E:Exp)) => . ... </stack> 
  rule <k> I:Id => E ... </k>
       <state> ... I |-> quote(E:Exp) ... </state>
  rule <k> I:Id ~> bind ... </k>
       <stack> ListItem(A:Atom => quote(A)) ... </stack>
  rule <k> (I:Id ~> bind) => . ... </k>
       <stack> (ListItem(QuotedForm:Quote)) => . ... </stack>
       <state> ... . => I |-> QuotedForm ... </state>
endmodule

/* test.forthward:

1 2 3 4 + - / (2 *) f bind f

→ 10 */
