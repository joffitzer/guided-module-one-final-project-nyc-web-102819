require 'pry'
require 'rest-client'
require 'net/http'
require 'uri'
require 'tty-prompt'
require 'figlet'
require 'colorize'
require 'colorized_string'

class PlaylistApp 

    def run
        figlet
        greeting
        found_user = select_profile
        interface(found_user).reload 
    end

    def figlet
    system "clear"
    puts " * " * 24
    puts ''                                                   
    puts ' _______    ___   ____    ____  __       __       _______.___________.'.colorize(:color => :black, :background => :green)
    puts '|   ____|  /   \  \   \  /   / |  |     |  |     /       |           |'.colorize(:color => :black, :background => :green)
    puts '|  |__    /  ^  \  \   \/   /  |  |     |  |    |   (----`---|  |----`'.colorize(:color => :black, :background => :green)
    puts '|   __|  /  /_\  \  \      /   |  |     |  |     \   \       |  |     '.colorize(:color => :black, :background => :green)     
    puts '|  |    /  _____  \  \    /    |  `----.|  | .----)   |      |  |     '.colorize(:color => :black, :background => :green)     
    puts '|__|   /__/     \__\  \__/     |_______||__| |_______/       |__|     '.colorize(:color => :black, :background => :green)
    puts '                                                                      '.colorize(:color => :black, :background => :green)    
    end 

    def greeting 
        puts ""
        puts " * " * 24
        puts ""
        puts "Welcome to FAVLIST - the Playlist App.".colorize(:green)
        puts ""
    end

    def select_profile
        prompt = TTY::Prompt.new
        choice = prompt.select("Please select your profile") do |menu|
            menu.choice "Jonah" 
            menu.choice "Triona" 
        end
        if choice == "Jonah"
           found_user = User.find_by(name: "Jonah")
        else  choice == "Triona"
            found_user = User.find_by(name: "Triona")
        end 
        found_user
    end

    def interface(found_user)
        system "clear"
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do?") do |menu|
            menu.choice "Make a new playlist" 
            menu.choice "View playlists" 
            menu.choice "Choose another profile"
            menu.choice "Log Out"
        end 
        if choice == "Make a new playlist"
            make_a_new_playlist_flow(found_user).reload 
        elsif choice == "View playlists"
            view_playlist_flow(found_user).reload
        elsif choice == "Choose another profile"
            run
        else choice == "Log Out"
            log_out
        end  
    end

    # FLOWS #
    
    def make_a_new_playlist_flow(found_user)
        time_range = playlist_time_range_prompt
        limit = playlist_limit_prompt(found_user)
        response = call_api(time_range, limit, found_user)
        response_hash = parse_response(response)
        add_to_songs_table(response_hash, limit)
        songs_for_playlist_array = add_songs_to_an_array(response_hash, limit)
        display_top_spotify_songs(response_hash, limit)
        create_playlist_response = create_playlist_prompt(found_user, songs_for_playlist_array)
    end 
    
    def make_a_new_playlist_flow_invalid_number(found_user)
        time_range = playlist_time_range_prompt
        limit = playlist_limit_prompt_if_error(found_user)
        response = call_api(time_range, limit, found_user)
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
        view_songs_in_playlist(chosen_playlist_response, found_user)
        prompt_to_delete_return_or_exit(found_user, chosen_playlist_response)
    end

    def view_playlist_flow_if_error(found_user)
        show_playlists_if_error(found_user)
        chosen_playlist_response = chosen_playlist_prompt
        view_songs_in_playlist(chosen_playlist_response, found_user)
        prompt_to_delete_return_or_exit(found_user, chosen_playlist_response)
    end

    # END FLOWS #
    
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

    def playlist_limit_prompt(found_user)
        system "clear"
        puts "How many songs do you want your playlist to have? (max 50)"
        limit = gets.chomp.to_i
        if limit > 0 && limit <= 50
            limit = limit 
        elsif limit > 50
            limit = 50
        else 
            puts "Please enter a number between 1 and 50:"
            make_a_new_playlist_flow_invalid_number(found_user)
        end
        limit
    end

    def playlist_limit_prompt_if_error(found_user)
        system "clear"
        puts "Please enter a valid number between 1 and 50:"
        puts ""
        puts "How many songs do you want your playlist to have? (max 50)"
        limit = gets.chomp.to_i
        if limit > 0 && limit < 50
            limit = limit 
        elsif limit > 50
            limit = 50
        else 
            puts "Please enter a number between 1 and 50:"
            make_a_new_playlist_flow_invalid_number(found_user)
        end
        limit
    end

    def call_api(time_range, limit, found_user)
        uri = URI.parse("https://api.spotify.com/v1/me/top/tracks?time_range=#{time_range}&limit=#{limit}")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        request["Accept"] = "application/json"
        if found_user.name == "Jonah"
            request["Authorization"] = "Bearer BQBhjDuA5nqhCMm8HoaVqGwGk0YlGBqA6_hU-XrgntF1MlOhIdUVihw57AmiZXkOohEhKBTbufFZFJBUMqH04DTd82CWfdCyyrb7ltccEJq4izdH7Yjf-SeLwjW0LyNjLfAIiHnq90nu_XPP7teK1S0"
        else
            request["Authorization"] = "Bearer BQC9IgehrONibEYJjQlxKnIUU4nKn8TnkVPDOTkPmf6qF9fvg00GepZv9Mp0u1RLEYy1R72hoeL7KF6X6pzV1aK-KdxQSYkDoZS9S9-CpT9zM1w8JOjv5k1r6sWnpsCw6ouxL1XgYRsOMlkxJqa3FF2VD96GG_Am6mrBz_A_gH2kBIA57BJlJOTV_X_mI5qEfpK0r-OKO3G-BaKjvVpdt3sFsI1-e5-UBMlE"
        end 
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
        # system "clear"
        puts "#{found_user.name}'s saved playlists:"
        puts ""
        playlists = found_user.playlists.reload
            playlists.each_with_index do |playlist, i|
                puts "#{i + 1}. #{playlist.name}"
            end 
        puts ""
    end 

    def show_playlists_if_error(found_user)
        puts "#{found_user.name}'s saved playlists:"
        puts ""
        playlists = found_user.playlists.reload
            playlists.each_with_index do |playlist, i|
                puts "#{i + 1}. #{playlist.name}"
            end 
        puts ""
        puts "Please enter a valid playlist name:"
    end 

    def chosen_playlist_prompt
        puts "Type a playlist name to view that playlist's songs:"
        gets.chomp 
    end

    def view_songs_in_playlist(chosen_playlist_response, found_user)
        system "clear"
        if Playlist.find_by(name: "#{chosen_playlist_response}")
            puts "Songs in #{chosen_playlist_response}:"
            puts ""
            po = Playlist.find_by(name: "#{chosen_playlist_response}")
            po.songs.each_with_index do |song, i|
                puts "#{i + 1}. #{song.title} - #{song.artist}"
            end
            first_song = po.songs.first.title
            system("spotify play #{first_song}")
        else 
            view_playlist_flow_if_error(found_user)
        end 
            puts ""
    end 

    def prompt_to_delete_return_or_exit(found_user, chosen_playlist_response)
        prompt = TTY::Prompt.new
        choice = prompt.select("What would you like to do next?") do |menu|
            menu.choice "Rename this playlist"
            menu.choice "Delete this playlist"
            menu.choice "Return to Main Menu" 
            menu.choice "Choose another profile"
            menu.choice "Log Out" 
        end
        if choice == "Rename this playlist"
            stop_spotify
            rename_playlist(chosen_playlist_response, found_user)
        elsif choice == "Delete this playlist"
            stop_spotify
            delete_playlist(chosen_playlist_response)
            system "clear"
            view_playlist_flow(found_user).reload
        elsif choice == "Return to Main Menu"
            stop_spotify
            interface(found_user).reload 
        elsif choice == "Choose another profile"
            run
        else choice == "Log Out"
            stop_spotify
            log_out
        end
    end  

    def stop_spotify
        system("spotify stop")
    end 

    def rename_playlist(chosen_playlist_response, found_user)
        puts "Choose a new name for this playlist:"
        new_playlist_name = gets.chomp
        found_playlist = Playlist.find_by(name: "#{chosen_playlist_response}")
        found_playlist.name = new_playlist_name 
        found_playlist.save
        view_playlist_flow(found_user).reload
    end 

    def delete_playlist(chosen_playlist_response)
        pl_to_delete = Playlist.find_by(name: "#{chosen_playlist_response}")
        pl_to_delete.destroy
    end 

    def log_out
        system "clear"
        puts ''                               
        puts '     _____           _ _              '.colorize(:color => :black, :background => :green)
        puts '    |   __|___ ___ _| | |_ _ _ ___    '.colorize(:color => :black, :background => :green)
        puts '    |  |  | . | . | . | . | | | -_|   '.colorize(:color => :black, :background => :green)
        puts '    |_____|___|___|___|___|_  |___|   '.colorize(:color => :black, :background => :green)
        puts '                          |___|       '.colorize(:color => :black, :background => :green)
        puts '                                      '
        exit 
    end 

end 