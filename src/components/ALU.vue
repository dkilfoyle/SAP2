<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title title="ALU" :message="message" :value="aluBits.asInteger()"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="aluBits"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import BitArray from './BitArray'
export default {
  name: 'ALU',
  props: ['cBus', 'aluBits', 'accBits', 'brBits'],
  data() {
    return {}
  },
  computed: {
    isActive: function() {
      return this.cBus.Su === 1 || this.cBus.Eu === 1
    },
    message: function() {
      if (this.cBus.Su === 1) {
        return {
          icon: 'arrow_forward',
          pointing: 'left',
          msg: 'ACC-B: ' + this.aluBits.toString()
        }
      }
      if (this.cBus.Eu === 1) {
        return {
          icon: 'arrow_back',
          pointing: 'left',
          msg: 'ACC+B: ' + this.aluBits.toString()
        }
      }
      return ''
    }
  },
  watch: {
    'cBus.Eu': function(newEu) {
      if (newEu === 1) {
        let x = new BitArray(8)
        // x.setNumber(this.accBits.asInteger() + this.brBits.asInteger());
        x.setNumber(BitArray.add(this.accBits.asInteger(), this.brBits.asInteger()))
        this.$emit('loadALUandPushToBus', x)
      }
    },
    'cBus.Su': function(newSu) {
      if (newSu === 1) {
        let x = new BitArray(8)
        x.setNumber(this.accBits.asInteger() - this.brBits.asInteger())
        this.$emit('loadALUandPushToBus', x)
      }
    }
  }
}
</script>

<style></style>
