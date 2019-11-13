require 'pry'
require 'rest-client'
require 'net/http'
require 'uri'
require 'tty-prompt'

class PlaylistApp 

    def run
        greeting
        found_user = select_profile
        interface(found_user)
    end

    def greeting 
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
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do?") do |menu|
            menu.choice "Make a new playlist" 
            menu.choice "View playlists" 
            menu.choice "Log Out"
        end 
        if choice == "Make a new playlist"
            make_a_new_playlist_flow(found_user)
        elsif choice == "View playlists"
            view_playlist_flow(found_user)
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
        prompt_to_return_or_exit(found_user)
    end
    
    def playlist_time_range_prompt
        prompt = TTY::Prompt.new
        puts "Please answer the following questions to make your playlist:"
        choice = prompt.select("Would you like the time range to be long_term, medium_term, or short_term?") do |menu|
            menu.choice "Short-term" 
            menu.choice "Medium-term" 
            menu.choice "Long-term" 
        end 
        if choice == 'Short-term'
            time_range = "short_term"
        elsif choice == 'Medium-term'
            time_range = "medium_term"
        else choice == 'Long-term'
            time_range = "long_term"
        end 
        time_range 
    end

    def playlist_limit_prompt
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
        request["Authorization"] = "Bearer BQAfp8PUPXD85y557NRpbDqQVC_ezmf9vzBsjLhMGpoxiOkU-k80QQH8rqhZit2oaKfNCBfE3ZRghcFz8AWLzbS_E3Uo8E6BMWJkOs7gfvg94YViQKAEVMM0jEOmXuZEme8F1GcVlSh0apURpSk3sfI"

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
        limit.to_i.times do |count|
        puts "#{count + 1}. #{response_hash["items"][count]["album"]["artists"][0]["name"]} - #{response_hash["items"][count]["name"]}"
        end
    end

    def create_playlist_prompt(found_user, songs_for_playlist_array)
        prompt = TTY::Prompt.new 
        choice = prompt.select("Would you like to save these songs as a playlist?") do |menu|
            menu.choice "Yes" 
            menu.choice "No" 
        end 
        if choice == "Yes"
            create_playlist_flow(found_user, songs_for_playlist_array)
        else choice == "No" 
            interface(found_user)
        end
    end

    def create_playlist(found_user, songs_for_playlist_array)
        puts "Please choose a name for your playlist:"
        pl_name = gets.chomp
        new_pl = Playlist.create(name: "#{pl_name}", user_id:found_user.id) 
        new_pl.songs = songs_for_playlist_array
    end

    def show_playlist_prompt(found_user)
        prompt = TTY::Prompt.new 
        choice = prompt.select("Would you like to see your playlists?") do |menu|
            menu.choice "Yes" 
            menu.choice "No" 
        end 
        if choice == "Yes"
            view_playlist_flow(found_user)
        else choice == "No" 
            interface(found_user)
        end
    end 

    def find_a_users_playlists
        jonah = User.find_by(name: "Jonah")
        jonah.playlists
    end 

    def show_playlists(found_user)
        playlists = found_user.playlists
            playlists.each_with_index do |playlist, i|
                puts "#{i + 1}. #{playlist.name}"
            end 
    end 

    def chosen_playlist_prompt
        puts "Select a playlist to view that playlist's songs:"
        gets.chomp 
    end 

    def view_songs_in_playlist(chosen_playlist_response)
        po = Playlist.find_by(name: "#{chosen_playlist_response}")
        po.songs.each_with_index do |song, i|
            puts "#{i + 1}. #{song.title} - #{song.artist}"
        end
    end 

    def prompt_to_return_or_exit(found_user)
        prompt = TTY::Prompt.new
        choice = prompt.select("Would you like to return to the main menu, or log out?") do |menu|
            menu.choice "Return to Main Menu" 
            menu.choice "Log Out" 
        end
        if choice == "Return to Main Menu"
            interface(found_user) 
        else choice == "Log Out"
           puts "Have a nice day. Goodbye!"
        end
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

