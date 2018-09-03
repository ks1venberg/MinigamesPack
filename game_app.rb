require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen
  # Methods and variables _________________________________________________________________________
  @slotboxes = {}
  @tictboxes = {}
  @balance = nil

  def sizes
    # size of general layout
    @xselfmid = self.width*0.5
    @yselfmid = self.height*0.5

    # variables and coordinates for boxes in playzone
    #borders of playzone
      @xplayleft = @playzone.left
      @yplaytop = @playzone.top
    #box params
      @boxwidth = @playzone.width / 5
      @boxheight = @boxwidth
      @step = 10
    # start position for adding boxes to playzone
      @yplaycenter = @yplaytop + @playzone.height / 2 - @boxwidth / 2
      @xboxleft = @xplayleft + @step*3
    # above param used only for TicTacToe
      @yboxtop = @yplaycenter - @boxheight*1.5 - @step
  end

  def show_balance
    c = 200
    @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 80
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
    sizes
      if @balance == nil
        1.upto(3) do |i|

          box = rect(@xboxleft, @yplaycenter, @boxwidth, @boxheight, corners=4, fill: white)
          @slotboxes["box"<<i.to_s] = "#{box.left}, #{box.top}"
          @xboxleft = ("#{box.left}".to_i + @boxwidth + @step)
      end
        end

  end
 
    stack(margin: 10) do
      flow(margin: 2) do
        btn_slotmachine = button "Slot machine", width: 90, heigth: 35, margin_right: 4 do
          show_balance
          create_handle
          create_boxes
          #slot_alert
        

        end
        para strong "Play this classic casino game!", stroke: white
      end

      flow(margin: 2) do
        btn_tictac = button "Tic-Tac-Toe", width: 90, heigth: 35, margin_right: 4 do

        end
        para strong "Miss about school years? Try it!", stroke: white
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