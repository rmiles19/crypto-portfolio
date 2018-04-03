import {
  COINS,
  ADD_COIN,
  REMOVE_COIN,
} from '../actions/coins';

const coins = ( state = [], action ) => {
  switch ( action.type ) {
    case COINS:
      //{ type: 'COINS', coins: [{...}, {....}] }
      return action.coins
    case ADD_COIN:
      //{ type: 'ADD_COIN', coin: {...} }
      return [...state, action.coin]
    case REMOVE_COIN:
      //{ type: 'REMOVE_COIN', id: 7 }
      return state.filter( c => c.id !== action.id )
    default:
      return state
  }
}

export default coins