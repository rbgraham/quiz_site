# QuizSite

If you're marketing things on the web, you've probably noticed that quizzes are
high engagement and in high demand because from a marketer's perspective they
work so well. You learn about prospects and earn higher engagement in the
process.

The trouble is that building these quizzes can take a lot of time and it can be
frustrating or difficult for non-technical people in marketing to establish
throughput for getting more of them out the door or even making minor changes.

QuizSite tracks the data for individuals who interact with the quizzes you
create. You will know what questions they answered, how they answered, and where
they dropped off.

QuizSite will collect email addresses and send them via API to
[Drip](https://wwww.getdrip.com). If you would like me to connect to other systems, drop me
a line and we can talk about it.

QuizSite is a compromise. It still takes some technical skills, but it reduces
most of the production of these micro sites to YAML that anyone can write with
the help of this README.

QuizSite is built on top of React and Elixir+Phoenix. There are instructions
here to explain, get you started, and help you launch your own sites.

See my [example, live site built with
QuizSite.](https://www.whichcelebritydoispendlike.com)

# Installation

## Erlang, Elixir, and Phoenix

[Install instructions from the source](https://hexdocs.pm/phoenix/installation.html#content)

## The Database

By default QuizSite uses PostgreSQL. I recommend sticking with this unless you
have a very compelling reason to switch and the technical skills to navigate the
change.

You need only install PostgreSQL on your computer and know the default name and
password for our purposes. Edit `config/dev.exs` with the details of your local
database credentials and preferred naming.

If this is far too intimidating, you could also follow the instructions to
deploy Heroku and leave the site on an obscure Heroku URL no one will find until
you have things shaped up. I mention this only for those without the technical
skills to navigate this step without help.

[PostgreSQL](https://www.postgresql.org/download/) has downloads, docs, and many
options for install. I recommend a package manager like brew if you're on a Mac.

## QuizSite specific
    
    cd <project dir>
    touch config/dev.secret.exs

Edit the `dev.secret.exs` file to look like:

    use Mix.Config

    config :quiz_site,
      drip_id: <your-drip-email-account-id>,
      drip_client_id: "<your-drip-api-client-id>",
      drip_client_secret: "<your-drip-client-secret>"

Checkout [the Drip API docs about OAuth](https://www.getdrip.com/docs/rest-api) or
[jump right in with creating your application](https://www.getdrip.com/user/applications)
if you need help getting started or finding your 
API info. Your account id is on your account settings page accessible from the
top right gear icon when you login to Drip. These are required to securely send
your data to Drip.

    mix deps.get
    mix ecto.create && mix ecto.migrate
    cd assets && npm install
    cd .. && mix run priv/repo/seeds.exs

That should get you setup locally to run the QuizSite here which is a celebrity
financial quiz I created.

    mix phx.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


# Deployment (Heroku and more)

Heroku isn't ideal for deploying Phoenix projects because of the way that Heroku
runs the code. It erodes the advantages that Elixir and Erlang provide. For
more information on that [see the Phoenix docs](https://hexdocs.pm/phoenix/heroku.html#content).

That said, Heroku is simple and quick to get out a live site. If you want to
take more advantage of Elixir you should take a look at [Gigalixir](http://gigalixir.readthedocs.io/en/latest/)
and if you need a cloud platform like AWS or DigitalOcean look to [Distillery](https://github.com/bitwalker/distillery).

## Quick action with Heroku

This section is after you complete the first setup vis a vi the
[Phoenix docs to setup Heroku](https://hexdocs.pm/phoenix/heroku.html#content).
You can ignore the git instructions for now, but you do need to run the Heroku
buildpack commands. The "Making our project ready for Heroku" is completed for
you already.

We do need to create environment variables. The same ones from `dev.secret.exs`.

    heroku config:set drip_client_id=DRIP_CLIENT_APP_ID
    heroku config:set drip_client_secret=DRIP_CLIENT_APP_SECRET
    heroku config:set drip_id=DRIP_ACCOUNT_ID

You also need to handle the POOL_SIZE, SECRET_KEY_BASE, and database creation 
detailed in the
["Creating Environment..." section](https://hexdocs.pm/phoenix/heroku.html#creating-environment-variables-in-heroku).

Now you should be set to deploy.

    git push heroku master

If you load the site URL after deploy you will see a "Keepify" in the top left 
and otherwise a blank blue screen. We still need to load the data now that we
have deployed.

    heroku run "POOL_SIZE=2 mix ecto.create"
    heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"

Now if you visit your Heroku URL you will see your live and deployed site on the
wider Internet. If you make changes to the YAML and create your own quiz, you
will want to rerun

    heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"

in order to update the data.

## Managing a Heroku instance

Mainly, you update the YAML, images and then run two commands:

  git push heroku master
  heroku run "POOL_SIZE=2 mix run priv/repo/seeds.exs"


## What about a custom URL? DNS?

This is tricky depending on the specifics of your situation, but I can speak to
the general strategy here with Heroku and most of the ideas are transferrable.

Heroku will allow you to select a custom domain you own in the setting for your
app when you login. You will want to both select "www.yourdomain.com" and set
Heroku to manage the SSL certificate for you. This will greatly simplify some of
the potential issues in forwarding across domains and protocols (http/https).

In your DNS or domain provider DNS settings you will want to forward
"http://yourdomain.com" to "https://www.yourdomain.com". You can then create
a CNAME record in your DNS for the URL that Heroku will show in your settings to
point to.

Wait about 10m (as many as 60m may be required) and try your URL. You should
have a shiny QuizSite established at https://www.yourdomain.com. =)

# Forking your own site from this repo

Fork the repo on Github or BitBucket as desired. You will want to put your new
images in `assets/static/images` folder. You can delete any old images you don't
need.

Edit the `priv/repo/celeb-site.yml` file with your desired YAML for your site.
Use the next section to understand all your options. If you want to change the
name for this file to something more bespoke, you can rename the file and then
change `config/config.exs` on the `yaml_data_file` line to point at your desired
filename.

You may also want to change the `page_title_suffix` line in `config/config.exs`
to something more appropriate for you page titles on the quiz you have in mind.

If you want to go outside the framework for how the site looks and behaves you
are obviously welcome to change the code, but short of that the next section
will detail your options. Minor visual changes like text and colors can be
edited in either the YAML or `assets/css/app.css` files.

# YAML for QuizSite

Here I'll layout the conceptual underpinnings and then run through an example to
highlight how to use the YAML to build your own site.

## Concepts

The YAML markup for QuizSite is structured around a few elements: Cards,
Sections, Questions, Choices, and Conditions.

Cards are like webpages. There are no special cards. Cards are made up of
Sections and Questions. Cards also have a sequence so the site knows which one
comes next. Lastly, Cards have a "site" which is not particularly relevant. It's
vestigial or perhaps an affordance for future QuizSite features.

Questions are not conditional. They may coexist with Sections on a Card but are
often the only element on a Card to progress Choices are the answer options for
a question. All questions are multiple choice with fixed response options.
Choices can be textual, an image, or both. Choices can also carry a score which
can be positive or negative and used for quiz or lead scoring purposes.

Sections are simply like blocks of a site with a headline, paragraph, and
potentially a button. Sections may also come with Conditions. You may choose to
show a Section only if a quiz taker has answered a specific question in
a specific way or based on overall current quiz/lead scoring.

## An Example

I edited the `config/config.exs` and changed the YAML filename to point to
a blank file. Let's make a new quiz together and figure this thing out.

If you want to understand YAML syntax I'd recommend the [Ansible docs on YAML](http://docs.ansible.com/ansible/latest/YAMLSyntax.html).
[yaml.org](www.yaml.org/start.html) also has docs available.

We start out with a root element for all our cards and a title card.

    cards:
      - card:
        title: "Hello World"
        navigation: ""
        site: "sample-quiz"
        sequence: 1
        sections:
          - content: "This is a sample section paragraph."
            cta: "This is button copy!"
            title: "This is a section header."

If you input that and rerun the data updating seeds script we can see the new
quiz site.

    mix run priv/repo/seeds.exs

Make sure your local server is up (or run the heroku version of these commands).

    mix phx.server

Now [checkout the quiz](localhost:4000) you created.

Admittedly, it's not much. You have a button, a section header, and some sub
text. It's all centered and the button doesn't do anything. Let's add a couple
questions and flex our new quiz software.

    cards:
      - card:
        title: "Hello World"
        navigation: ""
        site: "sample-quiz"
        sequence: 1
        sections:
          - content: "This is a sample section paragraph."
            cta: "This is button copy!"
            title: "This is a section header."

      - card:
        title: "Sports"
        navigation: ""
        site: "sample-quiz"
        sequence: 2
        questions:
          - question: "What is your favorite sport?"
            choices:
              - choice: "I hate sports"
                score: 0
              - choice: "All of them"
                score: 1
              - choice: "Baseball"
                score: 10
              - choice: "Basketball"
                score: 10
              - choice: "Football"
                score: 15
              - choice: "Soccer"
                score: 10
              - choice: "Other"
                score: 5

      - card:
        title: "Sports Feels"
        navigation: ""
        site: "sample-quiz"
        sequence: 3
        questions:
          - question: "How do you feel playing sports or games?"
            choices:
              - choice: "I hate sports"
                image_path: "crying.png"
                score: 0
              - choice: "YES"
                score: 1
                image_path: "strong.png"
              - choice: "OK"
                score: 10
                image_path: "thumbsup.png"
              - choice: "Meh"
                score: 10
                image_path: "thumbsdown.png"

Rerun your update commands above and make sure the YAML file is saved.

OK. Now we have an interactive quiz that is also getting scored and tracked as
we progress. Since these images are included in the original repo we don't need
to add them, but to use new images you'll want to add them in
`assets/static/images`.

We can also add email collection to the form. You can do this conditionally and
at the very end or just before the reveal. It's up to how you build the cards.
We'll put it just before the reveal here and use an email form with the optional
skip button.

        - card:
          title: "Email report"
          navigation: ""
          site: "sample-quiz"
          sequence: 4
          sections:
              - content: "Thanks for taking our super sweet sports quiz."
                title: "Get a new report about sports injuries for your competitive profile."
                cta: "Collect your report"
                email_form: true
                skip_button: true

Now, let's add a results page with some sweet conditional features.

        - card:
          title: "Thanks for taking our sports quiz"
          navigation: ""
          site: "sample-quiz"
          sequence: 5
          sections:
            - content: "Scope out your friend's result below."
              title: "Find out what sports injuries are most likely for you."
              share: true
              share_text: "The text we send to Twitter, Fb, etc."
              result_display: true
              cta: "Button copy in this section to take the quiz."

            - content: "You might not have any fun but won't get hurt"
              title: "I'm so sorry"
              image_path: "crying.jpg"
              conditions:
                - less_than: 0
            - content: "You might hurt a knee"
              title: "Good and bad. Way to be active."
              image_path: "strong.jpg"
              conditions:
                - less_than: 50
                  greater_than: 0

You can use these conditions as an example for how to use the score to show
a section or not. QuizSite automatically sums the scoring as it progresses and
can show or not show these sections on each Card accordingly.

The other tricky section above is "result_display" which is something we use for
sharing quiz results. It will only display on the URL that quiz takers can share
with their friends. This URL will display the results of their quiz by loading
their choices and showing the final sequenced card. The "result_display" option
will ONLY show the section if the quiz is showing the shared URL and not for
quiz takers. This also allows you to show a section at the top or bottom to new
people checking out a friend's result. We prompt them to take the quiz
themselves here.

Conditions can also hinge on a specific Choice, but they are text based. If your
question has responses like those above you might have a conditions section
like:

        conditions:
          - condition: "YES"

This section would only show for people who answered that for our question about
how people feel playing sports.

The sharing options are pretty straight forward. "true" puts sharing buttons in
that section and "share_text" is the text we send as the default for a Tweet, Fb
post, or LinkedIn share.

Sections that have "result_display: false" will only display for quiz takers and
won't show on share pages. This can be handy for sharing options for quiz takers
or links to additional quizzes or information.

# Security and License

The license is MIT. See [LICENSE.txt](/LICENSE.txt).

The security for this project is necessarily imperfect as offered. You will
ultimately be the best judge for your own context. The contributors to this
project express no warranty for this software. It is provided as is and may
contain flaws.

# Acknowledgements

All images here are courtesy of common licensing via Wikimedia Commons. Thanks!
