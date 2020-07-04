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
  if (expr.$and) {
    return expr.$and.map(unwrapIfAnd).flat()
  }
  return [ expr ]
}
