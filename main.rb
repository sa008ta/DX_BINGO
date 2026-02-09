require 'dxruby'

Window.width = 800
Window.height = 600
Window.bgcolor = C_WHITE

font1 = Font.new(16)
font2 = Font.new(32)
font3 = Font.new(48)
font4 = Font.new(64)
font5 = Font.new(400)
font6 = Font.new(200)

bingo_card = Image.load("images/bingo_card.jpg")
bingo_free = Image.load("images/ana.png")
bingo_ana = Image.load("images/metsu.png")
bingo_title = Image.load("images/bingo_title.png")
ball = Image.load("images/ball.png")
bingo10 = Image.load("images/jyu.png")
bingo20 = Image.load("images/nijyu.png")
bingo30 = Image.load("images/sanjyu.png")
bingo40 = Image.load("images/yonjyu.png")
bingo50 = Image.load("images/gojyu.png")
bingo60 = Image.load("images/rokujyu.png")
bingo70 = Image.load("images/else.png")
big_metsu = Image.load("images/metsu_big.png")
normal_char = Image.load("images/normal_char.png")
reach_char = Image.load("images/reach_char.png")
fukidashi1 = Image.load("images/fukidashi1.png")
fukidashi2 = Image.load("images/fukidashi2.png")
fukidashi3 = Image.load("images/fukidashi3.png")
fukidashi_reach = Image.load("images/fukidashireach.png")
fukidashi_bingo = Image.load("images/fukidashibingo.png")
bingo_free.set_color_key(C_WHITE)
bingo_ana.set_color_key(C_WHITE)
ball.set_color_key(C_WHITE)
big_metsu.set_color_key(C_WHITE)
normal_char.set_color_key(C_WHITE)
reach_char.set_color_key(C_WHITE)
fukidashi1.set_color_key(C_WHITE)
fukidashi2.set_color_key(C_WHITE)
fukidashi3.set_color_key(C_WHITE)
fukidashi_reach.set_color_key(C_WHITE)
fukidashi_bingo.set_color_key(C_WHITE)

bingo_num = (1..75).to_a
open_num = bingo_num.sample


bingo_num1 = (1..15).to_a
bingo_num2 = (16..30).to_a
bingo_num3 = (31..45).to_a
bingo_num4 = (46..60).to_a
bingo_num5 = (61..75).to_a
bingo_card_num = [bingo_num1.sample(5),bingo_num2.sample(5),bingo_num3.sample(5),bingo_num4.sample(5),bingo_num5.sample(5)]
bingo_card_num[2][2] = nil

$scene = "title"

is_rolling = true

bingo_hantei = Array.new(5) { Array.new(5, false) }
bingo_hantei[2][2] = true

win_num = []

num_timer = 0
num_interval = 2       
num_interval_max = 20
slowing = false


ball_angle = 0
ball_speed = 20

frame_count = 0
delay_count = 130

metsu_hantei = false

push_count = 0

bingo = false
reach = false
reach_count = false

ending_frame_count = 0
ending_delay_count = 20


def bingo?(card)
  #  横
  return true if card.any? { |row| row.all? }

  #  縦
  return true if card.transpose.any? { |col| col.all? }

 # 斜め
  return true if (0..4).all? { |i| card[i][i] }

 
  return true if (0..4).all? { |i| card[i][4 - i] }

  false
end

def reach?(card)
  # 横
  card.each do |row|
    return true if row.count(true) == 4 && row.count(false) == 1
  end

  # 縦
  card.transpose.each do |col|
    return true if col.count(true) == 4 && col.count(false) == 1
  end

  # 斜め
  diag1 = (0..4).map { |i| card[i][i] }
  return true if diag1.count(true) == 4 && diag1.count(false) == 1

  diag2 = (0..4).map { |i| card[i][4-i] }
  return true if diag2.count(true) == 4 && diag2.count(false) == 1

  false
end

min_count = nil

Window.loop do


    case $scene
        when "title"
            Window.draw_scale(0, 0, bingo_title, 1, 1)
            if min_count != nil
                Window.draw_font_ex(530, 45, "BEST #{min_count}回", font3, 
                    color: [0, 0, 0],
                    edge: true,
                    edge_color: [255, 255, 255],
                    edge_width: 4
                )
            end
            break if Input.key_push?(K_ESCAPE)
            $scene = "main" if Input.key_push?(K_RETURN)
            bingo_num = (1..75).to_a
            open_num = bingo_num.sample
            bingo_card_num = [bingo_num1.sample(5),bingo_num2.sample(5),bingo_num3.sample(5),bingo_num4.sample(5),bingo_num5.sample(5)]
            bingo_card_num[2][2] = nil
            is_rolling = true
            bingo_hantei = Array.new(5) { Array.new(5, false) }
            bingo_hantei[2][2] = true
            win_num = []
            frame_count = 0
            metsu_hantei = false
            push_count = 0
            bingo = false
            reach = false
            reach_count = false
            ending_frame_count = 0
            ending_delay_count = 20


        when "main"
            break if Input.key_push?(K_ESCAPE)
            # 数字止める
            if is_rolling == true
                if Input.key_push?(K_SPACE)
                    is_rolling = false
                    slowing = true
                    push_count += 1
                end
            end

            # 時間で数字スタート
            if is_rolling == false && bingo == false && slowing == false
                frame_count += 1
                if frame_count == 40
                    win_num.push(open_num)
                    bingo_num.delete(open_num)
                end
                if frame_count > delay_count
                    is_rolling = true
                    metsu_hantei = false
                    frame_count = 0
                end
            end
            # ビンゴカード
            Window.draw_scale(20, 120, bingo_card, 1.6, 1.6)

            # 最小スコア
            if min_count != nil
                Window.draw_font(530, 45, "BEST #{min_count}回", font3, {:color => C_BLACK})
            end

            #space後の数字の動き
            if slowing
                num_timer += 1
                if  num_timer >= num_interval
                    num_timer = 0
                    open_num = bingo_num.sample
                    num_interval += 2
                    ball_angle += ball_speed
                end
                if num_interval >= num_interval_max
                    slowing = false
                    num_interval = 2
                end
            end

            # 数字ランダム
            if is_rolling && bingo == false && slowing == false
                open_num = bingo_num.sample
                ball_angle += ball_speed
            end
            Window.draw_rot(554, 184, ball, ball_angle)
            if open_num < 10
                Window.draw_font(596, 230," #{open_num}", font4, {:color => C_BLACK})
            else
                Window.draw_font(580, 230," #{open_num}", font4, {:color => C_BLACK})
            end

            # BINGO数字
            if win_num.include?(bingo_card_num[0][0])
                metsu_hantei = true if bingo_hantei[0][0] == false
                bingo_hantei[0][0] = true
                Window.draw_scale(-428, -345, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(95, 180, "#{bingo_card_num[0][0]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[0][1])
                metsu_hantei = true if bingo_hantei[0][1] == false
                bingo_hantei[0][1] = true
                Window.draw_scale(-428, -271, bingo_ana, 0.07, 0.07)
            else 
                Window.draw_font(95, 255, "#{bingo_card_num[0][1]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[0][2])
                metsu_hantei = true if bingo_hantei[0][2] == false
                bingo_hantei[0][2] = true
                Window.draw_scale(-428, -197, bingo_ana, 0.07, 0.07)
            else 
                Window.draw_font(95, 328, "#{bingo_card_num[0][2]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[0][3])
                metsu_hantei = true if bingo_hantei[0][3] == false
                bingo_hantei[0][3] = true
                Window.draw_scale(-428, -123, bingo_ana, 0.07, 0.07)
            else 
                Window.draw_font(95, 400, "#{bingo_card_num[0][3]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[0][4])
                metsu_hantei = true if bingo_hantei[0][4] == false
                bingo_hantei[0][4] = true
                Window.draw_scale(-428, -49, bingo_ana, 0.07, 0.07)
            else 
                Window.draw_font(95, 470, "#{bingo_card_num[0][4]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[1][0])
                metsu_hantei = true if bingo_hantei[1][0] == false
                bingo_hantei[1][0] = true
                Window.draw_scale(-354.5, -345, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(170, 180, "#{bingo_card_num[1][0]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[1][1])
                metsu_hantei = true if bingo_hantei[1][1] == false
                bingo_hantei[1][1] = true
                Window.draw_scale(-354.5, -271, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(170, 255, "#{bingo_card_num[1][1]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[1][2])
                metsu_hantei = true if bingo_hantei[1][2] == false
                bingo_hantei[1][2] = true
                Window.draw_scale(-354.5, -197, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(170, 328, "#{bingo_card_num[1][2]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[1][3])
                metsu_hantei = true if bingo_hantei[1][3] == false
                bingo_hantei[1][3] = true
                Window.draw_scale(-354.5, -123, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(170, 400, "#{bingo_card_num[1][3]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[1][4])
                metsu_hantei = true if bingo_hantei[1][4] == false
                bingo_hantei[1][4] = true
                Window.draw_scale(-354.5, -49, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(170, 470, "#{bingo_card_num[1][4]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[2][0])
                metsu_hantei = true if bingo_hantei[2][0] == false
                bingo_hantei[2][0] = true
                Window.draw_scale(-281, -345, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(244, 180, "#{bingo_card_num[2][0]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[2][1])
                metsu_hantei = true if bingo_hantei[2][1] == false
                bingo_hantei[2][1] = true
                Window.draw_scale(-281, -271, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(244, 255, "#{bingo_card_num[2][1]}", font2, {:color => C_BLACK})
            end
            Window.draw_scale(-281, -197, bingo_free, 0.07, 0.07)
            if win_num.include?(bingo_card_num[2][3])
                metsu_hantei = true if bingo_hantei[2][3] == false
                bingo_hantei[2][3] = true
                Window.draw_scale(-281, -123, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(244, 400, "#{bingo_card_num[2][3]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[2][4])
                metsu_hantei = true if bingo_hantei[2][4] == false
                bingo_hantei[2][4] = true
                Window.draw_scale(-281, -49, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(244, 475, "#{bingo_card_num[2][4]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[3][0])
                metsu_hantei = true if bingo_hantei[3][0] == false
                bingo_hantei[3][0] = true
                Window.draw_scale(-207.5, -345, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(317, 180, "#{bingo_card_num[3][0]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[3][1])
                metsu_hantei = true if bingo_hantei[3][1] == false
                bingo_hantei[3][1] = true
                Window.draw_scale(-207.5, -271, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(317, 255, "#{bingo_card_num[3][1]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[3][2])
                metsu_hantei = true if bingo_hantei[3][2] == false
                bingo_hantei[3][2] = true
                Window.draw_scale(-207.5, -197, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(317, 328, "#{bingo_card_num[3][2]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[3][3])
                metsu_hantei = true if bingo_hantei[3][3] == false
                bingo_hantei[3][3] = true
                Window.draw_scale(-207.5, -123, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(317, 400, "#{bingo_card_num[3][3]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[3][4])
                metsu_hantei = true if bingo_hantei[3][4] == false
                bingo_hantei[3][4] = true
                Window.draw_scale(-207.5, -49, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(317, 470, "#{bingo_card_num[3][4]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[4][0])
                metsu_hantei = true if bingo_hantei[4][0] == false
                bingo_hantei[4][0] = true
                Window.draw_scale(-134, -345, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(390, 180, "#{bingo_card_num[4][0]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[4][1])
                metsu_hantei = true if bingo_hantei[4][1] == false
                bingo_hantei[4][1] = true
                Window.draw_scale(-134, -271, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(390, 255, "#{bingo_card_num[4][1]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[4][2])
                metsu_hantei = true if bingo_hantei[4][2] == false
                bingo_hantei[4][2] = true
                Window.draw_scale(-134, -197, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(390, 328, "#{bingo_card_num[4][2]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[4][3])
                metsu_hantei = true if bingo_hantei[4][3] == false
                bingo_hantei[4][3] = true
                Window.draw_scale(-134, -123, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(390, 400, "#{bingo_card_num[4][3]}", font2, {:color => C_BLACK})
            end
            if win_num.include?(bingo_card_num[4][4])
                metsu_hantei = true if bingo_hantei[4][4] == false
                bingo_hantei[4][4] = true
                Window.draw_scale(-134, -49, bingo_ana, 0.07, 0.07)
            else
                Window.draw_font(390, 470, "#{bingo_card_num[4][4]}", font2, {:color => C_BLACK})
            end
            
            # turn数
            Window.draw_font(490, 100, "試行回数 #{push_count}回", font3, {:color => C_BLACK})


            # BINGO判定
            bingo = true if bingo?(bingo_hantei)  
            # REACH判定
            reach = true if reach?(bingo_hantei)

            if bingo == true
                frame_count += 1
                $scene = "ending" if delay_count + 20 <= frame_count
            end

            # オリジナルキャラ表示
            if reach
                Window.draw_scale(540, 330, reach_char, 1, 1)
            else
                Window.draw_scale(540, 330, normal_char, 1, 1)
            end

            # オリジナルキャラ吹き出し
            if push_count <= 10 && !reach 
                Window.draw_scale(410, 265, fukidashi1, 1, 1)
            elsif push_count <= 20 && !reach
                Window.draw_scale(410, 265, fukidashi2, 1, 1)
            elsif bingo
                Window.draw_scale(410, 265, fukidashi_bingo, 1, 1)
            elsif reach
                Window.draw_scale(410, 265, fukidashi_reach, 1, 1)
            else
                Window.draw_scale(410, 265, fukidashi3, 1, 1)
            end

            
           
            if 80 <= frame_count && metsu_hantei

                if bingo
                    Window.draw_font_ex(100, 200, "BINGO!", font6,
                        color: [255, 0, 0],
                        edge: true,
                        edge_color: [0,0,0],
                        edge_width: 4
                    )

                elsif reach && reach_count == false
                    Window.draw_font_ex(100, 200, "REACH!", font6,
                        color: [255, 0, 0],
                        edge: true,
                        edge_color: [0,0,0],
                        edge_width: 4
                    )
                    if delay_count == frame_count
                        reach_count = true
                    end

                else
                    Window.draw_scale(30, 0, big_metsu, 1.6, 1.6)
                end

            end
            


    when "ending" 
        break if Input.key_push?(K_ESCAPE)
        ending_frame_count += 1
        if  min_count == nil || min_count >= push_count 
            Window.draw_font(240, 140, "NEW RECORD!", font3, {:color => C_BLACK})
            min_count = push_count
        end
        if ending_frame_count >= ending_delay_count
            Window.draw_font(250, 190, "記録 #{push_count}回", font4, {:color => C_BLACK})
        end
        if ending_frame_count >= ending_delay_count + 30
            $scene = "title" if Input.key_push?(K_RETURN)
            if push_count <= 10
                Window.draw_scale(0, 300, bingo10, 1, 1)
            elsif push_count <= 20
                Window.draw_scale(0, 300, bingo20, 1, 1)
            elsif push_count <= 30
                Window.draw_scale(0, 300, bingo30, 1, 1)
            elsif push_count <= 40
                Window.draw_scale(0, 300, bingo40, 1, 1)
            elsif push_count <= 50
                Window.draw_scale(0, 300, bingo50, 1, 1)
            elsif push_count <= 60
                Window.draw_scale(0, 300, bingo60, 1, 1)
            else
                Window.draw_scale(0, 300, bingo70, 1, 1)
            end
            Window.draw_font(290, 270, "ENTERでTITLE", font2, {:color => C_BLACK})
        end

    end


end