<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title title="MAR" :message="message" :value="marBits.asInteger()"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="marBits"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
import BlockTitle from './BlockTitle'
export default {
  name: 'MAR',
  components: { BlockTitle },
  props: ['cBus', 'busBits', 'marBits'],
  data() {
    return {}
  },
  computed: {
    isActive: function() {
      return this.cBus.Lm === 0
    },
    message: function() {
      if (this.cBus.Lm === 0 && this.cBus.CLK === 1) {
        return {
          icon: 'arrow_back',
          pointing: 'left',
          msg: 'XXXX ' + this.busBits.getLWord()
        }
      }
      return ''
    }
  },
  watch: {
    'cBus.CLK': function(newCLK) {
      if (newCLK === 1 && this.cBus.Lm === 0) this.$emit('loadBusToMar')
    }
  }
}
</script>

<style></style>
