class PlaylistApp 

    def run
        greeting
        user_input = get_user_input
        found_user = find_user_name(user_input)
        users_songs = find_a_users_songs(found_user)
        show_songs(users_songs)
        top_five_response = top_five_prompt
        show_top_five_songs(top_five_response, users_songs)

    end

    def greeting 
        puts "Welcome to the Playlist App."
    end

    def get_user_input
        puts "Please enter your user name to see your song library:"
        gets.chomp
    end

    def find_user_name(user_input)
        found_user = User.find_by(name: "#{user_input}")
    end

    def find_a_users_songs(found_user)
        found_user.songs
    end 

    def show_songs(users_songs)
        unique_songs = users_songs.uniq 
        unique_songs.each_with_index do |song, i|
            puts "#{i + 1}. #{song.title} - #{song.artist}"
        end 
    end 

    def top_five_prompt 
        puts " * " * 10
        puts "Would you like to see your top 5 songs? (Yes/No)"
        gets.chomp 
    end 

    # def show_top_five_songs(top_five_response, users_songs)
    #     if top_five_response == "Yes"
    #         my_song_titles = users_songs.map do |s|
    #             s.title
    #         end 
    #         p my_song_titles
    #     else 
    #         puts "Have a nice day!"
    #     end 
    # end 

    def show_top_five_songs(top_five_response, users_songs)
        if top_five_response == "Yes"
            a = users_songs.map do |s|
                s.title
            end 
            a.uniq.each do |s| 
                puts "#{a.count(s)} - #{s}"
            end
        else 
            puts "Have a nice day!"
        end 
    end 

end