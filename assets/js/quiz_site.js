import axios from "axios"
import React from "react"

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },

  section: function (props) {
    return (
        <div>
          <h1>
          { props.section.title }
          </h1>
          <div>
            <p>
              { props.section.content }
            </p>
          </div>
          <button onClick={ props.click }>{ props.section.cta }</button>
        </div>
      );
  },

  choice: function (props) {
    return (
      <div className="choice">
        <button onClick={props.click} value={props.choice.choice}>
          { props.choice.choice }
        </button>
      </div>
    );
  },

  question: function (props) {
    var choices = [];
    props.question.choices.forEach((choice) => {
      choices.push(<Cards.choice key={choice.choice} choice={choice} click={ props.click }/>);
    });
    return (
        <div>
          <h1>
          { props.question.question }
          </h1>
          <div>
            <span className="small">
              { props.question.subtext }
            </span>
          </div>
          <div className="choices">
            { choices }
          </div>
          <button onClick={ props.click }>placeholder</button>
        </div>
      );
  }
}

class QuizSite extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cards: [],
      sequence: 1,
      choices: []
    };
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

  getCard() {
    return this.state.cards.find((elem) =>
                                 { return elem.sequence === this.state.sequence; });
  }

  maxSequence() {
    return Math.max(...this.state.cards.map((elem) => { return elem.sequence }));
  }

  advance(sequence, cards, e) {
    let seq = sequence + 1;
    if (seq > this.maxSequence()) {
      seq = this.maxSequence();
    }

    var choices = this.state.choices;
    if (e != null) {
      choices.push(e.target.value);
    }

    this.setState({ 
      cards: cards,
      sequence: seq,
      choices: choices
    });
  }

  render() {
    const cardObj = this.getCard();
    let card = null;
    if (this.state.cards.length > 0 ) {
      const section = cardObj.sections[0];
      const question = cardObj.questions[0];
      
      if (section != null) {
        return (<Cards.section section={ section } click={ () => this.advance(this.state.sequence, this.state.cards, null) }/>);
      } else {
        return (<Cards.question question={question} click={ (e) => this.advance(this.state.sequence, this.state.cards, e) }/>);
      }
      
    } else {
      return (<Cards.blank />);
    }
  }
}

export { QuizSite };
