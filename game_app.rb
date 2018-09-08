require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen
  # Methods and variables _________________________________________________________________________
  @boxes = {}

  def sizes
    # size of general layout
    @xselfmid = self.width*0.5
    @yselfmid = self.height*0.5

    # size of playzone (260x242 px from 400x440)
    @plwidth = self.width*0.65
    @plheight = self.height*0.55

    # variables and coordinates for boxes in playzone
    #borders of playzone
      @xplayleft = @playzone.left
      @yplaytop = @playzone.top
    #box params (52 px)
      @boxside = @plwidth / 5
      @step = 10
    # start position for adding boxes to playzone
      @yplaycenter = @yplaytop + @plheight/2 - @boxside/2
      @xboxleft = @xplayleft + @step*3
    # above param used only for TicTacToe
      @yboxtop = @yplaycenter - @boxside - @step
  end

  def show_balance
    @balance = 200
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
        @boxes.each_value do |value|
          value.each do |x, y|
            @num = para strong(rand(0..9).to_s), size: 36, left: x.to_i + @boxside*0.3, top: @yplaycenter
          end
        end
        @handle.top += 40

        if @handle.top >= 300
          @handle.displace(0, -160)

            @anm.stop
            @num.clear
            # @boxes.each_value do |value|
            #   value.each do |x, y|
            #     @num = para strong("0"), size: 36, left: x.to_i + @boxside*0.3, top: @yplaycenter
            #   end
            # end
              #delete handle & create new one to restart animation
              remove_handle
              create_handle
        end
      end
  end

  def g1start_alert
    timer 0.5 do
      stack margin_left: 2, align:'left' do
        alert(
        "       Three equal numbers gives you +10$
        Magic combi (777, 333, 555) gives you +100$
        Different numbers takes -5$
        Three zeroes - you`re bancrupt\n
        Push the handle, and good luck!")
      end
    end
  end

  def create_boxes
    sizes
       # first, is to check wich game has started and so decide about 1st box position
       # @balance variable assigned only in Slot machine
      @yplaycenter = @yboxtop if !@balance
        1.upto 9 do |z|
          box = rect(@xboxleft, @yplaycenter, @boxside, @boxside, corners=4, fill: white)
           # here is creating array with boxes names & coordinates
          @boxes["box"<<z.to_s] = ["#{box.left}, #{box.top}"]
           # moving boxes over the playzone
          @xboxleft = ("#{box.left}".to_i + @boxside + @step)
            # end loop after 3rd box created (rule for Slot machine)
            break if @balance && z == 3
            # change x,y when row is ended
            @xboxleft = (@xplayleft + @step*3) if (z == 3 || z == 6)
            @yplaycenter += (@boxside + @step) if (z == 3 || z == 6)
        end
  end
 
    stack(margin: 10) do
      flow(margin: 2) do
        btn_slotmachine = button "Slot machine", width: 90, heigth: 35, margin_right: 4 do
          show_balance
          create_handle
          create_boxes
          g1start_alert
        

        end
        para strong "Play this classic casino game!", stroke: white
      end

      flow(margin: 2) do
        btn_tictac = button "Tic-Tac-Toe", width: 90, heigth: 35, margin_right: 4 do
          create_boxes
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