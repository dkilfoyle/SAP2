<template>
  <div class="row q-gutter-md">
    <div class="col">
      <program-counter
        :cBus="pcSignals"
        @pushToBus="pushToBus"
        :maxCounter="maxCounter"
        class="q-mb-md"
        ref="PC"
      ></program-counter>
      <r-a-m-block
        :cBus="rbSignals"
        :busBits="busBits"
        @pushToBus="pushToBus"
        @setMaxCounter="setMaxCounter"
        ref="RB"
      ></r-a-m-block>
    </div>
    <div class="col">
      <bus :busBits="busBits" :cBus="busSignals"></bus>
      <control-block
        :cBus="cbSignals"
        :conSignals="conSignals"
        :busBits="busBits"
        @halfCycle="halfCycle"
        @setCBus="setCBus"
        @reset="reset"
        ref="CB"
        class="q-mt-md"
      ></control-block>
    </div>
    <div class="col">
      <a-l-u-block :cBus="abSignals" :busBits="busBits" @pushToBus="pushToBus" ref="ALU" />
      <output-register
        :cBus="outSignals"
        :busBits="busBits"
        class="q-mt-md"
        ref="OUTR"
      ></output-register>
    </div>
  </div>
</template>

<style></style>

<script>
import ProgramCounter from './ProgramCounter'
import RAMBlock from './RAMBlock'
import Bus from './Bus'
import ControlBlock from './ControlBlock'
import ALUBlock from './ALUBlock'
import OutputRegister from './OutputRegister'
import BitArray from '../BitArray'

export default {
  name: 'PageIndex',
  components: {
    ProgramCounter,
    RAMBlock,
    Bus,
    ControlBlock,
    ALUBlock,
    OutputRegister
  },
  data() {
    return {
      selectedTab: 'cpu',
      busBits: new BitArray(8),
      maxCounter: 0,
      CLK: 1,
      CLR: 0,
      CLKi: 0,
      CLRi: 1,
      Cp: 0,
      Ep: 0,
      Lm: 1,
      CE: 1,
      Li: 1,
      Ei: 1,
      La: 1,
      Ea: 0,
      Su: 0,
      Eu: 0,
      Lb: 1,
      Lo: 1
    }
  },
  computed: {
    cbSignals: function() {
      return {
        Cp: this.Cp,
        Ep: this.Ep,
        Lm: this.Lm,
        CE: this.CE,
        Li: this.Li,
        Ei: this.Ei,
        La: this.La,
        Ea: this.Ea,
        Su: this.Su,
        Eu: this.Eu,
        Lb: this.Lb,
        Lo: this.Lo
      }
    },
    pcSignals: function() {
      return { CLKi: this.CLKi, CLRi: this.CLRi, Cp: this.Cp, Ep: this.Ep }
    },
    rbSignals: function() {
      return { CLK: this.CLK, Lm: this.Lm, CE: this.CE }
    },
    conSignals: function() {
      return {
        CLK: this.CLK,
        CLKi: this.CLKi,
        CLR: this.CLR,
        CLRi: this.CLRi
      }
    },
    busSignals: function() {
      return { CLK: this.CLK }
    },
    abSignals: function() {
      return {
        CLK: this.CLK,
        Ea: this.Ea,
        La: this.La,
        Lb: this.Lb,
        Su: this.Su,
        Eu: this.Eu
      }
    },
    outSignals: function() {
      return { CLK: this.CLK, Lo: this.Lo }
    }
  },

  methods: {
    reset: function() {
      this.busBits = new BitArray(8)
      this.CLK = 0
      this.CLR = 0
      this.CLKi = 1
      this.CLRi = 1
      this.Cp = 0
      this.Ep = 0
      this.Lm = 1
      this.CE = 1
      this.Li = 1
      this.Ei = 1
      this.La = 1
      this.Ea = 0
      this.Su = 0
      this.Eu = 0
      this.Lb = 1
      this.Lo = 1
      this.$refs.PC.reset()
      this.$refs.RB.reset()
      this.$refs.CB.reset()
      this.$refs.OUTR.reset()
      this.$refs.ALU.reset()
    },
    halfCycle: function() {
      this.CLK = this.CLK === 1 ? 0 : 1
      this.CLKi = this.CLK === 1 ? 0 : 1
    },
    setCBus: function(payload) {
      this.Cp = payload.Cp
      this.Ep = payload.Ep
      this.Lm = payload.Lm
      this.CE = payload.CE
      this.Li = payload.Li
      this.Ei = payload.Ei
      this.La = payload.La
      this.Ea = payload.Ea
      this.Su = payload.Su
      this.Eu = payload.Eu
      this.Lb = payload.Lb
      this.Lo = payload.Lo
    },
    pushToBus: function(payload) {
      // console.log("pushToBus: ", payload);
      this.busBits.set(payload)
    },
    setMaxCounter: function(payload) {
      this.maxCounter = payload
    }
  }
}
</script>
