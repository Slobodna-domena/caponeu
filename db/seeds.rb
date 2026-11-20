# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development?
  AdminUser.create!(
    email: ENV.fetch("ADMIN_EMAIL", "admin@example.com"),
    password: ENV.fetch("ADMIN_PASSWORD", "change-me-please"),
    password_confirmation: ENV.fetch("ADMIN_PASSWORD", "change-me-please")
  )
end

# Homepage default news
News.create!(
  title: "Workshop:
  European Centers and Peripheries in the Political Novel",
  date: "25 – 26 April 2024",
  venue: "Leibniz-Zentrum für Literatur- und Kulturforschung, Pariser Str. 1, 10719 Berlin",
  contact: "caponeu@zfl-berlin.org",
  lead: "<p>The workshop examines how asymmetries between European centers and peripheries are articulated in explicitly political terms by the political novel. It investigates the question of what formal and textual features are common of literary centers on the one hand and peripheries on the other, as well as the question of how literary centers and peripheries respond to political novels. The workshop is organized by Kyung-Ho Cha, Patrick Eiden-Offe, Ivana Perica (all ZfL), Johanna-Charlotte Horst (Ludwig-Maximilians-Universität München) and Christoph Schaub (University of Vechta). <a href='https://www.zfl-berlin.org/event/european-centers-and-peripheries-in-the-political-novel.html'>More information</a></p>",
  priority: 1
)

News.create!(
  title: "The Feminist Book Club",
  date: "12 October 2023",
  venue: "Club Booksa, Martićeva 14D, Zagreb",
  contact: "booksa@booksa.hr",
  lead: "<p>The Feminist Book Club is organised in collaboration of the Faculty of Humanities and Social Sciences, University of Zagreb, and Club Booksa (Association for Promotion of Cultures Kulturtreger). It will be organised over a period of nine months (October 2023–June 2024) with one meeting per month. The book club will explore and discuss how the contemporary political novel shapes and transforms perceptions of gender and class within the framework of 20th and 21st century world and (post)Yugoslav literature.
<a href='https://booksa.hr/vijesti/vijesti/poziv-na-prvi-susret-feministicke-citaonice-u-booksi'>More information.</a></p>",
  priority: 3
)

News.create!(
  title: "Book club Politics and Literature: Novels for the New Century",
  date: "23 October 2023 7PM",
  topic: "Natasha Brown's Assembly",
  venue: "Club Booksa, Martićeva 14D, Zagreb",
  contact: "caponeu@zfl-berlin.de",
  lead: "<p>The book club is a cooperation of our ZfL team (Leibniz Centre for Literary and Cultural Research) with the Literaturhaus Berlin. It is organised over a nine-month period (Oct. 2023-June 2024), with one meeting per month. <a href='https://www.zfl-berlin.org/projekt/caponeu-buchklub.html'>More information.</a> </p>",
  priority: 2
)


