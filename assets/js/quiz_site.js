import axios from "axios"
import React from "react"

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },

  section: class Section extends React.Component {
    constructor(props) {
      super(props);
      this.state = { section: props.section, click: props.click, choices: props.choices }
    }

    shouldDisplay() {
      if (this.state.section.conditions.length == 0) {
        return true;
      } else {
        var conditions = [];
        this.state.section.conditions.forEach((c) => {
          conditions.push( this.state.choices.find((e) => {
            return e == c.condition;
          }) );
        });

        if (conditions.filter((c) => { return c != undefined; }).length < conditions.length) {
          return false;
        } else {
          return true;
        }
      }
    }

    render() {
      let cta = null;
      if (this.state.section.cta) {
        cta = <button onClick={ this.state.click }>{ this.state.section.cta }</button>;
      }

      var rendered = (
          <div>
            <h1>
            { this.state.section.title }
            </h1>
            <div>
              <p>
                { this.state.section.content }
              </p>
            </div>
            { cta }
          </div>
      );

      if (this.shouldDisplay()) {
        return rendered;
      } else {
        return Cards.blank();
      }
    }
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
  },

  layout: class Layout extends React.Component {
    constructor(props){
      super(props);
    }
    componentWillUpdate(nextProps) {
      document.title = nextProps.title;
    }
    render(){
      return null;
    }
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
        sections.push(<Cards.section key={ s.id } section={ s } click={ this.sectionCta() } choices={ this.state.choices } />);
      });
      const title = card.title + " | Celebrity Financial Twin Quiz";

      return (
        <div>
          <Cards.layout title={ title } />
          <div> { questions } </div>
          <div> { sections } </div>
        </div>
      );

    } else {
      return (
        <div>
          <Cards.layout title="Celebrity Financial Twin Quiz"/>
          <Cards.blank />
        </div>
      );
    }
  }
}

export { QuizSite };
