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
