require 'pry'
require 'rest-client'
require 'net/http'
require 'uri'
require 'tty-prompt'

class PlaylistApp 

    def run
        greeting
        found_user = select_profile
        interface(found_user).reload 
    end

    def greeting 
        system "clear"
        puts " * " * 10
        puts "Welcome to the Playlist App."
    end

    def select_profile
        prompt = TTY::Prompt.new
        choice = prompt.select("Please select your profile") do |menu|
            menu.choice "Jonah" 
            menu.choice "Triona" 
        end
        if choice == "Jonah"
           found_user = User.find_by(name: "Jonah")
        end
        found_user
    end

    def interface(found_user)
        system "clear"
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do?") do |menu|
            menu.choice "Make a new playlist" 
            menu.choice "View playlists" 
            menu.choice "Log Out"
        end 
        if choice == "Make a new playlist"
            make_a_new_playlist_flow(found_user).reload 
        elsif choice == "View playlists"
            view_playlist_flow(found_user).reload
        else choice == "Log Out"
            puts "Goodbye!"
            exit 
        end  
    end

    # FLOWS #
    # PLAYLIST FLOW #
    
    def make_a_new_playlist_flow(found_user)
        time_range = playlist_time_range_prompt
        limit = playlist_limit_prompt
        response = call_api(time_range, limit)
        response_hash = parse_response(response)
        add_to_songs_table(response_hash, limit)
        songs_for_playlist_array = add_songs_to_an_array(response_hash, limit)
        display_top_spotify_songs(response_hash, limit)
        create_playlist_response = create_playlist_prompt(found_user, songs_for_playlist_array)
    end 

    def create_playlist_flow(found_user, songs_for_playlist_array)
        create_playlist(found_user, songs_for_playlist_array)
        show_playlist_response = show_playlist_prompt(found_user)
        users_playlists = find_a_users_playlists
        view_playlist_flow(found_user)
    end

    def view_playlist_flow(found_user)
        show_playlists(found_user)
        chosen_playlist_response = chosen_playlist_prompt 
        view_songs_in_playlist(chosen_playlist_response)
        prompt_to_delete_return_or_exit(found_user, chosen_playlist_response)
    end
    
    def playlist_time_range_prompt
        system "clear"
        prompt = TTY::Prompt.new
        puts "Please answer the following questions to make your playlist:"
        puts ""
        choice = prompt.select("Would you like to see your favorite songs from the past 4 weeks, 6 months or all-time?") do |menu|
            menu.choice "4 Weeks" 
            menu.choice "6 months" 
            menu.choice "All-time" 
        end 
        if choice == '4 Weeks'
            time_range = "short_term"
        elsif choice == '6 months'
            time_range = "medium_term"
        else choice == 'All-time'
            time_range = "long_term"
        end 
        time_range 
    end

    def playlist_limit_prompt
        system "clear"
        puts "How many songs do you want your playlist to have? (max 50)"
        limit = gets.chomp.to_i
            if limit > 50
                limit = 50
            end
        limit
    end

    def call_api(time_range, limit)
        uri = URI.parse("https://api.spotify.com/v1/me/top/tracks?time_range=#{time_range}&limit=#{limit}")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        request["Accept"] = "application/json"
        request["Authorization"] = "Bearer BQC5oEVesPCM42-BqrJlmsmBv5A81PLCqhrSU3MkS_z0ga152KPkCFxqdPsclmZRbB5dnjX1VhjiREF7Mp6LR01xfAv8SzXALEcAIZbQ1B6u5zwqOKH0wVU0ccDhYotwh4YPD8SLI5Y5nXpZafLDhik"

        req_options = {
        use_ssl: uri.scheme == "https",
        }

        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
        end
    end

    def parse_response(response)
        JSON.parse(response.body)
    end

    def add_to_songs_table(response_hash, limit)
        limit.to_i.times do |count|
            if !Song.all.exists?(title: "#{response_hash["items"][count]["name"]}")
                Song.create(title: "#{response_hash["items"][count]["name"]}", artist: "#{response_hash["items"][count]["album"]["artists"][0]["name"]}") 
            end 
        end
    end

    def add_songs_to_an_array(response_hash, limit)
        song_array = []
        limit.to_i.times do |count|
            song_array << Song.find_by(title: "#{response_hash["items"][count]["name"]}")
        end 
        song_array
    end 

    def display_top_spotify_songs(response_hash, limit)
        system "clear"
        puts "Here are your top #{limit} songs from that time frame:"
        puts ""
        limit.to_i.times do |count|
        puts "#{count + 1}. #{response_hash["items"][count]["album"]["artists"][0]["name"]} - #{response_hash["items"][count]["name"]}"
        end
        puts ""
    end

    def create_playlist_prompt(found_user, songs_for_playlist_array)
        prompt = TTY::Prompt.new 
        choice = prompt.select("Would you like to save these songs as a playlist?") do |menu|
            menu.choice "Yes" 
            menu.choice "No" 
        end 
        if choice == "Yes"
            create_playlist_flow(found_user, songs_for_playlist_array).reload 
        else choice == "No" 
            interface(found_user).reload 
        end
    end

    def create_playlist(found_user, songs_for_playlist_array)
        system "clear"
        puts "Please choose a name for your playlist:"
        pl_name = gets.chomp
        new_pl = Playlist.create(name: "#{pl_name}", user_id:found_user.id) 
        new_pl.songs = songs_for_playlist_array
    end

    def show_playlist_prompt(found_user)
        system "clear"
        prompt = TTY::Prompt.new 
        choice = prompt.select("Would you like to see your playlists?") do |menu|
            menu.choice "Yes" 
            menu.choice "No" 
        end 
        if choice == "Yes"
            view_playlist_flow(found_user).reload
        else choice == "No" 
            interface(found_user).reload 
        end
    end 

    def find_a_users_playlists
        jonah = User.find_by(name: "Jonah")
        jonah.playlists
    end 

    def show_playlists(found_user)
        system "clear"
        puts "#{found_user.name}'s saved playlists:"
        puts ""
        playlists = found_user.playlists.reload
            playlists.each_with_index do |playlist, i|
                puts "#{i + 1}. #{playlist.name}"
            end 
        puts ""
    end 

    def chosen_playlist_prompt
        puts "Type a playlist name to view that playlist's songs:"
        gets.chomp 
    end 

    def view_songs_in_playlist(chosen_playlist_response)
        system "clear"
        puts "Songs in #{chosen_playlist_response}:"
        puts ""
        po = Playlist.find_by(name: "#{chosen_playlist_response}")
        po.songs.each_with_index do |song, i|
            puts "#{i + 1}. #{song.title} - #{song.artist}"
        end
        puts ""
    end 

    def prompt_to_delete_return_or_exit(found_user, chosen_playlist_response)
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to return to the main menu, or log out?") do |menu|
            menu.choice "Delete this playlist"
            menu.choice "Return to Main Menu" 
            menu.choice "Log Out" 
        end
        if choice == "Delete this playlist"
            delete_playlist(chosen_playlist_response)
            show_playlists(found_user)
            view_playlist_flow(found_user).reload
        elsif choice == "Return to Main Menu"
            interface(found_user).reload 
        else choice == "Log Out"
           puts "Have a nice day. Goodbye!"
           exit
        end
    end 

    def delete_playlist(chosen_playlist_response)
        pl_to_delete = Playlist.find_by(name: "#{chosen_playlist_response}")
        pl_to_delete.destroy 
    end 

    # END PLAYLIST FLOW #

    # HELPER? #

    def find_a_users_songs(found_user)
       songs = found_user.playlists.songs.map do |song|
            song.title
        end
        p songs.uniq
    end

end 


    # def get_user_input
    #     puts "Please enter your username:"
    #     gets.chomp
    # end

    # def find_user_name(user_input)
    #     a = User.all.map do |u|
    #         u.name
    #     end 
    #     if a.include?(user_input)
    #         found_user = User.find_by(name: "#{user_input}")
    #     else 
    #         puts "Please enter a valid username"
    #         puts " * " * 10
    #         run_after_greeting
    #     end 
    # end

    # def show_songs(users_songs)
    #     unique_songs = users_songs.uniq 
    #     unique_songs.each_with_index do |song, i|
    #         puts "#{i + 1}. #{song.title} - #{song.artist}"
    #     end 
    # end 
    
    # def prompt_to_continue
    #     puts "Would you like to return to the beginning, or log out?"
    #     puts "Please type 'Return' or 'Log Out'" 
    #     gets.chomp 
    # end 

    # def continue_or_log_out(continue_response)
    #     if continue_response == "Return"
    #         interface 
    #     elsif continue_response == "Log Out"
    #         puts " * " * 10 
    #         puts "Have a nice day. Goodbye!"
    #         puts " * " * 10 
    #     else 
    #         puts "Please enter a valid response."
    #         puts " * " * 10 
    #         continue_response = prompt_to_continue
    #         continue_or_log_out(continue_response)
    #     end 
    # end 

