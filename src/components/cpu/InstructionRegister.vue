<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title
        title="Instruction Register"
        :message="message"
        :value="instruction"
      ></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits
            rowname="Inst"
            :bitArray="instructionBits"
            :precalculated="{ label: 'Ins', value: instruction }"
          ></bits>
          <bits rowname="Addr" :bitArray="addressBits" class="q-mt-md"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
export default {
  name: 'IntructionRegister',
  props: ['cBus', 'busBits', 'irBits'],
  data() {
    return {}
  },
  computed: {
    instructionBits: function() {
      return this.irBits.getHWord()
    },
    addressBits: function() {
      return this.irBits.getLWord()
    },
    isActive: function() {
      return this.cBus.CLR === 1 || this.cBus.Li === 0 || this.cBus.Ei === 0
    },
    instruction: function() {
      return this.getInstruction(this.irBits.getHWord().toString(2))
    },
    message: function() {
      if (this.cBus.Li === 0 && this.cBus.CLK === 1) {
        return {
          icon: 'arrow_downward',
          pointing: 'left',
          msg: this.busBits.toString(2)
        }
      }
      if (this.cBus.Ei === 0) {
        return {
          icon: 'arrow_downward',
          pointing: 'right',
          msg: this.busBits.toString(2)
        }
      }
      return ''
    }
  },
  watch: {
    'cBus.CLK': function(newCLK) {
      if (newCLK === 1 && this.cBus.Li === 0) {
        this.$emit('loadIrFromBus')
      }
    }
  },
  methods: {
    getInstruction(insBits) {
      // TODO: convert to mixin for controller.vue and instructionregister.vue
      if (insBits === '0000') return 'LDA' // 0000
      if (insBits === '0001') return 'ADD' // 0001
      if (insBits === '0010') return 'SUB' // 0010
      if (insBits === '1110') return 'OUT' // 1110
      if (insBits === '1111') return 'HLT' // 1111
      throw new Error('unrecognised instruction')
    }
  }
}
</script>

<style></style>
