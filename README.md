# Gmail Filter Query Parser

A nearley based parser to parse/serialise Gmail filter query.

## Installation

```bash
npm install gmail-filter-query-parser
```

## Usage

```javascript
import { parse, serialise, HasAttachment, Subject } from 'gmail-filter-query-parser'

const parsed = parse('subject:(invoice) AND has:attachment')
console.log(parsed)
// { $and: [ { value: 'subject:(invoice)' }, { value: 'has:attachment' } ] }

const serialised = serialise(And(
  Subject('invoice'),
  HasAttachment(),
))
console.log(serialised)
// 'subject:(invoice) AND has:attachment'
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
