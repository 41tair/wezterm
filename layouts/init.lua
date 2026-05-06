local wezterm = require 'wezterm'
local act = wezterm.action

local workspaces = dofile('/Users/byron/Documents/lua/wezterm/layouts/workspaces.lua')
local config_root = '/Users/byron/Documents/lua/wezterm'

local M = {}
local by_id = {}

for _, workspace in ipairs(workspaces) do
  by_id[workspace.id] = workspace
end

local function choices()
  local items = {}

  for _, workspace in ipairs(workspaces) do
    table.insert(items, {
      id = workspace.id,
      label = workspace.label,
    })
  end

  return items
end

local function shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function command_env_exports(pane_config)
  local lines = {}

  for key, value in pairs(pane_config.command_env or {}) do
    table.insert(lines, 'export ' .. key .. '=' .. shell_quote(value))
  end

  table.sort(lines)

  return table.concat(lines, '\n')
end

local function merged_env(scope, pane_config)
  if not scope.env and not pane_config.env then
    return nil
  end

  local env = {}

  for key, value in pairs(scope.env or {}) do
    env[key] = value
  end

  for key, value in pairs(pane_config.env or {}) do
    env[key] = value
  end

  return env
end

local function spawn_command(scope, pane_config)
  local command = {
    args = pane_config.args,
    cwd = pane_config.cwd,
  }

  if pane_config.command then
    command.args = pane_config.shell_args or {
      pane_config.shell or '/bin/zsh',
      '-l',
    }
  end

  local env = merged_env(scope, pane_config)
  if pane_config.command then
    env = env or {}
    env.ZDOTDIR = config_root .. '/layouts/zsh'
    env.WEZTERM_LAYOUT_COMMAND = pane_config.command
    env.WEZTERM_LAYOUT_CWD = pane_config.cwd
    env.WEZTERM_LAYOUT_COMMAND_ENV = command_env_exports(pane_config)
  end

  if env then
    command.set_environment_variables = env
  end

  return command
end

local function spawn_tab(mux_window, workspace, tab_config)
  local first_pane = tab_config.panes[1]
  local tab, pane = mux_window:spawn_tab(spawn_command(tab_config, first_pane))

  tab:set_title(tab_config.tab_title or workspace.tab_title or workspace.label)

  for index = 2, #tab_config.panes do
    local pane_config = tab_config.panes[index]
    local command = spawn_command(tab_config, pane_config)

    command.direction = pane_config.direction or 'Bottom'
    command.size = pane_config.size or 0.5

    pane = pane:split(command)
  end
end

local function workspace_tabs(workspace)
  if workspace.tabs then
    return workspace.tabs
  end

  return {
    {
      tab_title = workspace.tab_title,
      panes = workspace.panes,
    },
  }
end

local function spawn_layout(mux_window, workspace)
  for _, tab_config in ipairs(workspace_tabs(workspace)) do
    spawn_tab(mux_window, workspace, tab_config)
  end
end

function M.open(window, id)
  local workspace = by_id[id]

  if not workspace then
    wezterm.log_error('unknown layout: ' .. tostring(id))
    return
  end

  spawn_layout(window:mux_window(), workspace)
end

function M.picker_action()
  return act.InputSelector {
    title = 'Open layout',
    choices = choices(),
    fuzzy = true,
    action = wezterm.action_callback(function(window, _, id)
      if id then
        M.open(window, id)
      end
    end),
  }
end

function M.apply_startup(id)
  wezterm.on('gui-startup', function()
    local _, _, window = wezterm.mux.spawn_window {}
    spawn_layout(window, by_id[id])
  end)
end

return M
