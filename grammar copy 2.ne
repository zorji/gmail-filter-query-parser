@builtin "whitespace.ne"

@{%
const orExpr = d => {
  // return {
  //   '+': [d[0], d[2]]
  // }
  return `(${d[0]}+${d[2]})`
}

const andExpr = d => {
  // return {
  //   '*': [d[0], d[2]]
  // }
  return `(${d[0]}*${d[2]})`
}
%}

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne

expression -> OrExpr {% id %}

# where ->
#   expr {% id %}
#   # | "(" _ expr _ ")" {% d => d[2] %}

OR -> "+"#i
AND -> "*"#i
# expr -> two_op_expr {% d => d[0] %}

OrExpr ->
  AndExpr _ OR _ OrExpr {% d => `(${d[0]}+${d[4]})` %}
  | AndExpr

AndExpr ->
  Clause _ AND _ AndExpr {% d => `(${d[0]}*${d[4]})` %}
  | Clause

# two_op_expr ->
#   pre_one_op_expr OR post_two_op_expr {% orExpr %}
#   | pre_one_op_expr AND post_two_op_expr {% andExpr %}
#   | one_op_expr {% d => d[0] %}

# pre_one_op_expr ->
#   # two_op_expr __ {% d => d[0] %}
#   one_op_expr {% id %}
#   # | "(" _ two_op_expr _ ")" _ {% d => d[2] %}

# post_two_op_expr ->
#   # __ two_op_expr {% d => d[1] %}
#   two_op_expr {% d => d[0] %}
#   # | _ "(" _ two_op_expr _ ")" {% d => d[3] %}

# one_op_expr -> [_a-zA-Z0-9-:\(\)@.]:* {% d => d[0].join('') %}
Clause -> "a" | "b" | "c" {% id %}
