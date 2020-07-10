import { Grammar, Parser } from 'nearley'

const grammar = require('./grammar')

export interface QueryLeafNode {
  value: string
}

export interface QueryAndNode {
  $and: QueryNode[]
}

export interface QueryOrNode {
  $or: QueryNode[]
}

export interface QueryNotNode {
  $not: QueryNode
}

export function HasAttachment(): QueryLeafNode {
  return { value: 'has:attachment' }
}

export function From(str: string): QueryLeafNode {
  return { value: `from:(${str})` }
}

export function Subject(str: string): QueryLeafNode {
  return { value: `subject:(${str})` }
}

export function Label(str: string): QueryLeafNode {
  return { value: `label:(${str})` }
}

export function AND(...nodes: QueryNode[]): QueryAndNode {
  return {
    $and: nodes,
  }
}


export function NOT(query: QueryNode): QueryNotNode {
  return ({ $not: query })
}

export function OR(...nodes: QueryNode[]): QueryOrNode {
  return {
    $or: nodes,
  }
}

export type QueryNode = QueryLeafNode | QueryAndNode | QueryOrNode | QueryNotNode

export function isAndNode(node: QueryNode): node is QueryAndNode {
  return '$and' in node
}

export function isOrNode(node: QueryNode): node is QueryOrNode {
  return '$or' in node
}

export function isNotNode(node: QueryNode): node is QueryNotNode {
  return '$not' in node
}

export function isLeafNode(node: QueryNode): node is QueryLeafNode {
  return !isAndNode(node) && !isOrNode(node)
}

export function parse(query: string): QueryNode {
  const parser = new Parser(
    Grammar.fromCompiled(grammar),
    { keepHistory: true },
  )
  parser.feed(query)
  const results = parser.finish()
  return results[0] as QueryNode
}

export function serialise(node: QueryNode): string {
  if (isLeafNode(node)) {
    return node.value
  } else if (isOrNode(node)) {
    if (node.$or.length < 2) {
      return serialise(node.$or[0])
    }
    return '(' + node.$or.map(serialise).join(' OR ') + ')'
  } else if (isAndNode(node)) {
    if (node.$and.length < 2) {
      return serialise(node.$and[0])
    }
    return '(' + node.$and.map(serialise).join(' AND ') + ')'
  } else {
    return 'NOT ' + serialise(node.$not)
  }
}
