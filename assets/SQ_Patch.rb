# SQ_Patch version 1.1.2

# デフォルトフォント
$sq_default_font = ["源暎ラテゴ v2", "GenEi LateGo v2", "メイリオ", "Meiryo", "ＭＳ Ｐゴシック", "MS PGothic", "ＭＳ ゴシック", "MS Gothic"]

# F12対応
# このファイルの読み込み済みフラグを消す
# リセット時に再び読み込ませる為
$".delete(File.basename(__FILE__))

mod_list = Dir.glob("Mod_Scripts/*.rb")
mod_list.each_with_index do |mod,i|
  load "./"+mod
end

class Game_Enemy_Book < Game_Enemy
  alias squd102_comment comment
  def comment(line = 0)
    c = ""
    enemy = $data_enemies[@enemy_id]
    if enemy.name.split(/\//)[0] == "バンシー"
      c0 = "アイルランド伝承"
      c1 = "家の守護妖精の一種。"
      c2 = "家の者の死が近づくと"
      c3 = "泣きまわってそれを知らせる。"
      c4 = "その家系の亡霊、特に若くして死んだ"
      c5 = "美しい乙女であるとされる。"
      c6 = "泣きはらして真っ赤な目と、"
      c7 = "流れるような長髪を持つ。"
      c8 = ""
      c9 = ""
      c10 = ""
      return c0 if line == 0
      return c1 if line == 1
      return c2 if line == 2
      return c3 if line == 3
      return c4 if line == 4
      return c5 if line == 5
      return c6 if line == 6
      return c7 if line == 7
      return c8 if line == 8
      return c9 if line == 9
      return c10 if line == 10
    end
    squd102_comment(line)
  end
end

module RPG
  class Skill
    def sp_cost
      if @id > 90 and @id < 190 and $game_actors[2] != nil
        if $game_actors[2].equip?("契約の杖")
          return [@sp_cost - 3, 0].max
        end
      end
      if @id == 5 and $game_actors[2] != nil
        if $game_actors[2].equip?("博士の呪文書")
          return - 5
        end
      end
      return @sp_cost
    end
  end
end

class Game_Map
  def setup(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))
    @map = load_data(sprintf("P_Map%03d.rxdata", @map_id)) if FileTest.exist?(sprintf("P_Map%03d.rxdata", @map_id))
    tileset = $data_tilesets[@map.tileset_id]
    @tileset_name = tileset.tileset_name
    @autotile_names = tileset.autotile_names
    @panorama_name = tileset.panorama_name
    @panorama_hue = tileset.panorama_hue
    @fog_name = tileset.fog_name
    @fog_hue = tileset.fog_hue
    @fog_opacity = tileset.fog_opacity
    @fog_blend_type = tileset.fog_blend_type
    @fog_zoom = tileset.fog_zoom
    @fog_sx = tileset.fog_sx
    @fog_sy = tileset.fog_sy
    @battleback_name = tileset.battleback_name
    @passages = tileset.passages
    @priorities = tileset.priorities
    @terrain_tags = tileset.terrain_tags
    @display_x = 0
    @display_y = 0
    check_special_map
    @need_refresh = false
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map_id, @map.events[i])
    end
    @common_events = {}
    for i in 1...$data_common_events.size
      @common_events[i] = Game_CommonEvent.new(i)
    end
    @fog_ox = 0
    @fog_oy = 0
    @fog_tone = Tone.new(0, 0, 0, 0)
    @fog_tone_target = Tone.new(0, 0, 0, 0)
    @fog_tone_duration = 0
    @fog_opacity_duration = 0
    @fog_opacity_target = 0
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
  end
end

#! ruby -Ku 
class Game_Battler
  alias squd101_bm_insert_actor bm_insert_actor
  def bm_insert_actor(c)
    if self.id == 122 and c == 2
      c2 = "「興奮してるの？\n\\w[\\v[105]]" +
           "　焦らしたくなっちゃうわね…\\e[0]"
      $n = "#{self.name}"
      return @suf_1 + c2
    end
    squd101_bm_insert_actor(c)
  end
  def rovissa_update
    c1 = "R"
    c2 = "blue"
    c1 = "R" if self.equip?("アルケインリボン") or self.equip?("クリプティリボン")
    c1 = "C" if self.equip?("リンクスマフス") or self.equip?("グリマルキンマフス")
    c1 = "M" if self.equip?("サヴァントカチューシャ") or self.equip?("メイデンカチューシャ")
    c1 = "S" if self.equip?("ルナバレッタ") or self.equip?("セレスシャルバレッタ")
    c2 = "blue" if self.equip?("アルケインドレス") or self.equip?("クリプティドレス")
    c2 = "red" if self.equip?("コーラルドレス") or self.equip?("ダマスクドレス")
    c2 = "white" if self.equip?("アイボリードレス") or self.equip?("アラバスタドレス")
    c2 = "C" if self.equip?("リンクスファー") or self.equip?("グリマルキンファー")
    c2 = "M" if self.equip?("サヴァントブラウス") or self.equip?("メイデンブラウス")
    c2 = "S" if self.equip?("ミニマルビキニ") or self.equip?("エンプティビキニ")
    battler_name = "Rovissa_" + c1 + c2
    battler_hue = 0
    @battler_name = battler_name
    @battler_hue = battler_hue
  end
  alias squd101_bm_crisis bm_crisis
  def bm_crisis
    return if not $game_system.message_talk
    return "" if not self.is_a?(Game_Enemy)
    if self.talk_type == "サキュバス"
      talk_chance = 70
      mood_point = 4
      if rand(100) < talk_chance
        $mood.temp_point = mood_point
      else
        return ""
      end
      c1 = "「ぁン、気持ちいいわぁ…\n\\w[\\v[104]]" +
           "　いっぱいちょうだいねぇ\\e[0]"
      c2 = "「ぁ…あぁんっ…\\e[0]\n\\w[\\v[104]]" +
           "　イイわぁ…もっといっぱいしてえっ"
      c3 = "「ふふふ…イきそう？ イっていいのよ？\n\\w[\\v[104]]" +
           "　はやく精液ちょうだい\\e[0]"
      if $game_actors[1].crisis? and self.crisis?
        if c1 != ""
          $n = "#{self.name}"
          return @suf_1 + c1 
        end
      elsif self.crisis?
        if c2 != ""
          $n = "#{self.name}"
          return @suf_1 + c2
        end
      elsif $game_actors[1].crisis?
        if c3 != ""
          $n = "#{self.name}"
          return @suf_1 + c3
        end
      else
        return ""
      end
    end
    if self.talk_type == "シルフ"
      talk_chance = 70
      mood_point = 4
      if rand(100) < talk_chance
        $mood.temp_point = mood_point
      else
        return ""
      end
      c1 = "「あぁん……、\n" +
           "　気持ちいいっ………\\e[0]"
      c2 = c1
      c3 = "「ふふふ……\n\\w[\\v[104]]" +
           "　気持ちよさそうだね\\e[0]"
      if $game_actors[1].crisis? and self.crisis?
        if c1 != ""
          $n = "#{self.name}"
          return @suf_1 + c1 
        end
      elsif self.crisis?
        if c2 != ""
          $n = "#{self.name}"
          return @suf_1 + c2
        end
      elsif $game_actors[1].crisis?
        if c3 != ""
          $n = "#{self.name}"
          return @suf_1 + c3
        end
      else
        return ""
      end
    end
    squd101_bm_crisis
  end
end

class Game_Enemy
  def initialize(troop_id, member_index)
    super()
    @troop_id = troop_id
    @member_index = member_index
    troop = $data_troops[@troop_id]
    @enemy_id = troop.members[@member_index].enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    if @enemy_id == 133 or @enemy_id == 233
      @battler_name = "Boss-" + $game_actors[2].battler_name.sub("_","")
    end
    @battler_hue = enemy.battler_hue
    @hp = maxhp
    @sp = 100
    @level_plus = 0
    @hidden = troop.members[@member_index].hidden
    @immortal = troop.members[@member_index].immortal
    @new_x = nil
    @new_y = nil
    @new_z = nil
    @talk_freq = 0
  end
  def refresh(hide = 0, new_enemy_id = nil)
    if new_enemy_id != nil
      @enemy_id = new_enemy_id
    end
    troop = $data_troops[@troop_id]
    if hide == 1
      @hidden = false
    elsif hide == 2
      @hidden = true
    else
      @hidden = troop.members[@member_index].hidden
    end
    @immortal = troop.members[@member_index].immortal
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    if @enemy_id == 133 or @enemy_id == 233
      @battler_name = "Boss-" + $game_actors[2].battler_name.sub("_","")
    end
    @battler_hue = enemy.battler_hue
    @states.clear
    @states_turn.clear
    @hp = enemy.maxhp
    @sp = 100 
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @chr_plus = 0
    @luk_plus = 0
    @start_sp_plus = 0
    @level_plus = 0
    @damage_pop = false
    @damage = nil
    @critical = false
    @animation_id = 0
    @animation_hit = false
    @white_flash = false
    @org_blink = false
    @undressing = false
    @dressing = false
    @uninserting = false
    @inserting = false
    @blink = false
    @current_action = Game_BattleAction.new
    @added_states = []
    @removed_states = []
    @second_action = false
    @state_reported = false
    @resist_01 = 0
  end
end

class Game_Enemy_Sitri < Game_Enemy
  def initialize(enemy_id)
    super(1, 0)
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @hp = maxhp
    @sp = maxsp
    if @enemy_id == 133 or @enemy_id == 233
      @battler_name = "Boss-" + $game_actors[2].battler_name.sub("_","")
    end
  end
end

class Game_Enemy_Book < Game_Enemy
  def initialize(enemy_id)
    super(1, 0)
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @hp = maxhp
    @sp = maxsp
    if @enemy_id == 133 or @enemy_id == 233
      @battler_name = "Boss-" + $game_actors[2].battler_name.sub("_","")
    end
  end
end

class Scene_Battle
  def update_phase4_step103
    $n = ""
    delete_message
    text = ""
    $mood.temp_point = 0
    for enemy in $game_troop.enemies
      if enemy.exist? and enemy.movable?
        text = enemy.bm_crisis
        break if text != ""
      end
    end
    $mood.vary($mood.temp_point)
    $game_temp.message_text = "\005[\\v[105]]" + text if text != "" and text != nil
    @phase4_step = 104
  end
end

class Window_Message < Window_Selectable
  def initialize
    super(80, 323, 730, 130)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.visible = true
    self.contents_opacity = 0
    self.z = 9998
    @fade_in = false
    @fade_out = false
    @contents_showing = false
    @cursor_width = 0
    self.active = false
    self.index = -1
    @speaker = Window_Speaker.new
    @gaiji_cache =RPG::Cache.picture("gaiji")
    @opacity_text_buf = Bitmap.new(32, 32)
    @frame_y = 338
    @back_y = 328 
    @pic_winframe = Sprite.new
    @pic_winframe.opacity = 0
    @pic_winframe.visible = false
    @pic_winframe.y = @frame_y
    @pic_winframe.x = 59
    @pic_winframe.z = 810
    @pic_winback = Sprite.new
    @pic_winback.bitmap = RPG::Cache.picture("MessWin_back")
    @pic_winback.opacity = 0
    @pic_winback.visible = false
    @pic_winback.y = @back_y
    @pic_winback.x = 59
    @pic_winback.z = 800
    @wait_count = -1            
    @keeping = false            
    @whole_keeping = false      
    @message_wait_count = -1    
    @auto_close_count = -1      
    @last_x = 0                 
    @last_y = 0                 
    @draw_dot = false           
    @appear_frame_duration = 0  
    @hide_frame_duration = 0    
    $message_showing = false
    @fs = 16
    @lh = 25
    self.contents.font.size = @fs
    if $game_variables[104] == nil or $game_variables[104] == 0
      $game_variables[104] = 20
      $game_variables[105] = 45
    end
  end
end

class Scene_Battle
  alias squd100_update update
  def update
    if Input.trigger?(Input::A)
      if @pic_mspeed != nil
        if @pic_mspeed.bitmap != nil
          @pic_mspeed.bitmap.dispose
        end
      end
      @pic_mspeed = Sprite.new
      @pic_mspeed.opacity = 255
      case $game_variables[104]
      when 4
        $game_variables[104] = 36
        $game_variables[105] = 76
        @pic_mspeed.bitmap = RPG::Cache.picture("MessageSpeed_1")
      when 36
        $game_variables[104] = 24
        $game_variables[105] = 60
        @pic_mspeed.bitmap = RPG::Cache.picture("MessageSpeed_2")
      when 24
        $game_variables[104] = 20
        $game_variables[105] = 44
        @pic_mspeed.bitmap = RPG::Cache.picture("MessageSpeed_3")
      when 20
        $game_variables[104] = 16
        $game_variables[105] = 28
        @pic_mspeed.bitmap = RPG::Cache.picture("MessageSpeed_4")
      when 16
        $game_variables[104] = 4
        $game_variables[105] = 12
        @pic_mspeed.bitmap = RPG::Cache.picture("MessageSpeed_5")
      end
      $game_system.se_play($data_system.decision_se)
    end
    if @pic_mspeed != nil
      @pic_mspeed.opacity -= 3 if @pic_mspeed.opacity > 0
      @pic_mspeed.opacity -= 7 if @pic_mspeed.opacity < 200 and @pic_mspeed.opacity > 0
    end
    if Input.trigger?(Input::Z) and $game_switches[18]
      case $game_system.battle_bgm.name
      when "SQ_Battle01"
        bgm = RPG::AudioFile.new("SQ_vsBoss01", 100, 100)
      when "SQ_vsBoss01"
        bgm = RPG::AudioFile.new("SQ_vsBossOld", 100, 100)
      when "SQ_vsBossOld"
        bgm = RPG::AudioFile.new("SQ_Theme_Olivia", 100, 100)
      when "SQ_Theme_Olivia"
        bgm = RPG::AudioFile.new("SQ_vsBossEx01", 100, 100)
      when "SQ_vsBossEx01"
        bgm = RPG::AudioFile.new("SQ_Battle01", 90, 100)
      end
      $game_system.bgm_play(bgm)
      $game_system.battle_bgm = $game_system.playing_bgm
    end
    squd100_update
  end
  alias squd100_after_battle_process after_battle_process
  def after_battle_process
    squd100_after_battle_process
    if @pic_mspeed != nil
      if @pic_mspeed.bitmap != nil
        @pic_mspeed.bitmap.dispose
      end
    end
  end
end

# =================================
# Patch 2020
# =================================

# Change Font
# ---------------------------------
class Scene_Title
  alias squd2020_main main
  def main
    Font.default_name = $sq_default_font
    squd2020_main
  end
end

class Window_Base < Window
  def draw_text_small(x, y, width, height, str, fcolor = 0, align = 0)
    self.contents.font.name = $sq_default_font
    self.contents.font.italic = false
    self.contents.font.bold = false
    self.contents.font.size = 14
    self.contents.font.color = shadow_color(0)
    self.contents.draw_text(x + 1, y, width, height, str, align) if str != nil
    self.contents.draw_text(x, y + 1, width, height, str, align) if str != nil
    self.contents.font.color = text_color(fcolor)
    self.contents.draw_text(x, y, width, height, str, align) if str != nil
  end
  def draw_text_skill(x, y, width, height, str, fcolor = 0, align = 0)
    self.contents.font.name = $sq_default_font
    self.contents.font.italic = false
    self.contents.font.bold = false
    self.contents.font.size = 16
    self.contents.font.color = shadow_color(0)
    self.contents.draw_text(x + 1, y, width, height, str, align) if str != nil
    self.contents.draw_text(x, y + 1, width, height, str, align) if str != nil
    self.contents.font.color = text_color(fcolor)
    self.contents.draw_text(x, y, width, height, str, align) if str != nil
  end
  def draw_text_enemy_name(x, y, width, height, str, fcolor = 0, align = 0)
    self.contents.font.name = $sq_default_font
    self.contents.font.italic = false
    self.contents.font.bold = false
    self.contents.font.size = 20
    self.contents.font.color = shadow_color(0)
    self.contents.draw_text(x + 1, y, width, height, str, align) if str != nil
    self.contents.draw_text(x, y + 1, width, height, str, align) if str != nil
    self.contents.font.color = text_color(fcolor)
    self.contents.draw_text(x, y, width, height, str, align) if str != nil
  end
end

class Window_Message < Window_Selectable
  def refresh
    if not @keeping and not @whole_keeping
      self.contents.clear
      @cursor_width = 0
      x = y = 0
      fcolor = 0
    else
      x = @last_x
      y = @last_y
    end
    if @speaker.name != ""
      self.y = 328
      self.height = 135
      if @pic_winframe.bitmap != RPG::Cache.picture("MessWin_02")
        @pic_winframe.bitmap = RPG::Cache.picture("MessWin_02")
      end
    elsif @speaker.name == ""
      self.y = 331
      self.height = 132
      if @pic_winframe.bitmap != RPG::Cache.picture("MessWin_01")
        @pic_winframe.bitmap = RPG::Cache.picture("MessWin_01")
      end
    end
    if @speaker.name != ""
      y = 1
    end
    if $game_temp.choice_start == 0
      x = 8
    end
    if $game_temp.message_text != nil
      text = $game_temp.message_text
      begin
        last_text = text.clone
        text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
      end until text == last_text
      text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      text.gsub!(/\\\\/) { "\000" }
      text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
      text.gsub!(/\\[Gg]/) { "\002" }
      text.gsub!(/\\[Ww]\[([0-9]+)\]/) { "\004[#{$1}]" }
      text.gsub!(/\\[Aa]\[([0-9]+)\]/) { "\005[#{$1}]" }
      text.gsub!(/\\[Kk]/) { "\007" }
      text.gsub!(/\\[Ee]\[([0-9]+)\]/) { "\022[#{$1}]" }
      text.gsub!(/\\[Dd]/) { "\026" }
      text.gsub!(/\\[Rr]\[(.*?)\]/) { "\027[#{$1}]" }
      text.gsub!(/\\[Bb]/) { "\023" }
      text.gsub!(/\\[Ff]/) { "\024" }
      while ((c = text.slice!(/./m)) != nil)
        if c == "\004"
          text.sub!(/\[([0-9]+)\]/, " ")
          @message_wait_count = $1.to_i
          @keeping = true
          @last_x = x
          @last_y = y
          break
        end
        if c == "\005"
          text.sub!(/\[([0-9]+)\]/, "")
          @auto_close_count = $1.to_i
          next
        end
        if c == "\007"
          text.sub!(/\[([0-9]+)\]/, "")
          @whole_keeping = true
          @last_x = x
          @last_y = y
          next
        end
        if c == "\026"
          if @draw_dot
            @draw_dot = false
          else
            @draw_dot = true
          end
          next
        end
        if c == "\027"
          text.sub!(/\[(.*?)\]/, "")
          x += ruby_draw_text(self.contents, 4 + x, y * @lh + (@lh - @fs - 4), $1, 255)
          c = ""
        end
        if c == "\022"
          text.sub!(/\[([0-9]+)\]/, "")
          x += gaiji_draw(4 + x, y * @lh + (@lh - self.contents.font.size), $1.to_i) + 2
          c = ""
        end
        if c == "\023"
          self.contents.font.name = "Arial"
          self.contents.font.size = (@fs + 3)
          self.contents.font.bold = true
          next
        end
        if c == "\024"
          self.contents.font.name = $sq_default_font
          self.contents.font.size = @fs
          self.contents.font.bold = false
          next
        end
        if c == "\666"
          self.contents.clear
          @last_x = @last_y = 0
          break
        end
        if c == "\000"
          c = "\\"
        end
        if c == "\001"
          text.sub!(/\[([0-9]+)\]/, "")
          color = $1.to_i
          if color >= 0 and color <= 7
            fcolor = color
          end
          next
        end
        if c == "\002"
          if @gold_window == nil
            @gold_window = Window_Gold.new
            @gold_window.x = 560 - @gold_window.width
            if $game_temp.in_battle
              @gold_window.y = 192
            else
              @gold_window.y = self.y >= 128 ? 32 : 384
            end
            @gold_window.opacity = self.opacity
            @gold_window.back_opacity = self.back_opacity
          end
          next
        end
        if c == "\n"
          if y >= $game_temp.choice_start
            @cursor_width = [@cursor_width, x].max
          end
          y += 1
          x = 0
          if y >= $game_temp.choice_start
            x = 8
          end
          next
        end
        if @last_x != 0 or @last_y != 0
          x = @last_x
          y = @last_y
          if y >= 4
            self.contents.clear
            y = x = 0
            #y = 1 if $n != ""
          end
          @last_x = @last_y = 0
          @keeping = false
          @whole_keeping = false
        end
        if @draw_dot
          self.draw_text_mes(6 + x, @lh * y - @lh / 2 + 2, 40, @lh, "・", fcolor, 0)
        end
        self.draw_text_mes(4 + x,2 + @lh * y, 40, @lh, c, fcolor, 0)
        x += self.contents.text_size(c).width
      end
    end
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
      self.active = true
      self.index = 0
    end
    if $game_temp.num_input_variable_id > 0
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.x = self.x + 8
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
  end
end

# Ctrl Acceleration - Battle
# ---------------------------------
class Scene_Battle
  # overwrite entire main function, because need to tweek main loop directly
  def main
    $game_temp.in_battle = true
    $game_temp.battle_turn = 0
    $game_temp.battle_event_flags.clear
    $game_temp.battle_abort = false
    $game_temp.battle_main_phase = false
    $game_temp.battleback_name = $game_map.battleback_name
    $game_temp.forcing_battler = nil
    $game_actors[1].reset_temps
    $extra_stock = 0
    $n = ""
    $no_damage_turn = 0
    $same_skill_turn = 0
    $dodge_attack = 0           
    $dodge_ennude = 0
    $dodge_insert = 0 
    $enemy_nude_num = 0
    $showing_battler = $game_actors[1]          
    $recover_trans = false                      
    @pause = false                              
    @repeat = 0                                 
    $battle_debug = false                       
    $last_one_enemy = false                     
    $escape_success = false                     
    $battle_result = 0                          
    $dont_show_status_window = false            
    $level_up_to = 0                            
    $binding_power = 0                          
    $extra_exp = $extra_gold = $extra_num = 0   
    @last_slay_count = $game_system.slay_count
    for actor in $game_party.actors
      actor.added_states.clear
      actor.removed_states.clear
    end
    $game_party.remove_actor(2)
    $game_party.remove_actor(9)
    $game_system.battle_interpreter.setup(nil, 0)
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    @actor_command_window = Window_BattleCommand.new(120, [])
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @party_command_window = Window_PartyCommand.new
    @party_command_window.active = false
    @party_command_window.visible = false
    @help_window = Window_Help.new
    @help_window.back_opacity = 160
    @help_window.visible = true
    @status_window = Window_BattleStatus.new
    $battle_message_window = Window_Message.new
    @showing_message_window = false
    @resist_meter = Window_ResistMeter.new
    $mood = Mood.new
    @pic_win_select = Sprite.new
    @pic_win_select.bitmap = RPG::Cache.picture("SelectWindow")
    @pic_win_select.opacity = 0
    @pic_win_select.z = 90
    @pic_tab0 = Sprite.new
    @pic_tab0.bitmap = RPG::Cache.picture("SelectWindow_Tab0")
    @pic_tab0.opacity = 0
    @pic_tab0.x = 0
    @pic_tab0.y = -1
    @pic_tab0.z = 100
    @pic_tab1 = Sprite.new
    @pic_tab1.bitmap = RPG::Cache.picture("SelectWindow_Tab1")
    @pic_tab1.opacity = 0
    @pic_tab1.x = 0
    @pic_tab1.y = -1
    @pic_tab1.z = 100
    @pic_tab2 = Sprite.new
    @pic_tab2.bitmap = RPG::Cache.picture("SelectWindow_Tab2")
    @pic_tab2.opacity = 0
    @pic_tab2.x = 0
    @pic_tab2.y = -1
    @pic_tab2.z = 100
    @pic_tab_arrow = Sprite.new
    @pic_tab_arrow.bitmap = RPG::Cache.picture("SelectWindow_tab")
    @pic_tab_arrow.opacity = 0
    @pic_tab_arrow.x = 0
    @pic_tab_arrow.y = -1
    @pic_tab_arrow.z = 110
    if $game_switches[17]
      @pic_ending_01 = Sprite.new
      @pic_ending_01.bitmap = RPG::Cache.picture("Ending_01")
      @pic_ending_01.opacity = 255
      @pic_ending_01.z = 99999
      @pic_ending_02 = Sprite.new
      @pic_ending_02.bitmap = RPG::Cache.picture("Ending_02")
      @pic_ending_02.opacity = 50
      @pic_ending_02.blend_type = 2
      @pic_ending_02.z = 99998
    else
      @pic_ending_01.bitmap.dispose if @pic_ending_01 != nil
      @pic_ending_02.bitmap.dispose if @pic_ending_02 != nil
    end
    @plus = true
    @skilltab = 0
    $showing_win_select = false
    $showing_win_item = false
    @pic_win_command = Sprite.new
    @pic_win_command.bitmap = RPG::Cache.picture("CommWindow")
    @pic_win_command.opacity = 0
    @pic_win_command.x = 400
    @pic_win_command.y = 1
    @pic_win_command.z = 10
    $showing_win_command = false
    @pic_line01 = Sprite.new
    @pic_line01.bitmap = RPG::Cache.picture("Line_01")
    @pic_line01.visible = false
    @pic_line01.z = 1
    @pic_line02 = Sprite.new
    @pic_line02.bitmap = RPG::Cache.picture("Line_02")
    @pic_line02.visible = false
    @pic_line02.z = 901
    @pic_sphere = Sprite.new
    @pic_sphere.bitmap = RPG::Cache.picture("Sphere_gray")
    @pic_sphere.visible = true
    @pic_sphere.opacity = 0
    @pic_sphere.z = 900
    @pic_guide01 = Sprite.new
    @pic_guide01.bitmap = RPG::Cache.picture("Guide_01")
    @pic_guide01.opacity = 0
    @pic_guide01.z = 2000  
    @pic_guide02 = Sprite.new
    @pic_guide02.bitmap = RPG::Cache.picture("Guide_02")
    @pic_guide02.visible = false
    @pic_guide02.z = 2000
    if not $not_sex_battle
      @pic_line01.visible = true
      @pic_line02.visible = true
    end
    @spriteset = Spriteset_Battle.new
    @wait_count = 0
    if $data_system.battle_transition == ""
      Graphics.transition(20)
    else
      Graphics.transition(40, "Graphics/Transitions/" +
        $data_system.battle_transition)
    end
    start_phase0
    loop do
      Graphics.update
      Input.update
      update
      # Acceleration
      if Input.press?(Input::CTRL)
        Input.update
        update
      end
      if $scene != self
        break
      end
    end
    $game_map.refresh
    Graphics.freeze
    @actor_command_window.dispose
    @party_command_window.dispose
    @help_window.dispose
    @status_window.dispose
    $battle_message_window.dispose
    @skill_window.dispose if @skill_window != nil
    @item_window.dispose if @item_window != nil
    @result_window.dispose if @result_window != nil
    @resist_meter.dispose if @resist_meter != nil
    @spriteset.dispose
    @pic_line01.bitmap.dispose
    @pic_sphere.bitmap.dispose
    @pic_win_command.bitmap.dispose
    @pic_win_select.bitmap.dispose
    @pic_line02.bitmap.dispose
    @pic_ending_01.bitmap.dispose if @pic_ending_01 != nil
    @pic_ending_02.bitmap.dispose if @pic_ending_02 != nil
    $mood.dispose
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
    if $BTEST and not $scene.is_a?(Scene_Gameover)
      $scene = nil
    end
  end
end

# Ctrl Acceleration - Map
# ---------------------------------
class Scene_Map
  # overwrite entire main function, because need to tweek main loop directly
  def main
    initialize_map_name_window
    @spriteset = Spriteset_Map.new
    @message_window = Window_Message.new
    $warp_window = Window_Warp.new
    Graphics.transition
    loop do
      Graphics.update
      Input.update
      update
      # Acceleration
      if Input.press?(Input::CTRL)
        Input.update
        update
      end
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @spriteset.dispose
    @pic_ending_01.bitmap.dispose if @pic_ending_01 != nil
    @pic_ending_02.bitmap.dispose if @pic_ending_02 != nil
    @message_window.dispose
    $warp_window.dispose
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
    @map_name_window.pic_dispose
  end
end

# No limit dash
# ---------------------------------
class Game_Player
  alias squd2020_update update
  def update
    unless moving? or $game_system.map_interpreter.running? or @move_route_forcing or $game_temp.message_window_showing
      if Input.press?(Input::C)
        @move_speed = 5
      else
        @move_speed = 4
      end
    end
    squd2020_update
  end
end

# Message Skip
# ---------------------------------
class Window_Message < Window_Selectable
  alias squd2020_update update
  def update
    if Input.press?(Input::CTRL)
      if @message_wait_count > 1
        @message_wait_count = 1
      end
      if @auto_close_count > 2
        @auto_close_count = 2
      end
    end
    squd2020_update
    if Input.press?(Input::CTRL)
      if @contents_showing and not @keeping
        if $game_temp.choice_max == 0 && @auto_close_count == -1
          @auto_close_count = 2
        end
      end
    end
  end
end

class Game_Enemy_Book < Game_Enemy
  def initialize(enemy_id)
    super(1, 0)#ダミー
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
	@battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
	if @enemy_id == 133
		enemy = $game_actors[2]
		enemy.rovissa_update()
		@battler_name = "Boss-"+enemy.battler_name.sub("_","")
	end
    @hp = maxhp
    @sp = maxsp
  end
end