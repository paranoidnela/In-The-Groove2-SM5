local style = ThemePrefs.Get("ITG1") and "_flare" or "flare"
local num = ThemePrefs.Get("ITG1") and "" or " 2"
local isDedicab = ThemePrefs.Get("DedicabToggle") or false
return Def.ActorFrame{
	CodeMessageCommand=function(self,param)
		if param.Name == "GoodEnding" and not GAMESTATE:Env()['ForceGoodEnding'] then
			GAMESTATE:Env()['ForceGoodEnding'] = "1"
			SOUND:PlayOnce( THEME:GetPathS("ScreenTitleMenu","ForceGoodEnding") )
		end
	end,
	LoadActor("../ScreenLogo background"),

	Def.Sprite{
		Texture="frame",
		 OnCommand=function(self)
			self:Center():zoomtowidth(SCREEN_WIDTH):faderight(0.1):fadeleft(0.1):cropright(1.1):cropleft(-0.1):linear(1):cropright(-0.1)
			GAMESTATE:Env()["WorkoutMode"] = nil
		end;
	},
	
	Def.Sprite{
		Texture=style,
		 OnCommand=function(self)
			self:xy(SCREEN_LEFT-64,SCREEN_CENTER_Y-165):rotationz(0):linear(1):x(SCREEN_RIGHT+64):rotationz(360)
		end
	},
	
	Def.Sprite{
		Texture=style,
		 OnCommand=function(self)
			self:xy(SCREEN_LEFT-64,SCREEN_CENTER_Y+165):rotationz(0):linear(1):x(SCREEN_RIGHT+64):rotationz(360)
		end
	},

	Def.BitmapText{
		Condition=PREFSMAN:GetPreference("UseUnlockSystem"),
		Font="Common Normal",
		OnCommand=function(self)
			local unlocked = 0
			for i=1,UNLOCKMAN:GetNumUnlocks() do
				local Code = UNLOCKMAN:GetUnlockEntry( i-1 )
				if Code and not Code:IsLocked() then
					unlocked = unlocked + 1
				end
			end

			self:settext( string.format( THEME:GetString("ScreenUnlock","%d/%d unlocked"), unlocked, UNLOCKMAN:GetNumUnlocks() ) )
			:halign(1):xy(SCREEN_RIGHT-30,SCREEN_CENTER_Y+100):zoom(0.6):diffusealpha(0.5)

			-- There can be a special case where a user changes to the theme, while the unlock preference is on.
			-- Because of how UNLOCKMAN is initialized only on startup, it can only perform the locks if the theme is
			-- part of the loading process at startup. For this, we need to inform the user that they need to restart.
			if UNLOCKMAN:GetNumUnlocks() == 0 then
				self:settext("Please restart your game for unlocks to work!")
				:wrapwidthpixels(400)
			end
		end;
	};

	Def.HelpDisplay {
		File="_eurostile normal",
		OnCommand=function(self)
			self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+203):zoom(0.7):diffuseblink():maxwidth(SCREEN_WIDTH/0.8)
		end;
		InitCommand=function(self)
			self:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
			self:SetTipsColonSeparated( THEME:GetString("ScreenTitleMenu","HelpText") );
			for i=1,UNLOCKMAN:GetNumUnlocks() do
				if PREFSMAN:GetPreference("UseUnlockSystem") then
					local Code = UNLOCKMAN:GetUnlockEntry( i-1 )
					if Code and Code:IsLocked() then
						UNLOCKMAN:LockEntryID( tostring(i) )
					end
				end
			end
		end;
		OffCommand=function(self)
			self:linear(0.5):zoomy(0)
			SOUND:PlayOnce( ThemePrefs.Get("ITG1") and THEME:GetPathS("ITG1/Common","start")
			or THEME:GetPathS("_ITGCommon","start") )
		end;
	},
	

	LoadActor("../ScreenWithMenuElements underlay"),
	LoadActor("PercentComplete","StepsType_Dance_Single")..{ OnCommand=function(self) self:xy(SCREEN_RIGHT-90,SCREEN_TOP+30):zoom(0.9) end; };
	LoadActor("PercentComplete","StepsType_Dance_Double")..{ OnCommand=function(self) self:xy(SCREEN_RIGHT-90,SCREEN_TOP+50):zoom(0.9) end; };
	Def.ActorFrame{
		OnCommand=function(self)
			self:xy(SCREEN_RIGHT-90,SCREEN_CENTER_Y+130):zoom(0.9)
			:addx(SCREEN_WIDTH):decelerate(0.5):addx(-SCREEN_WIDTH)
		end;
		LoadActor("../_frame 3x1", {"product bar",120})..{
			OnCommand=function(s)
				s:diffuse(color("#3DA1FF"))
				if SONGMAN:DoesSongGroupExist("In The Groove 2") then
					s:diffuse( color("#FE2424") )
				end
			end;
		};
		Def.BitmapText{ Font="_eurostile normal", Text=THEME:GetString("Product","Base") .. num;
			OnCommand=function(s)
				s:zoom(0.6):y(-2):shadowlength(2):maxwidth(200)
				if SONGMAN:DoesSongGroupExist("In The Groove 2") then
					s:settext( THEME:GetString("Product","PackA") )
				end
			end;
		};
	};

	Def.Sprite{
		Texture=THEME:GetPathB("ScreenLogo","background/roxor"),
		OnCommand=function(self)
			self:xy(SCREEN_LEFT+90,SCREEN_TOP+30):diffusealpha(0):sleep(0.5):linear(0.5):diffusealpha(1)
		end;
	};

	Def.Sprite{
		Condition=isDedicab,
		Texture=THEME:GetPathB("ScreenLogo","background/andamiro"),
		OnCommand=function(self)
			self:xy(SCREEN_LEFT+230,SCREEN_TOP+30):diffusealpha(0):sleep(0.5):linear(0.5):diffusealpha(1)
		end;
	},
}