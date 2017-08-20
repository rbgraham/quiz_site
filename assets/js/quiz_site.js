import axios from "axios"
import React from "react"

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },

  section: function (props) {
    let cta = null;
    if (props.section.cta) {
      cta = <button onClick={ props.click }>{ props.section.cta }</button>;
    }

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
          { cta }
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
    let subtext = null;
    if (props.question.subtext) {
      subtext = (
        <span className="small">
          { props.question.subtext }
        </span>
      );  
    }
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
          { subtext }
          </div>
          <div className="choices">
            { choices }
          </div>
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

  sectionCta() {
    return () => this.advance(this.state.sequence, this.state.cards, null);
  }

  questionCta() {
    return (e) => this.advance(this.state.sequence, this.state.cards, e);
  }

  render() {
    let card = null;
    if (this.state.cards.length > 0 ) {
      const card = this.getCard();
      var questions = [];
      card.questions.forEach((q) => {
        questions.push(<Cards.question key={ q.id } question={ q } click={ this.questionCta() }/>);  
      });

      var sections = [];
      card.sections.forEach((s) => {
        sections.push(<Cards.section key={ s.id } section={ s } click={ this.sectionCta() }/>);
      });
      
      return (
        <div>
          <div> { questions } </div>
          <div> { sections } </div>
        </div>
      );

    } else {
      return (<Cards.blank />);
    }
  }
}

export { QuizSite };
