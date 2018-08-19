require 'shoes'
SHOES_USE_INSTALLED = true

 Shoes.app do
   background "#DFA"
   para "welcome to minigames pack!"

   stack {
          button "Game 1"
          button "Game 2"
          button "Game 3"
        }
 end