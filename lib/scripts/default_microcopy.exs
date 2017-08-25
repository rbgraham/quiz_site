alias QuizSite.Repo
alias QuizSite.Questions.Choice
import Ecto.Query

new_microcopy = true
{:ok, dt} = NaiveDateTime.from_erl({{2017, 8, 23}, {0, 0, 0}})
from(c in Choice, where: c.inserted_at < ^dt, update: [set: [microcopy: ^new_microcopy]])
|> Repo.update_all([])
