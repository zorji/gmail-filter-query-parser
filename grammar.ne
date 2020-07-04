@builtin "whitespace.ne"

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne
# Operator precedence learnt from http://tobyho.com/video/How-to-Build-a-Parser-with-Nearley.js-Part-5-Operator-Precedence.html

expression -> OrExpr {% id %}

OR -> "+"#i
AND -> "*"#i

ParenthesesExpr ->
  "(" _ OrExpr _ ")"

OrExpr ->
  AndExpr _ OR _ OrExpr {% d => `(${d[0]}+${d[4]})` %}
  | AndExpr

AndExpr ->
  Clause _ AND _ AndExpr {% d => `(${d[0]}*${d[4]})` %}
  | Clause

Clause -> "a" | "b" | "c" {% id %}
