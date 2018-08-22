require 'shoes'

 Shoes.app(title: "welcome to minigames pack!", width: 400, height: 500) do

   background skyblue

   stack(margin: 10) do
      flow do
        button "Slot machine"
        para "Try to win in this classic casino game!"
      end
      flow do
        button "Tic-Tac-Toe"
        para "Miss about school years?! If yes, try it!"
      end
    end

    #stack do
      fill lightsalmon
      # widht & height values used from window_App size
      rect(70, 120, self.width - 140, self.height - 240, corners=4)
    #end

    flow left: self.width/2-self.width/10, top: self.height-110  do
      button "Restart"
      button "End"
      button "Exit App"
    end

 end