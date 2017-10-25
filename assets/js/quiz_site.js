import axios from "axios"
import React from "react"
import { Section } from "./sections.js"
import { Cards } from "./simple_cards.js"

var qs = require('qs');

class QuizSite extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      cards: [],
      sequence: 1,
      choices: [],
      score: 0,
      result_id: null,
      result_display: false,
      email_set: false
    };
  }

  componentDidMount() {
    var _this = this;
    window.that = this;
    this.serverRequest =
      axios
        .get("/api/cards")
        .then(function(result) {
          if (!_this.resultId()) {
            _this.setState({
              cards: result.data.data
            });
          } else {
            _this.resultData(result.data.data);
          }
        });
  }

  componentWillUnmount() {
    this.serverRequest.abort();
  }

  getCard() {
    return this.state.cards.find((elem) =>
                                 { return elem.sequence === this.state.sequence; });
  }

  onLastCard() {
    return this.state.sequence == this.maxSequence;
  }

  maxSequence() {
    return Math.max(...this.state.cards.map((elem) => { return elem.sequence }));
  }

  resultData(cardData) {
    var resultId = this.resultId();
    var _this = this;
    if (resultId) {
      this.serverRequest =
        axios
          .get("/api/results/" + resultId)
          .then(function(result) {
            _this.setState(Object.assign({}, _this.buildResultState(result.data.data, cardData), {cards: cardData}));
          });
    }
  }

  advance(sequence, cards, e) {
    let seq = sequence + 1;
    var result_id = this.state.result_id;
    var email_set = this.state.email_set;
    if (seq > this.maxSequence()) {
      seq = this.maxSequence();
    }

    var score = this.state.score;
    var choices = this.state.choices;
    if (e === "email") {
      email_set = true;
    } else if (e) {
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
      email_set: email_set,
      score: score
    });
  }

  back(sequence, e) {
    let seq = sequence - 1;
    if (seq < 1) {
      seq = 1;
    }

    this.setState({
      sequence: seq
    });
  }

  postEmailToDrip(e) {
    const email_regexp = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (e) {
      const drip_form_url = "/drip/subscribe";
      var email = document.getElementById("drip-email");
      var quiz_name = this.getCard().site;
      var score = this.state.score;
      var result_id = this.state.result_id;
      var _this = this;
      if (!email_regexp.test(email.value)) {
        var email_error = document.getElementById("email-error");
        email_error.style = "";
        email.className += " is-invalid";
      } else {
        var dripEmailRequest =
          axios
            .post(drip_form_url, qs.stringify({ "email": email.value, "score": score, "quiz_name": quiz_name, result_id: result_id, _csrf_token: this.csrfToken() }))
            .then((result) => {
              // TODO This null means that we don't track the email submission
              // because we are storing choice_ids here and not a string or similar
              // this is worth tracking, however, I should migrate the result object
              // to that end
              _this.advance(_this.state.sequence, _this.state.cards, "email");
            });
      }
    }
  }

  sectionKeyPress() {
    return (e) => {
      if (e.charCode == 13) {
        this.postEmailToDrip(e);
      }
    }
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

  sectionEmailForm() {
    return (e) => this.postEmailToDrip(e);
  }

  questionCta() {
    return (e) => this.advance(this.state.sequence, this.state.cards, e);
  }

  goBack() {
    return (e) => this.back(this.state.sequence, e);
  }

  initResult(choice_id) {
    var result_id = null;
    var _this = this;
    this.createResultRequest =
      axios
        .post("/api/results", qs.stringify({ result: { quiz_name: this.state.cards[0].site}, _csrf_token: this.csrfToken() }))
        .then((result) => {
          result_id = result.data.data.id;
          _this.storeResultId(result_id);
          _this.storeResponse(result_id, choice_id);
        });
  }

  storeResponse(result_id, choice_id) {
    axios
          .post("/api/responses", qs.stringify({ response: { result_id: result_id, choice_id: choice_id }, _csrf_token: this.csrfToken() }))
  }

  completeResult(sequence, result_id) {
    if (sequence == this.maxSequence()) {
      axios
        .put("/api/results/" + result_id, qs.stringify({ result: { completed: true }, _csrf_token: this.csrfToken() }))
    }
  }

  csrfToken() {
    var titleCard = document.getElementById("title-card");
    return titleCard.getAttribute("data-csrf-token");
  }

  resultId() {
    var titleCard = document.getElementById("title-card");
    return titleCard.getAttribute("data-result-id");
  }

  buildResultState(result, cardData) {
    var choices = [];
    var score = 0;
    if (result["id"]) {
      return {
        choices: result["responses"].map((resp) => { return resp["choice"]["choice"]; }),
        result_id: result["id"],
        score: result["responses"].map((resp) => { return resp["choice"]["score"]; }).reduce((acc, value) => { return acc + value; }),
        sequence: Math.max(...cardData.map((elem) => { return elem.sequence })),
        result_display: true,
        email_set: true,
      };
    } else {
      return {};
    }
  }

  render() {
    let card = null;
    if (this.state.cards.length > 0 ) {
      const card = this.getCard();
      var last = this.onLastCard();
      var questions = [];
      card.questions.forEach((q) => {
        questions.push(<Cards.question key={ q.id } question={ q } click={ this.questionCta() }/>);  
      });

      var sections = [];
      card.sections.forEach((s) => {
        sections.push(<Section key={ s.id } section={ s }
                      click={ this.sectionCta(card.sequence) }
                      emailClick={ this.sectionEmailForm() }
                      skip={ this.sectionCta(card.sequence) }
                      back={ this.goBack() }
                      choices={ this.state.choices }
                      score={ this.state.score }
                      drip_id={ card.drip_id }
                      result_id={ this.state.result_id }
                      last={ last }
                      result_display={ this.state.result_display }
                      email_set={ this.state.email_set }
                      />);
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
