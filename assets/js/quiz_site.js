import axios from "axios"
import React from "react"
var qs = require('qs');

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },

  section: class Section extends React.Component {
    constructor(props) {
      super(props);
      this.state = { 
        section: props.section,
        click: props.click,
        choices: props.choices,
        score: props.score,
        drip_id: props.drip_id
      }
    }

    shouldDisplay() {
      if (this.state.section.conditions.length == 0) {
        return true;
      } else if (this.scoreSection()) { 
        var cond = this.state.section.conditions[0];
        return this.checkScoreCondition(cond);
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

    scoreSection () {
      if (this.state.section.conditions.length == 1 && this.scoreCondition(this.state.section.conditions[0])) {
        return true;
      } else {
        return false;
      }
    }

    scoreCondition(cond) {
      if (cond.equal_to || cond.greater_than || cond.less_than) {
        return true;
      }
      return false;
    }

    checkScoreCondition(cond) {
      if (cond.equal_to) {
        return cond.equal_to == this.state.score;
      }

      var condition = true;
      if (cond.greater_than) {
        condition = (cond.greater_than < this.state.score);
      }

      if (cond.less_than) {
        condition = condition && (cond.less_than > this.state.score);
      }
      return condition;
    }

    emailForm(props) {
      return Cards.emailForm(props);
    }

    render() {
      let cta = null;
      if (this.state.section.cta) {
        cta = <button className="btn btn-warning btn-large h4" onClick={ this.state.click }>{ this.state.section.cta }</button>;
      }

      let img = null;
      if (this.state.section.image_path) {
        const src = Cards.image_path(this.state.section.image_path);
        img = (
          <img src={src} width={ this.state.section.image_width } className="center-block" />
        );
      }

      var rendered = (
          <div className="text-center">
            <div className="img-container">
              { img }
            </div>
            <h1 >
            { this.state.section.title }
            </h1>
            <p className="h5">{ this.state.section.content }</p>
            <br/>
            { cta }
          </div>
      );

      if (this.shouldDisplay() && !this.state.section.email_form) {
        return rendered;
      } else if (this.shouldDisplay() && this.state.section.email_form) {
        return this.emailForm(this.state);
      } else {
        return Cards.blank();
      }
    }
  },

  emailForm: function (props) {
    const drip_form_url = "https://www.getdrip.com/forms/" + props.drip_id + "/submissions";
    var form = (
    <div className="text-center form-group col-md-6 col-md-offset-3">
      <form action={ drip_form_url } method="post" data-drip-embedded-form={ props.drip_id }>
        <h3 data-drip-attribute="headline">{ props.section.title }</h3>
        <div data-drip-attribute="description">{ props.section.content }</div>
          <div>
              <label for="drip-email"></label><br />
              <input className="form-control" type="email" id="drip-email" name="fields[email]" placeholder="you@domain.com"/>
          </div>
        <div>
          <input className="btn btn-warning btn-large h4" type="submit" name="submit" value={ props.section.cta } data-drip-attribute="sign-up-button" />
        </div>
      </form>
    </div>
    );
    return form;
  },
    
  choice: function (props) {
    let img = null;
    var display = ( 
      <button className="btn btn-default choice big-btn" onClick={props.click} 
        value={props.choice.id} data-choice={props.choice.choice}
        data-choice-score={props.choice.score}>
        { props.choice.choice }
      </button>
    );

    if (props.choice.image_path) {
      const src = Cards.image_path(props.choice.image_path);
      let microcopy = null;
      if (props.choice.microcopy) {
        microcopy = props.choice.choice;
      }
      img = (
          <button className="btn btn-default choice" onClick={props.click} 
            value={props.choice.id} data-choice={props.choice.choice}
            data-choice-score={props.choice.score}>
            <img src={src} height="100px;" className="center-block"/>
            { microcopy }
          </button>
      );
      display = img;
    }

    return display;
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
        <div className="text-center">
          <h1>
          { props.question.question }
          </h1>
          <div>
          { subtext }
          </div>
          <div className="choices text-center">
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
  },

  image_path: function (path) {
    return "/images/" + path;
  }
}

class QuizSite extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cards: [],
      sequence: 1,
      choices: [],
      score: 0,
      result_id: null,
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
    var result_id = this.state.result_id;
    if (seq > this.maxSequence()) {
      seq = this.maxSequence();
    }

    var score = this.state.score;
    var choices = this.state.choices;
    if (e) {
      choices.push(e.currentTarget.getAttribute("data-choice"));
      if (result_id) {
        this.storeResponse(result_id, e.currentTarget.value);
        this.completeResult(seq, result_id);
      } else {
        this.initResult(e.currentTarget.value);
      }

      score += this.updatedScore(e);
    }

    this.setState({ 
      cards: cards,
      sequence: seq,
      choices: choices,
      result_id: result_id,
      score: score
    });
  }

  updatedScore(e) {
    return parseInt(e.currentTarget.getAttribute("data-choice-score"));
  }

  storeResultId(result_id) {
    this.setState({result_id: result_id});
  }

  sectionCta(sequence) {
    return () => this.advance(this.state.sequence, this.state.cards, null);
  }

  questionCta() {
    return (e) => this.advance(this.state.sequence, this.state.cards, e);
  }

  initResult(choice_id) {
    var result_id = null;
    var _this = this;
    this.createResultRequest =
      axios
        .post("/results", qs.stringify({ result: { quiz_name: this.state.cards[0].site}, _csrf_token: this.csrfToken() }))
        .then((result) => {
          result_id = result.data.data.id;
          _this.storeResultId(result_id);
          _this.storeResponse(result_id, choice_id);
        })
  }

  storeResponse(result_id, choice_id) {
    axios
          .post("/responses", qs.stringify({ response: { result_id: result_id, choice_id: choice_id }, _csrf_token: this.csrfToken() }))
  }

  completeResult(sequence, result_id) {
    if (sequence == this.maxSequence()) {
      axios
        .put("/results/" + result_id, qs.stringify({ result: { completed: true }, _csrf_token: this.csrfToken() }))
    }
  }

  csrfToken() {
    var titleCard = document.getElementById("title-card");
    return titleCard.getAttribute("data-csrf-token");
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
        sections.push(<Cards.section key={ s.id } section={ s } click={ this.sectionCta(card.sequence) } choices={ this.state.choices } score={ this.state.score } drip_id={ card.drip_id } />);
      });
      const title = card.title + " | Celebrity Financial Twin Quiz";

      return (
        <div className="top-spacer">
          <Cards.layout title={ title } />
          <div> { questions } </div>
          <div> { sections } </div>
        </div>
      );

    } else {
      return (
        <div className="container col-xs-12 col-md-12">
          <Cards.layout title="Celebrity Financial Twin Quiz"/>
          <Cards.blank />
        </div>
      );
    }
  }
}

export { QuizSite };
