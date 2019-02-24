var exampleCode = require('./example.asm')
import BitArray from '../../components/BitArray'

export default {
  sourceCode: exampleCode,
  textBits: [new BitArray(8, 240)],
  dataBits: [new BitArray(8, 0)]
}
