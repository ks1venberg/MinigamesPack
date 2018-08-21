require 'shoes'

 Shoes.app(title: "welcome to minigames pack!", width: 400, height: 500) do

   background gray

   stack(margin: 10) {
      flow do
        button "Slot machine"
        para "Try to win in this classic casino game!"
      end
      flow do
        button "Tic-Tac-Toe"
        para "Miss about school years?! If yes, try it!"
      end
    }

    stack do
      # widht & height values used from window_App size
      rect(70, 120, self.width - 140, self.height - 240, corners=4)
      background lightcoral
    end

 end