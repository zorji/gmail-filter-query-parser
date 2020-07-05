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

export const HasAttachment = (): QueryLeafNode => {
  return { value: 'has:attachment' }
}

export const From = (str: string): QueryLeafNode => {
  return { value: `from:(${str})` }
}

export const Subject = (str: string): QueryLeafNode => {
  return { value: `subject:(${str})` }
}

export const And = (...nodes: QueryNode[]): QueryAndNode => {
  return {
    $and: nodes,
  }
}

export const Or = (...nodes: QueryNode[]): QueryOrNode => {
  return {
    $or: nodes,
  }
}

export type QueryNode = QueryLeafNode | QueryAndNode | QueryOrNode

const isAndNode = (node: QueryNode): node is QueryAndNode => '$and' in node
const isOrNode = (node: QueryNode): node is QueryOrNode => '$or' in node
const isLeafNode = (node: QueryNode): node is QueryLeafNode => !isAndNode(node) && !isOrNode(node)

export const parse = (query: string): QueryNode => {
  const parser = new Parser(
    Grammar.fromCompiled(grammar),
    { keepHistory: true },
  )
  parser.feed(query)
  const results = parser.finish()
  return results[0] as QueryNode
}

export const serialise = (node: QueryNode): string => {
  if (isLeafNode(node)) {
    return node.value
  } else if (isOrNode(node)) {
    if (node.$or.length < 2) {
      return serialise(node.$or[0])
    }
    return '(' + node.$or.map(serialise).join(' OR ') + ')'
  } else {
    if (node.$and.length < 2) {
      return serialise(node.$and[0])
    }
    return '(' + node.$and.map(serialise).join(' AND ') + ')'
  }
}
