<template>
  <div>
    <q-table :data="sigTableData" :columns="sigTableColumns" dense hide-bottom>
      <q-td slot="body-cell" slot-scope="props" :props="props">
        <q-avatar
          v-if="isActive(props.col.name)"
          dense
          color="red"
          text-color="white"
          size="24px"
          >{{ props.value }}</q-avatar
        >
        <q-avatar v-else dense color="blue-grey-4" size="24px">
          {{ props.value }}
        </q-avatar>
      </q-td>
    </q-table>
  </div>
</template>

<script>
// >{{props.row[props.col.name]}}</q-td>
export default {
  name: 'Signals',
  data() {
    return {
      signalList: {
        CLK: { name: 'CLK', label: 'CLK', field: 'CLK', active: 1 },
        CLR: { name: 'CLR', label: 'CLR', field: 'CLR', active: 1 },
        CLKi: { name: 'CLKi', label: "CLK'", field: 'CLKi', active: 0 },
        CLRi: { name: 'CLRi', label: "CLR'", field: 'CLRi', active: 0 },
        Cp: { name: 'Cp', label: 'Cp', field: 'Cp', active: 1 },
        Ep: { name: 'Ep', label: 'Ep', field: 'Ep', active: 1 },
        Lm: { name: 'Lm', label: "Lm'", field: 'Lm', active: 0 },
        CE: { name: 'CE', label: "CE'", field: 'CE', active: 0 },
        Li: { name: 'Li', label: "Li'", field: 'Li', active: 0 },
        Ei: { name: 'Ei', label: "Ei'", field: 'Ei', active: 0 },
        La: { name: 'La', label: "La'", field: 'La', active: 0 },
        Ea: { name: 'Ea', label: 'Ea', field: 'Ea', active: 1 },
        Su: { name: 'Su', label: 'Su', field: 'Su', active: 1 },
        Eu: { name: 'Eu', label: 'Eu', field: 'Eu', active: 1 },
        Lb: { name: 'Lb', label: "Lb'", field: 'Lb', active: 0 },
        Lo: { name: 'Lo', label: "Lo'", field: 'Lo', active: 0 }
      }
    }
  },
  props: ['signals'],
  computed: {
    sigTableColumns: function() {
      return Object.keys(this.signals)
        .filter(x => x !== '__index')
        .map(x => this.signalList[x])
    },
    sigTableData: function() {
      return [this.signals]
    }
  },
  methods: {
    isActive(signal) {
      return this.signals[signal] === this.signalList[signal].active
    }
  }
}
</script>

<style></style>
