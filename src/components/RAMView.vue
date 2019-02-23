<template>
  <q-table
    :data="ramTableData"
    :columns="ramTableColumns"
    dense
    :pagination.sync="pagination"
    :selected.sync="selected"
    row-key="address"
  ></q-table>
</template>

<script>
export default {
  name: 'RAMView',
  props: ['ramBits', 'selectedAddress'],
  data() {
    return {
      pagination: {
        sortBy: null, // String, column "name" property value
        descending: false,
        page: 1,
        rowsPerPage: 10 // current rows per page being displayed
      }
    }
  },
  computed: {
    selected: function() {
      return [{ address: this.getAddressLabel(this.selectedAddress) }]
    },
    ramTableColumns: function() {
      return [
        { name: 'address', label: 'Address', field: 'address' },
        { name: 'bits', label: 'Bits', field: 'bits' },
        { name: 'dec', label: 'Dec', field: 'dec' },
        { name: 'hex', label: 'Hex', field: 'hex' }
      ]
    },
    ramTableData: function() {
      var x = []
      var bData = false
      for (let i = 0; i < 16; i++) {
        x[i] = {
          address: this.getAddressLabel(i),
          bits: this.ramBits[i].toString(2),
          dec: bData
            ? this.ramBits[i].toString(10)
            : this.getInstruction(this.ramBits[i].getWord(2).toString(2)),
          hex: this.ramBits[i].toString(16).toUpperCase()
        }
        if (this.ramBits[i].getWord(2).toString(2) === '1111') bData = true
      }
      return x
    }
  },
  methods: {
    getInstruction: function(insBitsStr) {
      if (insBitsStr === '0000') return 'LDA' // 0000
      if (insBitsStr === '0001') return 'ADD' // 0001
      if (insBitsStr === '0010') return 'SUB' // 0010
      if (insBitsStr === '1110') return 'OUT' // 1110
      if (insBitsStr === '1111') return 'HLT' // 1111
      return 'XXX'
    },
    getAddressLabel: function(i) {
      return (
        i.toString().padStart(2, '0') +
        '_' +
        i.toString(2).padStart(4, '0') +
        '_' +
        i.toString(16).toUpperCase()
      )
    }
  }
}
</script>

<style>
q-table tbody tr.selected {
  background: red;
}
</style>
