require 'shoes'

 Shoes.app(title: "welcome to minigames pack!", width: 400, height: 460) do

   background darkgreen

   stack(margin: 10) do
      flow do
        button "Slot machine", width: 80
        para "Try this classic casino game!", margin: 4
      end
      flow do
        button "Tic-Tac-Toe", width: 80
        para "Miss about school years?! Let's play!", margin: 4
      end
    end

    #stack do
      fill darkgoldenrod
      # widht & height values used from window_App size
      rect(70, 110, self.width - 140, self.height - 200, corners=4)
    #end

    flow left: self.width/2-self.width/5, top: self.height-80  do
      button "Restart", width: 60, margin: 2
      button "End", width: 60, margin: 2
      button "Exit App", width: 60, margin: 2
    end

 end