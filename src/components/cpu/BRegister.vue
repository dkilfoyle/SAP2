<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title title="B Register" :message="message" :value="brBits.asInteger()"></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="brBits"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
export default {
  name: 'BR',
  props: ['cBus', 'brBits', 'busBits'],
  data() {
    return {}
  },
  computed: {
    isActive: function() {
      return this.cBus.Lb === 0
    },
    message: function() {
      if (this.cBus.Lb === 0 && this.cBus.CLK === 1) {
        return {
          icon: 'arrow_forward',
          pointing: 'right',
          msg: this.busBits.toString(2)
        }
      }
      return ''
    }
  },
  watch: {
    'cBus.CLK': function(newCLK) {
      if (newCLK === 1 && this.cBus.Lb === 0) {
        this.$emit('loadBusToB')
      }
    }
  }
}
</script>

<style></style>
