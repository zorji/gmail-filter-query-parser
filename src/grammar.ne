@builtin "whitespace.ne"

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne
# Operator precedence learnt from http://tobyho.com/video/How-to-Build-a-Parser-with-Nearley.js-Part-5-Operator-Precedence.html

@{%
const orExpr = (left, right) => {
  return {
    $or: [
      ...unwrapIfOr(left),
      ...unwrapIfOr(right),
    ]
  }
}

const andExpr = (left, right) => {
  return {
    $and: [
      ...unwrapIfAnd(left),
      ...unwrapIfAnd(right),
    ]
  }
}

// unwraps (A AND (B AND C)) to (A AND B AND C)
const unwrapIfAnd = (expr) => {
  if (expr.$and) {
    return expr.$and.map(unwrapIfAnd).flat()
  }
  return [ expr ]
}

// unwraps (A OR (B OR C)) to (A OR B OR C)
const unwrapIfOr = (expr) => {
  if (expr.$or) {
    return expr.$or.map(unwrapIfOr).flat()
  }
  return [ expr ]
}
%}

expression -> OrExpr {% id %}

OR -> "OR"#i
AND -> "AND"#i

OrExpr ->
  AndExpr __ OR __ OrExpr {% d => orExpr(d[0], d[4]) %}
  | AndExpr {% id %}

AndExpr ->
  Clause __ AND __ AndExpr {% d => andExpr(d[0], d[4]) %}
  | ParenthesesExpr {% id %}

ParenthesesExpr ->
  "(" _ AndExpr __ OR __ OrExpr _ ")" {% d => orExpr(d[2], d[6]) %}
  | "(" _ AndExpr __ AND __ OrExpr _ ")" {% d => andExpr(d[2], d[6]) %}
  | Clause {% id %}

Clause ->
  "has:attachment" {% d => ({ value: d[0] }) %}
  | "from:(" _ Str _ ")" {% d => ({ value: d.join('') }) %}
  | "subject:(" _ Str _ ")" {% d => ({ value: d.join('') }) %}

Str -> [_a-zA-Z0-9-:\(\)@.]:* {% d => d[0].join('') %}
