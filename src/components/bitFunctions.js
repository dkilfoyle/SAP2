function convertBitsToWords(bits, radix) {
  let nWords = bits.length / 4
  let res = []
  let padLength = radix === 2 ? 4 : 1
  for (let iWord = 0; iWord < nWords; iWord++) {
    res[iWord] = parseInt(
      bits.slice(bits.length - (iWord + 1) * 4, bits.length - iWord * 4).join(''),
      2
    )
      .toString(radix)
      .padStart(padLength, '0')
  }
  return res
}

function convertWordsToBits(words) {
  return words
    .split('') // "1FC" -> "1","F","A"
    .map(
      x =>
        parseInt(x, 16) // "A" -> 10
          .toString(2) // 3 -> "11"
          .padStart(4, '0') // 11 -> "0011"
    )
    .join('')
}

function getInstruction(bits) {
  let insBits = convertBitsToWords(bits, 2)[bits.length / 4 - 1]
  if (insBits === '0000') return 'LDA' // 0000
  if (insBits === '0001') return 'ADD' // 0001
  if (insBits === '0010') return 'SUB' // 0010
  if (insBits === '1110') return 'OUT' // 1110
  if (insBits === '1111') return 'HLT' // 1111
  return 'XXX'
}

export { convertBitsToWords, convertWordsToBits, getInstruction }
