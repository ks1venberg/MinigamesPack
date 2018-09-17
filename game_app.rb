require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen
  # Methods and variables _________________________________________________________________________
  @boxes = {}
  @syms = {}
  @playzone = rect
  @stackplay = stack
  @stackboxes = stack
  @stacksyms = stack
  @stackhandler = stack

  @rcol = rect
  @handle = oval


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
    #box params: 52 px each side
      @boxside = @plwidth / 5
      @step = 10
    # start position for adding boxes to playzone
      @yplaycenter = @yplaytop + @plheight/2 - @boxside/2
      @xboxleft = @xplayleft + @step*3
    # above param used only for TicTacToe
      @yboxtop = @yplaycenter - @boxside - @step
  end

  def load_slotmachine
    @stackplay.clear{
      create_playzone
      show_balance
      create_boxes
      create_handlesystem
      g1start_alert}
  end

  def create_playzone
      @playzone = rect(0, 0, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod)
    sizes
  end

  def show_balance
    @balance = 200
    @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 10
  end

  def create_handlesystem
    @stackhandler = stack(left: 0, top: 0) do
      @rcol = rect(229, 50, self.width*0.02, self.height*0.33, corners=4, fill: orange..red)
      @handle = oval(220, 45, radius: 15, fill: orangered)
      @handle.click{start_slotmachine}
    end
    @stacksyms = stack(left: 0, top: 0) do
      @syms = {}
    end
  end

  def start_slotmachine
    i = 0
    @stacksyms = stack(left: @xplayleft + 68, top: @yplaycenter + 10) do
      @boxes.each_value do |value|
        value.each do |x, y|
          i += 1
          @syms["@sym"+i.to_s] = para strong(rand(0..9).to_s), size: 36, left: x.to_f + @boxside*0.25, top: @yplaycenter
        end
      end
    end

    @anm = animate(30) do |frame|
      @syms.each_value do |value|
        value.replace strong rand(0..9).to_s
      end

      @handle.top += 40

      if @handle.top >= 190
        @handle.displace(0, -160)
        @anm.stop
        #clear handle & create new one to restart animation
        @stackhandler.clear{create_handlesystem}
        timer 0.5 do
          alert(@syms.inspect +
            "#{@syms.values}".to_s +
            @syms.values[0].to_s)
        end
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
       # @balance variable assigned only in Slot machine, so if its true- there will be created 3 boxes in the middle
      @stackboxes = stack(left: @xplayleft, top: @yplaytop) do
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
  end
 
    stack(margin: 10) do

      flow(margin: 2) do
        btn_slotmachine = button "Slot machine", width: 90, heigth: 35, margin_right: 4 do
          load_slotmachine
        end
        para strong "Play this classic casino game!", stroke: white
      end

      flow(margin: 2) do
        btn_tictac = button "Tic-Tac-Toe", width: 90, heigth: 35, margin_right: 4 do

          @stackplay.clear{create_playzone} if @boxes.size == 3

        end
        para strong "Miss about school years? Try it!", stroke: white
      end

      # widht & height values used in % of window_App size
      @stackplay = stack(left: (self.width - self.width*0.65)/2 - 10, top: 95, width: self.width*0.65, height: self.height*0.55) do
        rect(0, 0, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod)
      end

      #control buttons
      flow(left: self.width*0.27, top: self.height-80)  do
        button "Restart", width: 60, margin: 2 do
          @stackplay.remove
          #@stacksyms.remove
        end
        button "Exit App", width: 60, margin: 2
      end

    end

end