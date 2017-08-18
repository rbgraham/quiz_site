import React from "react"

var Cards = { 
  title: function (props) {
    return (
        <div>
          <h1>{props.card.title}</h1>
        </div>
    );
  },

  blank: function (props) {
    return (
      <div></div>
    );
  },
  
  section: function (props) {
    return (
      <div>
        <h1>
        { props.title }
        </h1>
        <div>
          <p>
            { props.content }
          </p>
        </div>
        <button>{ props.cta }</button>
      </div>
    );
  },

  question: function (props) {
    return (
      <div>
        <h1>
        { props.question }
        <span class="small">{ props.subtext }</span>
        </h1>
      </div>
    );
  },
}

class TitleCard extends React.Component {
  constructor(props) {
    super(props);
    this.state = props.card;
  }

  renderSection (section) {
    return Cards.section(section);
  }

  render() {
    return (
      <div>
        { this.renderSection(this.state.sections[0]) }
      </div>
    );
  }

}

export { Cards, TitleCard };
