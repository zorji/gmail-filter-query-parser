@builtin "whitespace.ne"

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne
# Operator precedence learnt from http://tobyho.com/video/How-to-Build-a-Parser-with-Nearley.js-Part-5-Operator-Precedence.html

expression -> OrExpr {% id %}

OR -> "OR"#i
AND -> "AND"#i

OrExpr ->
  AndExpr __ OR __ OrExpr {% d => ({ $or: [d[0], d[4]] }) %}
  | AndExpr {% id %}

AndExpr ->
  Clause __ AND __ AndExpr {% d => ({ $and: [d[0], d[4]] }) %}
  | ParenthesesExpr {% id %}

ParenthesesExpr ->
  "(" _ AndExpr __ OR __ OrExpr _ ")" {% d => ({ $or: [d[2], d[6]] }) %}
  | "(" _ AndExpr __ AND __ OrExpr _ ")" {% d => ({ $and: [d[2], d[6]] }) %}
  | Clause {% id %}

Clause ->
  "has:attachment" {% d => ({ value: d[0] }) %}
  | "from:(" _ Str _ ")" {% d => ({ value: d.join('') }) %}
  | "subject:(" _ Str _ ")" {% d => ({ value: d.join('') }) %}

Str -> [_a-zA-Z0-9-:\(\)@.]:* {% d => d[0].join('') %}
