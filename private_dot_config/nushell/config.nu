# Nushell Config File
#
# version = 0.80.0

alias ls = exa -a --long --git
alias dfs = "git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
#alias air = "~/go/bin/air"
#alias matrix = "unimatrix -af -s 96"
alias clock = "tty-clock -c"
# alias thought = "fortune | pokemonthink"
# alias strat = "aow | pokemonsay"
alias nvim-config = "cd ~/.config/nvim && nvim ."
alias xmonad-config = "cd ~/.config/xmonad && nvim ."
alias fish-config = "cd ~/.config/fish && nvim ."
alias vue-language-server = "vls"
alias g = "git"
alias susp = "systemctl suspend"


let cursor = "#d8dee9"
let cursor_foreground = "#2e3440"

let foreground = "#d8dee9"
let foreground_bold = "#d8dee9"
let background = "#2e3440"

let highlight = "#4c566a"

let color0  = "#3b4252"
let color1  = "#bf616a"
let color2  = "#a3be8c"
let color3  = "#ebcb8b"
let color4  = "#81a1c1"
let color5  = "#b48ead"
let color6  = "#88c0d0"
let color7  = "#e5e9f0"
let color8  = "#4c566a"
let color9  = "#bf616a"
let color10 = "#a3be8c"
let color11 = "#ebcb8b"
let color12 = "#81a1c1"
let color13 = "#b48ead"
let color14 = "#8fbcbb"
let color15 = "#eceff4"
# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    # color for nushell primitives
    separator: $foreground_bold
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: $color12
    empty: $color14
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    bool: {|| if $in { '$color2' } else { $color8 } }
    int: $foreground
    filesize: {|e|
      if $e == 0b {
        $color15
      } else if $e < 1mb {
        $color6
      } else { $color4 }
    }
    duration: white
    date: {|| (date now) - $in |
      if $in < 1hr {
        # '$color13'
        $color13
      } else if $in < 6hr {
        # 'red'
        $color9
      } else if $in < 1day {
        # 'yellow'
        $color3
      } else if $in < 3day {
        # '$color2'
        $color2
      } else if $in < 1wk {
        # '$color2'
        $color2
      } else if $in < 6wk {
        # '$color14'
        $color14
      } else if $in < 52wk {
        # '$color4'
        $color12
      } else { 
          $highlight
          # 'dark_gray' 
      }
    }
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cellpath: white
    row_index: $color6
    record: white
    list: white
    block: white
    hints: dark_gray

    shape_and: $color13
    shape_binary: $color13
    shape_block: $color4
    shape_bool: $color6
    shape_closure: $color2
    shape_custom: $color2
    shape_datetime: $color14
    shape_directory: $color14
    shape_external: $color14
    shape_externalarg: $color2
    shape_filepath: $color14
    shape_flag: $color4
    shape_float: $color13
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: $color14
    shape_int: $color13
    shape_internalcall: $color14
    shape_list: $color14
    shape_literal: $color4
    shape_match_pattern: $color2
    shape_matching_brackets: { attr: u }
    shape_nothing: $color14
    shape_operator: yellow
    shape_or: $color13
    shape_pipe: $color13
    shape_range: yellow_bold
    shape_record: $color14
    shape_redirection: $color13
    shape_signature: $color2
    shape_string: $color2
    shape_string_interpolation: $color14
    shape_table: $color4
    shape_variable: $color13
    shape_vardecl: $color13
}

let light_theme = {
    # color for nushell primitives
    separator: dark_gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: $color2
    empty: $color4
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    bool: {|| if $in { 'dark_$color14' } else { 'dark_gray' } }
    int: dark_gray
    filesize: {|e|
      if $e == 0b {
        'dark_gray'
      } else if $e < 1mb {
        '$color14'
      } else { '$color4' }
    }
    duration: dark_gray
  date: {|| (date now) - $in |
    if $in < 1hr {
      '$color13'
    } else if $in < 6hr {
      'red'
    } else if $in < 1day {
      'yellow'
    } else if $in < 3day {
      '$color2'
    } else if $in < 1wk {
      '$color2'
    } else if $in < 6wk {
      '$color14'
    } else if $in < 52wk {
      '$color4'
    } else { 'dark_gray' }
  }
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cellpath: dark_gray
    row_index: $color2
    record: white
    list: white
    block: white
    hints: dark_gray

    shape_and: $color13
    shape_binary: $color13
    shape_block: $color4
    shape_bool: $color14
    shape_closure: $color2
    shape_custom: $color2
    shape_datetime: $color14
    shape_directory: $color14
    shape_external: $color14
    shape_externalarg: $color2
    shape_filepath: $color14
    shape_flag: $color4
    shape_float: $color13
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: $color14
    shape_int: $color13
    shape_internalcall: $color14
    shape_list: $color14
    shape_literal: $color4
    shape_match_pattern: $color2
    shape_matching_brackets: { attr: u }
    shape_nothing: $color14
    shape_operator: yellow
    shape_or: $color13
    shape_pipe: $color13
    shape_range: yellow_bold
    shape_record: $color14
    shape_redirection: $color13
    shape_signature: $color2
    shape_string: $color2
    shape_string_interpolation: $color14
    shape_table: $color4
    shape_variable: $color13
    shape_vardecl: $color13
}

# External completer example
# let carapace_completer = {|spans|
#     carapace $spans.0 nushell $spans | from json
# }


# The default config record. This is where much of your global configuration is setup.
let-env config = {
  # true or false to enable or disable the welcome banner at startup
  show_banner: false
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: true # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  cd: {
    abbreviations: true # allows `cd s/o/f` to expand to `cd some/other/folder`
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    show_empty: true # show 'empty list' and 'empty record' placeholders for command output
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
  }

  explore: {
    help_banner: true
    exit_esc: true

    command_bar_text: '#C4C9C6'
    # command_bar: {fg: '#C4C9C6' bg: '#223311' }

    status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6' }
    # status_bar_text: {fg: '#C4C9C6' bg: '#223311' }

    highlight: {bg: 'yellow' fg: 'black' }

    status: {
      # warn: {bg: 'yellow', fg: '$color4'}
      # error: {bg: 'yellow', fg: '$color4'}
      # info: {bg: 'yellow', fg: '$color4'}
    }

    try: {
      # border_color: 'red'
      # highlighted_color: '$color4'

      # reactive: false
    }

    table: {
      split_line: '#404040'

      cursor: true

      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true

      show_head: true
      show_index: true

      # selected_cell: {fg: 'white', bg: '#777777'}
      # selected_row: {fg: 'yellow', bg: '#C1C2A3'}
      # selected_column: $color4

      # padding_column_right: 2
      # padding_column_left: 2

      # padding_index_left: 2
      # padding_index_right: 1
    }

    config: {
      cursor_color: {bg: 'yellow' fg: 'black' }

      # border_color: white
      # list_color: $color2
    }
  }

  history: {
    max_size: 10000 # Session has to be reloaded for this to take effect
    sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "plaintext" # "sqlite" or "plaintext"
    history_isolation: true # true enables history isolation, false disables it. true will allow the history to be isolated to the current session. false will allow the history to be shared across all sessions.
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  cursor_shape: {
    emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
    vi_insert: block # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
    vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
  }
  color_config: $dark_theme   # if you want a light theme, replace `$dark_theme` to `$light_theme`
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2 # the precision for displaying floats in tables
  # buffer_editor: "emacs" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  bracketed_paste: true # enable bracketed paste, currently useless on windows
  edit_mode: emacs # emacs, vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.

  hooks: {
    pre_prompt: [{||
      null  # replace with source code to run before the prompt is shown
    }]
    pre_execution: [{||
      null  # replace with source code to run before the repl input is run
    }]
    env_change: {
      PWD: [{|before, after|
        null  # replace with source code to run if the PWD environment is different since the last repl input
      }]
    }
    display_output: {||
      if (term size).columns >= 100 { table -e } else { table }
    }
    command_not_found: {||
      null  # replace with source code to return an error message when a command is not found
    }
  }
  menus: [
      # Configuration for default nushell menus
      # Note the lack of source parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.vars
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        style: {
            text: $color2
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            $nu.scope.commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
  ]
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
       }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}
