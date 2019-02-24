<template>
  <q-card>
    <q-card-section>
      <block-title title="Bus" :message="message" :value="busBits.asInteger()"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <!-- <signals :signals="conSignals" class="q-mt-md"></signals> -->
      <bits :bitArray="busBits"></bits>
    </q-card-section>
  </q-card>
</template>

<script>
export default {
  name: 'Bus',
  props: ['busBits', 'cBus'],
  data() {
    return { message: '' }
  },
  watch: {
    'busBits.bits': function() {
      if (this.cBus.CLK === 0) {
        this.message = {
          icon: 'arrow_downward',
          msg: 'Bus loaded: ' + this.busBits.toString(2)
        }
      } else {
        this.message = ''
      }
    },
    'cBus.CLK': function(newCLK) {
      if (newCLK === 1) this.message = ''
    }
  }
}
</script>

<style></style>
