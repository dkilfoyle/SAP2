<template>
  <q-card :color="isActive ? 'grey-2' : 'white'" text-color="black">
    <q-card-section>
      <block-title
        title="Accumulator"
        :message="message"
        :value="accBits.asInteger()"
      ></block-title>
    </q-card-section>
    <q-separator />
    <q-card-section>
      <div class="row q-gutter-sm">
        <div class="col-auto">
          <signals :signals="cBus"></signals>
        </div>
        <div class="col">
          <bits :bitArray="accBits"></bits>
        </div>
      </div>
    </q-card-section>
  </q-card>
</template>

<script>
export default {
  name: 'ACC',
  props: ['cBus', 'accBits', 'busBits'],
  data() {
    return {}
  },
  computed: {
    isActive: function() {
      return this.cBus.La === 0 || this.cBus.Ea === 1
    },
    message: function() {
      if (this.cBus.La === 0 && this.cBus.CLK === 1) {
        return {
          icon: 'arrow_forward',
          pointing: 'right',
          msg: this.busBits.toString()
        }
      }
      if (this.cBus.Ea === 1) {
        return {
          icon: 'arrow_back',
          pointing: 'left',
          msg: this.accBits.toString()
        }
      }
      return ''
    }
  },
  watch: {
    'cBus.CLK': function(newCLK) {
      if (newCLK === 1 && this.cBus.La === 0) this.$emit('loadBusToACC')
    },
    'cBus.Ea': function(newEA) {
      if (newEA === 1) this.$emit('pushACCToBus')
    }
  }
}
</script>

<style></style>
