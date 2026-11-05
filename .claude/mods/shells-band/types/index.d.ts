export type Shell = { id: string; command: string; output: string }

declare module 'claude-code' {
  interface PluginState {
    'shells-band': { shells: Shell[] }
  }
}
