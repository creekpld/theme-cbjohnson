function brewup -d "upgrade and cleanup brew and brew casks"
	brew update; brew upgrade; brew cask upgrade; brew cleanup;
end