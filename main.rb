require 'dxruby'

Window.width = 800
Window.height = 600
Window.bgcolor = C_WHITE

font1 = Font.new(16)
font2 = Font.new(32)
font3 = Font.new(48)
font4 = Font.new(64)

bingo_card = Image.load("images/bingo_card.jpg")
bingo_ana = Image.load("images/ana.png")

bingo_num = (1..75).to_a
bingo_num1 = (1..15).to_a
bingo_num2 = (16..30).to_a
bingo_num3 = (31..45).to_a
bingo_num4 = (46..60).to_a
bingo_num5 = (61..75).to_a
bingo_card_num = [bingo_num1.sample(5),bingo_num2.sample(5),bingo_num3.sample(5),bingo_num4.sample(5),bingo_num5.sample(5)]
bingo_card_num[2][2] = nil

$scean = "title"



Window.loop do
    case $scean
        when "title"
            Window.draw_font(250, 230, "BINGO大会", font4, {:color => C_BLACK})
            Window.draw_font(270, 400, "[ENTER] で STRAT", font2, {:color => C_BLACK})
            break if Input.key_push?(K_ESCAPE)
            $scean = "main" if Input.key_push?(K_RETURN)
            

        when "main"

            open_num = bingo_num.sample
            Window.draw_font(650, 300," #{open_num}", font2, {:color => C_BLACK})
            Window.draw_scale(20, 120, bingo_card, 1.6, 1.6)
            Window.draw_font(95, 180, "#{bingo_card_num[0][0]}", font2, {:color => C_BLACK})
            Window.draw_font(95, 255, "#{bingo_card_num[0][1]}", font2, {:color => C_BLACK})
            Window.draw_font(95, 328, "#{bingo_card_num[0][2]}", font2, {:color => C_BLACK})
            Window.draw_font(95, 400, "#{bingo_card_num[0][3]}", font2, {:color => C_BLACK})
            Window.draw_font(95, 470, "#{bingo_card_num[0][4]}", font2, {:color => C_BLACK})
            Window.draw_font(170, 180, "#{bingo_card_num[1][0]}", font2, {:color => C_BLACK})
            Window.draw_font(170, 255, "#{bingo_card_num[1][1]}", font2, {:color => C_BLACK})
            Window.draw_font(170, 328, "#{bingo_card_num[1][2]}", font2, {:color => C_BLACK})
            Window.draw_font(170, 400, "#{bingo_card_num[1][3]}", font2, {:color => C_BLACK})
            Window.draw_font(170, 470, "#{bingo_card_num[1][4]}", font2, {:color => C_BLACK})
            Window.draw_font(244, 180, "#{bingo_card_num[2][0]}", font2, {:color => C_BLACK})
            Window.draw_font(244, 255, "#{bingo_card_num[2][1]}", font2, {:color => C_BLACK})
            Window.draw_font(244, 328, "#{bingo_card_num[2][2]}", font2, {:color => C_BLACK})
            Window.draw_font(244, 400, "#{bingo_card_num[2][3]}", font2, {:color => C_BLACK})
            Window.draw_font(244, 475, "#{bingo_card_num[2][4]}", font2, {:color => C_BLACK})
            Window.draw_font(317, 180, "#{bingo_card_num[3][0]}", font2, {:color => C_BLACK})
            Window.draw_font(317, 255, "#{bingo_card_num[3][1]}", font2, {:color => C_BLACK})
            Window.draw_font(317, 328, "#{bingo_card_num[3][2]}", font2, {:color => C_BLACK})
            Window.draw_font(317, 400, "#{bingo_card_num[3][3]}", font2, {:color => C_BLACK})
            Window.draw_font(317, 470, "#{bingo_card_num[3][4]}", font2, {:color => C_BLACK})
            Window.draw_font(390, 180, "#{bingo_card_num[4][0]}", font2, {:color => C_BLACK})
            Window.draw_font(390, 255, "#{bingo_card_num[4][1]}", font2, {:color => C_BLACK})
            Window.draw_font(390, 328, "#{bingo_card_num[4][2]}", font2, {:color => C_BLACK})
            Window.draw_font(390, 400, "#{bingo_card_num[4][3]}", font2, {:color => C_BLACK})
            Window.draw_font(390, 470, "#{bingo_card_num[4][4]}", font2, {:color => C_BLACK})
            




    end


end