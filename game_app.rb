require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen

  def create_playzone
    # widht & height values used from window_App size
    playzone = rect(70, 110, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod) 
  end

  # Methods and variables _________________________________________________________________________
  def show_balance
    @balance = 200
    @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 80
  end


    stack(margin: 10) do
      flow do
        btn_slotmachine = button "Slot machine", width: 80 do
          show_balance
        

        end
        para "Try this classic casino game!", margin: 4
      end

      flow do
        btn_tictac = button "Tic-Tac-Toe", width: 80 do

        end
        para "Miss about school years?! Let's play!", margin: 4
      end
    end

    create_playzone

    flow left: self.width/2-self.width/5, top: self.height-80  do
      button "Restart", width: 60, margin: 2
      button "End", width: 60, margin: 2
      button "Exit App", width: 60, margin: 2
    end

end