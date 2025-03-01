require 'pry'
require_relative '../config/environment'

def welcome 
title=Artii::Base.new(:font=> "cosmic")
puts "Welcome to"
puts title.asciify("Command Theater").colorize(:blue)
end


def signup 
  
    prompt = TTY::Prompt.new
    login_choice = prompt.select("New users please Sign Up",["Sign Up", "Login", ("Exit").colorize(:red)]) #could say "Log in or new user please sign up and put login back in as an option IF
   
    if (login_choice == "Sign Up")
        $new_username = prompt.ask("What is your username?")
        $new_password = prompt.ask("What is your password? Must only include numbers")
        $g = Guest.create(name: "#{$new_username}", password: "#{$new_password}")
        
            puts "Lets start watching!"
    elsif login_choice == "Login"
        name = prompt.ask("What username?")
        password = prompt.ask("What pass?")
        users = Guest.all.map{|u| u.name}
        if users.include?(name) && Guest.find_by(password: password)
            $g = Guest.find_by(name: name)
            puts "Hello #{$g.name}."
            guest_choice = prompt.select("What would you like to do?", ["Review Orders", "Continue Browsing"])
                if guest_choice == "Review Orders"
                    puts $g.tickets
                    option = prompt.select("What next?", ["Cancel Ticket", "Continue Browsing"])
                    if option == "Cancel Ticket"
                        $g.tickets.delete
                        puts "#{$g.name}, your ticket has been deleted."
                        exit!
                    end
                elsif guest_choice == "Continue Browsing"
                    search
                end            
        end
        else 
            exit!
        end
    end

def search
    movies = Movie.all.map {|movie| movie.title}
    genres = Genre.all.map {|genre| genre.genre}
    prompt = TTY::Prompt.new
    search_choice = prompt.select("What would you like to see?", ["All Movies", "Genres"])
    if (search_choice == "All Movies")
        prompt = TTY::Prompt.new
        choice = prompt.select("Pick a movie", movies)
        puts "You selected #{choice}!!! We love that one!"
        select_movie = Movie.find_by(title: choice)
    
        menu_options = prompt.select("What would you like to do next", ["Purchase Ticket"])
        if menu_options == "Purchase Ticket"
            puts "Here is your ticket! Excited yet?!"
            your_ticket = Ticket.create(theater_id: Theater.all.first.id, movie_id: select_movie.id, guest_id: $g.id) 
            puts your_ticket
            puts ("Please save this id for your confirmation number.").colorize(:magenta) 
            puts "You're going to see the #{select_movie.genre.genre}, #{your_ticket.movie.title}, @ #{select_movie.showtime} "
        end
        
    elsif (search_choice == "Genres")
            prompt = TTY::Prompt.new
            genre_choice = prompt.select("Pick a genre", genres)
            puts "You selected #{genre_choice}. That's a popular one!"
            select_genre = Genre.find_by(genre: genre_choice)
             genre_titles = select_genre.movies.map {|movie| movie.title}
            prompt = TTY::Prompt.new
            genre_movie_choice = prompt.select("Which movie?", genre_titles)
            ticket_choice = Movie.find_by(title: genre_movie_choice)
           
    
            prompt = TTY::Prompt.new
            menu_options = prompt.select("What would you like to do next", ["Purchase Ticket"])
                if (menu_options == "Purchase Ticket")
                    puts "Here is your ticket! Excited yet?!"
                    your_ticket = Ticket.create(theater_id: Theater.all.first.id, movie_id: ticket_choice.id, guest_id: $g.id) 
                    puts your_ticket
                    puts ("Please save this id for your confirmation number.").colorize(:magenta)
                    puts "You're going to see a #{ticket_choice.genre.genre} movie, #{your_ticket.movie.title}, @ #{ticket_choice.showtime} "
        end
    end
end

    def thanks
        puts "Thank you for your purchase! We cant wait to watch a movie with you!"
        prompt = TTY::Prompt.new
        thanks_choice = prompt.ask("Please leave us a rating from 1-5")
        puts ("Thank you for your feedback!").colorize(:yellow)

        end


welcome
signup
search
thanks