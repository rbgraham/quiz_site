import axios from "axios"
import React from "react"

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },
}

class QuizSite extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cards: [],
      sequence: 1
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

  sectionCard(section) {
    return (
        <div>
          <h1>
          { section.title }
          </h1>
          <div>
            <p>
              { section.content }
            </p>
          </div>
          <button onClick={ () => this.advance(this.state.sequence, this.state.cards) }>{ section.cta }</button>
        </div>
      );
  }

  questionCard(question) {
    return (
        <div>
          <h1>
          { question.question }
          </h1>
          <div>
            <span class="small">
              { question.content }
            </span>
          </div>
          <button onClick={ () => this.advance(this.state.sequence, this.state.cards) }></button>
        </div>
      );
  }

  advance(sequence, cards) {
    console.log("ADVANCE>");
    this.setState({ 
      cards: cards,
      sequence: sequence + 1
    });
  }

  render() {
    const cardObj = this.getCard();
    let card = null;
    if (this.state.cards.length > 0 ) {
      const section = cardObj.sections[0];
      const question = cardObj.questions[0];
      
      if (section != null) {
        return this.sectionCard(section);
      } else {
        return this.questionCard(question);
      }
      
    } else {
      return (<Cards.blank />);
    }
  }
}

export { QuizSite };
