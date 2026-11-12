import type { Register } from 'claude-code'

export const register: Register = on => {
  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    const ran = await next(e)
    const url = ran.text?.match(/https:\/\/github\.com\/\S+\/pull\/\d+/)?.[0]

    if (!/\bgh\s+pr\s+create\b/.test(e.command) || ran.isError || !url) {
      return ran
    }

    const view = await $.process
      .run(['gh', 'pr', 'view', url, '--json', 'title', '-q', '.title'])
      .catch(() => undefined)
    const title = view?.exitCode === 0 ? view.stdout.trim() : ''

    // A slash command cannot run inside a hook the turn waits on. The timer runs it outside this hook,
    // and the engine queues it until the session is idle.
    if (title) {
      $.clock.after(0, () => $.command.run({ command: 'rename', args: title }))
    }

    return ran
  })
}
