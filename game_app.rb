require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  background darkgreen # main layout color
  
  # Methods and variables ========================================================================

  # size of playzone (260x242 px from 400x440)
  @plwidth = self.width*0.65
  @plheight = self.height*0.55
  # objects 
  @objectboxes = {}
  @objsyms = {}
  @nums = []
  @i = 0
  @userchoice = ""
  @compchoice = ""
  @win_text = ""

  # Common methods for both games ________________________________________________________________
  def sizes
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

  def create_playzone
      @playzone = rect(0, 0, @plwidth, @plheight, corners=4, fill: darkgoldenrod)
    sizes
  end

  def create_boxes
  sizes
    
    @stackboxes = stack(left: @xplayleft, top: @yplaytop) do          # first, is to check wich game has started and so decide about 1st box position:
      ((@yplaycenter = @yboxtop) && (@xboxleft +=10)) if !@balance    # @balance assigned only in Slot machine, so if its true- there will be created 3 boxes in the middle
        1.upto 9 do |z|                                               # here is created hash with objects - rectangles
          if @userchoice                                                # clickable rects for tictactoe
            @objectboxes[z.to_i] = rect(@xboxleft, @yplaycenter, @boxside, @boxside, corners=4, fill: white).click{
              make_turn(z.to_i, @objectboxes[z.to_i].left, @objectboxes[z.to_i].top)}
          else                                                          # standart rects for slotmachine
            @objectboxes[z.to_i] = rect(@xboxleft, @yplaycenter, @boxside, @boxside, corners=4, fill: white)
          end

          @xboxleft = ((@objectboxes.values[-1].left).to_i + @boxside + @step) # moving boxes over the playzone
          break if @balance && z == 3                                 # end loop after 3rd box created (rule for Slot machine)
          @xboxleft = (@xplayleft + @step*4) if (z == 3 || z == 6)    # change x,y when row is ended
          @yplaycenter += (@boxside + @step) if (z == 3 || z == 6)
        end
    end

    @stacksyms = stack(left: 0, top: 0) do                            # stack for symbols
      @objsyms = {}
    end
  end
  # _______________________________________________________________________________________________

  # Methods for Slot machine ======================================================================
  def create_balance
    @balance = 200 #start balance in slot machine
  end
  
  def show_balance
    @stackbalance = stack(left: 0, top: 0) do
      @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 10
    end
  end

  def create_handlesystem
    @stackhandler = stack(left: 0, top: 0) do
      @rcol = rect(229, 50, self.width*0.02, self.height*0.33, corners=4, fill: orange..red)
      @handle = oval(220, 45, radius: 15, fill: orangered)
      @handle.click{start_slotmachine}
    end
  end

  def refresh_symbols
    @nums = []                                          #clear objects before animation restart
    @stacksyms.clear{
      @objectboxes.each_value do |value|
          @i += 1                                       #@objsyms - is hash filled with animated para-objects with numbers
          @objsyms[@i.to_i] = para strong(""), size: 36, left: (value.left).to_i + @boxside*0.25, top: (value.top).to_i
      end}
  end

  def generate_sym                                      #random numbers for @stacksyms & @nums
    rand(0..9).to_s
  end

  def start_slotmachine
    refresh_symbols
    @anm = animate(30) do |frame|                       # Animation block _________________________________
      
      @objsyms.each_value do |value|          
        value.replace strong (generate_sym)             # here is animation working (replace "" with rand)
      end
      @handle.top += 40

      if @handle.top >= 190
        @handle.displace(0, -160)
        @anm.stop
                                                        # after animation stop symbols changed last time
        @objsyms.each do |key, value|
          x = generate_sym
          value.replace strong (x)
          @nums << x                                    # then created final array with random numbers - @nums
        end

          slotmachine_calc                              # call method to count result

          if @balance == 0
            @stackbalance.clear{show_balance}
              timer 0.5 do
                alert("Try again or play Tic-Tac-Toe")
                @stackplay.clear{create_playzone}
                create_balance
              end
          else
            @stackbalance.clear{show_balance}
            #clear handle & create new one to restart animation
            @stackhandler.clear{create_handlesystem}
          end
      end
    end                                                 # End animation_____________________________________
  end

  def slotmachine_calc
    @nums = @nums.join                                  # convert array into string
    if @nums == "000"                                   # all zeroes - bancrupt
      @balance = 0                                      # elsif - checks mirror-like combinations
    elsif @nums[0] == @nums[2] && (@nums[1] != @nums[2]) && (@nums.to_i != 0)
      @balance += 5
    else
      @nums = @nums.to_i                                # check combinations with array converted into integer
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

  # Methods for Tic Tac Toe ==================================================================================
  def create_choice
    clear_objects
    @choiceflow = flow(left: 100, top: 72) do
      para strong("Choose the symbol:   "), size: 10, stroke: orange
      lb1 = list_box items: ["X", "0"], width: 60, fill: darkgoldenrod,
        choose:() do |list|
          while list.text == nil do
          @userchoice = ""
          end

          if list.text != nil
            @userchoice = list.text
            @compchoice = lb1.items.reject!{|q| q == @userchoice}.join
            alert(
            "            You play with _ #{@userchoice}
            Computer plays with _ #{@compchoice}\n
            Start press on rectangles,
            - symbols will appear on the desk.")   
            @choiceflow.clear                           #clear list_box element after user has chose symbol
          end
      end
    end
  end

  def make_turn (boxnum, x, y)
    if @win_text !=""
      find_emptybox
    else
      if @objsyms.keys.include?(boxnum)
        alert("Choose another box")
      else
        @stacksyms.append{
        @objsyms = @objsyms
        @objsyms[boxnum] = [(para strong("#{@userchoice}"), size: 36, left: x + @boxside*0.25, top: y), "#{@userchoice}"]}
      end
        find_emptybox
    end
  end

  def combi_counter (arr, usrkeys, pckeys)
    combi_user = usrkeys.select{|i| arr.include?(i)}
    combi_pc = pckeys.select{|i| arr.include?(i)}
      
      win_text = ""
    if combi_pc.size == 3 && combi_user.size == 0
      win_text = "PC won the game"
    elsif (combi_pc.size == 0 && combi_user.size == 3 && win_text == "")
      win_text = "You're the winner!"
    end

    if win_text != ""
      alert(win_text)
      load_tictactoe
    else
      @boxnum = ((arr - combi_user).join).to_i if combi_user.size ==2 && !@objsyms[((arr - combi_user).join).to_i]
      @boxnum = ((arr - combi_pc).join).to_i if combi_pc.size ==2 && !@objsyms[((arr - combi_pc).join).to_i]
    end
  end

  def find_emptybox
    @boxnum = (((@objectboxes.keys - @objsyms.keys).sample(1)).join).to_i if @objsyms.keys.size == 1
    usrkeys = @objsyms.select{|k,(v1,v2)| v2==@userchoice}.keys
    pckeys = @objsyms.select{|k,(v1,v2)| v2==@compchoice}.keys

    if usrkeys.size >=2
        arr = []
        @boxnum = 0
        x=1

      while @boxnum == 0 do
        arr = Array.new(3){|i| i+=x}
        combi_counter(arr, usrkeys, pckeys)
        x +=3
        break if (@boxnum != 0 or arr[2]>=9) 
      end

        arr = []
      while @boxnum == 0 do
        arr = (1..3).each_with_object(arr){|i, arr| if i==1; arr << 1; else arr[i-1] = (3+arr[i-2].to_i); end} if arr.size == 0
        combi_counter(arr, usrkeys, pckeys)
        arr.map!{|i| i+=1} if @boxnum == 0
        break if (@boxnum != 0 or arr[2]>9)
      end

      if @boxnum == 0
        x = [[3,5,7], [1,5,9]]
        arr = x[rand(0..1)]
        combi_counter(arr, usrkeys, pckeys)
        if arr == x[0]; combi_counter(x[1], usrkeys, pckeys); else combi_counter(x[0], usrkeys, pckeys); end
      end
    end

    if (@boxnum == 0 && @win_text == "" && @objsyms.size < 9); @boxnum = (((@objectboxes.keys - @objsyms.keys).sample(1)).join).to_i; end
    load_tictactoe if @objsyms.size == 9
    pc_turn(@boxnum) if @userchoice !=""
  end

  def pc_turn (boxnum)
    @stacksyms.append{
      @objsyms = @objsyms
      timer 0.3 do
      @objsyms[boxnum] = [(para strong("#{@compchoice}"), size: 36, left: @objectboxes[boxnum].left + @boxside*0.25, top: @objectboxes[boxnum].top), "#{@compchoice}"]
      end} if @objsyms.size < 9
    if @win_text == "PC won the game"; alert(@win_text); load_tictactoe; end
  end

  def clear_objects
      @stacksyms.remove if @stacksyms
      @objectboxes = {}
      @stackboxes.remove if @stackboxes
      @choiceflow.clear if @choiceflow
      @userchoice = ""
      @compchoice = ""
      @win_text = ""
  end

  # Summary methods for start games ___________________________________________________________________________

  def load_slotmachine
  @stackplay.clear{
    create_playzone       # main area containing all objects (for both games)
    create_balance        # var @balance assigned (object creation depends from it)
    show_balance          # row with balance
    create_boxes          # filling playzone with white boxes (3 for Slot machine, 9 for Tic Tac Toe), & objects(para) with num_symbols
    create_handlesystem   # create two elements to start & visualize animation     
    g1start_alert}        # hello alert for Slot machine
  end

  def load_tictactoe
    create_choice
    @stackplay.clear{
    create_playzone
    create_boxes}
  end

# =============================================================================================================
# Main layout
    stack(margin: 10) do

      flow(margin: 2) do
        btn_slotmachine = button "Slot machine", width: 90, heigth: 35, margin_right: 4 do
          clear_objects
          load_slotmachine
        end
        para strong "Play this classic casino game!", stroke: white
      end

      flow(margin: 2) do
        btn_tictac = button "Tic-Tac-Toe", width: 90, heigth: 35, margin_right: 4 do
          @balance = nil if @balance
          load_tictactoe
        end
        para strong "Miss about school years? Try it!", stroke: white
      end

      @stackplay = stack(left: (self.width - @plwidth)/2 - 10, top: 95, width: @plwidth, height: @plheight) do
        rect(0, 0, @plwidth, @plheight, corners=4, fill: darkgoldenrod)
      end

      #control buttons
      flow(left: self.width*0.29, top: self.height-80)  do
        button "Restart", width: 70, margin: 3 do
          if @balance
            clear_objects
            load_slotmachine
          else
            load_tictactoe
          end
        end
        button "Exit App", width: 70, margin: 3 do
          exit
        end
      end

    end
# =============================================================================================================

end