<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title
        title="Program Counter"
        :message="message"
        :value="pcBits.asInteger()"
      ></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="pcBits"></bits>
          <q-linear-progress :percentage="percentage"></q-linear-progress>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import BitArray from './BitArray'

export default {
  name: 'PC',
  props: ['cBus', 'maxCounter'],
  // components: { Signals, Bits, BlockTitle },
  data() {
    return {
      pcBits: new BitArray(4)
    }
  },
  computed: {
    isActive: function() {
      return this.cBus.Cp === 1 || this.cBus.Ep === 1
    },
    percentage: function() {
      return (this.pcBits.asInteger() / this.maxCounter) * 100
    },
    message: function() {
      if (this.cBus.Ep === 1)
        return {
          icon: 'arrow_forward',
          pointing: 'right',
          msg: this.pcBits.toString(2)
        }
      if (this.cBus.Cp === 1 && this.cBus.CLKi === 0)
        return {
          icon: 'arrow_downward',
          pointing: 'left',
          msg: 'Incremented: ' + this.pcBits.toString(2)
        }
      return ''
    }
  },
  watch: {
    'cBus.Ep': function() {
      if (this.cBus.Ep === 1) {
        this.$emit('pushToBus', this.pcBits)
      }
    },
    'cBus.CLKi': function(newCLKi) {
      if (this.cBus.Cp === 1 && newCLKi === 0) this.increment()
    }
  },
  methods: {
    increment: function() {
      this.pcBits.set(this.pcBits.asInteger() + 1)
    },
    reset: function() {
      this.pcBits.set(0)
    }
  }
}
</script>

<style></style>
