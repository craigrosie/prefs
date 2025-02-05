local M = {}

function M.is_plugin_enabled(env_var_name)
  local env_value = os.getenv(env_var_name)
  if env_value then
    -- Convert string to boolean
    return env_value:lower() == 'true'
  end
  -- Default to false if the environment variable is not set
  return false
end

return M
