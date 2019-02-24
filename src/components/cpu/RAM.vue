<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title title="RAM" :message="message" :value="addressedValue.asInteger()"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <r-a-m-view :ramBits="ramBits" :selectedAddress="marBits.asInteger()" />
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
// TODO: Implement RAM editing
import RAMView from './RAMView'
import BlockTitle from './BlockTitle'
export default {
  name: 'RAM',
  components: { RAMView, BlockTitle },
  props: ['cBus', 'ramBits', 'marBits'],
  watch: {
    'cBus.CE': function(newCE) {
      if (newCE === 0) {
        this.$emit('loadRamToBus', this.addressedValue)
      }
    },
    marBits: function() {
      this.pagination.page = Math.floor(this.marBits.asInteger() / this.pagination.rowsPerPage) + 1
    }
  },
  computed: {
    addressedValue: function() {
      return this.ramBits[this.marBits.asInteger()]
    },
    isActive: function() {
      return this.cBus.CE === 0
    },
    message: function() {
      if (this.cBus.CE === 0) {
        return {
          icon: 'arrow_forward',
          pointing: 'right',
          msg: this.ramBits[this.marBits.asInteger()].toString(2)
        }
      }
      return ''
    }
  }
}
</script>

<style>
q-table tbody tr.selected {
  background: red;
}
</style>
