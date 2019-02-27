<template>
  <q-page>
    <q-tabs
      v-model="selectedTab"
      dense
      class="text-grey"
      active-color="primary"
      indicator-color="primary"
      align="justify"
      narrow-indicator
    >
      <q-tab name="cpu" label="CPU" />
      <q-tab name="code" label="Code" />
      <q-tab name="help" label="Help" />
    </q-tabs>

    <q-separator />

    <q-tab-panels v-model="selectedTab" animated>
      <q-tab-panel name="cpu" class="q-pa-md">
        <c-p-u></c-p-u>
      </q-tab-panel>

      <q-tab-panel name="code">
        <editor></editor>
      </q-tab-panel>

      <q-tab-panel name="help">
        <p>Simple as Possible Computer: From Digital Computer Electronics by Albert Malvino.</p>
        <q-markup-table>
          <tbody>
            <tr>
              <td>Program Counter</td>
              <td>4 bits (0 to 15)</td>
            </tr>
            <tr>
              <td>W Bus</td>
              <td>8 bits</td>
            </tr>
            <tr>
              <td>Memory</td>
              <td>16 * 8 bits</td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-tab-panel>
    </q-tab-panels>
  </q-page>
</template>

<style></style>

<script>
import CPU from '../components/CPU/CPU'
import Editor from '../components/Editor/Editor'

export default {
  name: 'Computer',
  components: {
    CPU,
    Editor
  },
  data() {
    return {
      selectedTab: 'cpu'
    }
  }
}
</script>
