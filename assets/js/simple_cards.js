import React from "react"

var Cards = { 
  blank: function (props) {
    return (
      <div></div>
    );
  },

  emailForm: function (props) {
    var skip = null;
    if (props.section.skip_button) {
      skip = (
        <div>
          <button className="btn btn-default btn-sm h5 btn--skip"
            type="submit" name="skip"
            onClick={ props.skip }>
            Skip &gt;
          </button>
        </div>
      );
    }
    var form = (
    <div className="text-center form-group col-md-6 col-md-offset-3 needs-validation">
      <h3 data-drip-attribute="headline">{ props.section.title }</h3>
      <div data-drip-attribute="description">{ props.section.content }</div>
        <div>
            <input className="form-control"
              type="email" 
              id="drip-email" 
              name="fields[email]" 
              placeholder="you@domain.com"
              onKeyPress={ props.emailKeyPress }
              required/>
            <div className="invalid-feedback" id="email-error" style={{ display: 'none' }}>
              Please provide a valid email address.
            </div>
        </div>
      <div>
        <button className="btn btn-warning btn-large h4"
          type="submit" name="submit"
          data-drip-attribute="sign-up-button"
          data-choice="full-report"
          onClick={ props.emailClick }>
          { props.section.cta }
        </button>
      </div>
      { skip }
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
    props.question.choices.sort((choice, choice_b) => {
      return choice.id - choice_b.id;
    }).forEach((choice) => {
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

export { Cards };
