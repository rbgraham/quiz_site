import React from "react"
import { Cards } from "./simple_cards.js"

import {
  ShareButtons,
  generateShareIcon
} from 'react-share';

const {
  FacebookShareButton,
  GooglePlusShareButton,
  LinkedinShareButton,
  TwitterShareButton,
  TelegramShareButton,
  WhatsappShareButton,
  PinterestShareButton,
  VKShareButton,
  OKShareButton,
  RedditShareButton,
  EmailShareButton,
} = ShareButtons;

const FacebookIcon = generateShareIcon('facebook');
const TwitterIcon = generateShareIcon('twitter');
const LinkedinIcon = generateShareIcon('linkedin');
const EmailIcon = generateShareIcon('email');

class Section extends React.Component {
    constructor(props) {
      super(props);
      this.state = { 
        section: props.section,
        click: props.click,
        choices: props.choices,
        score: props.score,
        emailClick: props.emailClick,
        skip: props.skip,
        emailKeyPress: props.emailKeyPress,
        drip_id: props.drip_id,
        result_id: props.result_id,
        back: props.back,
        email_set: props.email_set,
        result_display: props.result_display
      }
    }

    shouldDisplay() {
      if (this.state.section.conditions.length == 0) {
        /* 
         * Handle whether or not this is a results oriented shared page.
         * The result page context may choose to show or hide certain sections
         * so the content is relevant to the viewer.
         */
        if (this.state.result_display == false && this.state.section.result_display == false) {
          return true;
        } else if (this.state.result_display == true && this.state.section.result_display == true) {
          return true;
        } else if ((this.state.result_display == true && this.state.section.result_display == false) ||
                  (this.state.result_display == false && this.state.section.result_display == true)) {
          return false;
        }
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
      let share = null;
      if (this.state.section.share) {
        /* TODO This isn't quite right. I need a data model for the tweet text.
        */
        var tweet_url = window.location.protocol + "//" + window.location.host + "/results/" + this.state.result_id;
        var tweet_text = this.state.section.share_text;
        share = (
          <div className="col-md-offset-4 col-md-4 col-xs-4 col-xs-offset-3">
            <FacebookShareButton url={ tweet_url } quote={ tweet_text } className="col-md-1 col-xs-1">
              <FacebookIcon size={32} round={true} />
            </FacebookShareButton>
            <TwitterShareButton url={ tweet_url } title={ tweet_text } className="col-md-1 col-xs-1">
              <TwitterIcon size={32} round={true} />
            </TwitterShareButton>
            <LinkedinShareButton url={ tweet_url } title={ tweet_text } className="col-md-1 col-xs-1">
              <LinkedinIcon size={32} round={true} />
            </LinkedinShareButton>
            <EmailShareButton url={ tweet_url } subject={ tweet_text } className="col-md-1 col-xs-1">
              <EmailIcon size={32} round={true} />
            </EmailShareButton>
          </div>
        );
      }

      /*
       * A little bit (OK a lot) hacky to check the CTA string for making
       * behavior, but I blame this being the last TODO before release.
       */
      if (this.state.section.cta && this.state.section.cta.includes("Go back")) {
        if (!this.state.email_set) {
          cta = <button className="btn btn-warning btn-sm h5 btn--email-set" onClick={ this.state.back }>{this.state.section.cta}</button>;
        }
      } else if (this.state.section.cta && this.state.section.cta.includes("Take the quiz!")) {
        cta = <div><a className="btn btn-warning btn-large h4 btn--email-set" href="/" >{this.state.section.cta}</a></div>;
      } else if (this.state.section.cta) {
        cta = <button className="btn btn-warning btn-large h4" onClick={ this.state.click }>{ this.state.section.cta }</button>;
      }

      let img = null;
      if (this.state.section.image_path) {
        const src = Cards.image_path(this.state.section.image_path);
        img = (
          <img src={src} width="100%" className="img-fluid center-block" />
        );
      }

      var rendered = (
          <div className="text-center col-md-8 col-md-offset-2">
            <div className="img-container">
              { img }
            </div>
            <h1 >
            { this.state.section.title }
            </h1>
            <p className="h5">{ this.state.section.content }</p>
            <br/>
            { cta }
            { share }
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
}

export { Section };
