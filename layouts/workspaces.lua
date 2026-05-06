return {
  {
    id = 'app-runner-dev',
    label = 'AppRunnerDev',
    tabs = {
      {
        tab_title = 'AppRunnerDev',
        panes = {
          {
            cwd = '/Users/byron/Documents/dify/dify-enterprise/server/cmd/app-runner',
            command_env = {
              APPRUNNER_GRAPHON_DIR = '../../hack/runtime/app-runner/debug/graphon',
              APPRUNNER_SLIM_BINARY = '../../hack/runtime/app-runner/debug/slim',
              APPRUNNER_SLIM_PLUGIN_FOLDER = '../../hack/runtime/app-runner/debug/.slim/plugins',
              APP_RUNNER_CONTROL_JOIN_TOKEN = 'jointoken',
            },
            command = './app-runner server start --conf ../../hack/configs/app-runner/config-dev.yaml',
          },
          {
            cwd = '/Users/byron/Documents/dify/dify-enterprise/server/cmd/enterprise',
            direction = 'Bottom',
            size = 0.5,
            command_env = {
              APP_RUNNER_CONTROL_JOIN_TOKEN = 'jointoken',
              LOG_FORMAT = 'text',
            },
            command = 'go run . --conf ../../hack/configs/enterprise/config-dev.yaml',
          },
        },
      },
      {
        tab_title = 'AppRunnerDev Plugin',
        panes = {
          {
            cwd = '/Users/byron/Documents/dify/dify-plugin-daemon',
            command = 'go run github.com/joho/godotenv/cmd/godotenv@latest -f .env go run cmd/server/main.go',
          },
          {
            cwd = '/Users/byron/Documents/dify/dify-enterprise/server/hack/runtime/app-runner/debug',
            direction = 'Right',
            size = 0.5,
            command = 'bash bashs',
          },
        },
      },
      {
        tab_title = 'AppRunnerDev Docker',
        panes = {
          {
            cwd = '/Users/byron/Documents/dify/dify-enterprise',
            command = 'docker run -it --cpus="2" --memory="4g" --network="host" -v /Users/byron/Documents/dify/dify-enterprise:/workspace python bash -lc "cd /workspace && python --version && exec bash"',
          },
        },
      },
    },
  },
  {
    id = 'wezterm-config',
    label = 'WezTerm Config',
    tab_title = 'wezterm',
    panes = {
      {
        cwd = '/Users/byron/Documents/lua/wezterm',
      },
    },
  },
}
