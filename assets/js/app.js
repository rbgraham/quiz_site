// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import React from "react"
import ReactDOM from "react-dom"
import axios from "axios"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function TitleCard(props) {
   return (
      <div>
        <h1>{props.card.title}</h1>
      </div>
   );
}

function BlankCard(props) {
    return (
      <div></div>
    );
}

class QuizSite extends React.Component {
  constructor(props) {
    super(props);
    this.state = {cards: []};
  }

  componentDidMount() {
    var _this = this;
    this.serverRequest =
      axios
        .get("/cards")
        .then(function(result) {
          _this.setState({
            cards: result.data.data
          });
        })
  }

  componentWillUnmount() {
    this.serverRequest.abort();
  }

  getInitialCard() {
   return this.state.cards.find((elem) => { return elem.sequence === 1; } );
  }

  render() {
    let card = null;
    if (this.state.cards.length > 0) {
      card = <TitleCard card={this.getInitialCard()}/>;
    } else {
      card = <BlankCard/>;
    }

    window.w = this;

    return (
      <div>
        { card }
      </div>
    );
  }
}

ReactDOM.render(
  <QuizSite/>,
  document.getElementById("title-card")
)

