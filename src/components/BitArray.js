export default class BitArray {
  bits
  // Bits are stored in array from LSB to MSB
  // Bits: 7 6 5 4 3 2 1 0
  // Arry: 0 1 2 3 4 5 6 7
  constructor(bitSize, val) {
    this.bits = new Array(bitSize).fill(0)
    if (val !== undefined) this.set(val)
  }
  asInteger() {
    return parseInt(this.asString(), 2)
  }
  asString() {
    return [...this.bits].reverse().join('')
  }
  asArray() {
    return [...this.bits]
  }
  getHWord() {
    if (this.bits.length < 5) throw new Error('Only LWord')
    return this.getWord(2)
  }
  getLWord() {
    return this.getWord(1)
  }
  getWord(i) {
    if (i === 0) throw new Error('getWord is not 0 based')
    let wordStart = Math.max((i - 1) * 4, 0)
    let x = new BitArray(4).setArray(this.bits.slice(wordStart, wordStart + 4))
    return x
  }
  getMSB() {
    return this.bits.findIndex(x => x === 1)
  }
  toString(radix) {
    if (radix === undefined) radix = 2
    if (radix === 16) {
      return this.asInteger()
        .toString(16)
        .padStart(2, '0')
    }
    if (radix === 10) {
      return this.asInteger()
        .toString(10)
        .padStart(2, '0')
    }
    if (radix === 2) {
      let bitstr = this.asString()
      if (this.bits.length === 8) return bitstr.substr(0, 4) + ' ' + bitstr.substr(4, 4)
      return bitstr
    }
  }
  asWords() {
    let nWords = Math.ceil(this.bits.length / 4)
    // eslint-disable-next-line no-unused-vars
    let out = new Array(nWords).fill().map(x => new BitArray(4))
    for (let i = 1; i <= nWords; i++) out[i].setArray(this.getWord(i))
    return out
  }
  get length() {
    return this.bits.length
  }
  setNumber(val) {
    this.setString(val.toString(2).padStart(this.bits.length, '0'))
    return this
  }
  setString(val) {
    var newBits = val
      .split('')
      .reverse()
      .map(x => parseInt(x))
    this.bits.splice(0, newBits.length, ...newBits)
    return this
  }
  setArray(val) {
    if (val.length > this.bits.length) throw new Error('val.length is greater than this.length')
    this.bits.splice(0, val.length, ...val)
    return this
  }
  setBitArray(val) {
    if (val instanceof BitArray) this.setArray(val.bits)
    else throw new Error('val is not bitarray')
  }
  set(val) {
    if (typeof val === 'number') return this.setNumber(val)
    if (typeof val === 'string') return this.setString(val)
    if (Array.isArray(val)) return this.setArray(val)
    if (val instanceof BitArray) return this.setArray(val.bits)
    return this
  }
  static add(a, b) {
    let x = a ^ b // xor to get sum without carry

    while (a & b) {
      // while there is still a carry
      b = (a & b) << 1
      a = x
      x = a ^ b
    }
    return x
  }
  static subtract(a, b) {
    return BitArray.add(a, BitArray.add(~b + 1))
  }
}
