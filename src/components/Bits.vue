<template>
  <div>
    <q-table :data="bitsTableData" :columns="bitsTableColumns" dense hide-bottom></q-table>
  </div>
</template>

<script>
import BitArray from './BitArray'
export default {
  name: 'Bits',
  data() {
    return {
      allColumns: [
        { name: 'rowname', label: '', field: 'rowname' },
        { name: 'bits', label: 'Bits', field: 'bits' },
        { name: 'dec', label: 'Dec', field: 'dec' },
        { name: 'hex', label: 'Hex', field: 'hex' }
      ]
    }
  },
  props: {
    bitArray: BitArray,
    showNum: { type: Boolean, default: true },
    precalculated: { type: Object, default: undefined },
    rowname: { type: String, default: undefined }
  },
  computed: {
    bitsTableColumns: function() {
      let x = this.showNum ? this.allColumns : this.allColumns.slice(0, 1)
      if (this.precalculated !== undefined) {
        x[4] = {
          name: 'precalc',
          label: this.precalculated.label,
          field: this.precalculated.label
        }
      }
      if (this.rowname !== undefined) return x
      else return x.slice(1)
    },
    bitsTableData: function() {
      var x = {}
      x.bits = this.bitArray.toString(2)
      x.dec = this.bitArray.toString(10)
      x.hex = this.bitArray.toString(16)
      if (this.precalculated !== undefined) {
        x[this.precalculated.label] = this.precalculated.value
      }
      if (this.rowname !== undefined) {
        x.rowname = this.rowname
      }
      return [x]
    }
  }
}
</script>

<style></style>
