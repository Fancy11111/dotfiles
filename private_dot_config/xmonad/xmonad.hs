import System.Exit (exitSuccess)
import System.IO (hPutStrLn)
import XMonad
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (WSType (..), moveTo, nextScreen, prevScreen, shiftTo)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll, sinkAll)

-- Data
import Data.Char (isSpace)
import qualified Data.Map as M
import Data.Maybe (isJust)
import Data.Monoid
import Data.Tree
import qualified Data.Tuple.Extra as TE

-- Hooks
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.EwmhDesktops -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (ToggleStruts (..), avoidStruts, docks, docksEventHook, manageDocks)
import XMonad.Hooks.ManageHelpers (doFullFloat, isFullscreen)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)

-- Prompt

import Control.Arrow (first)
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Input
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad

-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

import Colors.Nord

myTerminal = "kitty"

myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=16:antialias=true:hinting=true"

myEditor = "nvim"

intellij = "intellij-idea-ultimate-edition"

myBrowser = "brave"

myFileManager = "nemo"

discord = "discord"

myModMask = mod4Mask

altMask = mod1Mask

myBorderWidth = 2

myNormColor = "#292d3e"

myFocusColor = "#bbc5ff"

myScreenshot = "flameshot gui"

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
--
-- myManageHook = composeAll [
-- 	title =? myTerminal --> doRectFloat (W.RationalRect 0.375 0.375 0.25 0.25),
--     className =? "Obsidian" --> doShift workspaceNotes,
--     title =? myBrowser --> doShift workspaceBrowser
-- 	] <+> manageDocks <+> manageSpawn
--
-- tall =
-- 	renamed [Replace "tall"] $
--  	mySpacing 8 $
--  	ResizableTall 1 (3 / 100) (1 / 2) []
--
-- wide =
--  	renamed [Replace "wide"] $
--  	mySpacing 8 $
--  	Mirror (ResizableTall 1 (3 / 100) (1 / 2) [])
--
-- grid =
--  	renamed [Replace "grid"] $
--  	mySpacing 8 $
--  	Grid (16 / 10)
--
-- full =
--  	renamed [Replace "full"] $
--  	mySpacing 8 $
--  	Full
--
-- myLayoutHook = avoidStruts $ tall ||| wide ||| grid ||| full

-- myStartupHook = do
-- 	spawnOn (myWorkspaces !! 0) myTerminal
-----------------------------------------------
-- AUTOSTART
-----------------------------------------------

myStartupHook :: X ()
myStartupHook = do
    -- spawnOnce "nitrogen --restore &"
    -- spawnOnce "picom &"
    spawnOnce "wezterm &"
    spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x292d3e --height 24 &"
    -- spawnonce "nm-applet &"
    setWMName "LG3D"

-----------------------------------------------
-- GRID SELECT
-----------------------------------------------
myColorizer :: Window -> Bool -> X (String, String)
myColorizer =
    colorRangeFromClassName
        (0x29, 0x2d, 0x3e) -- lowest inactive bg
        (0x29, 0x2d, 0x3e) -- highest inactive bg
        (0xc7, 0x92, 0xea) -- active bg
        (0xc0, 0xa7, 0x9a) -- inactive fg
        (0x29, 0x2d, 0x3e) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer =
    (buildDefaultGSConfig myColorizer)
        { gs_cellheight = 40
        , gs_cellwidth = 200
        , gs_cellpadding = 6
        , gs_originFractX = 0.5
        , gs_originFractY = 0.5
        , gs_font = myFont
        }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
  where
    conf =
        def
            { gs_cellheight = 40
            , gs_cellwidth = 200
            , gs_cellpadding = 6
            , gs_originFractX = 0.5
            , gs_originFractY = 0.5
            , gs_font = myFont
            }

-----------------------------------------------------------------------
-- WORKSPACES
------------------------------------------------------------------------
-- My workspaces are clickable meaning that the mouse can be used to switch
-- workspaces. This requires xdotool. You need to use UnsafeStdInReader instead
-- of simply StdInReader in xmobar config so you can pass actions to it.

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x = [x]

workspaceHome = " <fn=3>\xf015</fn> "
workspaceDev = " <fn=3>\xf1c9</fn> "
workspaceBrowser = " <fn=3>\xf0ac</fn> "
workspaceNotes = " notes "
workspaceMessage = " <fn=3>\xf4ad</fn> "
workspaceSettings = " <fn=3>\xf7d9</fn> "
workspaceFiles = " <fn=3>\xf233</fn> "

--
myWorkspaces = [workspaceHome, workspaceDev, workspaceBrowser, workspaceNotes, workspaceMessage, workspaceSettings, workspaceFiles]

-- where
--       clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
--                     (i,ws) <- zip [1..9] l,
-- let n = i ]

-- myWorkspaces :: [String]
-- myWorkspaces = clickable . map xmobarEscape $ ["<fn=3>\xf015</fn>", "<fn=3>\xf1c9</fn>", "<fn=3>\xf0ac</fn>", "notes</fn>", "<fn=3>\xf4ad</fn>", "<fn=3>\xf7d9</fn>", "<fn=3>\xf233</fn>"]
--   where
--         clickable l = [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>" |
--                       (i,ws) <- zip [1..9] l,
--                       let n = i ]
------------------------------------------------------------------------
-- MANAGEHOOK
------------------------------------------------------------------------
-- Sets some rules for certain programs. Examples include forcing certain
-- programs to always float, or to always appear on a certain workspace.
-- Forcing programs to a certain workspace with a doShift requires xdotool
-- if you are using clickable workspaces. You need the className or title
-- of the program. Use xprop to get this info.

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook =
    composeAll
        -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
        -- I'm doing it this way because otherwise I would have to write out
        -- the full name of my clickable workspaces, which would look like:
        -- doShift "<action xdotool super+8>gfx</action>"
        [ className =? "obs" --> doShift ("video.obs")
        , title =? "firefox" --> doShift ("web.browser")
        , title =? "qutebrowser" --> doShift ("web.browser")
        , className =? "mpv" --> doShift ("video.movie player")
        , className =? "vlc" --> doShift ("video.movie player")
        , className =? "Gimp" --> doShift ("graphics.gimp")
        , className =? "Gimp" --> doFloat
        , title =? "Oracle VM VirtualBox Manager" --> doFloat
        , className =? "VirtualBox Manager" --> doShift ("dev.virtualization")
        , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat -- Float Firefox Dialog
        ]

------------------------------------------------------------------------
-- LOGHOOK
------------------------------------------------------------------------
-- Sets opacity for inactive (unfocused) windows. I prefer to not use
-- this feature so I've set opacity to 1.0. If you want opacity, set
-- this to a value of less than 1 (such as 0.9 for 90% opacity).
myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
  where
    fadeAmount = 1.0

------------------------------------------------------------------------
-- LAYOUTS
------------------------------------------------------------------------
-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall =
    renamed [Replace "tall"] $
        limitWindows 12 $
            mySpacing 8 $
                ResizableTall 1 (3 / 100) (1 / 2) []
grid =
    renamed [Replace "grid"] $
        limitWindows 12 $
            mySpacing 8 $
                mkToggle (single MIRROR) $
                    Grid (16 / 10)
tabs =
    renamed [Replace "tabs"] $
        tabbed shrinkText myTabConfig
  where
    myTabConfig =
        def
            { fontName = "xft:Mononoki Nerd Font:regular:pixelsize=24"
            , activeColor = "#77c0d0"
            , inactiveColor = "#5e81ac"
            , activeBorderColor = "#77c0d0"
            , inactiveBorderColor = "#5e81ac"
            , activeTextColor = "#000000"
            , inactiveTextColor = "#d0d0d0"
            }

full =
    renamed [Replace "full"] $
        mySpacing 0 $
            Full

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
    def
        { swn_font = "xft:Sans:bold:size=60"
        , swn_fade = 1.0
        , swn_bgcolor = "#000000"
        , swn_color = "#FFFFFF"
        }

-- The layout hook
myLayoutHook =
    avoidStruts $
        mouseResize $
            windowArrange $
                mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout =
        tall
            ||| grid
            ||| noBorders tabs

-- \||| noBorders full

-- myLayoutPrinter "tall" = "<fn=3>\xf338</fn>"
-- myLayoutPrinter "wide" = "<fn=3>\xf337</fn>"
-- myLayoutPrinter "grid" = "<fn=3>\xf047</fn>"
-- myLayoutPrinter "full" = "<fn=3>\xf31e</fn>"
-- myLayoutPrinter x = x
--
-- myLogHook xmproc0 = dynamicLogWithPP $ xmobarPP {
-- 	ppOutput = \x -> hPutStrLn xmproc0 x ,
-- 	ppCurrent = xmobarColor "#89b4fa" "" . wrap "<box type=Bottom width=2 mb=2>" "</box>",
-- 	ppVisible = xmobarColor "#cba6f7" "" . wrap "<box type=Bottom width=2 mb=2>" "</box>",
-- 	ppHidden = xmobarColor "#45475a" "" . wrap "<box type=Bottom width=2 mb=2>" "</box>",
-- 	ppHiddenNoWindows = xmobarColor "#313244" "",
-- 	ppUrgent = xmobarColor "#f38ba8" "" . wrap "<box type=Bottom width=2 mb=2>" "</box>",
-- 	ppTitle = xmobarColor "#cdd6f4" "" . shorten 60,
-- 	ppLayout = xmobarColor "#cba6f7" "" . myLayoutPrinter,
-- 	ppSep = "  "
-- 	}

toggleFloat w =
    windows
        ( \s ->
            if M.member w (W.floating s)
                then W.sink w s
                else (W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s)
        )

myKeys :: [(String, X ())]
myKeys =
    [ ("M-c", kill1)
    , ("M-<Tab>", sendMessage NextLayout)
    , ("M-S-<Up>", sendMessage MirrorExpand)
    , ("M-S-<Down>", sendMessage MirrorShrink)
    , ("M-S-<Left>", sendMessage Shrink)
    , ("M-S-<Right>", sendMessage Expand)
    , -- ("M-<Left>", sendMessage PreviousWorkspace),
      -- ("M-<Right>", sendMessage NextWorkspace),
      ("M-<Return>", spawn myTerminal)
    , ("M-b", spawn myBrowser)
    , ("M-r", spawn "dmenu_run")
    , ("M-S-o", spawn "obsidian")
    , ("M-S-s", spawn "spotify-launcher")
    , ("M-S-f", spawn myFileManager)
    , ("M-S-d", spawn discord)
    , ("M-S-<Print>", spawn myScreenshot)
    , ("M-S-i", spawn intellij)
    , ("M-S-x", spawn "xournalpp")
    , ("M-S-m", spawn "mattermost-desktop")
    , -- , ("M-<Space>", sendMessage $ JumpToLayout "tabs")
      ("M-<Space>", sendMessage $ JumpToLayout "tabs")
    , -- , ("M-S-t", sendMessage $ JumpToLayout "tabs")
      ("M-g", sendMessage $ JumpToLayout "grid")
    , ("M-f", withFocused toggleFloat)
    , ("M-t", withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1))
    , ("<Print>", spawn "spectacle")
    , ("<XF86AudioRaiseVolume>", spawn "pamixer -i 5")
    , ("<XF86AudioLowerVolume>", spawn "pamixer -d 5")
    , ("<XF86AudioMute>", spawn "pamixer -t")
    , ("<XF86Calculator>", spawn "alacritty -e qalc")
    , -- , ("<XF86HomePage>", spawn (myBrowser ++ " https://todoist.com"))
      ("<XF86Mail>", spawn (myBrowser ++ " https://mail.proton.me/u/0/inbox"))
    , ("M-S-l", spawn "light-locker-command -l")
    , --    , ("M-r", spawn "xmonad --recompile"),
      -- conflicts with standard move window to 3rd xinerame screen
      -- ("M-S-r", spawn "xmonad --restart")
      ("M-S-<Left>", shiftTo Next nonNSP >> moveTo Next nonNSP)
    , ("M-S-<Right>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)
    ]
  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "nsp"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

------------------------------------------------------------------------

------------------------------------------------------------------------
-- MAIN
------------------------------------------------------------------------
main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 ~/.config/xmonad/nord-xmobarrc"
    xmproc1 <- spawnPipe "xmobar -x 1 ~/.config/xmonad/nord-xmobarrc"
    xmproc2 <- spawnPipe "xmobar -x 2 ~/.config/xmonad/nord-xmobarrc"
    -- xmproc2 <- spawnPipe "xmobar -x 2 ~/.config/xmobar/xmobarrc1"
    xmonad $
        ewmh . docks $
            def
                { manageHook = (isFullscreen --> doFullFloat) <+> myManageHook <+> manageDocks
                , -- Run xmonad commands from command line with "xmonadctl command". Commands include:
                  -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
                  -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
                  -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
                  handleEventHook =
                    serverModeEventHookCmd
                        <+> serverModeEventHook
                        <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                , -- <+> docksEventHook
                  modMask = myModMask
                , terminal = myTerminal
                , startupHook = myStartupHook
                , layoutHook = myLayoutHook
                , workspaces = myWorkspaces
                , borderWidth = myBorderWidth
                , normalBorderColor = myNormColor
                , focusedBorderColor = myFocusColor
                , logHook =
                    workspaceHistoryHook
                        <+> myLogHook
                        <+> dynamicLogWithPP
                            xmobarPP
                                { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x >> hPutStrLn xmproc2 x
                                , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                                , ppVisible = xmobarColor "#c3e88d" "" -- Visible but not current workspace
                                , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" -- Hidden workspaces in xmobar
                                , ppHiddenNoWindows = xmobarColor "#F07178" "" -- Hidden workspaces (no windows)
                                , ppTitle = xmobarColor "#d0d0d0" "" . shorten 60 -- Title of active window in xmobar
                                , ppSep = "<fc=#666666> | </fc>" -- Separators in xmobar
                                , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!" -- Urgent workspace
                                , ppExtras = [windowCount] -- # of windows current workspace
                                , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                                }
                }
                `additionalKeysP` myKeys

-- mySB = statusBarProp "xmobar" (pure xmobarPP)

-- main = do
--     xmproc0 <- spawnPipe "xmobar -x 1 -p \"Static { xpos = 10, ypos = 10, width = 1900, height = 24 }\" ~/.config/xmonad/xmobar.hs"
--     xmonad $ ewmhFullscreen . docks $ def {
-- 		terminal = myTerminal,
-- 		modMask = myModMask,
-- 		borderWidth = myBorderWidth,
-- 		workspaces = myWorkspaces,
-- 		manageHook = myManageHook,
-- 		layoutHook = myLayoutHook,
-- 		startupHook = myStartupHook,
-- 		logHook = myLogHook xmproc0
-- 	} `additionalKeysP` myKeys
