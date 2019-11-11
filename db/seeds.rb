require 'pry'
happy_birthday = Song.create(title: "Happy Birthday", artist: "?")
yesterday = Song.create(title: "Yesterday", artist: "Beatles")
love_will_tear_us_apart = Song.create(title: "Love Will Tear Us Apart", artist: "Joy Division")
someday = Song.create(title: "Someday", artist: "The Strokes")
hey_ya = Song.create(title: "Hey Ya", artist: "Outkast")
eleanor_rigby = Song.create(title: "Eleanor Rigby", artist: "The Beatles")
jesus_walks = Song.create(title: "Jesus Walks", artist: "Kanye West")
fun = Song.create(title: "Fun", artist: "Spongebob Squarepants")
song2 = Song.create(title: "Song 2", artist: "Blur")
ruby_tuesday = Song.create(title: "Ruby Tuesday", artist: "Rolling Stones")

triona = User.create(name: "Triona")
jonah = User.create(name: "Jonah")
eli = User.create(name: "Eli")
barak = User.create(name: "Barak")
barak_obama = User.create(name: "President Barak Obama")

triona.songs << song2
triona.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << hey_ya
eli.songs << love_will_tear_us_apart
eli.songs << love_will_tear_us_apart 
eli.songs << yesterday
eli.songs << yesterday
eli.songs << happy_birthday
eli.songs << happy_birthday
eli.songs << someday
eli.songs << someday
eli.songs << hey_ya
eli.songs << hey_ya 
eli.songs << eleanor_rigby
eli.songs << jesus_walks 
eli.songs << fun
eli.songs << song2 
eli.songs << ruby_tuesday 
barak.songs << ruby_tuesday
barak.songs << hey_ya
barak_obama.songs << jesus_walks
barak_obama.songs << happy_birthday