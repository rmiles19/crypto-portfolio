import React, { Fragment } from 'react';
import { 
  Grid, 
  Card, 
  Header, 
  Segment,
  Loader,
  Dimmer,
} from 'semantic-ui-react';
import axios from 'axios';
import { connect } from 'react-redux';
import { setHeaders } from '../actions/headers';

class Coin extends React.Component {
  state = { coin: {} }

  componentDidMount() {
    const {
      dispatch,
      match: { params: { id }}
    } = this.props;
    axios.get(`/api/coins/${id}`)
      .then(({ data, headers }) => {
        dispatch(setHeaders(headers))
        this.setState({ coin: data })
      })
  }

  render() {
    const { coin } = this.state;
    return (
      <Fragment>
        { coin.id ?
          <Grid>
            <Grid.Row>
              <Grid.Column width={6}>
                <Card>
                  <Card.Content header={coin.name} />
                  <Card.Content
                    description={`$${coin.price_usd}`}
                  />
                  <Card.Content
                    description={`${coin.price_btc} BTC`}
                  />
                  <Card.Content extra>
                    <p>Rank: {coin.rank}</p>
                    <p>Symbol: {coin.symbol}</p>
                  </Card.Content>
                </Card>
              </Grid.Column>
            </Grid.Row>
          </Grid>
          :
          <Segment style={{ height: '100vh' }}>
            <Dimmer active>
              <Loader size="huge" />
            </Dimmer>
          </Segment>
        }
      </Fragment>
    )
  }
}

export default connect()(Coin)