import Signals from '../components/Signals'
import Bits from '../components/Bits'
import BlockTitle from '../components/BlockTitle'

// leave the export, even if you don't use it
export default ({ app, router, Vue }) => {
  Vue.component('signals', Signals)
  Vue.component('bits', Bits)
  Vue.component('block-title', BlockTitle)
}
