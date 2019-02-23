<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title title="Controller" :message="message" :value="microInstruction"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="conSignals"></signals>
        </div>
        <div class="col">
          <q-table :data="ringTableData" :columns="ringTableColumns" dense hide-bottom></q-table>
          <q-linear-progress :percentage="tStatePercentage"></q-linear-progress>
          <q-table
            :data="muinsTableData"
            :columns="muinsTableColumns"
            dense
            hide-bottom
            class="q-mt-md"
          ></q-table>
        </div>
      </div>

      <signals :signals="cBus" class="q-mt-md"></signals>
      <!-- <signals :signals="conSignals" class="q-mt-md"></signals> -->
    </q-card-section>
    <q-separator />
    <q-card-actions align="around">
      <q-btn
        :label="conSignals.CLK ? 'Tock' : 'Tick'"
        @click="$emit('halfCycle')"
        :disable="instruction === 'HLT'"
        color="primary"
        icon="access_time"
      ></q-btn>
      <q-btn @click="play" :disable="halted" color="secondary" icon="play_arrow"></q-btn>
      <q-btn @click="pause" :disable="halted" color="secondary" icon="pause"></q-btn>
      <q-btn @click="$parent.emit('reset')" color="secondary" icon="replay"></q-btn>
    </q-card-actions>
  </q-card>
</template>

<script>
import { convertWordsToBits } from './bitFunctions'
import BitArray from './BitArray'
export default {
  name: 'Controller',
  props: ['cBus', 'conSignals', 'irBits'],
  data() {
    return {
      message: '',
      timer: undefined,
      ringBits: new BitArray(6),
      TStateStr: ['Undef', 'Address', 'Increment', 'Memory', 'Exec1', 'Exec2', 'Exec3'],
      microInstructionsROM: {
        AIM: ['5E3', 'BE3', '263'],
        LDA: ['1A3', '2C3', '3E3'],
        ADD: ['1A3', '2E1', '3C7'],
        SUB: ['1A3', '2E1', '3CF'],
        OUT: ['3F2', '3E3', '3E3'],
        HLT: ['3E3', '3E3', '3E3'],
        NOP: ['3E3']
      },
      microInstructionDescr: {
        '5E3': 'Push PC to MAR via Bus',
        BE3: 'Increment PC',
        '263': 'Push RAM at MAR to IR via Bus',
        '1A3': 'Push Add in IR to MAR via Bus',
        '2C3': 'Push RAM at MAR to ACC via Bus',
        '3E3': 'NOP',
        '2E1': 'Push RAM at MAR to B via Bus',
        '3C7': 'ACC + B and push result to Bus',
        '3CF': 'ACC - B and push result to Bus',
        '3F2': 'Push ACC to Out'
      }
    }
  },
  computed: {
    TState: function() {
      let msbi = this.ringBits.getMSB()
      return msbi + 1
    },
    tStatePercentage: function() {
      return (this.TState / 6) * 100
    },
    TStateDesc: function() {
      return this.TStateStr[this.TState]
    },
    halted: function() {
      return this.getInstruction(this.irBits.getHWord().toString(2)) === 'HLT'
    },
    instruction: function() {
      if (this.TState < 4) return 'AIM'
      else return this.getInstruction(this.irBits.getHWord().toString(2))
    },
    microInstruction: function() {
      if (this.TState < 4) return this.microInstructionsROM.AIM[this.TState - 1]
      if (this.TState < 7) return this.microInstructionsROM[this.instruction][this.TState - 4]
      if (this.TState === 7) return this.microInstructionsROM.NOP[0]
      throw new Error('Invalid TState')
    },
    isActive: function() {
      return true
    },
    ringTableColumns: function() {
      return [
        { name: 'tstate', label: '', field: 'tstate' },
        { name: 'bits', label: 'Bits', field: 'bits' },
        { name: 't', label: 'T', field: 't' },
        { name: 'descr', label: 'Descr', field: 'descr' }
      ]
    },
    ringTableData: function() {
      return [
        {
          tstate: 'TState',
          bits: this.ringBits.toString(2),
          t: this.TState,
          descr: this.TStateDesc
        }
      ]
    },
    muinsTableColumns: function() {
      return [
        { name: 'ins', label: 'Ins', field: 'ins' },
        { name: 'muins', label: 'MuIns', field: 'muins' },
        { name: 'descr', label: 'Descr', field: 'descr' }
      ]
    },
    muinsTableData: function() {
      return [
        {
          ins: this.instruction,
          muins: this.microInstruction,
          descr: this.microInstructionDescr[this.microInstruction]
        }
      ]
    }
  },
  watch: {
    'conSignals.CLK': function(newCLK, oldCLK) {
      if (newCLK === 0 && oldCLK === 0) throw new Error('CLK same')
      if (newCLK === 0) {
        this.ringRotate()
      }
    },
    microInstruction: function() {
      let cBusBits = convertWordsToBits(this.microInstruction)
        .split('')
        .map(x => parseInt(x))
      let cBusNew = {
        Cp: cBusBits[0],
        Ep: cBusBits[1],
        Lm: cBusBits[2],
        CE: cBusBits[3],
        Li: cBusBits[4],
        Ei: cBusBits[5],
        La: cBusBits[6],
        Ea: cBusBits[7],
        Su: cBusBits[8],
        Eu: cBusBits[9],
        Lb: cBusBits[10],
        Lo: cBusBits[11]
      }
      this.$emit('setCBus', cBusNew)
    }
  },
  methods: {
    getInstruction(insBits) {
      if (insBits === '0000') return 'LDA' // 0000
      if (insBits === '0001') return 'ADD' // 0001
      if (insBits === '0010') return 'SUB' // 0010
      if (insBits === '1110') return 'OUT' // 1110
      if (insBits === '1111') return 'HLT' // 1111
      throw new Error('unrecognised instruction')
    },
    halfCycle() {
      if (this.instruction !== 'HLT') this.$emit('halfCycle')
    },
    play() {
      this.timer = setInterval(() => {
        if (this.instruction === 'HLT') {
          clearInterval(this.timer)
        } else this.halfCycle()
      }, 500)
    },
    pause() {
      clearInterval(this.timer)
    },
    reset() {
      this.ringBits.set(0)
    },
    ringRotate: function() {
      let msbi = this.ringBits.getMSB()
      if (msbi === -1) {
        // first rotation
        this.ringBits.bits.splice(0, 1, 1)
      } else {
        this.ringBits.bits.splice(msbi, 1, 0)
        if (msbi === 5) {
          this.ringBits.bits.splice(0, 1, 1)
        } else {
          this.ringBits.bits.splice(msbi + 1, 1, 1)
        }
      }
    }
  }
}
</script>

<style></style>
