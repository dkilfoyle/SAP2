<template>
  <div>
    <accumulator
      :cBus="accSignals"
      :accBits="accBits"
      :busBits="busBits"
      @loadBusToACC="loadBusToACC"
      @pushACCToBus="pushACCToBus"
    />
    <a-l-u
      :cBus="aluSignals"
      :accBits="accBits"
      :brBits="brBits"
      :aluBits="aluBits"
      @loadALUandPushToBus="loadALUandPushToBus"
      class="q-mt-md"
    />
    <b-register
      :cBus="brSignals"
      :brBits="brBits"
      :busBits="busBits"
      @loadBusToB="loadBusToB"
      class="q-mt-md"
    />
  </div>
</template>

<script>
import Accumulator from './Accumulator'
import ALU from './ALU'
import BRegister from './BRegister'
import BitArray from './BitArray'
export default {
  name: 'ALUBlock',
  components: { Accumulator, ALU, BRegister },
  props: ['cBus', 'busBits'],
  data() {
    return {
      brBits: new BitArray(8),
      accBits: new BitArray(8),
      aluBits: new BitArray(8)
    }
  },
  computed: {
    accSignals: function() {
      return {
        CLK: this.cBus.CLK,
        La: this.cBus.La,
        Ea: this.cBus.Ea
      }
    },
    brSignals: function() {
      return {
        CLK: this.cBus.CLK,
        Lb: this.cBus.Lb
      }
    },
    aluSignals: function() {
      return { Su: this.cBus.Su, Eu: this.cBus.Eu }
    }
  },
  methods: {
    loadBusToACC() {
      this.accBits.set(this.busBits) // splice(0, 8, ...this.busBits);
    },
    loadBusToB() {
      this.brBits.set(this.busBits)
    },
    loadALUandPushToBus(payload) {
      this.aluBits.set(payload) // splice(0, 8, ...payload);
      this.$emit('pushToBus', this.aluBits)
    },
    pushACCToBus() {
      this.$emit('pushToBus', this.accBits)
    }
  }
}
</script>

<style></style>
