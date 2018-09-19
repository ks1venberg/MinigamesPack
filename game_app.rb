require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen
  # Methods and variables _________________________________________________________________________
  @boxes = {}
  @objsyms = {}
  @nums = []
  @i = 0
  @balance = 200 #start balance in slot machine
  @stackplay = stack
  @stackboxes = stack
  @stacksyms = stack
  @stackhandler = stack
  @playzone = rect
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
      create_stacksym
      g1start_alert}
  end

  def show_balance
    @stackbalance = stack(left: 0, top: 0) do
      @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 10
    end
  end

  def generate_sym
    rand(0..9).to_s
  end

  def clear_slothashes
    @nums = []
    @objsyms = {}
  end

  def create_playzone
      @playzone = rect(0, 0, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod)
    sizes
  end

  def create_handlesystem
    @stackhandler = stack(left: 0, top: 0) do
      @rcol = rect(229, 50, self.width*0.02, self.height*0.33, corners=4, fill: orange..red)
      @handle = oval(220, 45, radius: 15, fill: orangered)
      @handle.click{start_slotmachine}
    end
  end

  def create_stacksym
    @stacksyms = stack(left: 0, top: 0) do
      @objsyms = {}
    end
  end

  def start_slotmachine
    clear_slothashes
    
    @stacksyms.clear{
      @boxes.each_value do |value|
        value.each do |x, y|
          @i += 1 #@objsyms - is hash filled with animated para-objects with numbers
          @objsyms["@sym"+@i.to_s] = para strong(""), size: 36, left: x.to_f + @boxside*0.25, top: @yplaycenter
        end
      end}

    @anm = animate(30) do |frame| # ANIMATION BLOCK ____________________________________________________________
      
      @objsyms.each_value do |value|
        value.replace strong (generate_sym)
      end
      @handle.top += 40

      if @handle.top >= 190
        @handle.displace(0, -160)
        
        @anm.stop
        # here is created final array with random numbers (not with objects like @objsyms)
        @objsyms.each do |key, value|
          x = generate_sym
          value.replace strong (x)
          @nums << x
        end

        slotmachine_calc 

        if @balance == 0
          @stackbalance.clear{show_balance}
            timer 0.5 do
              alert("Try again or play Tic-Tac-Toe")
              @stackplay.clear{create_playzone}
              @balance = 200
            end
        else
          @stackbalance.clear{show_balance}
          #clear handle & create new one to restart animation
          @stackhandler.clear{create_handlesystem}
        end
      end
    end  #_______________________________________________________________________________________________________

  end

  def slotmachine_calc

    @nums = @nums.join                                  # convert array into string
    if @nums == "000"                                   # all zeroes - bancrupt
      @balance = 0
    elsif @nums[0] == @nums[2] && (@nums[1] != @nums[2]) && (@nums.to_i != 0)     # check mirror-like combinations
      @balance += 5
    else
                                                        # check combinations with array[integer] 
      @nums = @nums.to_i                                # convert array into string
      combihash = {111 =>50, 222 =>50, 333 =>100, 444 =>50, 555 =>100, 666 =>50, 777 =>100, 888 =>50, 999 =>50}
        if combihash[@nums]
          @balance += combihash[@nums]
        else
          @balance -= 5                                 # for different numbers
        end
    end
  end

  def g1start_alert
    timer 0.5 do
      stack margin_left: 2, align:'left' do
        alert(
        "       Three equal numbers gives you +50$
        Magic combi (777, 333, 555) gives you +100$
        Mirror-like combi (e.g. 131, 454) gives you +5$
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