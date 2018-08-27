require 'shoes'

class Gameconstuct
  def initialize
    @balance = balance
  end

  attr_accessor :balance

end

 Shoes.app(title: "welcome to minigames pack!", width: 400, height: 460) do

   background darkgreen

   stack(margin: 10) do
      flow do
        button "Slot machine", width: 80 do
          #balance_field
          @balance = 200
          @bal_msg.replace "Your balance: ", strong(@balance.to_s), align: 'center', top: 70
          # @bal_txt = strong "Your balance: ", align: 'center', top: 60
        end
        para "Try this classic casino game!", margin: 4
      end

      flow do
        button "Tic-Tac-Toe", width: 80
        para "Miss about school years?! Let's play!", margin: 4
      end

      @bal_msg = para ""
    end

    fill darkgoldenrod
    # widht & height values used from window_App size
    rect(70, 110, self.width - 140, self.height - 200, corners=4)

    flow left: self.width/2-self.width/5, top: self.height-80  do
      button "Restart", width: 60, margin: 2
      button "End", width: 60, margin: 2
      button "Exit App", width: 60, margin: 2
    end

 end