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

75.times do
    eli.songs << love_will_tear_us_apart
end 
3.times do
    eli.songs << yesterday
end 
56.times do
    eli.songs << love_will_tear_us_apart
end 
83.times do
    eli.songs << happy_birthday
end 
25.times do
    eli.songs << someday
end 
26.times do
    eli.songs << hey_ya
end 
49.times do
    eli.songs << eleanor_rigby
end 
8.times do
    eli.songs << jesus_walks 
end 
13.times do
    eli.songs << fun
end 
17.times do
    eli.songs << song2 
end 

barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << ruby_tuesday
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << hey_ya
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << happy_birthday
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << yesterday 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << love_will_tear_us_apart 
barak.songs << someday  
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak.songs << someday 
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << jesus_walks
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << happy_birthday
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
barak_obama.songs << fun 
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << song2
triona.songs << eleanor_rigby
triona.songs << eleanor_rigby
triona.songs << eleanor_rigby
triona.songs << eleanor_rigby
triona.songs << eleanor_rigby
triona.songs << fun 
triona.songs << fun 
triona.songs << fun 
triona.songs << fun 
triona.songs << fun 
triona.songs << fun 
triona.songs << fun 
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << eleanor_rigby
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << hey_ya
jonah.songs << yesterday
jonah.songs << yesterday
jonah.songs << yesterday
jonah.songs << yesterday
jonah.songs << yesterday
jonah.songs << yesterday
jonah.songs << someday
jonah.songs << someday
jonah.songs << someday
jonah.songs << ruby_tuesday
jonah.songs << ruby_tuesday
jonah.songs << ruby_tuesday

