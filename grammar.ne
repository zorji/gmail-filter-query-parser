@builtin "whitespace.ne"

@{%
const orExpr = d => {
  return {
    $or: [d[0], d[2]]
  }
}

const andExpr = d => {
  return {
    $and: [
      ...unwrapIfAnd(d[0]),
      ...unwrapIfAnd(d[2]),
    ]
  }
}

const unwrapIfAnd = (expr) => {
  console.log(expr)
  if (expr.$and) {
    return [
      ...unwrapIfAnd(expr.$and[0]),
      ...unwrapIfAnd(expr.$and[1]),
    ]
  }
  return [ expr ]
}
%}

# Inspired by https://github.com/justinkenel/js-sql-parse/blob/master/sql.ne

expression ->
  expr {% d => ({$and: [d[0]]}) %}
  | "(" _ expr _ ")" {% d => ({$and: [d[2]]}) %}

OR -> "or"i
AND -> "and"i
expr -> two_op_expr {% d => d[0] %}

two_op_expr ->
    pre_two_op_expr OR post_one_op_expr {% orExpr %}
  | pre_two_op_expr AND post_one_op_expr {% andExpr %}
  | one_op_expr {% d => d[0] %}

pre_two_op_expr ->
  two_op_expr __ {% d => d[0] %}
  | "(" _ two_op_expr _ ")" {% d => d[2] %}

one_op_expr -> [_a-zA-Z0-9-:\(\)@.]:* {% d => d[0].join('') %}

post_one_op_expr ->
  __ one_op_expr {% d => d[1] %}
  | "(" _ one_op_expr _ ")" {% d => d[2] %}
