require 'pry'
require 'rest-client'
require 'net/http'
require 'uri'

class PlaylistApp 

    def run
        greeting
        type = playlist_type_prompt
        time_range = playlist_time_range_prompt
        limit = playlist_limit_prompt
        response = call_api(type, time_range, limit)
        response_hash = parse_response(response)
        display_top_spotify_songs(response_hash, limit)
        run_after_greeting
    end

    def greeting 
        puts " * " * 10
        puts "Welcome to the Playlist App."
    end

    def playlist_type_prompt
        puts "Would you like to make a playlist of your favorite tracks or artists?"
        gets.chomp
    end

    def playlist_time_range_prompt
        puts "Would you like the time range to be long_term, medium_term, short_term?"
        gets.chomp
    end

    def playlist_limit_prompt
        puts "How many songs do you want your playlist to have?"
        gets.chomp
    end

    def call_api(type, time_range, limit)
        uri = URI.parse("https://api.spotify.com/v1/me/top/#{type}?time_range=#{time_range}&limit=#{limit}")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        request["Accept"] = "application/json"
        request["Authorization"] = "Bearer BQAqsq3IElF7dCJsEXdB9wAkGQWAZgGKM-9V3L0JC7w1Hhb2l565bb1ED2qdFqRGRPC5lj3HKej7V8sCySE65uMUkGj8Z2E9NTpPKyLsLdc32t6QS5qpHEdUf5n_V7dZaLY7UGzhL7RccLXmcPvsU94"

        req_options = {
        use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
        end

        # binding.pry
    end

    def parse_response(response)
        JSON.parse(response.body)
    end

    def display_top_spotify_songs(response_hash, limit)
            limit.to_i.times do |count|
            puts "#{response_hash["items"][count]["album"]["artists"][0]["name"]} - #{response_hash["items"][count]["name"]}"
            end
    end
    
    
    #hash["items"][0]["album"]["artists"][0]["name"]
    #returns Artist name as a string
    #hash["items"][0]["name"]
    #returns Song name as a string



    def get_user_input
        puts "Please enter your username:"
        gets.chomp
    end

    def find_user_name(user_input)
        a = User.all.map do |u|
            u.name
        end 
        if a.include?(user_input)
            found_user = User.find_by(name: "#{user_input}")
        else 
            puts "Please enter a valid username"
            puts " * " * 10
            run_after_greeting
        end 
    end

    def find_a_users_songs(found_user)
        found_user.songs
    end 

    def find_a_users_playlists(found_user)
        found_user.playlists
    end 

    def show_playlist_prompt
        puts "Would you like to see your playlists? (Yes/No)"
        gets.chomp
    end 

    def chosen_playlist_prompt
        puts "Select a playlist to view that playlist's songs:"
        gets.chomp 
    end 

    def show_songs(users_songs)
        unique_songs = users_songs.uniq 
        unique_songs.each_with_index do |song, i|
            puts "#{i + 1}. #{song.title} - #{song.artist}"
        end 
    end 

    def show_playlists(users_playlists, show_playlist_response)
        playlists = users_playlists
        if show_playlist_response == "Yes"
            playlists.each_with_index do |playlist, i|
                puts "#{i + 1}. #{playlist.name}"
            end 
        else 
            puts "No problem! There's more that this app can do..."
            puts " * " * 10
        end 
    end 

    def view_songs_in_playlist(chosen_playlist_response)
        po = Playlist.find_by(name: "#{chosen_playlist_response}")
        po.songs.each_with_index do |song, i|
            puts "#{i + 1}. #{song.title} - #{song.artist}"
        end 
    end 

    def top_five_prompt 
        puts " * " * 10
        puts "Would you like to see your top 5 songs? (Yes/No)"
        gets.chomp 
    end 

    def top_songs_in_order(users_songs)
        array_of_titles = users_songs.map do |s|
            s.title
        end 
        titles_sorted_by_count = array_of_titles.sort_by do |s| 
            array_of_titles.count(s)
        end
        titles_in_order = titles_sorted_by_count.reverse
        top_five_titles_array = titles_in_order.uniq
    end

    #this is the new one 
    def top_song_titles(users_songs)
        array_of_titles = users_songs.map do |s|
            s.title
        end 
        titles_sorted_by_count = array_of_titles.sort_by do |s| 
            array_of_titles.count(s)
        end
        titles_in_order = titles_sorted_by_count.reverse
        top_five_titles_array = titles_in_order.uniq
        objects = top_five_titles_array.map do |s|
             Song.find_by(title: "#{s}")
        end 
        objects 
    end


    def top_song_objects(users_songs)
        array_of_song_titles = users_songs.map do |s|
            s.title
        end 
        songs_sorted_by_count = array_of_songs.sort_by do |s| 
            array_of_songs.count(s)
        end
        songs_in_order = songs_sorted_by_count.reverse
        top_songs_array = songs_in_order.uniq
        top_songs_array.map do |s|
        end 
    end 

    def run_after_greeting
        user_input = get_user_input
        found_user = find_user_name(user_input)
        users_songs = find_a_users_songs(found_user)
        show_songs(users_songs)
        top_five_response = top_five_prompt
        show_top_five_songs(top_five_response, users_songs)
        create_playlist_response = create_playlist_prompt
        song_object_array = top_song_titles(users_songs)
        create_top_five_playlist(create_playlist_response, found_user, users_songs, song_object_array)
        show_playlist_response = show_playlist_prompt 
        users_playlists = find_a_users_playlists(found_user)
        show_playlists(users_playlists, show_playlist_response)
        chosen_playlist_response = chosen_playlist_prompt 
        view_songs_in_playlist(chosen_playlist_response)
        plays_by_title_response = plays_by_title_prompt 
        plays_by_title(plays_by_title_response, users_songs)
        continue_response = prompt_to_continue
        continue_or_log_out(continue_response)
    end 

    def show_top_five_songs(top_five_response, users_songs)
        if top_five_response == "Yes"
            top_five_titles_array = top_songs_in_order(users_songs).take(5)
            puts " * " * 10
            puts "Here are the 5 songs you've listened to the most, in order:"
            top_five_titles_array.each_with_index do |s, i|
                puts "#{i + 1}. #{s}"
            end 
            puts " * " * 10 
        else 
            puts "No problem! There's more that this app can do..."
            puts " * " * 10
        end 
    end 

    # def show_top_five_songs(top_five_response, users_songs)
    #     if top_five_response == "Yes"
    #         array_of_titles = users_songs.map do |s|
    #             s.title
    #         end 
    #         titles_sorted_by_count = array_of_titles.sort_by do |s| 
    #             array_of_titles.count(s)
    #         end
    #         titles_in_order = titles_sorted_by_count.reverse
    #         top_five_titles_array = titles_in_order.uniq.take(5)
    #         puts " * " * 10
    #         puts "Here are the 5 songs you've listened to the most, in order:"
    #         top_five_titles_array.each_with_index do |s, i|
    #             puts "#{i + 1}. #{s}"
    #         end 
    #         puts " * " * 10 
    #     else 
    #         puts "No problem! There's more that this app can do..."
    #         puts " * " * 10
    #     end 
    # end 

    def plays_by_title_prompt
        puts "Please enter a song title to see the number of times you played that song:"
        gets.chomp 
    end 

    def plays_by_title(plays_by_title_response, users_songs)
            a = users_songs.map do |s|
                s.title
            end 
            if a.include?(plays_by_title_response)
                b = a.select do |s| 
                    s == plays_by_title_response
                end
                puts "You played #{plays_by_title_response} #{b.count} times." 
                puts " * " * 10
            else 
                puts "You did not play #{plays_by_title_response} any times."
            end 
    end 

    def prompt_to_continue
        puts "Would you like to return to the beginning, or log out?"
        puts "Please type 'Return' or 'Log Out'" 
        gets.chomp 
    end 

    def continue_or_log_out(continue_response)
        if continue_response == "Return"
            run_after_greeting
        elsif continue_response == "Log Out"
            puts " * " * 10 
            puts "Have a nice day. Goodbye!"
            puts " * " * 10 
        else 
            puts "Please enter a valid response."
            puts " * " * 10 
            continue_response = prompt_to_continue
            continue_or_log_out(continue_response)
        end 
    end 

    def create_playlist_prompt
        puts "Would you like to save these songs as a playlist?"
        puts "Please type 'Yes' or 'No'"
        gets.chomp
    end

    def create_top_five_playlist(create_playlist_response, found_user, users_songs, song_object_array)
        if create_playlist_response == "Yes"
            puts "Please choose a name:"
            pl_name = gets.chomp
            new_pl = Playlist.create(name: "#{pl_name}", user_id:found_user.id) 
            new_pl.songs = song_object_array.take(5)
        end
    end

end