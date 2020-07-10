import { AND, From, HasAttachment, OR, parse, QueryNode, serialise, Subject } from './parser'

describe('parser', () => {

  it('should generate query correctly', () => {

    const node = OR(
      AND(From('account@strata1.com'), HasAttachment()),
      AND(From('account@strata2.com'), HasAttachment()),
      AND(
        OR(
          From('noreply@strata3.com'),
          From('account@strata3.com'),
        ),
        Subject('Levy'),
        HasAttachment(),
      ),
      AND(
        From('noreply@internet.co'),
        Subject('Invoice'),
      ),
      AND(From('donotreply@reates.govt'), HasAttachment()),
    )

    expect(serialise(node))
      .toEqual('((from:(account@strata1.com) AND has:attachment) OR (from:(account@strata2.com) AND has:attachment) OR ((from:(noreply@strata3.com) OR from:(account@strata3.com)) AND subject:(Levy) AND has:attachment) OR (from:(noreply@internet.co) AND subject:(Invoice)) OR (from:(donotreply@reates.govt) AND has:attachment))')

  })

  it('should parse query', () => {

    expect(parse('has:attachment AND subject:(Levy)'))
      .toEqual({
        $and: [
          { value: 'has:attachment' },
          { value: 'subject:(Levy)' },
        ],
      } as QueryNode)

    expect(parse('((from:(account@strata1.com) AND has:attachment) OR (from:(account@strata2.com) AND has:attachment) OR ((from:(noreply@strata3.com) OR from:(account@strata3.com)) AND subject:(Levy) AND has:attachment) OR (from:(noreply@internet.co) AND subject:(Invoice)) OR (from:(donotreply@reates.govt) AND has:attachment))'))
      .toEqual(OR(
        AND(From('account@strata1.com'), HasAttachment()),
        AND(From('account@strata2.com'), HasAttachment()),
        AND(
          OR(
            From('noreply@strata3.com'),
            From('account@strata3.com'),
          ),
          Subject('Levy'),
          HasAttachment(),
        ),
        AND(
          From('noreply@internet.co'),
          Subject('Invoice'),
        ),
        AND(From('donotreply@reates.govt'), HasAttachment()),
      ))

  })

})
