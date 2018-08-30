require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen

  # Methods and variables _________________________________________________________________________
  def show_balance
    balance = 200
    bal_msg = para "Your balance: ", strong(balance.to_s), align: 'center', top: 80
  end

  def create_handle
    @rcol = rect(297, 145, self.width*0.02, self.height*0.33, corners=4, fill: orange..red)
    @handle = oval(left: self.width*0.72, top: 140, radius: 15, fill: orangered)
      @handle.click {click_handle}
  end

  def remove_handle
    @handle.remove
    @rcol.remove
  end

  def click_handle
      @anm = animate(30) do |frame|
        @handle.top += 40
          if @handle.top >= 300
            @handle.displace(0, -160)
            @anm.stop
            #delete handle & create new one to restart animation
            remove_handle
            create_handle
          end
      end
  end

  def create_boxes
    #flow do
      @box1 = rect(105, self.height*0.45, @playzone.width/5, @playzone.height/5, corners=4, fill: white)
      @box2 = rect(115+@playzone.width/5, self.height*0.45, @playzone.width/5,  @playzone.height/5, corners=4, fill: white)
      @box3 = rect(130+(@playzone.width/5)*2, self.height*0.45, @playzone.width/5, @playzone.height/5, corners=4, fill: white)
    #end
  end


    stack(margin: 10) do
      flow do
        btn_slotmachine = button "Slot machine", width: 90, margin: 4  do
          show_balance
          create_handle
          create_boxes
        

        end
        para strong "Try this classic casino game!", stroke: white, margin: 4
      end

      flow do
        btn_tictac = button "Tic-Tac-Toe", width: 90, margin: 4 do

        end
        para strong "Hmm.. Miss about school years?!", stroke: white, margin: 4
      end
    end

    # widht & height values used in % of window_App size
    @playzone = rect(70, 110, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod)

    #control buttons
    flow(left: self.width*0.27, top: self.height-80)  do
      button "Restart", width: 60, margin: 2
      button "End", width: 60, margin: 2
      button "Exit App", width: 60, margin: 2
    end

end