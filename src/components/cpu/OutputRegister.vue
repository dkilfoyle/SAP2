<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <div class="row items-center">
        <div class="col-9">
          <span class="text-h6">Output</span>
        </div>
        <div class="col-3">
          <!-- <seven-seg :value="outBits.toString(10)" /> -->
          <v-sevenseg :value="outBits.toString(10)" digits="2" height="40" width="60"></v-sevenseg>
        </div>
      </div>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="outBits"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import BitArray from '../BitArray'
// import SevenSeg from '../SevenSeg'
import VSevenseg from './VSevenseg'

export default {
  name: 'OutputRegister',
  components: { VSevenseg },
  props: ['cBus', 'busBits'],
  data() {
    return {
      outBits: new BitArray(8)
    }
  },
  computed: {
    isActive: function() {
      return this.cBus.Lo === 0
    },
    message: function() {
      if (this.cBus.Lo === 0 && this.cBus.CLK === 1) {
        return {
          icon: 'arrow_forward',
          pointing: 'right',
          msg: this.busBits.toString()
        }
      }
      return ''
    }
  },
  watch: {
    // eslint-disable-next-line no-unused-vars
    'cBus.CLK': function(newCLK, oldCLK) {
      if (newCLK === 1 && this.cBus.Lo === 0) this.outBits.set(this.busBits)
    }
  },
  methods: {
    reset: function() {
      this.outBits.set(0)
    }
  }
}
</script>

<style></style>
