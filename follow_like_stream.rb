
require 'twitter'
require 'dotenv'# n'oublie pas les lignes pour Dotenv ici…

Dotenv.load('.env')



def perform

	client = login  				#ce client c'est moi, mon compte, mes accès à Twitter
	
	clientStream = login_stream		#ce client c'est la version qui a accès à stream
	
	stream(clientStream, client)	#c'est la def finale qui utilise comme variable client et clientstream, qui correspondent respectivement à login et login_stream

end

def login
	return Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]		#la même chose que ce qu'on met sur tt nos fichiers.rb, donné par THP au début
	  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
	end
end


def login_stream
	return Twitter::Streaming::Client.new do |config|
	  config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
	  config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]			#spécial pour le stream, juste en changeant rest par streaming ça marche !
	  config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
	  config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
	end
end



def stream (clientStream,client)										#la def stream, qui applique donc le stream qui va automatiquement liker et follow tous ceux qui parlent de bonjour monde
	clientStream.filter(track: "#bonjour_monde") do |object|
		if object.is_a?(Twitter::Tweet) then 							#si l'objet est un tweet (un truc TWitter de type "tweet")
			print "Nouveau Tweet de : @#{object.user.screen_name} : "	#ça affiche une notif sur le terminal: un nouveau tweet de @bidule (truc établi par twitter, à ne pas changer) 
	  		puts object.text 											#affiche le texte du tweet
	  		client.follow(object.user)    #on follow la personne 
	  		client.fav object 											#on fav 
  		end
	end
end
perform