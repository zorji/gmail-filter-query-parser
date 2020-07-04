@builtin "whitespace.ne"

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne
# Operator precedence learnt from http://tobyho.com/video/How-to-Build-a-Parser-with-Nearley.js-Part-5-Operator-Precedence.html

expression -> OrExpr {% id %}

OR -> "OR"#i
AND -> "AND"#i

OPERATOR -> OR | AND

OrExpr ->
  AndExpr __ OR __ OrExpr {% d => `(${d[0]} OR ${d[4]})` %}
  | AndExpr

AndExpr ->
  Clause __ AND __ AndExpr {% d => `(${d[0]} AND ${d[4]})` %}
  | ParenthesesExpr

ParenthesesExpr ->
  "(" _ AndExpr __ OPERATOR __ OrExpr _ ")" {% d => `(${d[2]} ${d[4]} ${d[6]})` %}
  | Clause

Clause ->
  "has:attachment" {% id %}
  | "from:(" _ Str _ ")" {% d => d.join('') %}
  | "subject:(" _ Str _ ")" {% d => d.join('') %}

Str -> [_a-zA-Z0-9-:\(\)@.]:* {% d => d[0].join('') %}
